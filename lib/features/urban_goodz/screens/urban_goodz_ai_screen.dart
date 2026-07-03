import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
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
  String? _lastQuery;
  String? _responseText;
  Widget? _responseAction;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _isProcessing = true;
      _lastQuery = query.trim();
      _responseText = null;
      _responseAction = null;
    });

    Timer(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        final q = query.toLowerCase();
        if (q.contains('tailor') || q.contains('stylist') || q.contains('measur') || q.contains('clothe') || q.contains('fit')) {
          _responseText = 'Tester preview found local Stylist and alteration paths. Open Fashion Fit to prepare a sizing profile before any live Stylist matching is enabled.';
          _responseAction = UrbanGoodzActionButton(
            label: 'Open Fashion Fit',
            onPressed: () => Get.toNamed(RouteHelper.getUrbanGoodzFashionMeasurementsRoute()),
          );
        } else if (q.contains('order') || q.contains('shop') || q.contains('store') || q.contains('not listed') || q.contains('buy') || q.contains('anywhere')) {
          _responseText = 'Tester preview can collect an Order Anywhere request for a store that is not listed. No live purchase, payment, pickup, or dispatch starts from this build.';
          _responseAction = UrbanGoodzActionButton(
            label: 'Order Anywhere Form',
            onPressed: () => Get.toNamed(RouteHelper.getOrderAnywhereRequestRoute()),
          );
        } else if (q.contains('creator') || q.contains('influencer') || q.contains('reel') || q.contains('content')) {
          _responseText = 'Tester preview can show local creator commerce paths, product ideas, and an interest form without starting a live creator campaign.';
          _responseAction = UrbanGoodzActionButton(
            label: 'Creator Commerce',
            onPressed: () => Get.toNamed(RouteHelper.getUrbanGoodzCreatorCommerceRoute()),
          );
        } else if (q.contains('deliver') || q.contains('courier') || q.contains('job') || q.contains('earn') || q.contains('opportunity') || q.contains('gig') || q.contains('logistics') || q.contains('load') || q.contains('board')) {
          _responseText = 'Tester preview can show earning, logistics, load board, and courier opportunity screens without posting or accepting live work.';
          _responseAction = UrbanGoodzActionButton(
            label: 'Earn Money Dashboard',
            onPressed: () => Get.toNamed(RouteHelper.getUrbanGoodzEarnMoneyRoute()),
          );
        } else if (q.contains('car') || q.contains('rental') || q.contains('vehicle') || q.contains('rent')) {
          _responseText = 'Tester preview can route you to car rental options. Live booking availability depends on the connected module.';
          _responseAction = UrbanGoodzActionButton(
            label: 'Open Car Rental Hub',
            onPressed: () => Get.find<SplashController>().switchModule(
              Get.find<SplashController>().moduleList!.indexWhere(
                (m) => m.moduleType.toString() == AppConstants.taxi,
              ),
              true,
            ),
          );
        } else {
          _responseText = 'Tester preview processed your query. For custom store requests, use Order Anywhere. For apparel sizing, open Fashion Fit.';
          _responseAction = Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.toNamed(RouteHelper.getOrderAnywhereRequestRoute()),
                  child: const Text('Order Anywhere'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: UrbanGoodzActionButton(
                  label: 'Fashion Fit',
                  onPressed: () => Get.toNamed(RouteHelper.getUrbanGoodzFashionMeasurementsRoute()),
                ),
              ),
            ],
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> quickOptions = [
      'Stylists',
      'Order Anywhere',
      'Local Creators',
      'Courier Opportunities',
      'Car Rentals',
    ];

    final List<Map<String, dynamic>> guidedPrompts = [
      {
        'title': 'Find a Stylist near me',
        'query': 'Find a Stylist near me',
        'asset': 'assets/image/urban_goodz_features/ai_measuring_fit.png',
      },
      {
        'title': 'Help me order from a store not listed',
        'query': 'Help me order from a store not listed',
      },
      {'title': 'Find local creators', 'query': 'Find local creators'},
      {'title': 'Find delivery or courier opportunities', 'query': 'Find delivery or courier opportunities'},
      {'title': 'Find car rental options', 'query': 'Find car rental options'},
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
          left: ResponsiveHelper.isDesktop(context)
              ? Dimensions.paddingSizeLarge
              : Dimensions.paddingSizeDefault,
          right: ResponsiveHelper.isDesktop(context)
              ? Dimensions.paddingSizeLarge
              : Dimensions.paddingSizeDefault,
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
                  message:
                      'This is an interactive Ask UG tester preview. It suggests safe routes and mock guidance without using a live AI backend.',
                  icon: Icons.auto_awesome_outlined,
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                UrbanGoodzFeatureAssetImage(
                  assetPath:
                      'assets/image/urban_goodz_features/ask_urban_goodz.png',
                  maxHeight: ResponsiveHelper.isDesktop(context) ? 560 : 360,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.transparent,
                  hasBorder: false,
                  padding: EdgeInsets.zero,
                  hasShadow: true,
                  fillWidth: true,
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
                      color: AppConstants.seasoningOrange.withValues(
                        alpha: 0.5,
                      ),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.ugBlack.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
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
                              color: AppConstants.seasoningOrange.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: AppConstants.seasoningOrange,
                              size: 20,
                            ),
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
                        'Get guided tester-preview recommendations for Fashion Fit, Order Anywhere, creators, rentals, logistics, and local opportunities.',
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
                      color: AppConstants.seasoningOrange.withValues(
                        alpha: 0.4,
                      ),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.seasoningOrange.withValues(
                          alpha: 0.1,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.search,
                        color: AppConstants.seasoningOrange,
                        size: 24,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          enabled: !_isProcessing,
                          decoration: InputDecoration(
                            hintText:
                                'Ask about fit, stores, creators, courier work...',
                            hintStyle: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: AppConstants.ugBlack.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
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
                              onPressed: () =>
                                  _handleSearch(_searchController.text),
                            ),
                    ],
                  ),
                ),

                if (_isProcessing) ...[
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: Dimensions.paddingSizeSmall,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 12,
                          width: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppConstants.seasoningOrange,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tester preview is matching routes and screens...',
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: AppConstants.seasoningOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (_responseText != null) ...[
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppConstants.seasoningOrange.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: AppConstants.seasoningOrange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Response for: "${_lastQuery}"',
                              style: robotoBold.copyWith(fontSize: 14, color: AppConstants.ugBlack),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _responseText!,
                          style: robotoRegular.copyWith(fontSize: 13, color: AppConstants.ugBlack, height: 1.45),
                        ),
                        if (_responseAction != null) ...[
                          const SizedBox(height: 16),
                          _responseAction!,
                        ],
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
                      label: Text(
                        option,
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                      backgroundColor: AppConstants.ugWhite,
                      side: const BorderSide(
                        color: AppConstants.seasoningOrange,
                        width: 1.2,
                      ),
                      labelStyle: robotoBold.copyWith(
                        color: AppConstants.ugBlack,
                      ),
                      elevation: 1,
                      onPressed: _isProcessing
                          ? null
                          : () {
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
                      padding: const EdgeInsets.only(
                        bottom: Dimensions.paddingSizeSmall,
                      ),
                      child: GestureDetector(
                        onTap: _isProcessing
                            ? null
                            : () {
                                if (prompt['route'] != null) {
                                  Get.toNamed(prompt['route'] as String);
                                } else if (prompt['query'] != null) {
                                  _searchController.text =
                                      prompt['query'] as String;
                                  _handleSearch(prompt['query'] as String);
                                }
                              },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(
                            Dimensions.paddingSizeDefault,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.ugWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppConstants.ugBlack.withValues(
                                alpha: 0.08,
                              ),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.ugBlack.withValues(
                                  alpha: 0.02,
                                ),
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
                                  maxHeight: ResponsiveHelper.isDesktop(context)
                                      ? 460
                                      : 320,
                                  fillWidth: true,
                                ),
                                const SizedBox(
                                  height: Dimensions.paddingSizeDefault,
                                ),
                              ],
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppConstants.seasoningOrange
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radiusLarge,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.lightbulb_outline,
                                      color: AppConstants.seasoningOrange,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Dimensions.paddingSizeDefault,
                                  ),
                                  Expanded(
                                    child: Text(
                                      prompt['title'] as String,
                                      style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: AppConstants.ugBlack,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: AppConstants.ugBlack.withValues(
                                      alpha: 0.4,
                                    ),
                                  ),
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
