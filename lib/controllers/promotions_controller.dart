import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/promotion_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class PromotionsController extends GetxController {
  final promotions = <PromotionModel>[].obs;
  final filteredPromotions = <PromotionModel>[].obs;
  final selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPromotions();
  }

  void fetchPromotions() {
    promotions.value = MockVendorData.promotions;
    _applyFilters();
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
        result = result.where((p) => p.isActive && p.endDate.isAfter(now)).toList();
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

  void createPromotion(PromotionModel promotion) {
    promotions.add(promotion);
    _applyFilters();
  }

  void toggleActive(String id) {
    final index = promotions.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = promotions[index];
      final updated = PromotionModel(
        id: p.id,
        title: p.title,
        description: p.description,
        discountType: p.discountType,
        discountValue: p.discountValue,
        code: p.code,
        minOrderAmount: p.minOrderAmount,
        startDate: p.startDate,
        endDate: p.endDate,
        usageLimit: p.usageLimit,
        usageCount: p.usageCount,
        isActive: !p.isActive,
        imageUrl: p.imageUrl,
      );
      promotions[index] = updated;
      _applyFilters();
    }
  }

  void deletePromotion(String id) {
    promotions.removeWhere((p) => p.id == id);
    _applyFilters();
  }
}
