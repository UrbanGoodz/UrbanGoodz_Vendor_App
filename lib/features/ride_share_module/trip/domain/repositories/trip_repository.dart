   
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixam_mart/util/app_constants.dart';

import '../../../../../api/api_client.dart';
import 'trip_repository_interface.dart';

class TripRepository implements TripRepositoryInterface {
  final ApiClient apiClient;
  TripRepository({required this.apiClient});

  @override
  Future<Response> getTripList(String tripType, int offset, String from, String to, String filter,String status) async {
    return await apiClient.getData('${AppConstants.tripList}?type=ride_request&limit=20&offset=$offset&filter=$filter&start=$from&end=$to&status=$status');
  }

  @override
  Future getRideCancellationReasonList() async{
    return await apiClient.getData(AppConstants.rideCancellationReasonList);
  }

  @override
  Future<Response> submitReview(String id, int ratting, String comment ) async {
    return await apiClient.postData(AppConstants.submitReview,{
      "ride_request_id" : id,
      "rating" : ratting,
      "feedback" : comment,
    });
  }

  // @override
  // Future getParcelCancellationReasonList() async{
  //   return await apiClient.getData(AppConstants.parcelCancellationReasonList);
  // }

  @override
  Future add(value) async {
    return await apiClient.postData(AppConstants.tripList, value);
  }

  @override
  Future delete(int? id) async {
    return await apiClient.deleteData('${AppConstants.tripList}/$id');
  }

  @override
  Future get(String? id) async {
    return await apiClient.getData('${AppConstants.tripDetails}/$id');
  }

  @override
  Future getList({int? offset}) async {
    return await apiClient.getData('${AppConstants.tripList}?limit=20&offset=$offset');
  }

  @override
  Future update(Map<String, dynamic> body, int? id) async {
    return await apiClient.postData('${AppConstants.updateTripStatus}/$id', body);
  }

}
  