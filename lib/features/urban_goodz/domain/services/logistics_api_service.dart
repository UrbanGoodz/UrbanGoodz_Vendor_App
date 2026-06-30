import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/urban_goodz/domain/models/logistics_opportunity_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

class LogisticsApiService {
  final ApiClient _apiClient;

  LogisticsApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? Get.find<ApiClient>();

  Future<List<LogisticsOpportunityModel>> getJobs() =>
      _getList(AppConstants.ugLogisticsJobsUri);

  Future<LogisticsOpportunityModel?> getJob(String record) =>
      _getOne('${AppConstants.ugLogisticsJobsUri}/$record');

  Future<Response> acceptJob(String record) => _apiClient.postData(
    '${AppConstants.ugLogisticsJobsUri}/$record/accept',
    <String, dynamic>{},
  );

  Future<Response> updateJobStatus(String record, String status) =>
      _apiClient.postData('${AppConstants.ugLogisticsJobsUri}/$record/status', {
        'status': status,
      });

  Future<List<LogisticsOpportunityModel>> getLoads() =>
      _getList(AppConstants.ugLoadBoardLoadsUri);

  Future<LogisticsOpportunityModel?> getLoad(String record) =>
      _getOne('${AppConstants.ugLoadBoardLoadsUri}/$record');

  Future<Response> acceptLoad(String record) => _apiClient.postData(
    '${AppConstants.ugLoadBoardLoadsUri}/$record/accept',
    <String, dynamic>{},
  );

  Future<Response> updateLoadStatus(String record, String status) =>
      _apiClient.postData(
        '${AppConstants.ugLoadBoardLoadsUri}/$record/status',
        {'status': status},
      );

  Future<List<LogisticsOpportunityModel>> _getList(String uri) async {
    final Response response = await _apiClient.getData(uri);
    if (response.statusCode == 200) {
      return _extractList(
        response.body,
      ).map(LogisticsOpportunityModel.fromJson).toList();
    }
    return <LogisticsOpportunityModel>[];
  }

  Future<LogisticsOpportunityModel?> _getOne(String uri) async {
    final Response response = await _apiClient.getData(uri);
    if (response.statusCode == 200 && response.body is Map) {
      return LogisticsOpportunityModel.fromJson(
        Map<String, dynamic>.from(response.body),
      );
    }
    return null;
  }

  List<Map<String, dynamic>> _extractList(dynamic body) {
    final dynamic list = body is List
        ? body
        : body is Map
        ? body['data'] ?? body['jobs'] ?? body['loads'] ?? body['records']
        : null;
    if (list is! List) return <Map<String, dynamic>>[];
    return list
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
