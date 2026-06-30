import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/urban_goodz/domain/models/medical_courier_job_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

class MedicalCourierApiService {
  final ApiClient _apiClient;

  MedicalCourierApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? Get.find<ApiClient>();

  Future<List<MedicalCourierJobModel>> getJobs() async {
    final Response response = await _apiClient.getData(
      AppConstants.ugMedicalCourierJobsUri,
    );
    if (response.statusCode == 200) {
      return _extractList(
        response.body,
      ).map(MedicalCourierJobModel.fromJson).toList();
    }
    return <MedicalCourierJobModel>[];
  }

  Future<MedicalCourierJobModel?> getJob(String record) async {
    final Response response = await _apiClient.getData(
      '${AppConstants.ugMedicalCourierJobsUri}/$record',
    );
    if (response.statusCode == 200 && response.body is Map) {
      return MedicalCourierJobModel.fromJson(
        Map<String, dynamic>.from(response.body),
      );
    }
    return null;
  }

  Future<Response> acceptJob(String record) => _apiClient.postData(
    '${AppConstants.ugMedicalCourierJobsUri}/$record/accept',
    <String, dynamic>{},
  );

  Future<Response> updateJobStatus(String record, String status) =>
      _apiClient.postData(
        '${AppConstants.ugMedicalCourierJobsUri}/$record/status',
        {'status': status},
      );

  Future<Response> updateCustody(String record, Map<String, dynamic> custody) =>
      _apiClient.postData(
        '${AppConstants.ugMedicalCourierJobsUri}/$record/custody',
        custody,
      );

  List<Map<String, dynamic>> _extractList(dynamic body) {
    final dynamic list = body is List
        ? body
        : body is Map
        ? body['data'] ?? body['jobs'] ?? body['records']
        : null;
    if (list is! List) return <Map<String, dynamic>>[];
    return list
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
