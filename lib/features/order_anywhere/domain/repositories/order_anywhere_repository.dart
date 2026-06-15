import 'package:image_picker/image_picker.dart';
import 'package:sixam_mart/api/api_client.dart';
import 'package:sixam_mart/features/order_anywhere/domain/models/order_anywhere_request_model.dart';
import 'package:sixam_mart/features/order_anywhere/domain/repositories/order_anywhere_repository_interface.dart';
import 'package:sixam_mart/util/app_constants.dart';

class OrderAnywhereRepository implements OrderAnywhereRepositoryInterface {
  final ApiClient apiClient;

  OrderAnywhereRepository({required this.apiClient});

  @override
  Future<List<OrderAnywhereRequestModel>> getMyRequests() async {
    final response = await apiClient.getData(AppConstants.orderAnywhereListUri);
    if (response.statusCode == 200 && response.body['data'] != null) {
      final List<dynamic> list = response.body['data'];
      return list.map((e) => OrderAnywhereRequestModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to fetch requests: ${response.statusCode}');
  }

  @override
  Future<OrderAnywhereRequestModel?> getRequestById(String id) async {
    final response = await apiClient.getData('${AppConstants.orderAnywhereRequestUri}/$id');
    if (response.statusCode == 200 && response.body['data'] != null) {
      return OrderAnywhereRequestModel.fromJson(response.body['data'] as Map<String, dynamic>);
    }
    throw Exception('Failed to fetch request: ${response.statusCode}');
  }

  @override
  Future<OrderAnywhereRequestModel?> submitRequest(OrderAnywhereRequestModel request) async {
    final response = await apiClient.postData(AppConstants.orderAnywhereRequestUri, request.toJson());
    if ((response.statusCode == 200 || response.statusCode == 201) && response.body['data'] != null) {
      return OrderAnywhereRequestModel.fromJson(response.body['data'] as Map<String, dynamic>);
    }
    throw Exception('Backend endpoint pending. This tester build cannot submit live Order Anywhere requests yet. (${response.statusCode})');
  }

  @override
  Future<bool> markPaymentTest(String requestId) async {
    final response = await apiClient.postData(
      '${AppConstants.orderAnywhereRequestUri}/$requestId/test-payment', {},
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Test payment endpoint not available. Backend pending. (${response.statusCode})');
  }

  @override
  Future<bool> uploadReceipt(String requestId, String? imagePath, {double? receiptAmount, String? receiptNotes}) async {
    final Map<String, String> fields = {};
    if (receiptAmount != null) fields['receipt_amount'] = receiptAmount.toString();
    if (receiptNotes != null && receiptNotes.isNotEmpty) fields['receipt_notes'] = receiptNotes;

    final List<MultipartBody> files = [];
    if (imagePath != null && imagePath.isNotEmpty) {
      files.add(MultipartBody('receipt_image', XFile(imagePath)));
    }

    final response = await apiClient.postMultipartData(
      '${AppConstants.orderAnywhereRequestUri}/$requestId/receipt',
      fields,
      files,
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Receipt upload endpoint not available. Backend pending. (${response.statusCode})');
  }

  @override
  Future<bool> cancelRequest(String requestId) async {
    final response = await apiClient.postData(
      '${AppConstants.orderAnywhereRequestUri}/$requestId/cancel', {},
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Cancel endpoint not available. Backend pending. (${response.statusCode})');
  }

  @override
  Future<double> getEstimatedDeliveryFee(String? address) async {
    final response = await apiClient.getData(AppConstants.orderAnywhereEstimateUri);
    if (response.statusCode == 200 && response.body['fee'] != null) {
      return (response.body['fee'] as num).toDouble();
    }
    throw Exception('Estimate endpoint not available. Backend pending. (${response.statusCode})');
  }
}
