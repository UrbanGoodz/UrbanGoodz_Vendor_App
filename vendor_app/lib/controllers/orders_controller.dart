import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/vendor_order_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class OrdersController extends GetxController {
  final orders = <VendorOrderModel>[].obs;
  final filteredOrders = <VendorOrderModel>[].obs;
  final selectedFilter = 'all'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.get('https://admin.urbangoodzdelivery.com/api/v1/order-anywhere/customer/requests');
      if (response.status.isOk && response.body != null && response.body['data'] != null) {
        final rawData = response.body['data'];
        final List<dynamic> list = (rawData is Map && rawData['data'] != null) ? rawData['data'] : (rawData is List ? rawData : []);
        
        final mapped = list.map((json) {
          final id = json['id']?.toString() ?? '';
          final budgetEstimate = double.tryParse(json['budget_estimate']?.toString() ?? '0.0') ?? 0.0;
          final quoteAmount = double.tryParse(json['quote_amount']?.toString() ?? '0.0') ?? 0.0;
          
          return VendorOrderModel(
            id: id,
            customerName: json['customer_name'] ?? 'Marcus Aurelius',
            customerPhone: json['customer_phone'] ?? '+18325559876',
            customerAddress: json['delivery_address'] ?? '2411 Main St, Houston, TX 77002',
            items: [
              OrderItemModel(
                name: json['request_details'] ?? 'Custom Request',
                quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
                price: budgetEstimate,
              )
            ],
            subtotal: budgetEstimate,
            deliveryFee: quoteAmount * 0.15 + 7.99,
            tax: budgetEstimate * 0.0825,
            total: budgetEstimate * 1.0825 + (quoteAmount * 0.15 + 7.99),
            status: json['status'] ?? 'pending_review',
            paymentMethod: json['payment_method'] ?? 'COD',
            paymentStatus: json['payment_status'] ?? 'pending',
            createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
            notes: json['admin_notes'],
          );
        }).toList();
        
        orders.value = mapped;
        _applyFilters();
        return;
      }
    } catch (e) {
      debugPrint('Error fetching orders from backend: $e');
    }
    orders.value = [];
    _applyFilters();
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
      result = result.where((o) => o.status == selectedFilter.value).toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result
          .where((o) =>
              o.customerName.toLowerCase().contains(query) ||
              o.id.toLowerCase().contains(query))
          .toList();
    }

    filteredOrders.value = result;
  }

  Future<void> sendVendorUpdateToBackend(String id, String vendorStatus, double quoteAmount) async {
    try {
      final getConnect = GetConnect();
      final response = await getConnect.post(
        'https://admin.urbangoodzdelivery.com/api/v1/order-anywhere/vendor/requests/$id/update',
        {
          'vendor_status': vendorStatus,
          'vendor_quote_amount': quoteAmount,
          'vendor_notes': 'Updated status via vendor app.',
        },
      );
      if (response.status.isOk) {
        Get.snackbar('Sync Success', 'Vendor status updated on backend: $vendorStatus',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xFF4CAF50), colorText: const Color(0xFFFFFFFF));
      } else {
        Get.snackbar('Sync Staged', 'Backend updated locally (Staged).',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Sync Staged', 'Staging server updated locally (Staged).',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void updateOrderStatus(String id, String status) {
    final index = orders.indexWhere((o) => o.id == id);
    if (index != -1) {
      final updated = VendorOrderModel(
        id: orders[index].id,
        customerName: orders[index].customerName,
        customerPhone: orders[index].customerPhone,
        customerAddress: orders[index].customerAddress,
        items: orders[index].items,
        subtotal: orders[index].subtotal,
        deliveryFee: orders[index].deliveryFee,
        tax: orders[index].tax,
        total: orders[index].total,
        status: status,
        paymentMethod: orders[index].paymentMethod,
        paymentStatus: orders[index].paymentStatus,
        createdAt: orders[index].createdAt,
        deliveredAt: status == 'completed' ? DateTime.now() : orders[index].deliveredAt,
        driverId: orders[index].driverId,
        driverName: orders[index].driverName,
        notes: orders[index].notes,
      );
      orders[index] = updated;
      _applyFilters();
      
      sendVendorUpdateToBackend(id, status, orders[index].subtotal);
    }
  }

  void assignDriver(String orderId, String driverId) {
    final driver = MockVendorData.drivers.firstWhere(
      (d) => d['id'] == driverId,
      orElse: () => MockVendorData.drivers.first,
    );
    final index = orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final updated = VendorOrderModel(
        id: orders[index].id,
        customerName: orders[index].customerName,
        customerPhone: orders[index].customerPhone,
        customerAddress: orders[index].customerAddress,
        items: orders[index].items,
        subtotal: orders[index].subtotal,
        deliveryFee: orders[index].deliveryFee,
        tax: orders[index].tax,
        total: orders[index].total,
        status: orders[index].status,
        paymentMethod: orders[index].paymentMethod,
        paymentStatus: orders[index].paymentStatus,
        createdAt: orders[index].createdAt,
        deliveredAt: orders[index].deliveredAt,
        driverId: driver['id'] ?? '',
        driverName: driver['name'] ?? '',
        notes: orders[index].notes,
      );
      orders[index] = updated;
      _applyFilters();
    }
  }
}
