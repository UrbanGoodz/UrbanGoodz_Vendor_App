import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';
import 'package:sixam_mart/features/order_anywhere/domain/services/order_anywhere_service_interface.dart';
import 'package:sixam_mart/features/order_anywhere/domain/repositories/order_anywhere_repository_interface.dart';

class OrderAnywhereService implements OrderAnywhereServiceInterface {
  final OrderAnywhereRepositoryInterface orderAnywhereRepositoryInterface;
  OrderAnywhereService({required this.orderAnywhereRepositoryInterface});

  @override
  Future<List<OrderAnywhereRequestModel>> getMyRequests() async {
    try {
      return await orderAnywhereRepositoryInterface.getMyRequests();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<OrderAnywhereRequestModel?> getRequestById(String id) async {
    try {
      return await orderAnywhereRepositoryInterface.getRequestById(id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<OrderAnywhereRequestModel?> submitRequest(OrderAnywhereRequestModel request) async {
    try {
      return await orderAnywhereRepositoryInterface.submitRequest(request);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> markPaymentTest(String requestId) async {
    try {
      return await orderAnywhereRepositoryInterface.markPaymentTest(requestId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> uploadReceipt(String requestId, String? imagePath) async {
    try {
      return await orderAnywhereRepositoryInterface.uploadReceipt(requestId, imagePath);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> cancelRequest(String requestId) async {
    try {
      return await orderAnywhereRepositoryInterface.cancelRequest(requestId);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<double> getEstimatedDeliveryFee(String? address) async {
    try {
      return await orderAnywhereRepositoryInterface.getEstimatedDeliveryFee(address);
    } catch (e) {
      return 7.99;
    }
  }
}
