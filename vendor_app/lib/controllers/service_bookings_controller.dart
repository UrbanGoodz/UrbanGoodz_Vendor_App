import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/service_booking_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class ServiceBookingsController extends GetxController {
  final bookings = <ServiceBookingModel>[].obs;
  final filteredBookings = <ServiceBookingModel>[].obs;
  final selectedFilter = 'all'.obs;
  final selectedDate = ''.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final repository = Get.find<VendorRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final rows = await repository.serviceBookings();
      bookings.assignAll(rows.map(ServiceBookingModel.fromJson));
      _applyFilters();
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      bookings.clear();
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
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
      result = result.where((b) => b.status == selectedFilter.value).toList();
    }

    if (selectedDate.value.isNotEmpty) {
      result = result
          .where(
            (b) =>
                b.bookingDate.toIso8601String().startsWith(selectedDate.value),
          )
          .toList();
    }

    filteredBookings.value = result;
  }

  Future<void> confirmBooking(String id) async {
    await updateStatus(id, 'accepted');
  }

  Future<void> completeBooking(String id) async {
    await updateStatus(id, 'completed');
  }

  Future<void> cancelBooking(String id, String reason) async {
    await updateStatus(id, 'declined', notes: reason);
  }

  Future<void> updateStatus(String id, String status, {String? notes}) async {
    try {
      await repository.updateServiceBookingStatus(id, status, notes: notes);
      await fetchBookings();
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      Get.snackbar('Booking update failed', error.message);
    }
  }

  Future<void> submitQuote(
    String id,
    double amount,
    double deposit,
    DateTime scheduledAt,
    String? notes,
  ) async {
    try {
      await repository.quoteServiceBooking(
        id,
        amountMinor: (amount * 100).round(),
        depositMinor: (deposit * 100).round(),
        scheduledAt: scheduledAt,
        notes: notes,
      );
      await fetchBookings();
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      Get.snackbar('Quote failed', error.message);
    }
  }
}
