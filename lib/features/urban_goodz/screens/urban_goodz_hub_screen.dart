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
      description: 'Find local earning opportunities, gigs, and partner requests.',
      route: RouteHelper.getUrbanGoodzEarnMoneyRoute(),
      icon: Icons.paid_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Logistics',
      title: 'Logistics',
      description: 'Explore local delivery jobs and logistics opportunities.',
      route: RouteHelper.getUrbanGoodzLogisticsRoute(),
      icon: Icons.local_shipping_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Load Board',
      title: 'Load Board',
      description: 'Review available routes, loads, and carrier-ready dispatches.',
      route: RouteHelper.getUrbanGoodzLoadBoardRoute(),
      icon: Icons.view_list_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Medical Courier',
      title: 'Medical Courier',
      description: 'Access medical courier opportunities and healthcare logistics.',
      route: RouteHelper.getUrbanGoodzMedicalCourierRoute(),
      icon: Icons.medical_services_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Book Anything',
      title: 'Book Anything',
      description: 'Request services, bookings, and local help through Urban Goodz.',
      route: RouteHelper.getUrbanGoodzBookServicesRoute(),
      icon: Icons.event_available_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Events',
      title: 'Events & Creators',
      description: 'Discover local events, creators, and community experiences.',
      route: RouteHelper.getLocalEventsCreatorsRoute(),
      icon: Icons.celebration_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Community',
      title: 'Community Marketplace',
      description: 'Browse community listings and local marketplace activity.',
      route: RouteHelper.getUrbanGoodzCommunityMarketplaceRoute(),
      icon: Icons.groups_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Creators',
      title: 'Creator Commerce',
      description: 'Connect with creator-led shops, services, and local offers.',
      route: RouteHelper.getUrbanGoodzCreatorCommerceRoute(),
      icon: Icons.storefront_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'Ask UG',
      title: 'Urban Goodz AI',
      description: 'Ask the Urban Goodz concierge to help find what you need.',
      route: RouteHelper.getUrbanGoodzAIRoute(),
      icon: Icons.auto_awesome_outlined,
    ),
    _UrbanGoodzHubTab(
      label: 'UG+',
      title: 'Urban Goodz Plus',
      description: 'Open the Urban Goodz Plus member experience.',
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
                  Icon(tab.icon, color: AppConstants.seasoningOrange, size: 42),
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
                      child: Text('Open ${tab.label}'),
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

class _UrbanGoodzHubTab {
  final String label;
  final String title;
  final String description;
  final String route;
  final IconData icon;

  const _UrbanGoodzHubTab({
    required this.label,
    required this.title,
    required this.description,
    required this.route,
    required this.icon,
  });
}
