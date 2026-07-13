import 'package:get/get.dart';
import 'package:urban_goodz_driver/models/payout_model.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';

class PayoutHistoryController extends GetxController {
  DriverApiService get _api => Get.find<DriverApiService>();

  var payouts = <PayoutModel>[].obs;
  var filteredPayouts = <PayoutModel>[].obs;
  var totalPaid = 0.0.obs;
  var pendingAmount = 0.0.obs;
  var selectedFilter = 'all'.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchPayoutHistory();
    super.onInit();
  }

  void fetchPayoutHistory() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final body = await _api.getPayoutHistory();
      final raw = body['payouts'];
      List<PayoutModel> items = [];
      if (raw is Map && raw['data'] is List) {
        items = (raw['data'] as List)
            .map((e) => PayoutModel.fromJson(e))
            .toList();
      } else if (raw is List) {
        items = raw.map((e) => PayoutModel.fromJson(e)).toList();
      }
      payouts.value = items;
      totalPaid.value = items
          .where((po) => po.status == 'completed' || po.status == 'paid')
          .fold(0.0, (sum, po) => sum + po.amount);
      pendingAmount.value = items
          .where((po) => po.status == 'pending')
          .fold(0.0, (sum, po) => sum + po.amount);
      filterByStatus(selectedFilter.value);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterByStatus(String status) {
    selectedFilter.value = status;
    if (status == 'all') {
      filteredPayouts.value = List.from(payouts);
    } else {
      filteredPayouts.value =
          payouts.where((p) => p.status == status).toList();
    }
  }

  void requestPayout(double amount) async {
    try {
      await _api.requestPayout(amount);
      pendingAmount.value += amount;
      Get.snackbar('Request Submitted',
          'Your payout of \$${amount.toStringAsFixed(2)} is being processed.',
          snackPosition: SnackPosition.BOTTOM);
      fetchPayoutHistory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to request payout: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
