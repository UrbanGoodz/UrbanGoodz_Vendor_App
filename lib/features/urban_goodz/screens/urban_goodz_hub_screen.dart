import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_feature_asset_image.dart';

class UrbanGoodzHubScreen extends StatelessWidget {
  const UrbanGoodzHubScreen({super.key});

  static const String _hubAssetPath =
      'assets/image/urban_goodz_features/urban_goodz_hub.png';
  static const String _plusAssetPath =
      'assets/image/urban_goodz_features/urban_goodz_plus.png';
  static const String _askAssetPath =
      'assets/image/urban_goodz_features/ask_urban_goodz.png';
  static const String _thumbnailBasePath =
      'assets/image/urban_goodz_features/hub_thumbnails';

  static final List<_UrbanGoodzHubTab> _tabs = [
    _UrbanGoodzHubTab(
      label: 'Earn Money',
      title: 'Earn Money',
      description:
          'Find local earning opportunities, gigs, delivery requests, and partner work.',
      status: 'Live',
      buttonLabel: 'Open Earn Money',
      route: RouteHelper.getUrbanGoodzEarnMoneyRoute(),
      icon: Icons.paid_outlined,
      marketInsight: 'Demand signal preview',
      thumbnailAssetPath: '$_thumbnailBasePath/01_earn_money.png',
    ),
    _UrbanGoodzHubTab(
      label: 'Logistics',
      title: 'Logistics',
      description:
          'Access local logistics, package movement, and delivery support opportunities.',
      status: 'Preview',
      buttonLabel: 'Open Logistics',
      route: RouteHelper.getUrbanGoodzLogisticsRoute(),
      icon: Icons.local_shipping_outlined,
      marketInsight: 'Dispatch preview mode',
      thumbnailAssetPath: '$_thumbnailBasePath/02_logistics.png',
    ),
    _UrbanGoodzHubTab(
      label: 'Load Board',
      title: 'Load Board',
      description: 'View available loads, routes, and transport opportunities.',
      status: 'Preview',
      buttonLabel: 'Open Load Board',
      route: RouteHelper.getUrbanGoodzLoadBoardRoute(),
      icon: Icons.view_list_outlined,
      marketInsight: 'Estimated freight rate preview',
      thumbnailAssetPath: '$_thumbnailBasePath/03_load_board.png',
    ),
    _UrbanGoodzHubTab(
      label: 'Medical Courier',
      title: 'Medical Courier',
      description:
          'Explore medical courier jobs, chain-of-custody work, and healthcare logistics.',
      status: 'Preview',
      buttonLabel: 'Open Medical Courier',
      route: RouteHelper.getUrbanGoodzMedicalCourierRoute(),
      icon: Icons.medical_services_outlined,
      marketInsight: 'Medical courier readiness preview',
      thumbnailAssetPath: '$_thumbnailBasePath/04_medical_courier.png',
    ),
    _UrbanGoodzHubTab(
      label: 'Book Anything',
      title: 'Book Anything',
      description:
          'Request services, appointments, rentals, and custom local help.',
      status: 'Preview',
      buttonLabel: 'Open Book Anything',
      route: RouteHelper.getUrbanGoodzBookServicesRoute(),
      icon: Icons.event_available_outlined,
      marketInsight: '12 local service categories listed',
      thumbnailAssetPath: '$_thumbnailBasePath/05_book_anything.png',
    ),
    _UrbanGoodzHubTab(
      label: 'Events',
      title: 'Events & Creators',
      description:
          'Discover local events, creator activations, vendor opportunities, and community happenings.',
      status: 'Preview',
      buttonLabel: 'Open Events',
      route: RouteHelper.getLocalEventsCreatorsRoute(),
      icon: Icons.celebration_outlined,
      marketInsight: '3 local creator pop-ups this week',
      thumbnailAssetPath: '$_thumbnailBasePath/06_events.png',
    ),
    _UrbanGoodzHubTab(
      label: 'Community',
      title: 'Community Marketplace',
      description:
          'Connect with local conversations, recommendations, and neighborhood activity.',
      status: 'Preview',
      buttonLabel: 'Open Community',
      route: RouteHelper.getUrbanGoodzCommunityMarketplaceRoute(),
      icon: Icons.groups_outlined,
      marketInsight: 'Trending posts in your zip code',
      thumbnailAssetPath: '$_thumbnailBasePath/11_community_tab.png',
      thumbnailAspectRatio: 321 / 795,
    ),
    _UrbanGoodzHubTab(
      label: 'Creators',
      title: 'Creator Commerce',
      description:
          'Explore creator commerce, shoppable content, campaigns, and local influence opportunities.',
      status: 'Preview',
      buttonLabel: 'Open Creators',
      route: RouteHelper.getUrbanGoodzCreatorCommerceRoute(),
      icon: Icons.storefront_outlined,
      marketInsight: 'Creator campaign preview',
      thumbnailAssetPath: '$_thumbnailBasePath/12_creators_tab.png',
      thumbnailAspectRatio: 324 / 795,
    ),
    _UrbanGoodzHubTab(
      label: 'Ask UG',
      title: 'Urban Goodz AI',
      description:
          'Use Urban Goodz AI to help find products, services, vendors, rentals, events, and opportunities.',
      status: 'Preview',
      buttonLabel: 'Open Ask UG',
      route: RouteHelper.getUrbanGoodzAIRoute(),
      icon: Icons.auto_awesome_outlined,
      marketInsight: 'AI Assistant ready',
      assetPath: _askAssetPath,
      thumbnailAssetPath: '$_thumbnailBasePath/13_ask_ug_tab.png',
      thumbnailAspectRatio: 323 / 795,
    ),
    _UrbanGoodzHubTab(
      label: 'UG+',
      title: 'Urban Goodz Plus',
      description:
          'Access premium Urban Goodz perks, early features, and membership benefits.',
      status: 'Preview',
      buttonLabel: 'Open UG+',
      route: RouteHelper.getUrbanGoodzPlusRoute(),
      icon: Icons.workspace_premium_outlined,
      marketInsight: 'Premium waitlist open',
      assetPath: _plusAssetPath,
      thumbnailAssetPath: '$_thumbnailBasePath/14_ug_plus_tab.png',
      thumbnailAspectRatio: 317 / 795,
    ),
    _UrbanGoodzHubTab(
      label: 'Fashion Fit',
      title: 'Fashion Fit & Measurements',
      description:
          'Create a tester preview fit profile for fashion, styling, uniforms, creator merchandise, and local apparel services.',
      status: 'Preview',
      buttonLabel: 'Open Fashion Fit',
      route: RouteHelper.getUrbanGoodzFashionMeasurementsRoute(),
      icon: Icons.checkroom_outlined,
      marketInsight: 'Measurement intake preview',
      thumbnailAssetPath: '$_thumbnailBasePath/15_fashion_fit_tab.png',
      thumbnailAspectRatio: 322 / 795,
    ),
    _UrbanGoodzHubTab(
      label: 'Order Anywhere',
      title: 'Order Anywhere',
      description:
          'Need items from a store not listed? Request custom pickup or delivery from any local merchant.',
      status: 'Preview',
      buttonLabel: 'Open Order Anywhere',
      route: RouteHelper.getOrderAnywhereRequestRoute(),
      icon: Icons.map_outlined,
      marketInsight: 'Order from any shop',
      thumbnailAssetPath: '$_thumbnailBasePath/05_book_anything.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: AppConstants.canvas,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  title: const Text(
                    'Urban Goodz Hub',
                    style: TextStyle(
                      color: AppConstants.ugBlack,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  centerTitle: false,
                  backgroundColor: AppConstants.canvas,
                  foregroundColor: AppConstants.ugBlack,
                  elevation: 0,
                  floating: true,
                  pinned: false,
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFAF7F2), AppConstants.canvas],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusLarge,
                      ),
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
                        UrbanGoodzFeatureAssetImage(
                          assetPath: _hubAssetPath,
                          maxHeight: ResponsiveHelper.isDesktop(context)
                              ? 285
                              : 210,
                          fit: BoxFit.contain,
                          backgroundColor: Colors.transparent,
                          hasBorder: false,
                          padding: EdgeInsets.zero,
                          fillWidth: true,
                          alignment: Alignment.center,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.seasoningOrange,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusSmall,
                                ),
                              ),
                              child: const Text(
                                'CONCIERGE',
                                style: TextStyle(
                                  color: AppConstants.ugBlack,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 9,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'One Platform. Unlimited Possibilities.',
                                style: TextStyle(
                                  color: AppConstants.ugBlack,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        const Text(
                          'Your Connection To Local Everything',
                          style: TextStyle(
                            color: AppConstants.ugBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Explore food, logistics, courier work, local events, rentals, and creators in one smart hub.',
                          style: TextStyle(
                            color: AppConstants.ugBlack.withValues(alpha: 0.75),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    Container(
                      color: AppConstants.canvas,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeDefault,
                        vertical: Dimensions.paddingSizeSmall,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppConstants.ugWhite,
                          borderRadius: BorderRadius.circular(
                            Dimensions.radiusDefault,
                          ),
                          border: Border.all(
                            color: AppConstants.ugBlack.withValues(alpha: 0.1),
                          ),
                        ),
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          labelColor: AppConstants.ugWhite,
                          unselectedLabelColor: AppConstants.ugBlack,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: AppConstants.ugBlack,
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusDefault - 2,
                            ),
                          ),
                          tabs: _tabs
                              .map(
                                (tab) => Tab(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      tab.label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: _tabs
                  .map((tab) => _UrbanGoodzHubPanel(tab: tab))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate(this.child);

  @override
  double get minExtent => 68.0;
  @override
  double get maxExtent => 68.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overridesHeader,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _UrbanGoodzHubPanel extends StatelessWidget {
  final _UrbanGoodzHubTab tab;

  const _UrbanGoodzHubPanel({required this.tab});

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 720;
    final bool useSplitLayout = isWide && tab.usesPortraitDetailLayout;
    final double paddingVal = isWide
        ? Dimensions.paddingSizeExtraLarge
        : Dimensions.paddingSizeDefault;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: paddingVal,
        right: paddingVal,
        top: paddingVal,
        bottom: paddingVal + 80, // Safe bottom spacing
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Container(
            decoration: BoxDecoration(
              color: AppConstants.ugWhite,
              borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              border: Border.all(
                color: AppConstants.seasoningOrange.withValues(alpha: 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.ugBlack.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.04),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(
                isWide
                    ? Dimensions.paddingSizeExtraLarge
                    : Dimensions.paddingSizeLarge,
              ),
              child: useSplitLayout
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HubDetailImage(tab: tab),
                        const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                        Expanded(child: _HubFeatureInfo(tab: tab)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _HubFeatureInfo(tab: tab, includeActions: false),
                        if (tab.hasDetailImage) ...[
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          _HubDetailImage(tab: tab),
                        ],
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        _HubMarketInsight(tab: tab),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        _HubAction(tab: tab),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HubFeatureInfo extends StatelessWidget {
  final _UrbanGoodzHubTab tab;
  final bool includeActions;

  const _HubFeatureInfo({required this.tab, this.includeActions = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppConstants.seasoningOrange.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                tab.icon,
                color: AppConstants.seasoningOrange,
                size: 30,
              ),
            ),
            const Spacer(),
            UrbanGoodzStatusBadge(status: tab.status),
          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),
        Text(
          tab.title,
          style: const TextStyle(
            color: AppConstants.ugBlack,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),
        Text(
          tab.description,
          style: TextStyle(
            color: AppConstants.ugBlack.withValues(alpha: 0.75),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        if (includeActions) ...[
          const SizedBox(height: Dimensions.paddingSizeLarge),
          _HubMarketInsight(tab: tab),
          const SizedBox(height: Dimensions.paddingSizeLarge),
          _HubAction(tab: tab),
        ],
      ],
    );
  }
}

class _HubDetailImage extends StatelessWidget {
  final _UrbanGoodzHubTab tab;

  const _HubDetailImage({required this.tab});

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 720;
    final bool isPortrait = tab.usesPortraitDetailLayout;
    final String? assetPath = tab.detailImageAssetPath;

    if (assetPath == null) {
      return const SizedBox.shrink();
    }

    final double maxWidth = isPortrait
        ? (isWide ? 360 : 320)
        : (isWide ? 820 : 520);
    final double height = isPortrait
        ? (isWide ? 540 : 500)
        : (isWide ? 430 : 340);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          width: double.infinity,
          height: height,
          padding: EdgeInsets.all(isPortrait ? 10 : 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFBF5), AppConstants.canvas],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            border: Border.all(
              color: AppConstants.seasoningOrange.withValues(alpha: 0.16),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            child: Image.asset(
              assetPath!,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class _HubMarketInsight extends StatelessWidget {
  final _UrbanGoodzHubTab tab;

  const _HubMarketInsight({required this.tab});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppConstants.canvas.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(
          color: AppConstants.canvas.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.analytics_outlined,
            size: 16,
            color: AppConstants.seasoningOrange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tab.marketInsight,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppConstants.ugBlack,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HubAction extends StatelessWidget {
  final _UrbanGoodzHubTab tab;

  const _HubAction({required this.tab});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: UrbanGoodzActionButton(
        label: tab.buttonLabel,
        onPressed: () => Get.toNamed(tab.route),
      ),
    );
  }
}

class _UrbanGoodzHubTab {
  final String label;
  final String title;
  final String description;
  final String status;
  final String buttonLabel;
  final String route;
  final IconData icon;
  final String marketInsight;
  final String? assetPath;
  final String? thumbnailAssetPath;
  final double thumbnailAspectRatio;

  bool get hasDetailImage => detailImageAssetPath != null;
  bool get usesPortraitDetailLayout => thumbnailAspectRatio < 0.75;
  String? get detailImageAssetPath => thumbnailAssetPath ?? assetPath;

  const _UrbanGoodzHubTab({
    required this.label,
    required this.title,
    required this.description,
    required this.status,
    required this.buttonLabel,
    required this.route,
    required this.icon,
    required this.marketInsight,
    this.assetPath,
    this.thumbnailAssetPath,
    this.thumbnailAspectRatio = 1,
  });
}
