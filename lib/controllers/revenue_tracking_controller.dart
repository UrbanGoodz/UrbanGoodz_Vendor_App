import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/revenue_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class RevenueTrackingController extends GetxController {
  final revenueEntries = <RevenueModel>[].obs;
  final totalRevenue = 0.0.obs;
  final totalPayouts = 0.0.obs;
  final pendingPayout = 0.0.obs;
  final availableForPayout = 0.0.obs;
  final revenueBySource = <String, double>{}.obs;
  final selectedPeriod = '7d'.obs;
  final filteredEntries = <RevenueModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRevenue();
  }

  void fetchRevenue() {
    revenueEntries.value = MockVendorData.revenueEntries;
    _calculateStats();
    _applyPeriodFilter();
  }

  void _calculateStats() {
    totalRevenue.value = revenueEntries
        .where((r) => r.source != 'Payout')
        .fold<double>(0, (sum, r) => sum + r.amount);

    totalPayouts.value = revenueEntries
        .where((r) => r.source == 'Payout')
        .fold<double>(0, (sum, r) => sum + r.amount);

    pendingPayout.value = revenueEntries
        .where((r) => r.status == 'pending' && r.source != 'Payout')
        .fold<double>(0, (sum, r) => sum + r.amount);

    final settledRevenue = revenueEntries
        .where((r) => r.status == 'settled' && r.source != 'Payout')
        .fold<double>(0, (sum, r) => sum + r.amount);
    availableForPayout.value = settledRevenue - totalPayouts.value;

    final sources = <String, double>{};
    for (final r in revenueEntries) {
      if (r.source != 'Payout') {
        sources[r.source] = (sources[r.source] ?? 0) + r.amount;
      }
    }
    revenueBySource.value = sources;
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    _applyPeriodFilter();
  }

  void _applyPeriodFilter() {
    Duration duration;
    switch (selectedPeriod.value) {
      case '30d':
        duration = const Duration(days: 30);
        break;
      case '90d':
        duration = const Duration(days: 90);
        break;
      case '7d':
      default:
        duration = const Duration(days: 7);
        break;
    }

    final cutoff = DateTime.now().subtract(duration);
    filteredEntries.value =
        revenueEntries.where((r) => r.date.isAfter(cutoff)).toList();
  }

  void requestPayout(double amount) {
    final newEntry = RevenueModel(
      id: 'R-${DateTime.now().millisecondsSinceEpoch}',
      source: 'Payout',
      amount: amount,
      status: 'pending',
      date: DateTime.now(),
      description: 'Vendor payout request - \$${amount.toStringAsFixed(2)}',
    );
    revenueEntries.add(newEntry);
    _calculateStats();
    _applyPeriodFilter();
  }
}
