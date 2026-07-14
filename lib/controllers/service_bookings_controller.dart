import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/service_booking_model.dart';
import 'package:urban_goodz_vendor/repositories/api_client.dart';
import 'package:urban_goodz_vendor/controllers/vendor_auth_controller.dart';

class ServiceBookingsController extends GetxController {
  final bookings = <ServiceBookingModel>[].obs;
  final filteredBookings = <ServiceBookingModel>[].obs;
  final selectedFilter = 'all'.obs;
  final selectedDate = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final auth = Get.find<VendorAuthController>();
    if (auth.token.isEmpty) {
      bookings.value = [];
      _applyFilters();
      return;
    }

    isLoading.value = true;
    try {
      final client = Get.find<ApiClient>();
      final response = await client.get('/vendor/service-bookings/bookings');
      if (response.status.isOk && response.body != null) {
        final List<dynamic> list = response.body is List ? response.body : (response.body['data'] is List ? response.body['data'] : []);
        final mapped = list.map((json) {
          final amt = double.tryParse(json['amount']?.toString() ?? '0.0') ?? 0.0;
          final customer = json['customer'] ?? {};
          final customerName = '${customer['f_name'] ?? 'Marcus'} ${customer['l_name'] ?? 'Aurelius'}'.trim();
          
          return ServiceBookingModel(
            id: json['id']?.toString() ?? json['uuid'] ?? '',
            serviceName: json['service']?['name'] ?? json['service_name'] ?? 'Service Booking',
            customerName: customerName,
            customerPhone: customer['phone'] ?? '+18325559876',
            customerEmail: customer['email'] ?? 'customer@urbangoodz.com',
            bookingDate: DateTime.tryParse(json['booking_date']?.toString() ?? '') ?? DateTime.now(),
            timeSlot: json['time_slot'] ?? '10:00 AM',
            amount: amt,
            status: json['status'] ?? 'pending',
            notes: json['notes'],
            createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
          );
        }).toList();

        bookings.value = mapped;
        _applyFilters();
        isLoading.value = false;
        return;
      }
    } catch (e) {
      debugPrint('Error fetching service bookings: $e');
    }
    
    // Offline preview fallback
    bookings.value = [];
    _applyFilters();
    isLoading.value = false;
  }

  void filterByStatus(String status) {
    selectedFilter.value = status;
    _applyFilters();
  }

  void filterByDate(String date) {
    selectedDate.value = date;
    _applyFilters();
  }

  void _applyFilters() {
    var result = List<ServiceBookingModel>.from(bookings);

    if (selectedFilter.value != 'all') {
      result =
          result.where((b) => b.status == selectedFilter.value).toList();
    }

    if (selectedDate.value.isNotEmpty) {
      result = result
          .where((b) =>
              b.bookingDate.toIso8601String().startsWith(selectedDate.value))
          .toList();
    }

    filteredBookings.value = result;
  }

  Future<void> confirmBooking(String id) async {
    await _updateStatus(id, 'confirmed');
  }

  Future<void> completeBooking(String id) async {
    await _updateStatus(id, 'completed');
  }

  Future<void> cancelBooking(String id, String reason) async {
    await _updateStatus(id, 'cancelled');
  }

  Future<void> _updateStatus(String id, String status) async {
    try {
      final client = Get.find<ApiClient>();
      final response = await client.post('/vendor/service-bookings/bookings/$id/status', {
        'status': status,
      });

      if (response.status.isOk) {
        Get.snackbar(
          'Booking Synchronized',
          'Booking status changed to $status',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );
        await fetchBookings();
      }
    } catch (e) {
      debugPrint('Error updating booking status: $e');
      
      // Local fallback
      final index = bookings.indexWhere((b) => b.id == id);
      if (index != -1) {
        final b = bookings[index];
        final updated = ServiceBookingModel(
          id: b.id,
          serviceName: b.serviceName,
          customerName: b.customerName,
          customerPhone: b.customerPhone,
          customerEmail: b.customerEmail,
          bookingDate: b.bookingDate,
          timeSlot: b.timeSlot,
          amount: b.amount,
          status: status,
          notes: status == 'cancelled' ? 'Cancelled by vendor' : b.notes,
          createdAt: b.createdAt,
        );
        bookings[index] = updated;
        _applyFilters();
      }
    }
  }
}
