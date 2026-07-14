import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'safety_alert_repository_interface.dart';

class SafetyAlertRepository implements SafetyAlertRepositoryInterface {
  final ApiClient apiClient;
  SafetyAlertRepository({required this.apiClient});

  @override
  Future add(value) async {
    return await apiClient.postData(AppConstants.storeSafetyAlert, value);
  }

  @override
  Future delete(int? id) async {
    return await apiClient.deleteData('${AppConstants.undoSafetyAlert}$id');
  }

  @override
  Future get(String? id) async {
    return await apiClient.getData('${AppConstants.customerAlertDetails}$id');
  }

  @override
  Future getList({int? offset}) async {
    return await apiClient.getData(AppConstants.getSafetyAlertReasonList);
  }

  @override
  Future update(Map<String, dynamic> body, int? id) async {
    return await apiClient.postData('${AppConstants.markAsSolvedSafetyAlert}$id', body);
  }

}
  