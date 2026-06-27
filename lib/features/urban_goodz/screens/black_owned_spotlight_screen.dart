import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class BlackOwnedSpotlightScreen extends StatelessWidget {
  const BlackOwnedSpotlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Restaurants',
      'Retail',
      'Services',
      'Arts & Gifts',
      'Events',
    ];

    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: Text(
          'Black-Owned Spotlight',
          style: robotoBold.copyWith(color: AppConstants.ugBlack),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context)
              ? Dimensions.paddingSizeLarge
              : Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              'Support local Black-owned businesses across Urban Goodz.',
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: AppConstants.ugBlack,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              "Discover curated shops, restaurants, services, and experiences from the neighborhood's Black-owned community.",
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                height: 1.6,
                color: const Color(0xFF3B332B),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              'Browse Categories',
              style: robotoBold.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: AppConstants.ugBlack,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Wrap(
              spacing: Dimensions.paddingSizeSmall,
              runSpacing: Dimensions.paddingSizeSmall,
              children: categories.map((category) {
                return ActionChip(
                  label: Text(category),
                  labelStyle: robotoSemiBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: AppConstants.ugBlack,
                  ),
                  backgroundColor: AppConstants.ugWhite,
                  side: const BorderSide(
                    color: AppConstants.seasoningOrange,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  ),
                  onPressed: () {
                    switch (category) {
                      case 'Restaurants':
                        Navigator.pushNamed(
                          context,
                          RouteHelper.getSearchRoute(
                            queryText: 'black-owned restaurants',
                          ),
                        );
                        break;
                      case 'Retail':
                        Navigator.pushNamed(
                          context,
                          RouteHelper.getSearchRoute(
                            queryText: 'black-owned retail',
                          ),
                        );
                        break;
                      case 'Services':
                        Navigator.pushNamed(
                          context,
                          RouteHelper.getSearchRoute(
                            queryText: 'black-owned services',
                          ),
                        );
                        break;
                      case 'Arts & Gifts':
                        Navigator.pushNamed(
                          context,
                          RouteHelper.getSearchRoute(
                            queryText: 'black-owned gifts',
                          ),
                        );
                        break;
                      case 'Events':
                        Navigator.pushNamed(
                          context,
                          RouteHelper.getSearchRoute(
                            queryText: 'black-owned events',
                          ),
                        );
                        break;
                      default:
                        Navigator.pushNamed(
                          context,
                          RouteHelper.getSearchRoute(
                            queryText: category.toLowerCase(),
                          ),
                        );
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: AppConstants.ugWhite,
                borderRadius: BorderRadius.circular(
                  Dimensions.radiusExtraLarge,
                ),
                border: Border.all(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.45),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.ugBlack.withValues(alpha: 0.07),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Spotlight',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: AppConstants.ugBlack,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    "We're curating Black-owned businesses across Houston and the Urban Goodz market network. Check back soon for featured shops, services, creators, and local experiences.",
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      height: 1.6,
                      color: const Color(0xFF3B332B),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppConstants.seasoningOrange.withValues(
                            alpha: 0.16,
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusLarge,
                          ),
                        ),
                        padding: const EdgeInsets.all(
                          Dimensions.paddingSizeSmall,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: AppConstants.seasoningOrange,
                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      Expanded(
                        child: Text(
                          'Coming soon: curated Black-owned businesses near you.',
                          style: robotoSemiBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: AppConstants.ugBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
