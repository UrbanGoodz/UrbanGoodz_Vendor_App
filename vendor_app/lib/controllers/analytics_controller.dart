import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/analytics_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class AnalyticsController extends GetxController {
  final analyticsData = <AnalyticsModel>[].obs;
  final selectedPeriod = '7d'.obs;
  final revenueGrowth = 0.0.obs;
  final orderGrowth = 0.0.obs;
  final customerGrowth = 0.0.obs;
  final categoryBreakdown = <String, double>{}.obs;
  final popularTimeSlots = <MapEntry<String, int>>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final repository = Get.find<VendorRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final rows = await repository.allOrders();
      final now = DateTime.now();
      final days = selectedPeriod.value == '90d'
          ? 90
          : selectedPeriod.value == '30d'
          ? 30
          : 7;
      final cutoff = now.subtract(Duration(days: days));
      final current = rows.where((row) {
        final date = DateTime.tryParse(row['created_at']?.toString() ?? '');
        return date != null && date.isAfter(cutoff);
      }).toList();
      final revenue = current.fold<double>(
        0,
        (sum, row) =>
            sum + (double.tryParse(row['order_amount']?.toString() ?? '') ?? 0),
      );
      final customers = current
          .map((row) => row['user_id']?.toString())
          .whereType<String>()
          .toSet()
          .length;
      final hours = <String, int>{};
      for (final row in current) {
        final date = DateTime.tryParse(row['created_at']?.toString() ?? '');
        if (date != null) {
          final key = '${date.hour.toString().padLeft(2, '0')}:00';
          hours[key] = (hours[key] ?? 0) + 1;
        }
      }
      analyticsData.assignAll([
        AnalyticsModel(
          label: 'Revenue',
          value: revenue,
          category: 'revenue',
          date: now.toIso8601String(),
          totalRevenue: revenue,
        ),
        AnalyticsModel(
          label: 'Orders',
          value: current.length.toDouble(),
          category: 'orders',
          date: now.toIso8601String(),
          totalOrders: current.length,
        ),
        AnalyticsModel(
          label: 'Customers',
          value: customers.toDouble(),
          category: 'customers',
          date: now.toIso8601String(),
          newCustomers: customers,
        ),
      ]);
      revenueGrowth.value = 0;
      orderGrowth.value = 0;
      customerGrowth.value = 0;
      categoryBreakdown.value = {'Order commerce': revenue};
      popularTimeSlots.assignAll(
        hours.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
      );
    } on VendorApiException catch (e) {
      errorMessage.value = e.message;
      analyticsData.clear();
      categoryBreakdown.clear();
      popularTimeSlots.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    fetchAnalytics();
  }
}
