import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/customer_review_model.dart';
import 'package:urban_goodz_vendor/repositories/mock_vendor_data.dart';

class CustomerReviewsController extends GetxController {
  final reviews = <CustomerReviewModel>[].obs;
  final filteredReviews = <CustomerReviewModel>[].obs;
  final averageRating = 0.0.obs;
  final ratingDistribution = <int, int>{}.obs;
  final replyText = ''.obs;
  final selectedRating = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  void fetchReviews() {
    reviews.value = MockVendorData.customerReviews;
    _calculateStats();
    filterByRating(selectedRating.value);
  }

  void _calculateStats() {
    if (reviews.isEmpty) {
      averageRating.value = 0.0;
      ratingDistribution.value = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      return;
    }

    final total =
        reviews.fold<int>(0, (sum, r) => sum + r.rating);
    averageRating.value = total / reviews.length;

    final dist = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      dist[r.rating] = (dist[r.rating] ?? 0) + 1;
    }
    ratingDistribution.value = dist;
  }

  void filterByRating(int rating) {
    selectedRating.value = rating;
    if (rating == 0) {
      filteredReviews.value = List.from(reviews);
    } else {
      filteredReviews.value =
          reviews.where((r) => r.rating == rating).toList();
    }
  }

  void replyToReview(String id, String reply) {
    final index = reviews.indexWhere((r) => r.id == id);
    if (index != -1) {
      final r = reviews[index];
      final updated = CustomerReviewModel(
        id: r.id,
        customerName: r.customerName,
        customerAvatar: r.customerAvatar,
        rating: r.rating,
        comment: r.comment,
        createdAt: r.createdAt,
        vendorReply: reply,
        replyDate: DateTime.now(),
        helpfulCount: r.helpfulCount,
      );
      reviews[index] = updated;
      filterByRating(selectedRating.value);
    }
  }
}
