import 'package:get/get.dart';
import 'package:urban_goodz_driver/models/driver_job_model.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';

class LoadBoardController extends GetxController {
  DriverApiService get _api => Get.find<DriverApiService>();

  var availableLoads = <DriverJobModel>[].obs;
  var filteredLoads = <DriverJobModel>[].obs;
  var sortBy = 'pay'.obs;
  var minPay = 0.0.obs;
  var maxPay = 500.0.obs;
  var vehicleFilter = 'all'.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    fetchLoads();
    super.onInit();
  }

  void fetchLoads({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      hasMore.value = true;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final body = await _api.getLoadBoard(page: currentPage.value);
      final loads = body['loads'];
      final List<DriverJobModel> items;
      if (loads is Map && loads['data'] is List) {
        items = (loads['data'] as List)
            .map((e) => DriverJobModel.fromJson(e))
            .toList();
        hasMore.value = loads['next_page_url'] != null;
      } else if (loads is List) {
        items = loads.map((e) => DriverJobModel.fromJson(e)).toList();
        hasMore.value = false;
      } else {
        items = [];
        hasMore.value = false;
      }
      if (refresh || currentPage.value == 1) {
        availableLoads.value = items;
      } else {
        availableLoads.addAll(items);
      }
      applyFilters();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() {
    if (!isLoading.value && hasMore.value) {
      currentPage.value++;
      fetchLoads();
    }
  }

  void sortLoads(String by) {
    sortBy.value = by;
    final sorted = List<DriverJobModel>.from(filteredLoads);
    switch (by) {
      case 'pay':
        sorted.sort((a, b) => b.earnings.compareTo(a.earnings));
        break;
      case 'distance':
        sorted.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'date':
        sorted.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
        break;
    }
    filteredLoads.value = sorted;
  }

  void applyFilters() {
    var result = List<DriverJobModel>.from(availableLoads);
    result = result.where((l) => l.earnings >= minPay.value).toList();
    result = result.where((l) => l.earnings <= maxPay.value).toList();
    if (vehicleFilter.value != 'all') {
      result = result
          .where((l) => l.vehicleType == vehicleFilter.value)
          .toList();
    }
    filteredLoads.value = result;
    sortLoads(sortBy.value);
  }

  void bidOnLoad(String id) async {
    try {
      final loadId = int.tryParse(id);
      if (loadId == null) return;
      await _api.bidOnLoad(loadId, 0.0);
      Get.snackbar(
        'Bid Submitted',
        'Your bid has been submitted for review.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit bid: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
