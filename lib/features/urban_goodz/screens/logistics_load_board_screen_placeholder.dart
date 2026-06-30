import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

class LogisticsLoadBoardScreen extends StatelessWidget {
  const LogisticsLoadBoardScreen({super.key});

  static const List<Map<String, String>> _loads = [
    {
      'title': 'Same-Day Local Delivery',
      'route': 'Route: HOU-092 (Local Loop)',
      'rate': '\$240.00 Est',
    },
    {
      'title': 'Last-Mile Distribution Route',
      'route': 'Route: HOU-105 (Northside)',
      'rate': '\$380.00 Est',
    },
    {
      'title': 'Middle-Mile Cargo Transport',
      'route': 'Route: TX-847 (Metro Area)',
      'rate': '\$620.00 Est',
    },
    {
      'title': 'Cargo Van Route Preview',
      'route': 'Route: HOU-123 (Galleria Loop)',
      'rate': '\$290.00 Est',
    },
    {
      'title': 'Pickup Truck Courier Run',
      'route': 'Route: HOU-044 (East End)',
      'rate': '\$180.00 Est',
    },
    {
      'title': 'Box Truck Freight Load',
      'route': 'Route: TX-902 (Houston to Katy)',
      'rate': '\$450.00 Est',
    },
    {
      'title': 'Medical-Adjacent Delivery Route',
      'route': 'Route: MED-001 (Medical Center)',
      'rate': '\$320.00 Est',
    },
    {
      'title': 'Retail Shop Replenishment Logistics',
      'route': 'Route: RET-448 (Downtown Mall)',
      'rate': '\$210.00 Est',
    },
    {
      'title': 'Enterprise Parcel Logistics',
      'route': 'Route: ENT-810 (Sienna Area)',
      'rate': '\$500.00 Est',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Load Board - Local Logistics',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: AppConstants.ugBlack,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
      ),
      body: Column(
        children: [
          const UrbanGoodzPreviewBanner(
            message: 'Opportunity Network - Local logistics route previews and carrier matching concepts are currently in early access testing mode.',
          ),
          
          // Dispatch preview meter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.ugBlack,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.wifi_tethering, color: AppConstants.seasoningOrange, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Dispatch preview mode',
                      style: TextStyle(
                        color: AppConstants.ugWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Preview',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: AppConstants.ugWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.25)),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.ugBlack.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Logistics Opportunities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.ugBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Review middle-mile and last-mile route previews. Registered commercial carriers can view estimated pricing and join the waitlist.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.ugBlack.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: UrbanGoodzActionButton(
                      label: 'Register Carrier Waitlist',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              itemCount: _loads.length,
              separatorBuilder: (_, _) => const SizedBox(height: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                final load = _loads[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.ugWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppConstants.canvas.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.route_outlined, color: AppConstants.seasoningOrange, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              load['title'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AppConstants.ugBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              load['route'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color: AppConstants.ugBlack.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            load['rate'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: AppConstants.ugBlack,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const UrbanGoodzStatusBadge(status: 'Early Access', isCompact: true),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
