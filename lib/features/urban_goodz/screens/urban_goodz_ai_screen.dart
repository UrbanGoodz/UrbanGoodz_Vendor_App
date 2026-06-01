import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class UrbanGoodzAiScreen extends StatelessWidget {
  const UrbanGoodzAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> quickOptions = [
      'Food',
      'Groceries',
      'Rentals',
      'Black-owned shops',
      'Events',
      'Deals near me',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ask Urban Goodz AI'),
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
              'What are you looking for today?',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeDefault,
              ),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.18), width: 0.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.disabledColor, size: 22),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                    child: Text(
                      'Search for food, shops, rentals, events or deals',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: theme.disabledColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              'Quick options',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Wrap(
              spacing: Dimensions.paddingSizeSmall,
              runSpacing: Dimensions.paddingSizeSmall,
              children: quickOptions.map((option) {
                return ActionChip(
                  label: Text(option, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.14),
                  labelStyle: robotoRegular.copyWith(color: theme.primaryColor),
                  onPressed: () {
                    switch (option) {
                      case 'Food':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'food'));
                        break;
                      case 'Groceries':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'groceries'));
                        break;
                      case 'Rentals':
                        Navigator.pushNamed(context, RouteHelper.getInitialRoute(moduleId: AppConstants.taxi));
                        break;
                      case 'Black-owned shops':
                        Navigator.pushNamed(context, RouteHelper.getAllStoreRoute('nearby', isNearbyStore: true));
                        break;
                      case 'Events':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'events'));
                        break;
                      case 'Deals near me':
                        Navigator.pushNamed(context, RouteHelper.getSearchRoute(queryText: 'deals'));
                        break;
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
              child: Text(
                'AI assistance is coming soon. This screen will help you find local favorites, curated recommendations, and the best deals in your neighborhood.',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  height: 1.6,
                  color: theme.disabledColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
