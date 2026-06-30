import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

class UrbanGoodzAiScreen extends StatelessWidget {
  const UrbanGoodzAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: Text(
          'Urban Goodz Concierge',
          style: robotoBold.copyWith(
            color: AppConstants.ugBlack,
            fontSize: Dimensions.fontSizeOverLarge,
          ),
        ),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UrbanGoodzPreviewBanner(
                  message: 'This is a guided concierge experience. No real AI backend calls are used yet — just smart pathways into existing search and rental flows.',
                  icon: Icons.auto_awesome_outlined,
                ),
                
                const SizedBox(height: Dimensions.paddingSizeSmall),
                
                // Welcome Hero Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppConstants.ugBlack, Color(0xFF2D241E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppConstants.seasoningOrange.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.ugBlack.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppConstants.seasoningOrange.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome, color: AppConstants.seasoningOrange, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Your Local Lifestyle Concierge',
                            style: robotoBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: AppConstants.seasoningOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Text(
                        'Get guided recommendations for restaurants, rentals, deals, and events without the wait.',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          height: 1.5,
                          color: AppConstants.ugWhite.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: Dimensions.paddingSizeLarge),
                
                // Smart Glowing Search Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    color: AppConstants.ugWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppConstants.seasoningOrange.withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.seasoningOrange.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppConstants.seasoningOrange, size: 24),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Text(
                          'Ask about food, shops, rentals, events or deals...',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: AppConstants.ugBlack.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      UrbanGoodzActionButton(
                        label: 'Start',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: Dimensions.paddingSizeLarge),
                
                Text(
                  'Quick options',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: AppConstants.ugBlack,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                
                Wrap(
                  spacing: Dimensions.paddingSizeSmall,
                  runSpacing: Dimensions.paddingSizeSmall,
                  children: quickOptions.map((option) {
                    return ActionChip(
                      label: Text(option, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                      backgroundColor: AppConstants.ugWhite,
                      side: const BorderSide(color: AppConstants.seasoningOrange, width: 1.2),
                      labelStyle: robotoBold.copyWith(color: AppConstants.ugBlack),
                      elevation: 1,
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
                    color: AppConstants.ugBlack,
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
                            color: AppConstants.ugWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.08), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.ugBlack.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: AppConstants.seasoningOrange.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                                ),
                                child: const Icon(Icons.lightbulb_outline, color: AppConstants.seasoningOrange, size: 20),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),
                              Expanded(
                                child: Text(
                                  prompt['title'] as String,
                                  style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: AppConstants.ugBlack,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 14, color: AppConstants.ugBlack.withValues(alpha: 0.4)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
