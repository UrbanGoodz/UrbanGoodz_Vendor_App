import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';
import 'package:sixam_mart/features/order_anywhere/domain/services/order_anywhere_service_interface.dart';
import 'package:sixam_mart/features/order_anywhere/domain/repositories/order_anywhere_repository_interface.dart';

class OrderAnywhereService implements OrderAnywhereServiceInterface {
  final OrderAnywhereRepositoryInterface orderAnywhereRepositoryInterface;
  OrderAnywhereService({required this.orderAnywhereRepositoryInterface});

  @override
  Future<List<OrderAnywhereRequestModel>> getMyRequests() async {
    return await orderAnywhereRepositoryInterface.getMyRequests();
  }

  @override
  Future<OrderAnywhereRequestModel?> getRequestById(String id) async {
    return await orderAnywhereRepositoryInterface.getRequestById(id);
  }

  @override
  Future<OrderAnywhereRequestModel?> submitRequest(OrderAnywhereRequestModel request) async {
    return await orderAnywhereRepositoryInterface.submitRequest(request);
  }

  @override
  Future<bool> markPaymentTest(String requestId) async {
    return await orderAnywhereRepositoryInterface.markPaymentTest(requestId);
  }

  @override
  Future<bool> uploadReceipt(String requestId, String? imagePath, {double? receiptAmount, String? receiptNotes}) async {
    return await orderAnywhereRepositoryInterface.uploadReceipt(requestId, imagePath, receiptAmount: receiptAmount, receiptNotes: receiptNotes);
  }

  @override
  Future<bool> cancelRequest(String requestId) async {
    return await orderAnywhereRepositoryInterface.cancelRequest(requestId);
  }

  @override
  Future<double> getEstimatedDeliveryFee(String? address) async {
    return await orderAnywhereRepositoryInterface.getEstimatedDeliveryFee(address);
  }
}
