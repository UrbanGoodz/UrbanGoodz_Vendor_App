import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_profile_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_photo_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_request_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_service_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_quote_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/fashion_order_status_model.dart';

class FashionFitApiException implements Exception {
  const FashionFitApiException(this.message);
  final String message;
  @override
  String toString() => message;
}

class FashionFitAnalysisResult {
  const FashionFitAnalysisResult({
    required this.status,
    required this.measurements,
    this.retakeInstructions = const [],
    this.overallConfidence,
  });
  final String status;
  final List<Map<String, dynamic>> measurements;
  final List<String> retakeInstructions;
  final double? overallConfidence;
}

class FashionMeasurementApiService {
  static const _base = '/api/v1/fashion-fit';
  static String? _activeProfileUuid;
  static String? _activeAnalysisUuid;
  static Map<String, dynamic>? _activeProfile;
  static final Map<String, MeasurementPhotoModel> _photos = {};
  static final List<MeasurementRequestModel> _requests = [];
  static final Map<int, String> _quoteRequests = {};
  static String? _lastMessage;
  ApiClient get _api {
    if (!Get.isRegistered<ApiClient>()) {
      throw const FashionFitApiException(
        'Authenticated API client is unavailable.',
      );
    }
    return Get.find<ApiClient>();
  }

  String? get lastBackendMessage => _lastMessage;
  String? get activeProfileUuid => _activeProfileUuid;
  Map<String, MeasurementPhotoModel> get draftPhotos =>
      Map.unmodifiable(_photos);
  List<MeasurementRequestModel> get submittedRequests =>
      List.unmodifiable(_requests);
  MeasurementProfileModel? get draftProfile =>
      _activeProfile == null ? null : _legacyProfile(_activeProfile!);

  Future<Map<String, dynamic>> requirements() async =>
      _data(await _api.getData('$_base/requirements', handleError: false));
  Future<String> createAiProfile({
    required String name,
    required String units,
    required double height,
    required bool shareMeasurements,
    required bool sharePhotos,
    Map<String, dynamic>? fitPreferences,
  }) async {
    final response = await _api.postData('$_base/profiles', {
      'name': name,
      'units': units,
      'calibration_height': height,
      'fit_preferences': fitPreferences ?? {},
      'ai_processing_consent': true,
      'measurement_sharing_consent': shareMeasurements,
      'photo_sharing_consent': sharePhotos,
    }, handleError: false);
    final data = _expect(response, [201]);
    _activeProfile = data;
    _activeProfileUuid = data['uuid']?.toString();
    if (_activeProfileUuid == null) {
      throw const FashionFitApiException(
        'Backend did not return a profile ID.',
      );
    }
    _photos.clear();
    return _activeProfileUuid!;
  }

  Future<MeasurementPhotoModel> uploadMeasurementPhoto(
    XFile photo,
    String orientation, {
    double? heightRef,
  }) async {
    final uuid = _requireProfile();
    final response = await _api.postMultipartData(
      '$_base/profiles/$uuid/photos',
      {'view': orientation, 'confirmed_for_upload': '1'},
      [MultipartBody('photo', photo)],
      handleError: false,
    );
    final data = _expect(response, [201]);
    final model = MeasurementPhotoModel(
      id: null,
      photoUrl: null,
      orientation: data['view']?.toString() ?? orientation,
      status: data['status']?.toString() ?? 'accepted',
      uploadedAt: DateTime.now(),
    );
    _photos[orientation] = model;
    return model;
  }

