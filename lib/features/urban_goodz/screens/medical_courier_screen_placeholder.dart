import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

class MedicalCourierScreen extends StatelessWidget {
  const MedicalCourierScreen({super.key});

  static const List<Map<String, String>> _items = [
    {
      'title': 'STAT Lab Specimens Delivery',
      'reqs': 'Readiness: Cooler box, handling checklist',
      'urgency': 'Immediate',
    },
    {
      'title': 'Chain of Custody Transports',
      'reqs': 'Required: Signature logs, Courier ID card',
      'urgency': 'Same Day',
    },
    {
      'title': 'Temperature-Logged Deliveries',
      'reqs': 'Required: Thermometer probe, Insulated pack',
      'urgency': 'Immediate',
    },
    {
      'title': 'Hospital & Clinic Courier Routes',
      'reqs': 'Required: Hospital badge, Uniform',
      'urgency': 'Scheduled',
    },
    {
      'title': 'Medical Device Incident Reporting',
      'reqs': 'Required: Audit checklist, Tech training',
      'urgency': 'Standard',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Medical Courier Opportunities',
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
            message: 'Opportunity Network - Medical courier opportunities are in early access. Readiness guidance and route previews will appear here.',
            icon: Icons.shield_outlined,
          ),

          // Medical courier readiness meter
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
                  const Icon(Icons.security, color: AppConstants.seasoningOrange, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Medical Courier Readiness Checklist',
                      style: TextStyle(
                        color: AppConstants.ugWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Text(
                      'PREVIEW',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
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
                    'Healthcare Specimen Transit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.ugBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Preview medical courier opportunities for lab specimens, pharmaceuticals, and diagnostics. Credential, safety, and handling requirements may apply.',
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
                      label: 'Review Readiness Checklist',
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
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                final item = _items[index];
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
                          color: AppConstants.seasoningOrange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.medical_services_outlined, color: AppConstants.seasoningOrange, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AppConstants.ugBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['reqs'] ?? '',
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
                            item['urgency'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: item['urgency'] == 'Immediate' ? AppConstants.seasoningOrange : AppConstants.ugBlack,
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
