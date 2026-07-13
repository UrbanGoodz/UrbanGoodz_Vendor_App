import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/reel_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class ReelsController extends GetxController {
  final reels = <ReelModel>[].obs;
  final isLoading = false.obs;
  final selectedIndex = 0.obs;
  final errorMessage = RxnString();
  final repository = Get.find<VendorRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  Future<void> fetchReels() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final response = await repository.reels();
      final rows = response['reels'];
      reels.assignAll(
        rows is List
            ? rows.whereType<Map>().map(
                (row) => ReelModel.fromJson(Map<String, dynamic>.from(row)),
              )
            : const [],
      );
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      reels.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createReel({
    required String description,
    required String videoPath,
    required String thumbnailPath,
    required List<String> productIds,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      await repository.uploadReel(
        description: description,
        videoPath: videoPath,
        thumbnailPath: thumbnailPath,
        productIds: productIds,
      );
      await fetchReels();
      return true;
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteReel(String id) async {
    try {
      await repository.deleteReel(id);
      await fetchReels();
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
    }
  }

  Future<void> togglePublish(String id) async {
    final index = reels.indexWhere((r) => r.id == id);
    if (index < 0) return;
    try {
      if (reels[index].isPublished) {
        await repository.unpublishReel(id);
      } else {
        await repository.publishReel(id);
      }
      await fetchReels();
    } on VendorApiException catch (error) {
      errorMessage.value = error.message;
    }
  }
}
