import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/urban_goodz/domain/models/earn_money_opportunity_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

class EarnMoneyApiService {
  final ApiClient _apiClient;

  EarnMoneyApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? Get.find<ApiClient>();

  Future<List<EarnMoneyOpportunityModel>> getOpportunities() async {
    final Response response = await _apiClient.getData(
      AppConstants.ugEarnMoneyOpportunitiesUri,
    );
    if (response.statusCode == 200) {
      return _extractList(
        response.body,
      ).map(EarnMoneyOpportunityModel.fromJson).toList();
    }
    return <EarnMoneyOpportunityModel>[];
  }

  Future<EarnMoneyOpportunityModel?> getOpportunity(String record) async {
    final Response response = await _apiClient.getData(
      '${AppConstants.ugEarnMoneyOpportunitiesUri}/$record',
    );
    if (response.statusCode == 200 && response.body is Map) {
      return EarnMoneyOpportunityModel.fromJson(
        Map<String, dynamic>.from(response.body),
      );
    }
    return null;
  }

  Future<Response> acceptOpportunity(String record) {
    return _apiClient.postData(
      '${AppConstants.ugEarnMoneyOpportunitiesUri}/$record/accept',
      <String, dynamic>{},
    );
  }

  List<Map<String, dynamic>> _extractList(dynamic body) {
    final dynamic list = body is List
        ? body
        : body is Map
        ? body['data'] ?? body['opportunities'] ?? body['records']
        : null;
    if (list is! List) return <Map<String, dynamic>>[];
    return list
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
