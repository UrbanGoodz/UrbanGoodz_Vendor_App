import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';

class CreatorCommerceScreen extends StatelessWidget {
  const CreatorCommerceScreen({super.key});

  static const List<String> _features = [
    'Shoppable Reels',
    'Featured Creators',
    'Tagged Products',
    'Creator Campaigns',
    'Revenue Dashboard',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Creator Commerce',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppConstants.ugBlack,
          ),
        ),
      ),
      body: Column(
        children: [
          const _PreviewBanner(
            message:
                'Preview - creator commerce features are not yet available.',
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _features.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _PreviewCard(
                title: _features[index],
                subtitle: 'Preview - not yet operational',
                icon: Icons.video_library_outlined,
              ),
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

class _PreviewCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PreviewCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.ugWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppConstants.ugBlack.withValues(alpha: 0.12)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.seasoningOrange.withValues(alpha: 0.14),
          child: Icon(icon, color: AppConstants.seasoningOrange),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppConstants.ugBlack,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A4037),
          ),
        ),
      ),
    );
  }
}