  Future<FashionFitAnalysisResult> submitAndWaitForAnalysis({
    Duration timeout = const Duration(minutes: 2),
  }) async {
    final profile = _requireProfile();
    final submitted = await _api.postData(
      '$_base/profiles/$profile/analyses',
      {},
      handleError: false,
    );
    final analysis = _expect(submitted, [202]);
    _activeAnalysisUuid = analysis['uuid']?.toString();
    if (_activeAnalysisUuid == null) {
      throw const FashionFitApiException(
        'Backend did not return an analysis ID.',
      );
    }
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(seconds: 2));
      final response = await _api.getData(
        '$_base/profiles/$profile/analyses/$_activeAnalysisUuid',
        handleError: false,
      );
      final data = _expect(response, [200]);
      final status = data['status']?.toString() ?? 'failed';
      final measurements = _maps(data['measurements']);
      final retakes = (data['retake_requirements'] is List
          ? (data['retake_requirements'] as List)
                .map((e) => e.toString())
                .toList()
          : <String>[]);
      if (['completed', 'needs_retake', 'failed'].contains(status)) {
        _lastMessage = status;
        return FashionFitAnalysisResult(
          status: status,
          measurements: measurements,
          retakeInstructions: retakes,
          overallConfidence: double.tryParse(
            data['overall_confidence']?.toString() ?? '',
          ),
        );
      }
    }
    throw const FashionFitApiException(
      'AI analysis timed out. You can safely retry status polling.',
    );
  }

  Future<void> correctMeasurement(int id, double value, String unit) async {
    final response = await _api.putData(
      '$_base/profiles/${_requireProfile()}/measurements/$id',
      {'value': value, 'unit': unit},
      handleError: false,
    );
    _expect(response, [200]);
  }

  Future<Map<String, dynamic>> approveProfile() async {
    final response = await _api.postData(
      '$_base/profiles/${_requireProfile()}/approve',
      {},
      handleError: false,
    );
    final data = _expect(response, [200]);
    _activeProfile = data;
    return data;
  }

  Future<void> revokeSharing() async {
    final response = await _api
        .postData('$_base/profiles/${_requireProfile()}/consent', {
          'ai_processing_allowed': false,
          'measurement_sharing_allowed': false,
          'photo_sharing_allowed': false,
        }, handleError: false);
    _expect(response, [200]);
  }

  Future<void> deleteProfile() async {
    final response = await _api.deleteData(
      '$_base/profiles/${_requireProfile()}',
      handleError: false,
    );
    _expect(response, [200]);
    _activeProfileUuid = null;
    _activeProfile = null;
    _photos.clear();
  }

  Future<MeasurementProfileModel?> getMeasurementProfile(int userId) async {
    final response = await _api.getData('$_base/profiles', handleError: false);
    final body = response.body is Map
        ? Map<String, dynamic>.from(response.body)
        : <String, dynamic>{};
    final rows = _maps(body['data']);
    if (rows.isEmpty) return null;
    final uuid = rows.first['uuid']?.toString();
    if (uuid == null) return null;
    _activeProfileUuid = uuid;
    final detail = _data(
      await _api.getData('$_base/profiles/$uuid', handleError: false),
    );
    _activeProfile = detail;
    return _legacyProfile(detail);
  }

  Future<Map<String, dynamic>?> loadLatestProfile() async {
    final response = await _api.getData('$_base/profiles', handleError: false);
    if (response.statusCode != 200) {
      throw FashionFitApiException(
        response.statusText ?? 'Unable to load Fashion Fit profiles.',
      );
    }
    final body = response.body is Map
        ? Map<String, dynamic>.from(response.body)
        : <String, dynamic>{};
    final rows = _maps(body['data']);
    if (rows.isEmpty) return null;
    final uuid = rows.first['uuid']?.toString();
    if (uuid == null) return null;
    _activeProfileUuid = uuid;
    _activeProfile = _data(
      await _api.getData('$_base/profiles/$uuid', handleError: false),
    );
    return _activeProfile;
  }

  Future<bool> saveMeasurementProfile(MeasurementProfileModel profile) async {
    if (_activeProfileUuid == null) {
      throw const FashionFitApiException(
        'Complete AI photo analysis before editing measurements.',
      );
    }
    final response = await _api.putData('$_base/profiles/$_activeProfileUuid', {
      'name': profile.profileName,
      'units': 'in',
      'calibration_height': profile.height,
      'fit_preferences': {'preferred_fit': profile.preferredFit},
    }, handleError: false);
    _expect(response, [200]);
    return true;
  }

  Future<MeasurementPhotoModel?> uploadMeasurementPhotoPath(
    String path,
    String orientation,
  ) async => uploadMeasurementPhoto(XFile(path), orientation);
  Future<List<TailorServiceModel>> getTailorServices(int storeId) async {
    final response = await _api.getData('$_base/providers', handleError: false);
    final rows = _maps(
      response.body is Map ? (response.body as Map)['data'] : null,
    );
    return rows
        .map(
          (row) => TailorServiceModel(
            id: int.tryParse(row['vendor_id']?.toString() ?? ''),
            storeId: int.tryParse(row['vendor_id']?.toString() ?? ''),
            serviceName: row['name']?.toString() ?? 'Fashion Fit provider',
            description: row['bio']?.toString() ?? '',
            basePrice: 0,
            durationDays: 0,
          ),
        )
        .toList();
  }

  Future<bool> submitMeasurementRequest(MeasurementRequestModel request) async {
    final response = await _api.postData('$_base/requests', {
      'profile_uuid': _requireProfile(),
      'vendor_id': request.vendorId,
      'service_type': request.requestType ?? 'fashion_fit',
      'garment_type': request.itemWanted ?? 'custom garment',
      'notes': request.notes,
      'budget': request.budget,
      'requested_completion_date': request.dueDate?.toIso8601String(),
      'share_measurements': true,
      'share_photos': request.consentToSharePhotos ?? false,
    }, handleError: false);
    final data = _expect(response, [201]);
    _requests.insert(
      0,
      MeasurementRequestModel.fromJson({
        ...request.toJson(),
        ...data,
        'backend_synced': true,
      }),
    );
    return true;
  }

  Future<List<MeasurementRequestModel>> getSubmittedRequests(int userId) async {
    final response = await _api.getData('$_base/requests', handleError: false);
    final body = response.body is Map
        ? Map<String, dynamic>.from(response.body)
        : <String, dynamic>{};
    _requests
      ..clear()
      ..addAll(_maps(body['data']).map(MeasurementRequestModel.fromJson));
    return submittedRequests;
  }

  Future<List<TailorQuoteModel>> getTailorQuotes(int requestId) async {
    final request = _requests.firstWhereOrNull((r) => r.id == requestId);
    if (request?.uuid == null) return [];
    final data = _data(
      await _api.getData(
        '$_base/requests/${request!.uuid}',
        handleError: false,
      ),
    );
    final rows = _maps(data['estimates']);
    for (final row in rows) {
      final id = int.tryParse(row['id']?.toString() ?? '');
      if (id != null) _quoteRequests[id] = request.uuid!;
    }
    return rows.map(TailorQuoteModel.fromJson).toList();
  }

  Future<bool> acceptQuote(int quoteId) async {
    final uuid = _quoteRequests[quoteId];
    if (uuid == null) {
      throw const FashionFitApiException(
        'Quote request context is unavailable. Refresh quotes.',
      );
    }
    final response = await _api.postData(
      '$_base/requests/$uuid/estimates/$quoteId/decision',
      {'decision': 'accept'},
      handleError: false,
    );
    _expect(response, [200]);
    return true;
  }

  Future<bool> declineQuote(int quoteId) async {
    final uuid = _quoteRequests[quoteId];
    if (uuid == null) {
      throw const FashionFitApiException(
        'Quote request context is unavailable. Refresh quotes.',
      );
    }
    final response = await _api.postData(
      '$_base/requests/$uuid/estimates/$quoteId/decision',
      {'decision': 'decline'},
      handleError: false,
    );
    _expect(response, [200]);
    return true;
  }

  Future<FashionOrderStatusModel?> getFashionOrderStatus(int orderId) async {
    final request = _requests.firstWhereOrNull((r) => r.id == orderId);
    if (request?.uuid == null) return null;
    final data = _data(
      await _api.getData(
        '$_base/requests/${request!.uuid}',
        handleError: false,
      ),
    );
    return FashionOrderStatusModel(
      id: orderId,
      orderId: orderId,
      currentStatus: data['status']?.toString() ?? 'unknown',
      updatedAt:
          DateTime.tryParse(data['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      statusNotes: null,
    );
  }

  String _requireProfile() {
    if (_activeProfileUuid == null) {
      throw const FashionFitApiException(
        'Create a consented Fashion Fit profile first.',
      );
    }
    return _activeProfileUuid!;
  }

  Map<String, dynamic> _expect(Response response, List<int> codes) {
    if (!codes.contains(response.statusCode)) {
      final body = response.body;
      final message = body is Map
          ? (body['message'] ?? body['error'] ?? body['errors']?.toString())
                .toString()
          : (response.statusText ?? 'Fashion Fit request failed.');
      throw FashionFitApiException(message);
    }
    return _data(response);
  }

  Map<String, dynamic> _data(Response response) {
    if (response.statusCode != 200) {
      throw FashionFitApiException(
        response.statusText ?? 'Fashion Fit request failed.',
      );
    }
    final body = response.body is Map
        ? Map<String, dynamic>.from(response.body)
        : <String, dynamic>{};
    return body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
  }

  List<Map<String, dynamic>> _maps(Object? value) => value is List
      ? value.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList()
      : <Map<String, dynamic>>[];
  MeasurementProfileModel _legacyProfile(Map<String, dynamic> json) {
    final measurements = _maps(json['measurements']);
    double? value(String name) {
      for (final row in measurements) {
        if (row['name'] == name) {
          return double.tryParse(row['value']?.toString() ?? '');
        }
      }
      return null;
    }

    return MeasurementProfileModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      userId: int.tryParse(json['customer_id']?.toString() ?? ''),
      profileName: json['name']?.toString(),
      height: double.tryParse(json['calibration_height']?.toString() ?? ''),
      chestBust: value('chest_bust'),
      waist: value('waist'),
      hips: value('full_hip'),
      inseam: value('inseam'),
      sleeve: value('sleeve_length'),
      shoulderWidth: value('shoulder_width'),
      neck: value('neck'),
      preferredFit: json['fit_preferences']?.toString(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }
}
