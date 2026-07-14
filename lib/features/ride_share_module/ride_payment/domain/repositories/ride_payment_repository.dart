   
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart/util/app_constants.dart';

import '../../../../../api/api_client.dart';
import 'ride_payment_repository_interface.dart';

class RidePaymentRepository implements RidePaymentRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  RidePaymentRepository({required this.apiClient, required this.sharedPreferences});


  @override
  Future<Response> submitReview(String id, int ratting, String comment ) async {
    return await apiClient.postData(AppConstants.submitReview,{
      "ride_request_id" : id,
      "rating" : ratting,
      "feedback" : comment
    });
  }

  @override
  Future<Response> paymentSubmit(String tripId, String paymentMethod, String tips) async {
    return await apiClient.getData('${AppConstants.paymentUri}?ride_request_id=$tripId&payment_method=$paymentMethod&tips=$tips');
  }
  @override
  Future getPaymentGetWayList() async{
    return await apiClient.getData(AppConstants.getPaymentMethods);
  }

  @override
  Future<bool?> saveLastPaymentMethod(String method) async {
    return await sharedPreferences.setString(AppConstants.paymentMethod, method);
  }


  @override
  String getLastPaymentMethod() {
    return sharedPreferences.getString(AppConstants.paymentMethod) ?? "";
  }

  @override
  Future<bool?> saveLastPaymentType(String type) async {
    return await sharedPreferences.setString(AppConstants.paymentType, type);
  }


  @override
  String getLastPaymentType() {
    return sharedPreferences.getString(AppConstants.paymentType) ?? "";
  }

  @override
  Future add(value) async {
    return await apiClient.postData(AppConstants.paymentUri, value);
  }

  @override
  Future delete(int? id) async {
    return await apiClient.deleteData('${AppConstants.paymentUri}/$id');
  }

  @override
  Future get(String? id) async {
    return await apiClient.getData('${AppConstants.paymentUri}/$id');
  }

  @override
  Future getList({int? offset}) async {
    return await apiClient.getData('${AppConstants.getPaymentMethods}?limit=10&offset=$offset');
  }

  @override
  Future update(Map<String, dynamic> body, int? id) async {
    return await apiClient.postData('${AppConstants.paymentUri}/$id', body);
  }

}
  