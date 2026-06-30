import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/urban_goodz/domain/models/urban_goodz_event_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

class EventsApiService {
  final ApiClient _apiClient;

  EventsApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? Get.find<ApiClient>();

  Future<List<UrbanGoodzEventModel>> getEvents() async {
    final Response response = await _apiClient.getData(
      AppConstants.ugEventsUri,
    );
    if (response.statusCode == 200) {
      return _extractList(
        response.body,
      ).map(UrbanGoodzEventModel.fromJson).toList();
    }
    return <UrbanGoodzEventModel>[];
  }

  Future<UrbanGoodzEventModel?> getEvent(String record) async {
    final Response response = await _apiClient.getData(
      '${AppConstants.ugEventsUri}/$record',
    );
    if (response.statusCode == 200 && response.body is Map) {
      return UrbanGoodzEventModel.fromJson(
        Map<String, dynamic>.from(response.body),
      );
    }
    return null;
  }

  Future<Response> expressInterest(String record) =>
      _eventAction(record, 'interest');

  Future<Response> requestVendorOpportunity(
    String record,
    Map<String, dynamic> body,
  ) => _eventAction(record, 'vendor-opportunity', body);

  Future<Response> requestCreatorOpportunity(
    String record,
    Map<String, dynamic> body,
  ) => _eventAction(record, 'creator-opportunity', body);

  Future<Response> requestLogisticsSupport(
    String record,
    Map<String, dynamic> body,
  ) => _eventAction(record, 'logistics-support', body);

  Future<Response> _eventAction(
    String record,
    String action, [
    Map<String, dynamic>? body,
  ]) {
    return _apiClient.postData(
      '${AppConstants.ugEventsUri}/$record/$action',
      body ?? <String, dynamic>{},
    );
  }

  List<Map<String, dynamic>> _extractList(dynamic body) {
    final dynamic list = body is List
        ? body
        : body is Map
        ? body['data'] ?? body['events'] ?? body['records']
        : null;
    if (list is! List) return <Map<String, dynamic>>[];
    return list
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
