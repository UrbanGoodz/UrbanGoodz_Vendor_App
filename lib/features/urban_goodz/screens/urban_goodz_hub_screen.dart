import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';

class UrbanGoodzHubScreen extends StatelessWidget {
  const UrbanGoodzHubScreen({super.key});

  static final List<_UrbanGoodzHubTab> _tabs = [
    _UrbanGoodzHubTab(
      label: 'Earn Money',
      title: 'Earn Money',
      description: 'Find local earning opportunities, gigs, delivery requests, and partner work.',
      status: 'Live',
      buttonLabel: 'Open Earn Money',
      route: RouteHelper.getUrbanGoodzEarnMoneyRoute(),
      icon: Icons.paid_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Logistics',
      title: 'Logistics',
      description: 'Access local logistics, package movement, and delivery support opportunities.',
      status: 'Preview',
      buttonLabel: 'Open Logistics',
      route: RouteHelper.getUrbanGoodzLogisticsRoute(),
      icon: Icons.local_shipping_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Load Board',
      title: 'Load Board',
      description: 'View available loads, routes, and transport opportunities.',
      status: 'Preview',
      buttonLabel: 'Open Load Board',
      route: RouteHelper.getUrbanGoodzLoadBoardRoute(),
      icon: Icons.view_list_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Medical Courier',
      title: 'Medical Courier',
      description: 'Explore medical courier jobs, chain-of-custody work, and healthcare logistics.',
      status: 'Preview',
      buttonLabel: 'Open Medical Courier',
      route: RouteHelper.getUrbanGoodzMedicalCourierRoute(),
      icon: Icons.medical_services_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Book Anything',
      title: 'Book Anything',
      description: 'Request services, appointments, rentals, and custom local help.',
      status: 'Preview',
      buttonLabel: 'Open Book Anything',
      route: RouteHelper.getUrbanGoodzBookServicesRoute(),
      icon: Icons.event_available_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Events',
      title: 'Events & Creators',
      description: 'Discover local events, creator activations, vendor opportunities, and community happenings.',
      status: 'Preview',
      buttonLabel: 'Open Events',
      route: RouteHelper.getLocalEventsCreatorsRoute(),
      icon: Icons.celebration_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Community',
      title: 'Community Marketplace',
      description: 'Connect with local conversations, recommendations, and neighborhood activity.',
      status: 'Preview',
      buttonLabel: 'Open Community',
      route: RouteHelper.getUrbanGoodzCommunityMarketplaceRoute(),
      icon: Icons.groups_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Creators',
      title: 'Creator Commerce',
      description: 'Explore creator commerce, shoppable content, campaigns, and local influence opportunities.',
      status: 'Preview',
      buttonLabel: 'Open Creators',
      route: RouteHelper.getUrbanGoodzCreatorCommerceRoute(),
      icon: Icons.storefront_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Ask UG',
      title: 'Urban Goodz AI',
      description: 'Use Urban Goodz AI to help find products, services, vendors, rentals, events, and opportunities.',
      status: 'Preview',
      buttonLabel: 'Open Ask UG',
      route: RouteHelper.getUrbanGoodzAIRoute(),
      icon: Icons.auto_awesome_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'UG+',
      title: 'Urban Goodz Plus',
      description: 'Access premium Urban Goodz perks, early features, and membership benefits.',
      status: 'Preview',
      buttonLabel: 'Open UG+',
      route: RouteHelper.getUrbanGoodzPlusRoute(),
      icon: Icons.workspace_premium_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: AppConstants.canvas,
        appBar: AppBar(
          title: const Text(
            'Urban Goodz',
            style: TextStyle(
              color: AppConstants.ugBlack,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: false,
          backgroundColor: AppConstants.ugWhite,
          foregroundColor: AppConstants.ugBlack,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: AppConstants.ugWhite,
              padding: const EdgeInsets.fromLTRB(
                Dimensions.paddingSizeDefault,
                0,
                Dimensions.paddingSizeDefault,
                Dimensions.paddingSizeDefault,
              ),
              child: const Text(
                'Your Connection To Local Everything',
                style: TextStyle(
                  color: AppConstants.ugBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              color: AppConstants.ugWhite,
              child: TabBar(
                isScrollable: true,
                labelColor: AppConstants.ugBlack,
                unselectedLabelColor: AppConstants.ugBlack,
                indicatorColor: AppConstants.seasoningOrange,
                indicatorWeight: 3,
                tabs: _tabs.map((tab) => Tab(text: tab.label)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: _tabs.map((tab) => _UrbanGoodzHubPanel(tab: tab)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrbanGoodzHubPanel extends StatelessWidget {
  final _UrbanGoodzHubTab tab;

  const _UrbanGoodzHubPanel({required this.tab});

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 720;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isWide ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeDefault),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppConstants.ugWhite,
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.35)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(isWide ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppConstants.seasoningOrange.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        ),
                        child: Icon(tab.icon, color: AppConstants.seasoningOrange, size: 32),
                      ),
                      const Spacer(),
                      _StatusBadge(status: tab.status),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    tab.title,
                    style: const TextStyle(
                      color: AppConstants.ugBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    tab.description,
                    style: TextStyle(
                      color: AppConstants.ugBlack.withValues(alpha: 0.76),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  SizedBox(
                    width: isWide ? 240 : double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.ugBlack,
                        foregroundColor: AppConstants.ugWhite,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Get.toNamed(tab.route),
                      child: Text(tab.buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isLive = status == 'Live';
    final Color backgroundColor = isLive ? AppConstants.seasoningOrange : AppConstants.canvas;
    final Color borderColor = isLive ? AppConstants.seasoningOrange : AppConstants.seasoningOrange.withValues(alpha: 0.55);
    final Color textColor = isLive ? AppConstants.ugBlack : AppConstants.ugBlack.withValues(alpha: 0.78);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
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

  const _UrbanGoodzHubTab({
    required this.label,
    required this.title,
    required this.description,
    required this.status,
    required this.buttonLabel,
    required this.route,
    required this.icon,
  });
}
