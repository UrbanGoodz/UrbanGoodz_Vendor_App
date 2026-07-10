import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/reel_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class ReelsController extends GetxController {
  final reels = <ReelModel>[].obs;
  final isLoading = false.obs;
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  void fetchReels() {
    isLoading.value = true;
    reels.value = MockVendorData.reels;
    isLoading.value = false;
  }

  void createReel(ReelModel reel) {
    reels.add(reel);
  }

  void deleteReel(String id) {
    reels.removeWhere((r) => r.id == id);
  }

  void togglePublish(String id) {
    final index = reels.indexWhere((r) => r.id == id);
    if (index != -1) {
      final r = reels[index];
      final updated = ReelModel(
        id: r.id,
        title: r.title,
        description: r.description,
        videoUrl: r.videoUrl,
        thumbnailUrl: r.thumbnailUrl,
        views: r.views,
        likes: r.likes,
        comments: r.comments,
        shares: r.shares,
        isPublished: !r.isPublished,
        tags: r.tags,
        productTag: r.productTag,
        createdAt: r.createdAt,
      );
      reels[index] = updated;
    }
  }

  void incrementViews(String id) {
    final index = reels.indexWhere((r) => r.id == id);
    if (index != -1) {
      final r = reels[index];
      final updated = ReelModel(
        id: r.id,
        title: r.title,
        description: r.description,
        videoUrl: r.videoUrl,
        thumbnailUrl: r.thumbnailUrl,
        views: r.views + 1,
        likes: r.likes,
        comments: r.comments,
        shares: r.shares,
        isPublished: r.isPublished,
        tags: r.tags,
        productTag: r.productTag,
        createdAt: r.createdAt,
      );
      reels[index] = updated;
    }
  }
}
