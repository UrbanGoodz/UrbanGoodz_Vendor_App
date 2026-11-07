import 'package:get/get.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class VendorAiAssistantController extends GetxController {
  VendorApiClient get _client => Get.find<VendorApiClient>();

  var dailyBrief = ''.obs;
  var catalogSuggestions = <Map<String, dynamic>>[].obs;
  var recommendedActions = <Map<String, dynamic>>[].obs;
  var settlementBrief = <String, dynamic>{}.obs;

  var isLoading = false.obs;
  var isUpdatingCatalog = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    fetchAssistantBrief();
    super.onInit();
  }

  /// Sections whose request failed on the last load. The screen must say so
  /// instead of showing an empty state, which would read as "nothing to do".
  final unavailableSections = <String>{}.obs;

  static const sectionBrief = 'brief';
  static const sectionCatalog = 'catalog';
  static const sectionActions = 'actions';
  static const sectionSettlement = 'settlement';

  bool isUnavailable(String section) => unavailableSections.contains(section);

  Future<void> fetchAssistantBrief() async {
    isLoading.value = true;
    errorMessage.value = '';
    unavailableSections.clear();

    // Each section loads on its own: one missing or failing endpoint must not
    // blank the others, and a failure is never presented as an empty result.
    Future<void> load(String section, Future<void> Function() run) async {
      try {
        await run();
      } catch (_) {
        unavailableSections.add(section);
      }
    }

    await Future.wait([
      load(sectionBrief, () async {
        final res = await _client.get('/urban-goodz/cross-app/ai/vendor/daily-brief');
        if (res is! Map) throw const FormatException('unexpected daily brief response');
        dailyBrief.value = res['brief']?.toString() ?? 'Daily brief temporarily unavailable.';
      }),
      load(sectionCatalog, () async {
        final res = await _client.get('/urban-goodz/cross-app/ai/vendor/catalog-suggestions');
        if (res is! Map || res['suggestions'] is! List) {
          throw const FormatException('unexpected catalog response');
        }
        catalogSuggestions.value = List<Map<String, dynamic>>.from(
          (res['suggestions'] as List).map((s) => Map<String, dynamic>.from(s)),
        );
      }),
      load(sectionActions, () async {
        final res = await _client.get('/urban-goodz/cross-app/ai/vendor/recommended-actions');
        if (res is! Map || res['actions'] is! List) {
          throw const FormatException('unexpected actions response');
        }
        recommendedActions.value = List<Map<String, dynamic>>.from(
          (res['actions'] as List).map((a) => Map<String, dynamic>.from(a)),
        );
      }),
      load(sectionSettlement, () async {
        final res = await _client.get('/urban-goodz/cross-app/ai/vendor/settlement-metrics');
        if (res is! Map) throw const FormatException('unexpected settlement response');
        settlementBrief.value = Map<String, dynamic>.from(res);
      }),
    ]);

    if (unavailableSections.length == 4) {
      errorMessage.value = 'Failed to load Vendor AI briefing.';
    }
    isLoading.value = false;
  }

  Future<void> applyCatalogChange(int itemId, Map<String, dynamic> changes) async {
    isUpdatingCatalog.value = true;
    try {
      await _client.post('/urban-goodz/cross-app/ai/vendor/catalog-update', body: {
        'item_id': itemId,
        'changes': changes,
      });
      // Refresh suggestions
      fetchAssistantBrief();
    } catch (e) {
      Get.snackbar('Catalog Update', 'Failed to apply recommendation', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUpdatingCatalog.value = false;
    }
  }
}
