import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class BlackOwnedSpotlightScreen extends StatelessWidget {
  const BlackOwnedSpotlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> categories = [
      'Restaurants',
      'Retail',
      'Services',
      'Arts & Gifts',
      'Events',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Black-Owned Spotlight'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              'Support local Black-owned businesses',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(
              'Discover curated shops, restaurants, services, and experiences from the neighborhood’s Black-owned community.',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                height: 1.6,
                color: theme.disabledColor,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              'Browse categories',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Wrap(
              spacing: Dimensions.paddingSizeSmall,
              runSpacing: Dimensions.paddingSizeSmall,
              children: categories.map((category) {
                return ActionChip(
                  label: Text(category, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.14),
                  labelStyle: robotoRegular.copyWith(color: theme.primaryColor),
                  onPressed: () {
                    switch (category) {
                      case 'Restaurants':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'black-owned restaurants'));
                        break;
                      case 'Retail':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'black-owned retail'));
                        break;
                      case 'Services':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'black-owned services'));
                        break;
                      case 'Arts & Gifts':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'black-owned gifts'));
                        break;
                      case 'Events':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'black-owned events'));
                        break;
                      default:
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: category.toLowerCase()));
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
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured spotlight',
                    style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    'We’re curating the best Black-owned businesses in your area. Check back soon for local favorites, cultural experiences, and exclusive neighborhood deals.',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      height: 1.6,
                      color: theme.disabledColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                        ),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Icon(Icons.star, color: theme.primaryColor),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),
                      Expanded(
                        child: Text(
                          'Coming soon: a curated spotlight of Black-owned stores, eateries, and services near you.',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: theme.disabledColor,
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
