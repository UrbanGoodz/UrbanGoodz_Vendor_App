import 'dart:math';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';
import 'package:sixam_mart/features/order_anywhere/domain/repositories/order_anywhere_repository_interface.dart';
import 'package:sixam_mart/util/app_constants.dart';

class OrderAnywhereRepository implements OrderAnywhereRepositoryInterface {
  final ApiClient apiClient;

  OrderAnywhereRepository({required this.apiClient});

  @override
  Future<List<OrderAnywhereRequestModel>> getMyRequests() async {
    try {
      final response = await apiClient.getData(AppConstants.orderAnywhereListUri);
      if (response.statusCode == 200 && response.body['data'] != null) {
        final List<dynamic> list = response.body['data'];
        return list.map((e) => OrderAnywhereRequestModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<OrderAnywhereRequestModel?> getRequestById(String id) async {
    try {
      final response = await apiClient.getData('${AppConstants.orderAnywhereRequestUri}/$id');
      if (response.statusCode == 200 && response.body['data'] != null) {
        return OrderAnywhereRequestModel.fromJson(response.body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<OrderAnywhereRequestModel?> submitRequest(OrderAnywhereRequestModel request) async {
    try {
      final response = await apiClient.postData(AppConstants.orderAnywhereRequestUri, request.toJson());
      if (response.statusCode == 200 && response.body['data'] != null) {
        return OrderAnywhereRequestModel.fromJson(response.body['data'] as Map<String, dynamic>);
      }
    } catch (_) {}
    return _mockCreate(request);
  }

  @override
  Future<bool> markPaymentTest(String requestId) async {
    try {
      final response = await apiClient.postData('${AppConstants.orderAnywherePaymentUri}/$requestId', {});
      if (response.statusCode == 200) return true;
    } catch (_) {}
    return true;
  }

  @override
  Future<bool> uploadReceipt(String requestId, String? imagePath) async {
    try {
      final response = await apiClient.postMultipartData(
        '${AppConstants.orderAnywhereReceiptUri}/$requestId',
        {},
        [],
      );
      if (response.statusCode == 200) return true;
    } catch (_) {}
    return false;
  }

  @override
  Future<bool> cancelRequest(String requestId) async {
    try {
      final response = await apiClient.postData('${AppConstants.orderAnywhereCancelUri}/$requestId', {});
      if (response.statusCode == 200) return true;
    } catch (_) {}
    return false;
  }

  @override
  Future<double> getEstimatedDeliveryFee(String? address) async {
    try {
      final response = await apiClient.getData(AppConstants.orderAnywhereEstimateUri);
      if (response.statusCode == 200 && response.body['fee'] != null) {
        return (response.body['fee'] as num).toDouble();
      }
    } catch (_) {}
    return 7.99;
  }

  OrderAnywhereRequestModel _mockCreate(OrderAnywhereRequestModel request) {
    final id = 'oa_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    return request.copyWith(
      id: id,
      status: OrderAnywhereStatus.draft,
      createdAt: DateTime.now().toIso8601String(),
      estimatedTotal: request.estimatedItemCost + request.estimatedDeliveryFee + request.estimatedServiceFee + request.tip,
    );
  }
}
