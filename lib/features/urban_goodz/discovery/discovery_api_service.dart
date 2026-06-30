import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/urban_goodz/discovery/discovery_search_capture_model.dart';
import 'package:sixam_mart/util/app_constants.dart';

class DiscoveryApiService {
  final ApiClient apiClient;

  const DiscoveryApiService({required this.apiClient});

  Future<Response> captureSearch(DiscoverySearchCaptureModel capture) {
    debugPrint('[UG Discovery] appBaseUrl: ${apiClient.appBaseUrl}');
    debugPrint('[UG Discovery] submit path: ${AppConstants.ugDiscoverySearchCaptureUri}');
    debugPrint('[UG Discovery] final endpoint: ${apiClient.appBaseUrl}${AppConstants.ugDiscoverySearchCaptureUri}');

    return apiClient.postData(
      AppConstants.ugDiscoverySearchCaptureUri,
      capture.toJson(),
    );
  }

  Future<Response> getEntities() {
    return apiClient.getData(AppConstants.ugDiscoveryEntitiesUri);
  }

  Future<Response> getEntity(int id) {
    return apiClient.getData('${AppConstants.ugDiscoveryEntitiesUri}/$id');
  }

  Future<Response> submitEntityAction(int id, Map<String, dynamic> body) {
    return apiClient.postData(
      '${AppConstants.ugDiscoveryEntitiesUri}/$id/action',
      body,
    );
  }

  Future<Response> getOpportunities() {
    return apiClient.getData(AppConstants.ugDiscoveryOpportunitiesUri);
  }

  Future<Response> acceptOpportunity(int id) {
    return apiClient.postData(
      '${AppConstants.ugDiscoveryOpportunitiesUri}/$id/accept',
      <String, dynamic>{},
    );
  }
}
