import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_feature_asset_image.dart';

class UrbanGoodzAiScreen extends StatefulWidget {
  const UrbanGoodzAiScreen({super.key});

  @override
  State<UrbanGoodzAiScreen> createState() => _UrbanGoodzAiScreenState();
}

class _UrbanGoodzAiScreenState extends State<UrbanGoodzAiScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _isProcessing = true;
    });

    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
      });
      Get.toNamed(RouteHelper.getSearchRoute(queryText: query.trim()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> quickOptions = [
      'Food Trucks',
      'Grocery Deals',
      'Car Rentals',
      'Black-owned',
      'Pop-up Markets',
      'Local Services',
    ];

    final List<Map<String, dynamic>> guidedPrompts = [
      {
        'title': 'Find Black-owned restaurants near me',
        'query': 'black-owned restaurants',
        'asset': 'assets/image/urban_goodz_features/black_owned_spotlight.png',
      },
      {
        'title': 'Show rentals available today',
        'route': RouteHelper.getInitialRoute(moduleId: AppConstants.taxi),
      },
      {
        'title': 'Find local deals under \$25',
        'query': 'deals under 25',
      },
      {
        'title': 'Help me discover events nearby',
        'query': 'events near me',
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
        padding: EdgeInsets.only(
          left: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
          right: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
          top: Dimensions.paddingSizeDefault,
          bottom: Dimensions.paddingSizeDefault + 80, // Safe bottom spacing
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UrbanGoodzPreviewBanner(
                  message: 'This is an interactive AI concierge preview. Type any query to match local suppliers, logistics, or services.',
                  icon: Icons.auto_awesome_outlined,
                ),
                
                const SizedBox(height: Dimensions.paddingSizeSmall),

                UrbanGoodzFeatureAssetImage(
                  assetPath: 'assets/image/urban_goodz_features/ask_urban_goodz.png',
                  maxHeight: ResponsiveHelper.isDesktop(context) ? 320 : 220,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.transparent,
                  hasBorder: false,
                  padding: EdgeInsets.zero,
                  hasShadow: true,
                ),
 
                const SizedBox(height: Dimensions.paddingSizeLarge),
                
                // Welcome Hero Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFAF7F2), AppConstants.canvas],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppConstants.seasoningOrange.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.ugBlack.withValues(alpha: 0.05),
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
                              color: AppConstants.ugBlack,
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
                          color: AppConstants.ugBlack.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: Dimensions.paddingSizeLarge),
                
                // Smart Glowing Search Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
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
                      const SizedBox(width: 8),
                      const Icon(Icons.search, color: AppConstants.seasoningOrange, size: 24),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          enabled: !_isProcessing,
                          decoration: InputDecoration(
                            hintText: 'Ask about food, shops, rentals, events...',
                            hintStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: AppConstants.ugBlack.withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onSubmitted: (value) => _handleSearch(value),
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: AppConstants.ugBlack,
                          ),
                        ),
                      ),
                      _isProcessing
                          ? Container(
                              height: 36,
                              width: 36,
                              padding: const EdgeInsets.all(8),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppConstants.seasoningOrange,
                              ),
                            )
                          : UrbanGoodzActionButton(
                              label: 'Ask',
                              onPressed: () => _handleSearch(_searchController.text),
                            ),
                    ],
                  ),
                ),
                
                if (_isProcessing) ...[
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 12,
                          width: 12,
                          child: CircularProgressIndicator(strokeWidth: 1.5, color: AppConstants.seasoningOrange),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'AI is matching local vendors & catalogs...',
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: AppConstants.seasoningOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
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
                      onPressed: _isProcessing ? null : () {
                        _searchController.text = option;
                        _handleSearch(option);
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
                    final String? assetPath = prompt['asset'] as String?;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      child: GestureDetector(
                        onTap: _isProcessing ? null : () {
                          if (prompt['route'] != null) {
                            Get.toNamed(prompt['route'] as String);
                          } else if (prompt['query'] != null) {
                            _searchController.text = prompt['query'] as String;
                            _handleSearch(prompt['query'] as String);
                          }
                        },
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (assetPath != null) ...[
                                UrbanGoodzFeatureAssetImage(
                                  assetPath: assetPath,
                                  maxHeight: 240,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                              ],
                              Row(
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
