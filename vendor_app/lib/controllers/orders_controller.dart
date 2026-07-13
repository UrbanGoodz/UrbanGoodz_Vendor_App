import 'dart:convert';

import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/vendor_order_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class OrdersController extends GetxController {
  final repository = Get.find<VendorRepository>();
  final orders = <VendorOrderModel>[].obs;
  final filteredOrders = <VendorOrderModel>[].obs;
  final selectedFilter = 'all'.obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final rows = await repository.allOrders();
      orders.assignAll(rows.map(fromJson));
      _applyFilters();
    } on VendorApiException catch (error) {
      orders.clear();
      _applyFilters();
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedFilter.value = status;
    _applyFilters();
  }

  void searchOrders(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    var result = List<VendorOrderModel>.from(orders);
    if (selectedFilter.value != 'all') {
      result = result
          .where((order) => order.status == selectedFilter.value)
          .toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result
          .where(
            (order) =>
                order.customerName.toLowerCase().contains(query) ||
                order.id.toLowerCase().contains(query),
          )
          .toList();
    }
    filteredOrders.assignAll(result);
  }

  Future<void> updateOrderStatus(String id, String uiStatus) async {
    final backendStatus = const {
      'confirmed': 'confirmed',
      'preparing': 'processing',
      'ready': 'handover',
      'completed': 'delivered',
      'cancelled': 'canceled',
    }[uiStatus];
    if (backendStatus == null) return;
    try {
      await repository.updateOrderStatus(
        id,
        backendStatus,
        reason: backendStatus == 'canceled'
            ? 'Canceled by vendor from Vendor app'
            : null,
      );
      await fetchOrders();
      Get.snackbar('Order updated', 'Order #$id is now $uiStatus.');
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      Get.snackbar('Update failed', error.message);
    }
  }

  static VendorOrderModel fromJson(Map<String, dynamic> json) {
    final customerValue = json['customer'];
    final customer = customerValue is Map
        ? Map<String, dynamic>.from(customerValue)
        : <String, dynamic>{};
    final address = _address(json['delivery_address']);
    final detailValue = json['details'] ?? json['order_details'];
    final details = detailValue is List
        ? detailValue.whereType<Map>()
        : const Iterable<Map>.empty();
    final items = details.map((raw) {
      final detail = Map<String, dynamic>.from(raw);
      Map<String, dynamic> itemData = const {};
      final encoded = detail['item_details'];
      if (encoded is Map) itemData = Map<String, dynamic>.from(encoded);
      if (encoded is String && encoded.isNotEmpty) {
        try {
          final decoded = jsonDecode(encoded);
          if (decoded is Map) itemData = Map<String, dynamic>.from(decoded);
        } catch (_) {}
      }
      return OrderItemModel(
        name:
            itemData['name']?.toString() ??
            detail['item_name']?.toString() ??
            'Item #${detail['item_id'] ?? ''}',
        quantity: _int(detail['quantity'], fallback: 1),
        price: _double(detail['price']),
      );
    }).toList();
    return VendorOrderModel(
      id: json['id']?.toString() ?? '',
      customerName:
          [customer['f_name'], customer['l_name']]
              .where((value) => value != null && value.toString().isNotEmpty)
              .join(' ')
              .trim()
              .isEmpty
          ? (json['is_guest']?.toString() == '1'
                ? 'Guest customer'
                : 'Customer')
          : [
              customer['f_name'],
              customer['l_name'],
            ].where((value) => value != null).join(' '),
      customerPhone:
          customer['phone']?.toString() ??
          address['contact_person_number']?.toString() ??
          '',
      customerAddress: address['address']?.toString() ?? '',
      items: items,
      subtotal: _double(json['order_amount']),
      deliveryFee: _double(json['delivery_charge']),
      tax: _double(json['total_tax_amount']),
      total: _double(json['order_amount']) + _double(json['delivery_charge']),
      status: _uiStatus(json['order_status']?.toString() ?? ''),
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      deliveredAt: DateTime.tryParse(json['delivered']?.toString() ?? ''),
      driverId: json['delivery_man_id']?.toString(),
      driverName: json['delivery_man'] is Map
          ? '${json['delivery_man']['f_name'] ?? ''} ${json['delivery_man']['l_name'] ?? ''}'
                .trim()
          : null,
      notes: json['order_note']?.toString(),
    );
  }

  static String _uiStatus(String status) =>
      const {
        'processing': 'preparing',
        'handover': 'ready',
        'picked_up': 'ready',
        'delivered': 'completed',
        'refunded': 'completed',
        'canceled': 'cancelled',
      }[status] ??
      status;

  static Map<String, dynamic> _address(Object? value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        return {'address': value};
      }
    }
    return {};
  }

  static double _double(Object? value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;
  static int _int(Object? value, {int fallback = 0}) =>
      int.tryParse(value?.toString() ?? '') ?? fallback;
}
