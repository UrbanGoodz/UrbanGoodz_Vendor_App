import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/promotion_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class PromotionsController extends GetxController {
  final promotions = <PromotionModel>[].obs;
  final filteredPromotions = <PromotionModel>[].obs;
  final selectedFilter = 'all'.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final repository = Get.find<VendorRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchPromotions();
  }

  Future<void> fetchPromotions() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final rows = await repository.coupons();
      promotions.assignAll(
        rows.map(
          (row) => PromotionModel(
            id: row['id']?.toString() ?? '',
            title:
                row['title']?.toString() ?? row['code']?.toString() ?? 'Coupon',
            description: 'Vendor coupon',
            discountType: row['discount_type']?.toString() ?? 'percent',
            discountValue:
                double.tryParse(row['discount']?.toString() ?? '') ?? 0,
            code: row['code']?.toString(),
            minOrderAmount: double.tryParse(
              row['min_purchase']?.toString() ?? '',
            ),
            startDate:
                DateTime.tryParse(row['start_date']?.toString() ?? '') ??
                DateTime.now(),
            endDate:
                DateTime.tryParse(row['expire_date']?.toString() ?? '') ??
                DateTime.now(),
            usageLimit: int.tryParse(row['limit']?.toString() ?? '') ?? 0,
            usageCount: 0,
            isActive:
                row['status'] == true ||
                row['status'] == 1 ||
                row['status']?.toString() == '1',
            imageUrl: '',
          ),
        ),
      );
      _applyFilters();
    } on VendorApiException catch (e) {
      errorMessage.value = e.message;
      promotions.clear();
      _applyFilters();
    } finally {
      isLoading.value = false;
    }
  }

  void filterPromotions(String filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  void _applyFilters() {
    final now = DateTime.now();
    var result = List<PromotionModel>.from(promotions);

    switch (selectedFilter.value) {
      case 'active':
        result = result
            .where((p) => p.isActive && p.endDate.isAfter(now))
            .toList();
        break;
      case 'scheduled':
        result = result.where((p) => p.startDate.isAfter(now)).toList();
        break;
      case 'expired':
        result = result.where((p) => p.endDate.isBefore(now)).toList();
        break;
    }

    filteredPromotions.value = result;
  }

  Future<void> createPromotion(PromotionModel promotion) async {
    try {
      await repository.createCoupon(
        title: promotion.title,
        code: promotion.code ?? '',
        discount: promotion.discountValue,
      );
      await fetchPromotions();
    } on VendorApiException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('Promotion failed', e.message);
    }
  }

  Future<void> toggleActive(String id) async {
    final index = promotions.indexWhere((p) => p.id == id);
    if (index < 0) return;
    try {
      await repository.updateCouponStatus(id, !promotions[index].isActive);
      await fetchPromotions();
    } on VendorApiException catch (e) {
      errorMessage.value = e.message;
    }
  }

  Future<void> deletePromotion(String id) async {
    try {
      await repository.deleteCoupon(id);
      await fetchPromotions();
    } on VendorApiException catch (e) {
      errorMessage.value = e.message;
    }
  }
}
