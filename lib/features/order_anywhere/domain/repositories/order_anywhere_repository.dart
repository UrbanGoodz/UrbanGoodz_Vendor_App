import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
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
    // Map model fields to backend-accepted parameter names
    final Map<String, dynamic> payload = {
      'store_vendor_name': request.businessName,
      'store_vendor_address_or_website': request.businessAddress ?? '',
      'request_details': request.itemName,
      'item_details': request.itemDescription ?? '',
      'quantity': request.quantity,
      'budget_estimate': request.estimatedItemCost,
      // include some additional useful fields that backend may accept
      if (request.customerNotes != null) 'customer_notes': request.customerNotes,
      if (request.deliveryAddress != null) 'delivery_address': request.deliveryAddress,
      if (request.contactPhone != null) 'contact_phone': request.contactPhone,
      'pickup_preference': request.pickupPreference.name,
      'urgency': request.urgency.name,
      'consent_given': request.consentGiven,
    };

    debugPrint('OrderAnywhereRepository.submitRequest: POST ${AppConstants.orderAnywhereRequestUri}');
    debugPrint('OrderAnywhereRepository.submitRequest payload: $payload');

    // Ask ApiClient not to auto-handle errors so we can surface actual status/text
    final response = await apiClient.postData(AppConstants.orderAnywhereRequestUri, payload, handleError: false);

    debugPrint('OrderAnywhereRepository.submitRequest response: ${response.statusCode} ${response.statusText}');

    if ((response.statusCode == 200 || response.statusCode == 201) && response.body != null && response.body['data'] != null) {
      return OrderAnywhereRequestModel.fromJson(response.body['data'] as Map<String, dynamic>);
    }

    final String message = response.statusText ?? 'Failed to submit Order Anywhere request (${response.statusCode})';
    throw Exception(message);
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
