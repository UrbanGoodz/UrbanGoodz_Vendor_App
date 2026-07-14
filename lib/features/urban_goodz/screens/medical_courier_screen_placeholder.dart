import 'package:flutter/material.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

class MedicalCourierScreen extends StatelessWidget {
  const MedicalCourierScreen({super.key});

  static const List<Map<String, String>> _items = [];

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
                      label: 'Review Readiness Checklist & Apply',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Row(
                                children: [
                                  Icon(Icons.shield, color: AppConstants.seasoningOrange),
                                  SizedBox(width: 8),
                                  Text('Medical Courier Readiness', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                ],
                              ),
                              content: const SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('To qualify for medical logistics, carriers must meet these criteria:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                    SizedBox(height: 12),
                                    Row(children: [Icon(Icons.check_circle_outline, color: Colors.green, size: 16), SizedBox(width: 8), Text('HIPAA Compliance Training')]),
                                    SizedBox(height: 8),
                                    Row(children: [Icon(Icons.check_circle_outline, color: Colors.green, size: 16), SizedBox(width: 8), Text('Insulated Cooler Box + Temp Log')]),
                                    SizedBox(height: 8),
                                    Row(children: [Icon(Icons.check_circle_outline, color: Colors.green, size: 16), SizedBox(width: 8), Text('Valid Driver License & Background Check')]),
                                    SizedBox(height: 8),
                                    Row(children: [Icon(Icons.check_circle_outline, color: Colors.green, size: 16), SizedBox(width: 8), Text('Specimen handling orientation')]),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppConstants.seasoningOrange, foregroundColor: AppConstants.ugBlack),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Application Submitted'),
                                        content: const Text('Your interest in becoming a Medical Courier has been submitted!'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text('Express Interest & Apply'),
                                ),
                              ],
                            );
                          },
                        );
                      },
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
                return InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Medical Courier Run'),
                        content: Text('Route details for:\n\n"${item['title']}"\nRequirements: ${item['reqs']}\nUrgency: ${item['urgency']}\n\nInterest expressed. We will notify you once dispatch is live.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                        ],
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
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
