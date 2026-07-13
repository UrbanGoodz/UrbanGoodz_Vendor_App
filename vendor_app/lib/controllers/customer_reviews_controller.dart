import 'package:get/get.dart';
import 'package:urban_goodz_vendor/models/customer_review_model.dart';
import 'package:urban_goodz_vendor/repositories/vendor_repository.dart';
import 'package:urban_goodz_vendor/services/vendor_api_client.dart';

class CustomerReviewsController extends GetxController {
  final reviews = <CustomerReviewModel>[].obs;
  final filteredReviews = <CustomerReviewModel>[].obs;
  final averageRating = 0.0.obs;
  final ratingDistribution = <int, int>{}.obs;
  final replyText = ''.obs;
  final selectedRating = 0.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final repository = Get.find<VendorRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final rows = await repository.reviews();
      reviews.assignAll(
        rows.map((row) {
          final customer = row['customer'] is Map
              ? Map<String, dynamic>.from(row['customer'])
              : <String, dynamic>{};
          return CustomerReviewModel(
            id: row['id']?.toString() ?? '',
            customerName:
                [
                  customer['f_name'],
                  customer['l_name'],
                ].where((v) => v != null).join(' ').trim().isEmpty
                ? 'Customer'
                : [
                    customer['f_name'],
                    customer['l_name'],
                  ].where((v) => v != null).join(' '),
            customerAvatar: customer['image_full_url']?.toString() ?? '',
            rating: int.tryParse(row['rating']?.toString() ?? '') ?? 0,
            comment: row['comment']?.toString() ?? '',
            createdAt:
                DateTime.tryParse(row['created_at']?.toString() ?? '') ??
                DateTime.now(),
            vendorReply: row['reply']?.toString(),
            replyDate: DateTime.tryParse(row['replied_at']?.toString() ?? ''),
            serviceName: row['item_name']?.toString() ?? '',
            orderId: row['order_id']?.toString() ?? '',
            images: (row['attachment_full_url'] is List
                ? (row['attachment_full_url'] as List)
                      .map((e) => e.toString())
                      .toList()
                : const []),
            isVerified: true,
          );
        }),
      );
      _calculateStats();
      filterByRating(selectedRating.value);
    } on VendorApiException catch (e) {
      errorMessage.value = e.message;
      reviews.clear();
      _calculateStats();
      filterByRating(0);
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStats() {
    if (reviews.isEmpty) {
      averageRating.value = 0.0;
      ratingDistribution.value = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      return;
    }

    final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
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
      filteredReviews.value = reviews.where((r) => r.rating == rating).toList();
    }
  }

  Future<void> replyToReview(String id, String reply) async {
    try {
      await repository.replyToReview(id, reply);
      await fetchReviews();
    } on VendorApiException catch (e) {
      errorMessage.value = e.message;
      Get.snackbar('Reply failed', e.message);
    }
  }
}
