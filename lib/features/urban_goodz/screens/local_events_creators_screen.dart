import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';

class LocalEventsCreatorsScreen extends StatelessWidget {
  const LocalEventsCreatorsScreen({super.key});

  static const List<_LocalEventCreator> _items = [
    _LocalEventCreator(
      'Pop-up Market & Vendor Expo', 
      'Houston, TX', 
      'July 18, 2026', 
      '42 vendors registered',
    ),
    _LocalEventCreator(
      'Local Creator Showcase Mixer', 
      'Near you', 
      'July 25, 2026', 
      '18 creators attending',
    ),
    _LocalEventCreator(
      'Community Food Truck Festival', 
      'Downtown Houston', 
      'Aug 02, 2026', 
      '10 trucks listed',
    ),
    _LocalEventCreator(
      'Vendor Networking Mixer', 
      'Houston area', 
      'Aug 15, 2026', 
      'Guest speakers active',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: Text(
          'Events & Creators',
          style: robotoBold.copyWith(
            color: AppConstants.ugBlack,
            fontSize: Dimensions.fontSizeOverLarge,
          ),
        ),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UrbanGoodzPreviewBanner(
              message: 'Events, creators, and vendor opportunities. Find local events, pop-up markets, creator showcases, and vendor networking mixers near you.',
              icon: Icons.celebration_outlined,
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
              child: Text(
                'Explore Upcoming Happenings',
                style: robotoBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: AppConstants.ugBlack,
                ),
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                itemCount: _items.length,
                separatorBuilder: (_, index) => const SizedBox(height: Dimensions.paddingSizeSmall),
                itemBuilder: (context, index) {
                  final item = _items[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Register for Event [Tester]'),
                          content: Text('You are registering interest for:\n\n"${item.title}"\nLocation: ${item.location}\nDate: ${item.date}\n\nYour registration has been logged in preview mode! We will notify you when ticket issuing goes live.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: AppConstants.ugWhite,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        border: Border.all(
                          color: AppConstants.ugBlack.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.ugBlack.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
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
                            child: const Icon(Icons.event, color: AppConstants.seasoningOrange, size: 22),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: robotoBold.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: AppConstants.ugBlack,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, color: AppConstants.ugBlack.withValues(alpha: 0.4), size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.location,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: const Color(0xFF4A4037),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.calendar_today_outlined, color: AppConstants.ugBlack.withValues(alpha: 0.4), size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.date,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: const Color(0xFF4A4037),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.insight,
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
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
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalEventCreator {
  final String title;
  final String location;
  final String date;
  final String insight;

  const _LocalEventCreator(this.title, this.location, this.date, this.insight);
}
