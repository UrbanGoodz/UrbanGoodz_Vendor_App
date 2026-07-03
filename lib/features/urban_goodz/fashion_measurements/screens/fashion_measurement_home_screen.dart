import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';

class FashionMeasurementHomeScreen extends StatelessWidget {
  const FashionMeasurementHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color ugCanvas = Color(0xFFE2D3BF);
    const Color ugOrange = Color(0xFFED9914);
    const Color ugBlack = Color(0xFF161616);
    final fashionService = FashionMeasurementApiService();
    final fitRequests = fashionService.submittedRequests;

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
                message:
                    'Create a preview fit profile for fashion, styling, uniforms, creator merchandise, and local apparel services.',
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
                      'Create a preview fit profile for fashion, styling, uniforms, creator merchandise, and local apparel services.',
                      style: robotoRegular.copyWith(
                        fontSize: 14,
                        color: ugBlack.withValues(alpha: 0.8),
                      ),
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
                childAspectRatio: 1.5,
                children: [
                  _buildDashboardCard(
                    imagePath: 'assets/image/urban_goodz_features/fashion_fit_measurement_profile.jpg',
                    title: 'Measurement Profile',
                    subtitle: 'Manage saved sizes',
                    onTap: () {
                      Get.toNamed(RouteHelper.getUrbanGoodzFashionMeasurementProfileRoute());
                    },
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/image/urban_goodz_features/fashion_fit_photo_guides.jpg',
                    title: 'Photo Guides',
                    subtitle: 'Take or upload photo',
                    onTap: () {
                      Get.toNamed(RouteHelper.getUrbanGoodzFashionPhotoGuideRoute());
                    },
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/image/urban_goodz_features/fashion_fit_stylist_requests.jpg',
                    title: 'Stylist Requests',
                    subtitle: 'Bespoke fitting orders',
                    onTap: () {
                      Get.toNamed(RouteHelper.getUrbanGoodzFashionTailorRequestRoute());
                    },
                  ),
                  _buildDashboardCard(
                    imagePath: 'assets/image/urban_goodz_features/fashion_fit_bids_estimates.jpg',
                    title: 'Bids & Estimates',
                    subtitle: 'Review incoming quotes',
                    onTap: () {
                      Get.toNamed(RouteHelper.getUrbanGoodzFashionQuoteReviewRoute());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'My Fit Requests',
                style: robotoBold.copyWith(fontSize: 18, color: ugBlack),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ugOrange.withValues(alpha: 0.25)),
                ),
                child: fitRequests.isEmpty
                    ? Text(
                        'No Stylist Requests submitted yet. Create a measurement profile, take or upload front and side photos, generate an AI-Assisted Tester Estimate, then send a request to a Stylist.',
                        style: robotoRegular.copyWith(
                          fontSize: 13,
                          color: ugBlack.withValues(alpha: 0.75),
                          height: 1.4,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: fitRequests.map((request) {
                          final backendSynced = request.backendSynced == true;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ugCanvas.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.itemWanted ?? 'Stylist Request',
                                    style: robotoBold.copyWith(fontSize: 14, color: ugBlack),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    request.status ?? 'Pending Stylist Review',
                                    style: robotoBold.copyWith(fontSize: 12, color: ugOrange),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    backendSynced
                                        ? 'Backend connected: submitted for Stylist Review.'
                                        : 'Backend limitation: saved locally in this app session until Fashion Fit endpoints accept requests.',
                                    style: robotoRegular.copyWith(fontSize: 12, color: ugBlack.withValues(alpha: 0.72)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ugCanvas.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ugOrange.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Creator Space Fashion Education',
                      style: robotoBold.copyWith(fontSize: 15, color: ugBlack),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Browse public fashion drops, Stylist showcases, and measurement prep tips. Private customer measurement photos stay out of Creator Space and public feeds.',
                      style: robotoRegular.copyWith(
                        fontSize: 12,
                        color: ugBlack.withValues(alpha: 0.78),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => Get.toNamed(
                        RouteHelper.getUrbanGoodzCreatorCommerceRoute(),
                      ),
                      icon: const Icon(Icons.storefront_outlined),
                      label: const Text('Open Creator Fashion Content'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ugBlack,
                        side: BorderSide(
                          color: ugOrange.withValues(alpha: 0.65),
                        ),
                      ),
                    ),
                  ],
                ),
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
                            style: robotoBold.copyWith(
                              fontSize: 14,
                              color: ugBlack,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Measurement photos are intended only to help Stylists estimate fit. This tester preview does not claim production measurement accuracy.',
                            style: robotoRegular.copyWith(
                              fontSize: 12,
                              color: ugBlack.withValues(alpha: 0.8),
                            ),
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
    required String imagePath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.black.withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: robotoBold.copyWith(
                        fontSize: 13,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: robotoRegular.copyWith(
                        fontSize: 9,
                        color: Colors.white.withValues(alpha: 0.9),
                        shadows: [
                          const Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
}
