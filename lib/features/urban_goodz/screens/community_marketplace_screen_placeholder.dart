import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

class CommunityMarketplaceScreen extends StatelessWidget {
  const CommunityMarketplaceScreen({super.key});

  static const List<_CommunityItem> _items = [
    _CommunityItem(
      'Featured Zone Groups',
      'Local conversations organized by market area.',
      '14 group concepts',
    ),
    _CommunityItem(
      'Trending Local Posts',
      'Community recommendations and neighborhood updates.',
      'Sample post activity',
    ),
    _CommunityItem(
      'Nationwide Discussions',
      'Urban Goodz market network conversations.',
      'Global Network',
    ),
    _CommunityItem(
      'Business Recommendations',
      'Ask for trusted local shops and providers.',
      'Engagement preview',
    ),
    _CommunityItem(
      'Ask The Community',
      'Get answers from nearby customers and creators.',
      'Quick Answers',
    ),
    _CommunityItem(
      'Earn Money Opportunities',
      'Preview local ways to earn through Urban Goodz.',
      'Earning links preview',
    ),
    _CommunityItem(
      'Post Actions',
      'View Business, Order Anywhere, Book Service, Request Delivery, Rent Now, Follow.',
      'Action previews',
    ),
    _CommunityItem(
      'Photos & Videos',
      'Media placeholders for the tester experience.',
      'Rich Media Enabled',
    ),
    _CommunityItem(
      'Experience Sharing',
      'Community reviews and recommendations.',
      'Review preview',
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
            fontWeight: FontWeight.w900,
            color: AppConstants.ugBlack,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
      ),
      body: Column(
        children: [
          const UrbanGoodzPreviewBanner(
            message: 'Preview - community features are not yet available. Join local neighborhood channels and share recommendations soon.',
            icon: Icons.groups_outlined,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: AppConstants.ugWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.25)),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.ugBlack.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Local Neighborhood Marketplace',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.ugBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Connect with local conversations, discover recommended vendors, and trade insights with nearby community members.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.ugBlack.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: UrbanGoodzActionButton(
                      label: 'Join Marketplace Waitlist',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final nameController = TextEditingController();
                            final neighborhoodController = TextEditingController();
                            final phoneController = TextEditingController();
                            final formKey = GlobalKey<FormState>();

                            return AlertDialog(
                              title: const Text('Marketplace Waitlist [Tester]', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              content: SingleChildScrollView(
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Register your neighborhood to unlock trade & conversation zones.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(labelText: 'Name *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: neighborhoodController,
                                        decoration: const InputDecoration(labelText: 'Neighborhood / Zip Code *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: phoneController,
                                        decoration: const InputDecoration(labelText: 'Contact Phone Number *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppConstants.seasoningOrange, foregroundColor: AppConstants.ugBlack),
                                  onPressed: () {
                                    if (formKey.currentState?.validate() ?? false) {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Waitlist Confirmed'),
                                          content: const Text('Added to the Community Marketplace waitlist in tester preview! We will notify you once neighbor-to-neighbor zones roll out.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Join Waitlist'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
                bottom: Dimensions.paddingSizeDefault + 80, // Safe bottom spacing
              ),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                final item = _items[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.ugWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppConstants.seasoningOrange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.forum_outlined, color: AppConstants.seasoningOrange, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AppConstants.ugBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppConstants.ugBlack.withValues(alpha: 0.6),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.insight,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: AppConstants.seasoningOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const UrbanGoodzStatusBadge(status: 'Preview', isCompact: true),
                    ],
                  ),
                );
              },
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
  final String insight;

  const _CommunityItem(this.title, this.subtitle, this.insight);
}
