import 'package:get/get.dart';
import 'package:urban_goodz_driver/services/api_client.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';

class EarningsController extends GetxController {
  final ApiClient _client = Get.find<ApiClient>();

  var totalEarnings = 0.0.obs;
  var pendingPayout = 0.0.obs;
  var totalWithdrawn = 0.0.obs;
  var todayEarnings = 0.0.obs;
  var thisWeekEarnings = 0.0.obs;
  var thisMonthEarnings = 0.0.obs;
  var totalTips = 0.0.obs;
  var totalBonuses = 0.0.obs;
  var totalMileage = 0.0.obs;
  var projectedWeeklyEarnings = 0.0.obs;
  var dailyEarnings = <Map<String, dynamic>>[].obs;
  var selectedPeriod = 'week'.obs;
  var recentPayouts = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  void changePeriod(String period) {
    selectedPeriod.value = period;
    fetchEarnings();
  }

  @override
  void onInit() {
    fetchEarnings();
    super.onInit();
  }

  void fetchEarnings() {
    isLoading.value = true;
    errorMessage.value = '';

    _client
        .authGet('/api/v1/delivery-man/profile')
        .then((res) {
          if (res.statusCode == 200 && res.body is Map) {
            final dm = res.body['delivery_man'] ?? res.body;
            totalEarnings.value =
                double.tryParse(dm['total_earning']?.toString() ?? '0') ?? 0;
            pendingPayout.value =
                double.tryParse(dm['pending_withdraw']?.toString() ?? '0') ?? 0;
            totalWithdrawn.value =
                double.tryParse(dm['total_withdrawn']?.toString() ?? '0') ?? 0;
            todayEarnings.value =
                double.tryParse(dm['todays_earning']?.toString() ?? '0') ?? 0;
            thisWeekEarnings.value =
                double.tryParse(dm['this_week_earning']?.toString() ?? '0') ??
                0;
            thisMonthEarnings.value =
                double.tryParse(dm['this_month_earning']?.toString() ?? '0') ??
                0;
            totalTips.value =
                double.tryParse(dm['total_tips']?.toString() ?? '0') ?? 0;
            totalBonuses.value =
                double.tryParse(dm['total_bonuses']?.toString() ?? '0') ?? 0;
            totalMileage.value =
                double.tryParse(dm['total_mileage']?.toString() ?? '0') ?? 0;
            projectedWeeklyEarnings.value =
                double.tryParse(
                  dm['projected_weekly_earnings']?.toString() ?? '0',
                ) ??
                0;
          }
          isLoading.value = false;
        })
        .catchError((e) {
          errorMessage.value = 'Failed to load earnings.';
          isLoading.value = false;
        });

    Get.find<DriverApiService>()
        .getPayoutHistory()
        .then((res) {
          final list = res['withdraw_requests'];
          if (list is List) {
            recentPayouts.value = List<Map<String, dynamic>>.from(list);
          }
        })
        .catchError((_) {});
  }
}
