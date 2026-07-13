import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/revenue_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class RevenueTrackingController extends GetxController {
  final repository = Get.find<VendorRepository>();
  final revenueEntries = <RevenueModel>[].obs;
  final totalRevenue = 0.0.obs;
  final totalPayouts = 0.0.obs;
  final pendingPayout = 0.0.obs;
  final availableForPayout = 0.0.obs;
  final revenueBySource = <String, double>{}.obs;
  final selectedPeriod = '7d'.obs;
  final filteredEntries = <RevenueModel>[].obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchRevenue();
  }

  Future<void> fetchRevenue() async {
    errorMessage.value = null;
    try {
      final profile = await repository.profile();
      final withdrawals = await repository.withdrawals();
      totalRevenue.value = _double(profile['total_earning']);
      totalPayouts.value = _double(profile['total_withdrawn']);
      pendingPayout.value = _double(profile['pending_withdraw']);
      availableForPayout.value = _double(profile['withdraw_able_balance']);
      revenueBySource.value = {'Order earnings': totalRevenue.value};
      revenueEntries.assignAll(
        withdrawals.map(
          (row) => RevenueModel(
            id: row['id']?.toString() ?? '',
            source: 'Payout',
            amount: _double(row['amount']),
            status: row['status']?.toString().toLowerCase() ?? 'pending',
            date:
                DateTime.tryParse(row['requested_at']?.toString() ?? '') ??
                DateTime.now(),
            description: row['bank_name']?.toString() ?? 'Withdrawal request',
          ),
        ),
      );
      _applyPeriodFilter();
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      revenueEntries.clear();
      _applyPeriodFilter();
    }
  }

  void changePeriod(String period) {
    selectedPeriod.value = period;
    _applyPeriodFilter();
  }

  void _applyPeriodFilter() {
    final days = selectedPeriod.value == '90d'
        ? 90
        : selectedPeriod.value == '30d'
        ? 30
        : 7;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    filteredEntries.assignAll(
      revenueEntries.where((entry) => entry.date.isAfter(cutoff)),
    );
  }

  Future<void> requestPayout(double amount) async {
    try {
      final methods = await repository.withdrawalMethods();
      if (methods.isEmpty) {
        throw const VendorApiException(
          422,
          'No withdrawal method is configured for this Vendor account.',
        );
      }
      final methodId = methods.first['id']?.toString();
      if (methodId == null || methodId.isEmpty) {
        throw const VendorApiException(
          422,
          'The backend returned an invalid withdrawal method.',
        );
      }
      await repository.requestWithdrawal(amount, methodId);
      await fetchRevenue();
      Get.snackbar(
        'Payout requested',
        'Your withdrawal request was submitted.',
      );
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      Get.snackbar('Payout failed', error.message);
    }
  }

  static double _double(Object? value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;
}
