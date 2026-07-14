import 'package:get/get.dart';
import 'package:urban_goodz_driver/models/opportunity_model.dart';
import 'package:urban_goodz_driver/services/driver_api_service.dart';

class OpportunitiesController extends GetxController {
  DriverApiService get _api => Get.find<DriverApiService>();

  var opportunities = <OpportunityModel>[].obs;
  var filteredOpportunities = <OpportunityModel>[].obs;
  var selectedCategory = 'all'.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchOpportunities();
    super.onInit();
  }

  void fetchOpportunities() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final body = await _api.getOpportunities(
        type: selectedCategory.value == 'all' ? null : selectedCategory.value,
      );
      final raw = body['opportunities'];
      List<OpportunityModel> items = [];
      if (raw is Map && raw['data'] is List) {
        items = (raw['data'] as List)
            .map((e) => OpportunityModel.fromJson(e))
            .toList();
      } else if (raw is List) {
        items = raw.map((e) => OpportunityModel.fromJson(e)).toList();
      }
      opportunities.value = items;
      filterByCategory(selectedCategory.value);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'all') {
      filteredOpportunities.value = List.from(opportunities);
    } else {
      filteredOpportunities.value = opportunities
          .where((o) => o.type == category)
          .toList();
    }
  }

  void claimOpportunity(String id) async {
    try {
      final oppId = int.tryParse(id);
      if (oppId == null) return;
      await _api.claimOpportunity(oppId);
      final idx = opportunities.indexWhere((o) => o.id == id);
      if (idx != -1) {
        final updated = OpportunityModel(
          id: opportunities[idx].id,
          title: opportunities[idx].title,
          description: opportunities[idx].description,
          type: opportunities[idx].type,
          reward: opportunities[idx].reward,
          status: 'claimed',
          validFrom: opportunities[idx].validFrom,
          validUntil: opportunities[idx].validUntil,
          terms: opportunities[idx].terms,
          isActive: true,
        );
        opportunities[idx] = updated;
        filterByCategory(selectedCategory.value);
      }
      Get.snackbar(
        'Claimed!',
        'Opportunity has been added to your profile.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to claim opportunity: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
