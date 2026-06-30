import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/urban_goodz/domain/models/book_anything_record_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

class BookingApiService {
  final ApiClient _apiClient;

  BookingApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? Get.find<ApiClient>();

  Future<List<BookAnythingRecordModel>> getBookAnythingRecords() async {
    final Response response = await _apiClient.getData(
      AppConstants.ugBookAnythingRecordsUri,
    );
    if (response.statusCode == 200) {
      return _extractList(
        response.body,
      ).map(BookAnythingRecordModel.fromJson).toList();
    }
    return <BookAnythingRecordModel>[];
  }

  Future<BookAnythingRecordModel?> getBookAnythingRecord(String record) async {
    final Response response = await _apiClient.getData(
      '${AppConstants.ugBookAnythingRecordsUri}/$record',
    );
    if (response.statusCode == 200 && response.body is Map) {
      return BookAnythingRecordModel.fromJson(
        Map<String, dynamic>.from(response.body),
      );
    }
    return null;
  }

  Future<Response> submitBookAnythingRequest(Map<String, dynamic> request) {
    return _apiClient.postData(AppConstants.ugBookAnythingRequestUri, request);
  }

  List<Map<String, dynamic>> _extractList(dynamic body) {
    final dynamic list = body is List
        ? body
        : body is Map
        ? body['data'] ?? body['records'] ?? body['requests']
        : null;
    if (list is! List) return <Map<String, dynamic>>[];
    return list
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
