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

    final List<Map<String, dynamic>> guidedPrompts = [
      {
        'title': 'Find Black-owned restaurants near me',
        'route': RouteHelper.getSearchRoute(queryText: 'black-owned restaurants'),
      },
      {
        'title': 'Show rentals available today',
        'route': RouteHelper.getInitialRoute(moduleId: AppConstants.taxi),
      },
      {
        'title': 'Find local deals under \$25',
        'route': RouteHelper.getSearchRoute(queryText: 'deals under 25'),
      },
      {
        'title': 'Help me discover events nearby',
        'route': RouteHelper.getSearchRoute(queryText: 'events near me'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Urban Goodz Concierge'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your local lifestyle concierge',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    'Get guided recommendations for restaurants, rentals, deals, and events without the wait.',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      height: 1.6,
                      color: theme.textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
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
                  Icon(Icons.search, color: theme.primaryColor, size: 24),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeLarge,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                    ),
                    child: Text(
                      'Start',
                      style: robotoMedium.copyWith(
                        color: Colors.white,
                        fontSize: Dimensions.fontSizeSmall,
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
            Text(
              'Guided prompts',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: theme.textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Column(
              children: guidedPrompts.map((prompt) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, prompt['route'] as String),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12), width: 0.5),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withValues(alpha: 0.05),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                            ),
                            child: Icon(Icons.lightbulb, color: theme.primaryColor, size: 22),
                          ),
                          const SizedBox(width: Dimensions.paddingSizeDefault),
                          Expanded(
                            child: Text(
                              prompt['title'] as String,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                color: theme.textTheme.bodyLarge!.color,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16, color: theme.disabledColor),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              ),
              child: Text(
                'This is a guided concierge experience. No real AI backend calls are used yet — just smart pathways into existing search and rental flows.',
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  height: 1.6,
                  color: theme.textTheme.bodyLarge!.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
