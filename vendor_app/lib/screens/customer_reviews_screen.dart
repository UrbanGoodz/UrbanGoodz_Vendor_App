import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:urban_goodz_vendor/controllers/customer_reviews_controller.dart';
import 'package:urban_goodz_vendor/models/customer_review_model.dart';
import 'package:urban_goodz_vendor/theme/app_theme.dart';

class CustomerReviewsScreen extends StatelessWidget {
  const CustomerReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerReviewsController c = Get.put(CustomerReviewsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Reviews'),
        actions: [
          Obx(
            () => Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${c.reviews.length} reviews',
                  style: const TextStyle(fontSize: 13, color: AppTheme.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildRatingSummary(c),
          _buildStarFilter(c),
          Expanded(child: _buildReviewsList(c)),
        ],
      ),
    );
  }

  Widget _buildRatingSummary(CustomerReviewsController c) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.beige.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  c.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < c.averageRating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color: AppTheme.primary,
                      size: 16,
                    );
                  }),
                ),
                const SizedBox(height: 2),
                Text(
                  '${c.reviews.length} reviews',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.dark.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: List.generate(5, (i) {
                  final star = 5 - i;
                  final count = c.ratingDistribution[star] ?? 0;
                  final maxCount = c.ratingDistribution.values.fold<int>(
                    0,
                    (a, b) => a > b ? a : b,
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text(
                          '$star',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.dark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star,
                          color: AppTheme.primary,
                          size: 12,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: maxCount > 0 ? count / maxCount : 0,
                              backgroundColor: AppTheme.beige,
                              color: AppTheme.primary,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.dark.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarFilter(CustomerReviewsController c) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _StarChip(
              label: 'All',
              rating: 0,
              selected: c.selectedRating.value,
              onTap: () => c.filterByRating(0),
            ),
            const SizedBox(width: 6),
            ...List.generate(5, (i) {
              final star = 5 - i;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _StarChip(
                  label: '$star',
                  rating: star,
                  selected: c.selectedRating.value,
                  onTap: () => c.filterByRating(star),
                  showStar: true,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList(CustomerReviewsController c) {
    return Obx(() {
      if (c.filteredReviews.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.reviews,
                size: 64,
                color: AppTheme.dark.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              Text(
                'No reviews found',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.dark.withOpacity(0.4),
                ),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: c.filteredReviews.length,
        itemBuilder: (_, i) =>
            _ReviewCard(review: c.filteredReviews[i], controller: c),
      );
    });
  }
}

class _StarChip extends StatelessWidget {
  final String label;
  final int rating;
  final int selected;
  final VoidCallback onTap;
  final bool showStar;

  const _StarChip({
    required this.label,
    required this.rating,
    required this.selected,
    required this.onTap,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == rating;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary
              : AppTheme.beige.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.dark
                    : AppTheme.dark.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
            if (showStar) ...[
              const SizedBox(width: 2),
              Icon(
                Icons.star,
                color: isSelected ? AppTheme.dark : AppTheme.primary,
                size: 12,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final CustomerReviewModel review;
  final CustomerReviewsController controller;

  const _ReviewCard({required this.review, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primary.withOpacity(0.3),
                  child: Text(
                    review.customerName.isNotEmpty
                        ? review.customerName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.customerName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppTheme.dark,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (i) {
                              return Icon(
                                i < review.rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppTheme.primary,
                                size: 14,
                              );
                            }),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(review.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.dark.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (review.helpfulCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.thumb_up,
                          size: 10,
                          color: AppTheme.dark,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${review.helpfulCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review.comment,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.dark.withOpacity(0.8),
                height: 1.4,
              ),
            ),
            if (review.vendorReply != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.reply,
                          size: 14,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Your Reply',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: AppTheme.primary,
                          ),
                        ),
                        const Spacer(),
                        if (review.replyDate != null)
                          Text(
                            _formatDate(review.replyDate!),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.dark.withOpacity(0.4),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.vendorReply!,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.dark.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (review.vendorReply == null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _showReplyDialog(context),
                  icon: const Icon(Icons.reply, size: 16),
                  label: const Text('Reply', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showReplyDialog(BuildContext context) {
    final replyCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Reply to Review',
          style: TextStyle(color: AppTheme.dark),
        ),
        content: TextField(
          controller: replyCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write your reply...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (replyCtrl.text.isNotEmpty) {
                controller.replyToReview(review.id, replyCtrl.text);
                Get.back();
              }
            },
            child: const Text('Send Reply'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
