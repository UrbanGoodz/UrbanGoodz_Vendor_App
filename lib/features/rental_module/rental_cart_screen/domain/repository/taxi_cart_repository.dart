import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/features/rental_module/rental_cart_screen/domain/repository/taxi_cart_repository_interface.dart';

class TaxiCartRepository implements TaxiCartRepositoryInterface{
  final ApiClient apiClient;
  TaxiCartRepository({required this.apiClient});

  @override
  Future add(value) async {
    return await apiClient.postData(AppConstants.addToCarCartUri, value);
  }

  @override
  Future delete(int? id) async {
    return await apiClient.deleteData('${AppConstants.removeCarCartUri}/$id');
  }

  @override
  Future get(String? id) async {
    return await apiClient.getData('${AppConstants.getCarCartListUri}/$id');
  }

  @override
  Future getList({int? offset}) async {
    return await apiClient.getData('${AppConstants.getCarCartListUri}?limit=10&offset=$offset');
  }

  @override
  Future update(Map<String, dynamic> body, int? id) async {
    return await apiClient.postData('${AppConstants.updateCarCartUri}/$id', body);
  }


  
}