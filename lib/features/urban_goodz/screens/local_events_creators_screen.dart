import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class LocalEventsCreatorsScreen extends StatelessWidget {
  const LocalEventsCreatorsScreen({super.key});

  static const List<_LocalEventCreator> _items = [
    _LocalEventCreator('Pop-up Market', 'Houston, TX'),
    _LocalEventCreator('Local Creator Showcase', 'Near you'),
    _LocalEventCreator('Community Food Event', 'Downtown Houston'),
    _LocalEventCreator('Vendor Networking Mixer', 'Houston area'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: Text(
          'Local Events & Creators',
          style: robotoBold.copyWith(color: AppConstants.ugBlack),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover community events, pop-ups, creators, and local experiences near you.',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeDefault,
                  color: const Color(0xFF3B332B),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  border: Border.all(
                    color: AppConstants.seasoningOrange.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Event/Creator',
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: AppConstants.ugBlack,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Expanded(
                      child: Text(
                        'Location',
                        style: robotoBold.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: AppConstants.ugBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall),

              Expanded(
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, index) =>
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                  itemBuilder: (context, index) {
                    final item = _items[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusDefault,
                      ),
                      onTap: () => Get.toNamed(
                        RouteHelper.getSearchRoute(queryText: item.title),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(
                          Dimensions.paddingSizeDefault,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.ugWhite,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusDefault,
                          ),
                          border: Border.all(
                            color: AppConstants.ugBlack.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                item.title,
                                style: robotoSemiBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: AppConstants.ugBlack,
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                              child: Text(
                                item.location,
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: const Color(0xFF4A4037),
                                ),
                              ),
                            ),
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
      ),
    );
  }
}

class _LocalEventCreator {
  final String title;
  final String location;

  const _LocalEventCreator(this.title, this.location);
}
