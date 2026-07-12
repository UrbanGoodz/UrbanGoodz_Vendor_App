import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/analytics_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class AnalyticsController extends GetxController {
  final analyticsData = <AnalyticsModel>[].obs;
  final selectedPeriod = '7d'.obs;
  final revenueGrowth = 0.0.obs;
  final orderGrowth = 0.0.obs;
  final customerGrowth = 0.0.obs;
  final categoryBreakdown = <String, double>{}.obs;
  final popularTimeSlots = <MapEntry<String, int>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnalytics();
  }

  void fetchAnalytics() {
    analyticsData.value = MockVendorData.analytics;

    final revenue = analyticsData.firstWhereOrNull((a) => a.category == 'revenue');
    if (revenue != null) {
      revenueGrowth.value = revenue.growthPercentage;
    }

    final orders = analyticsData.firstWhereOrNull((a) => a.category == 'orders');
    if (orders != null) {
      orderGrowth.value = orders.growthPercentage;
    }

    final customers =
        analyticsData.firstWhereOrNull((a) => a.category == 'customers');
    if (customers != null) {
      customerGrowth.value = customers.growthPercentage;
    }

    categoryBreakdown.value = MockVendorData.categoryBreakdown;
    popularTimeSlots.value = MockVendorData.popularTimeSlots;
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    fetchAnalytics();
  }
}
