import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/revenue_model.dart';
import 'package:urban_goodz_vendor/repositories/api_client.dart';
import 'package:urban_goodz_vendor/controllers/vendor_auth_controller.dart';

class RevenueTrackingController extends GetxController {
  final revenueEntries = <RevenueModel>[].obs;
  final totalRevenue = 0.0.obs;
  final totalPayouts = 0.0.obs;
  final pendingPayout = 0.0.obs;
  final availableForPayout = 0.0.obs;
  final revenueBySource = <String, double>{}.obs;
  final selectedPeriod = '7d'.obs;
  final filteredEntries = <RevenueModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRevenue();
  }

  Future<void> fetchRevenue() async {
    final auth = Get.find<VendorAuthController>();
    if (auth.token.isEmpty) return;

    isLoading.value = true;
    try {
      final client = Get.find<ApiClient>();
      
      // Update profile stats first to ensure withdrawable balance is fresh
      await auth.fetchProfile();
      availableForPayout.value = auth.withdrawableBalance.value;
      pendingPayout.value = auth.pendingWithdraw.value;
      totalPayouts.value = auth.totalWithdrawn.value;
      totalRevenue.value = auth.totalEarning.value;

      final response = await client.get('/vendor/get-withdraw-list');
      if (response.status.isOk && response.body != null) {
        final List<dynamic> list = response.body is List ? response.body : [];
        final mapped = list.map((json) {
          final amt = double.tryParse(json['amount']?.toString() ?? '0.0') ?? 0.0;
          final statusStr = json['status']?.toString().toLowerCase() ?? 'pending';
          
          return RevenueModel(
            id: json['id']?.toString() ?? '',
            source: 'Payout',
            amount: amt,
            status: statusStr == 'approved' ? 'settled' : statusStr,
            date: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
            description: 'Vendor withdrawal request via bank/method.',
          );
        }).toList();

        revenueEntries.value = mapped;
        _applyPeriodFilter();
      }
    } catch (e) {
      debugPrint('Error fetching revenue/withdrawals: $e');
    }
    isLoading.value = false;
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

  Future<void> requestPayout(double amount) async {
    isLoading.value = true;
    try {
      final client = Get.find<ApiClient>();
      
      // Fetch available withdrawal methods
      final methodsRes = await client.get('/vendor/get-withdraw-method-list');
      int methodId = 1;
      if (methodsRes.status.isOk && methodsRes.body != null) {
        final List<dynamic> methods = methodsRes.body is List ? methodsRes.body : [];
        if (methods.isNotEmpty) {
          methodId = int.tryParse(methods.first['id']?.toString() ?? '1') ?? 1;
        }
      }

      final response = await client.post('/vendor/request-withdraw', {
        'amount': amount,
        'id': methodId,
      });

      if (response.status.isOk) {
        Get.snackbar(
          'Withdrawal Placed',
          'Payout request for \$${amount.toStringAsFixed(2)} has been submitted.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF),
        );
        await fetchRevenue();
      } else {
        final errorMsg = response.body?['errors']?[0]?['message'] ?? 'Could not place withdrawal.';
        Get.snackbar(
          'Withdrawal Failed',
          errorMsg.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error placing withdrawal: $e');
      // Local fallback
      final newEntry = RevenueModel(
        id: 'R-${DateTime.now().millisecondsSinceEpoch}',
        source: 'Payout',
        amount: amount,
        status: 'pending',
        date: DateTime.now(),
        description: 'Vendor payout request - \$${amount.toStringAsFixed(2)}',
      );
      revenueEntries.add(newEntry);
      _applyPeriodFilter();
    }
    isLoading.value = false;
  }
}
