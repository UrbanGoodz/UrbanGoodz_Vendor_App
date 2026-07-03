import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_profile_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_photo_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/measurement_request_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_service_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/tailor_quote_model.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/models/fashion_order_status_model.dart';

class FashionMeasurementApiService {
  static const String fashionMeasurementProfileUri =
      '/api/v1/customer/fashion/measurement-profiles';
  static const String fashionMeasurementPhotoUri =
      '/api/v1/customer/fashion/measurement-photos';
  static const String fashionMeasurementRequestUri =
      '/api/v1/urban-goodz/fashion/stylist-requests';
  static const String fashionTailorServicesUri =
      '/api/v1/customer/fashion/tailor-services';
  static const String fashionTailorQuotesUri =
      '/api/v1/customer/fashion/tailor-quotes';
  static const String fashionOrderStatusUri =
      '/api/v1/customer/fashion/order-statuses';

  static MeasurementProfileModel? _draftProfile;
  static final Map<String, MeasurementPhotoModel> _draftPhotos = {};
  static final List<MeasurementRequestModel> _submittedRequests = [];
  static String? _lastBackendMessage;

  String? get lastBackendMessage => _lastBackendMessage;
  MeasurementProfileModel? get draftProfile => _draftProfile;
  Map<String, MeasurementPhotoModel> get draftPhotos => Map.unmodifiable(_draftPhotos);
  List<MeasurementRequestModel> get submittedRequests =>
      List.unmodifiable(_submittedRequests);

  ApiClient? get _apiClient => Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : null;

  Future<MeasurementProfileModel?> getMeasurementProfile(int userId) async {
    // Placeholder GET request returning mock data
    await Future.delayed(const Duration(milliseconds: 500));
    return MeasurementProfileModel(
      id: 1,
      userId: userId,
      profileName: "My Fitting Profile",
      height: 70.0,
      chestBust: 40.0,
      waist: 34.0,
      hips: 42.0,
      inseam: 32.0,
      sleeve: 34.5,
      shoulderWidth: 18.0,
      neck: 15.5,
      preferredFit: "Regular",
      notes: "Preferred slim fit on cuffs.",
      updatedAt: DateTime.now(),
    );
  }

  Future<bool> saveMeasurementProfile(MeasurementProfileModel profile) async {
    _draftProfile = profile;
    final apiClient = _apiClient;
    if (apiClient == null) {
      _lastBackendMessage = 'Backend API client unavailable; profile saved locally for tester request assembly.';
      return false;
    }

    final response = await apiClient.postData(
      fashionMeasurementProfileUri,
      profile.toJson(),
      handleError: false,
    );
    final ok = response.statusCode == 200 || response.statusCode == 201;
    _lastBackendMessage = ok
        ? 'Measurement profile synced to backend.'
        : 'Backend profile sync unavailable (${response.statusCode ?? 'no response'}); profile saved locally for tester request assembly.';
    return ok;
  }

  Future<MeasurementPhotoModel?> uploadMeasurementPhoto(
    XFile photo,
    String orientation, {
    double? heightRef,
  }) async {
    final localPhoto = MeasurementPhotoModel(
      id: DateTime.now().millisecondsSinceEpoch,
      photoUrl: photo.name,
      orientation: orientation,
      heightRef: heightRef,
      status: "local_pending_backend",
      uploadedAt: DateTime.now(),
    );
    _draftPhotos[orientation] = localPhoto;

    final apiClient = _apiClient;
    if (apiClient == null) {
      _lastBackendMessage = 'Backend API client unavailable; photo reference retained locally for tester request assembly.';
      return localPhoto;
    }

    final response = await apiClient.postMultipartData(
      fashionMeasurementPhotoUri,
      {
        'orientation': orientation,
        if (heightRef != null) 'height_ref': heightRef.toString(),
      },
      [MultipartBody('photo', photo)],
      handleError: false,
    );

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        response.body is Map) {
      final body = Map<String, dynamic>.from(response.body);
      final data = body['data'] is Map ? Map<String, dynamic>.from(body['data']) : body;
      final remotePhoto = MeasurementPhotoModel.fromJson(data);
      _draftPhotos[orientation] = remotePhoto;
      _lastBackendMessage = 'Measurement photo synced to backend.';
      return remotePhoto;
    }

