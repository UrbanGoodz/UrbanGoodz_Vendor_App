import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';

abstract class OrderAnywhereServiceInterface {
  Future<List<OrderAnywhereRequestModel>> getMyRequests();
  Future<OrderAnywhereRequestModel?> getRequestById(String id);
  Future<OrderAnywhereRequestModel?> submitRequest(OrderAnywhereRequestModel request);
  Future<bool> markPaymentTest(String requestId);
  Future<bool> uploadReceipt(String requestId, String? imagePath);
  Future<bool> cancelRequest(String requestId);
  Future<double> getEstimatedDeliveryFee(String? address);
}
