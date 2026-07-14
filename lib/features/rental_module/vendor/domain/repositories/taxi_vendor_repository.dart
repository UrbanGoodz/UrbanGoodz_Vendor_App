
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/features/rental_module/vendor/domain/repositories/taxi_vendor_repository_interface.dart';

class TaxiVendorRepository implements TaxiVendorRepositoryInterface {
  final ApiClient apiClient;

  TaxiVendorRepository({required this.apiClient});


  @override
  Future add(value) async {
    return await apiClient.postData(AppConstants.getProviderDetailsUri, value);
  }

  @override
  Future delete(int? id) async {
    return await apiClient.deleteData('${AppConstants.getProviderDetailsUri}/$id');
  }

  @override
  Future get(String? id) async {
    return await apiClient.getData('${AppConstants.getProviderDetailsUri}/$id');
  }

  @override
  Future getList({int? offset}) async {
    return await apiClient.getData('${AppConstants.getServiceProviderListUri}?limit=10&offset=$offset');
  }

  @override
  Future update(Map<String, dynamic> body, int? id) async {
    return await apiClient.postData('${AppConstants.getProviderDetailsUri}/$id', body);
  }


}