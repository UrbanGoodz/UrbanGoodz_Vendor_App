import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'measurement_profile_screen.dart';
import 'measurement_photo_guide_screen.dart';
import 'tailor_service_request_screen.dart';
import 'tailor_quote_review_screen.dart';

class FashionMeasurementHomeScreen extends StatelessWidget {
  const FashionMeasurementHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color ugCanvas = Color(0xFFE2D3BF);
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Fashion Fit & Measurements',
          style: robotoBold.copyWith(color: ugBlack),
        ),
        backgroundColor: ugCanvas,
        iconTheme: const IconThemeData(color: ugBlack),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview Banner
              const UrbanGoodzPreviewBanner(
                message: 'Create a preview fit profile for fashion, tailoring, uniforms, creator merchandise, and local apparel services.',
              ),
              const SizedBox(height: 12),

              // Welcome Header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ugCanvas, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ugOrange.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fashion Fit & Measurements',
                      style: robotoBold.copyWith(fontSize: 22, color: ugBlack),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a preview fit profile for fashion, tailoring, uniforms, creator merchandise, and local apparel services.',
                      style: robotoRegular.copyWith(fontSize: 14, color: ugBlack.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'My Fitting Dashboard',
                style: robotoBold.copyWith(fontSize: 18, color: ugBlack),
              ),
              const SizedBox(height: 16),

              // Action Cards Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildDashboardCard(
                    icon: Icons.person_pin_rounded,
                    title: 'Measurement Profile',
                    subtitle: 'Manage saved sizes',
                    onTap: () {
                      Get.to(() => const MeasurementProfileScreen());
                    },
                  ),
                  _buildDashboardCard(
                    icon: Icons.camera_enhance_rounded,
                    title: 'Photo Guides',
                    subtitle: 'Upload fitting photos',
                    onTap: () {
                      Get.to(() => const MeasurementPhotoGuideScreen());
                    },
                  ),
                  _buildDashboardCard(
                    icon: Icons.design_services_rounded,
                    title: 'Tailor Requests',
                    subtitle: 'Bespoke fitting orders',
                    onTap: () {
                      Get.to(() => const TailorServiceRequestScreen());
                    },
                  ),
                  _buildDashboardCard(
                    icon: Icons.request_quote_rounded,
                    title: 'Bids & Estimates',
                    subtitle: 'Review incoming quotes',
                    onTap: () {
                      Get.to(() => const TailorQuoteReviewScreen());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Safety Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.security, color: ugOrange, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Photo-Assisted Disclaimer',
                            style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Measurement photos are intended only to help tailors estimate fit. This tester preview does not verify production storage, privacy, or measurement accuracy yet.',
                            style: robotoRegular.copyWith(fontSize: 12, color: ugBlack.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: ugOrange, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: robotoRegular.copyWith(fontSize: 11, color: Colors.grey.shade600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