    _lastBackendMessage = 'Backend photo upload unavailable (${response.statusCode ?? 'no response'}); photo reference retained locally.';
    return localPhoto;
  }

  Future<MeasurementPhotoModel?> uploadMeasurementPhotoPath(String path, String orientation) async {
    return MeasurementPhotoModel(
      id: DateTime.now().millisecondsSinceEpoch,
      photoUrl: path,
      orientation: orientation,
      status: "local_pending_backend",
      uploadedAt: DateTime.now(),
    );
  }

  Future<List<TailorServiceModel>> getTailorServices(int storeId) async {
    // Placeholder GET request for services
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TailorServiceModel(
        id: 1,
        storeId: storeId,
        serviceName: "Custom Tuxedo Fitting & Alteration",
        description: "Custom tuxedo fitting with photo-assisted measurement intake review.",
        basePrice: 150.0,
        durationDays: 14,
      ),
      TailorServiceModel(
        id: 2,
        storeId: storeId,
        serviceName: "Standard Pants Hemming",
        description: "Quick hem adjustment for trousers or suits.",
        basePrice: 20.0,
        durationDays: 3,
      ),
    ];
  }

  Future<bool> submitMeasurementRequest(MeasurementRequestModel request) async {
    final apiClient = _apiClient;
    if (apiClient != null) {
      final response = await apiClient.postData(
        fashionMeasurementRequestUri,
        request.toJson(),
        handleError: false,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final syncedRequest = MeasurementRequestModel.fromJson({
          ...request.toJson(),
          if (response.body is Map && response.body['data'] is Map)
            ...Map<String, dynamic>.from(response.body['data']),
          'backend_synced': true,
          'backend_message': 'Submitted to Fashion Fit backend for Stylist Review.',
        });
        _submittedRequests.insert(0, syncedRequest);
        _lastBackendMessage = 'Submitted to Fashion Fit backend for Stylist Review.';
        return true;
      }
      _lastBackendMessage = 'Backend submission unavailable (${response.statusCode ?? 'no response'}); request saved locally and labeled backend-limited.';
    } else {
      _lastBackendMessage = 'Backend API client unavailable; request saved locally and labeled backend-limited.';
    }

    _submittedRequests.insert(
      0,
      MeasurementRequestModel.fromJson({
        ...request.toJson(),
        'id': DateTime.now().millisecondsSinceEpoch,
        'backend_synced': false,
        'backend_message': _lastBackendMessage,
      }),
    );
    return false;
  }

  Future<List<MeasurementRequestModel>> getSubmittedRequests(int userId) async {
    final apiClient = _apiClient;
    if (apiClient != null) {
      final response = await apiClient.getData(
        '$fashionMeasurementRequestUri?user_id=$userId',
        handleError: false,
      );
      if (response.statusCode == 200 && response.body is Map && response.body['data'] is List) {
        final list = List<Map<String, dynamic>>.from(response.body['data']);
        _submittedRequests.clear();
        _submittedRequests.addAll(list.map((json) => MeasurementRequestModel.fromJson(json)));
      }
    }
    return _submittedRequests;
  }

  Future<List<TailorQuoteModel>> getTailorQuotes(int requestId) async {
    // Placeholder GET request for quotes
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      TailorQuoteModel(
        id: 10,
        requestId: requestId,
        serviceId: 1,
        quoteAmount: 165.0,
        comments: "Includes extra lining fabric for custom comfort.",
        isAccepted: false,
        offeredAt: DateTime.now(),
      )
    ];
  }

  Future<bool> acceptQuote(int quoteId) async {
    // Placeholder POST quote acceptance
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  Future<FashionOrderStatusModel?> getFashionOrderStatus(int orderId) async {
    // Placeholder GET status
    await Future.delayed(const Duration(milliseconds: 500));
    return FashionOrderStatusModel(
      id: 5,
      orderId: orderId,
      currentStatus: "Measuring",
      updatedAt: DateTime.now(),
      statusNotes: "Tailor review preview is checking photo alignment estimates.",
    );
  }
}
