import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class CommunityMarketplaceScreen extends StatelessWidget {
  const CommunityMarketplaceScreen({super.key});

  static const List<_CommunityItem> _items = [
    _CommunityItem(
      'Featured Zone Groups',
      'Local conversations organized by market area.',
    ),
    _CommunityItem(
      'Trending Local Posts',
      'Community recommendations and neighborhood updates.',
    ),
    _CommunityItem(
      'Nationwide Discussions',
      'Urban Goodz market network conversations.',
    ),
    _CommunityItem(
      'Business Recommendations',
      'Ask for trusted local shops and providers.',
    ),
    _CommunityItem(
      'Ask The Community',
      'Get answers from nearby customers and creators.',
    ),
    _CommunityItem(
      'Earn Money Opportunities',
      'Preview local ways to earn through Urban Goodz.',
    ),
    _CommunityItem(
      'Post Actions',
      'View Business, Order Anywhere, Book Service, Request Delivery, Rent Now, Follow.',
    ),
    _CommunityItem(
      'Photos & Videos',
      'Media placeholders for the tester experience.',
    ),
    _CommunityItem(
      'Experience Sharing',
      'Community reviews and recommendations.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Community Marketplace',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppConstants.ugBlack,
          ),
        ),
      ),
      body: Column(
        children: [
          const _PreviewBanner(
            message: 'Preview - community features are not yet available.',
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _items[index];
                return _CommunityCard(
                  title: item.title,
                  subtitle: item.subtitle,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewBanner extends StatelessWidget {
  final String message;

  const _PreviewBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppConstants.seasoningOrange.withValues(alpha: 0.14),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 18,
            color: AppConstants.seasoningOrange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppConstants.ugBlack,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CommunityCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.ugWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.forum_outlined, color: AppConstants.seasoningOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppConstants.ugBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A4037),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityItem {
  final String title;
  final String subtitle;

  const _CommunityItem(this.title, this.subtitle);
}
