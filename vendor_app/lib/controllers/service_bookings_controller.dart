import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/service_booking_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class ServiceBookingsController extends GetxController {
  final bookings = <ServiceBookingModel>[].obs;
  final filteredBookings = <ServiceBookingModel>[].obs;
  final selectedFilter = 'all'.obs;
  final selectedDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  void fetchBookings() {
    bookings.value = MockVendorData.serviceBookings;
    _applyFilters();
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

  void confirmBooking(String id) {
    _updateStatus(id, 'confirmed');
  }

  void completeBooking(String id) {
    _updateStatus(id, 'completed');
  }

  void cancelBooking(String id, String reason) {
    _updateStatus(id, 'cancelled');
  }

  void _updateStatus(String id, String status) {
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
