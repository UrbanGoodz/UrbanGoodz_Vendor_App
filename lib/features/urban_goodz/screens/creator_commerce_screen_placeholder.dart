import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

class CreatorCommerceScreen extends StatelessWidget {
  const CreatorCommerceScreen({super.key});

  static const List<Map<String, String>> _features = [
    {
      'title': 'Shoppable Reels',
      'desc': 'Preview local product video feeds and tagged shopping paths.',
      'metric': '10+ creator channels mapped',
    },
    {
      'title': 'Featured Creators',
      'desc': 'Discover popular local tastemakers and styling guides.',
      'metric': 'Hot in your area',
    },
    {
      'title': 'Tagged Products',
      'desc': 'Browse catalogs curated and reviewed by local influencers.',
      'metric': '48 items tagged',
    },
    {
      'title': 'Creator Campaigns',
      'desc':
          'Explore campaign concepts for promoting stores in your zip code.',
      'metric': 'Estimated payout preview',
    },
    {
      'title': 'Fashion Drops',
      'desc':
          'Preview vendor clothing drops, tailor showcases, and shoppable outfit reels.',
      'metric': 'Fashion discovery preview',
    },
    {
      'title': 'Measurement Education',
      'desc':
          'Creators and vendors can share public tips for preparing photo-assisted fit references.',
      'metric': 'Private customer photos excluded',
    },
    {
      'title': 'Revenue Dashboard',
      'desc': 'Track commissions, followers, and shop integration metrics.',
      'metric': 'Wallet preview mode',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Creator Commerce',
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
            message:
                'Preview - creator commerce features are not yet available. Shop tag integrations and local influencer networks are under development.',
            icon: Icons.storefront_outlined,
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: AppConstants.ugWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.25),
                ),
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
                    'Local Influencer Storefronts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.ugBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Explore shoppable video feeds and campaigns. Creators can tag products from local restaurants, boutiques, and rental services.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.ugBlack.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.canvas.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.seasoningOrange.withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fashion + Measurement Privacy Boundary',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppConstants.ugBlack,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Creator Space can show fashion drops, tailor showcases, before/after examples with approval, and measurement education. Private customer measurement photos are never posted to public feeds.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppConstants.ugBlack.withValues(alpha: 0.72),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.toNamed(
                        RouteHelper.getUrbanGoodzFashionMeasurementsRoute(),
                      ),
                      icon: const Icon(Icons.checkroom_outlined),
                      label: const Text('Open Fashion Measurement Preview'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.ugBlack,
                        side: BorderSide(
                          color: AppConstants.seasoningOrange.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: UrbanGoodzActionButton(
                      label: 'Apply as Urban Goodz Creator',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final nameController = TextEditingController();
                            final nicheController = TextEditingController();
                            final socialController = TextEditingController();
                            final cityController = TextEditingController();
                            final pitchController = TextEditingController();
                            final formKey = GlobalKey<FormState>();

                            return AlertDialog(
                              title: const Text('Creator Interest Form [Tester Preview]', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              content: SingleChildScrollView(
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Register your interest to sell or promote products in your area.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(labelText: 'Creator Name *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: nicheController,
                                        decoration: const InputDecoration(labelText: 'Category / Niche (e.g. Fashion, Food) *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: socialController,
                                        decoration: const InputDecoration(labelText: 'Social Media Link / Handle *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: cityController,
                                        decoration: const InputDecoration(labelText: 'City *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: pitchController,
                                        maxLines: 2,
                                        decoration: const InputDecoration(labelText: 'What do you want to sell/promote? *', border: OutlineInputBorder()),
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
                                          title: const Text('Application Logged'),
                                          content: const Text('Creator application received in tester preview mode! Information has been logged locally.'),
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
                                  child: const Text('Submit Application'),
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
                bottom:
                    Dimensions.paddingSizeDefault + 80, // Safe bottom spacing
              ),
              itemCount: _features.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                final feat = _features[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.ugWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppConstants.ugBlack.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppConstants.seasoningOrange.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppConstants.seasoningOrange.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.video_library_outlined,
                          color: AppConstants.seasoningOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feat['title'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AppConstants.ugBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              feat['desc'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppConstants.ugBlack.withValues(
                                  alpha: 0.6,
                                ),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              feat['metric'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                color: AppConstants.seasoningOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const UrbanGoodzStatusBadge(
                        status: 'Preview',
                        isCompact: true,
                      ),
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
