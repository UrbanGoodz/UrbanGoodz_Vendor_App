import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/urban_goodz/fashion_measurements/services/fashion_measurement_api_service.dart';
import 'package:sixam_mart/util/app_constants.dart';

class FashionMeasurementHomeScreen extends StatefulWidget {
  const FashionMeasurementHomeScreen({super.key});

  @override
  State<FashionMeasurementHomeScreen> createState() =>
      _FashionMeasurementHomeScreenState();
}

class _FashionMeasurementHomeScreenState
    extends State<FashionMeasurementHomeScreen> {
  final fashionService = FashionMeasurementApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    setState(() => _isLoading = true);
    try {
      final int userId = AuthHelper.isLoggedIn()
          ? (Get.find<ProfileController>().userInfoModel?.id ?? 1)
          : 1;
      await fashionService.getSubmittedRequests(userId);
    } catch (e) {
      debugPrint('Failed to fetch submitted requests: $e');
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fitRequests = fashionService.submittedRequests;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Fashion Fit & Measurements',
          style: robotoBold.copyWith(color: AppConstants.ugBlack),
        ),
        backgroundColor: AppConstants.canvas,
        iconTheme: const IconThemeData(color: AppConstants.ugBlack),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _fetchRequests,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRequests,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Header card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppConstants.canvas, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.seasoningOrange.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fashion Fit & Measurements',
                        style: robotoBold.copyWith(
                          fontSize: 22,
                          color: AppConstants.ugBlack,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create an AI photo measurement profile for fashion, styling, uniforms, creator merchandise, and local apparel services.',
                        style: robotoRegular.copyWith(
                          fontSize: 14,
                          color: AppConstants.ugBlack.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'My Fitting Dashboard',
                  style: robotoBold.copyWith(
                    fontSize: 18,
                    color: AppConstants.ugBlack,
                  ),
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
                      imagePath:
                          'assets/image/urban_goodz_features/fashion_fit_measurement_profile.jpg',
                      title: 'Measurement Profile',
                      subtitle: 'Manage saved sizes',
                      onTap: () {
                        Get.toNamed(
                          RouteHelper.getUrbanGoodzFashionMeasurementProfileRoute(),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      imagePath:
                          'assets/image/urban_goodz_features/fashion_fit_photo_guides.jpg',
                      title: 'Photo Guides',
                      subtitle: 'Take or upload photo',
                      onTap: () {
                        Get.toNamed(
                          RouteHelper.getUrbanGoodzFashionPhotoGuideRoute(),
                        );
                      },
                    ),
                    _buildDashboardCard(
                      imagePath:
                          'assets/image/urban_goodz_features/fashion_fit_stylist_requests.jpg',
                      title: 'Stylist Requests',
                      subtitle: 'Custom fit requests',
                      onTap: () async {
                        await Get.toNamed(
                          RouteHelper.getUrbanGoodzFashionTailorRequestRoute(),
                        );
                        _fetchRequests();
                      },
                    ),
                    _buildDashboardCard(
                      imagePath:
                          'assets/image/urban_goodz_features/fashion_fit_bids_estimates.jpg',
                      title: 'Bids & Estimates',
                      subtitle: 'Review incoming quotes',
                      onTap: () {
                        Get.toNamed(
                          RouteHelper.getUrbanGoodzFashionQuoteReviewRoute(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text(
                  'My Fit Requests',
                  style: robotoBold.copyWith(
                    fontSize: 18,
                    color: AppConstants.ugBlack,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.seasoningOrange.withValues(
                        alpha: 0.25,
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(
                              color: AppConstants.seasoningOrange,
                            ),
                          ),
                        )
                      : fitRequests.isEmpty
                      ? Text(
                          'No Stylist Requests submitted yet. Create a measurement profile, take or upload front and side photos, generate an AI-Assisted Tester Estimate, then send a request to a Stylist.',
                          style: robotoRegular.copyWith(
                            fontSize: 13,
                            color: AppConstants.ugBlack.withValues(alpha: 0.75),
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
                                  color: AppConstants.canvas.withValues(
                                    alpha: 0.18,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            request.itemWanted ??
                                                'Stylist Request',
                                            style: robotoBold.copyWith(
                                              fontSize: 14,
                                              color: AppConstants.ugBlack,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          request.status ??
                                              'Pending Stylist Review',
                                          style: robotoBold.copyWith(
                                            fontSize: 12,
                                            color: AppConstants.seasoningOrange,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    if (request.budget != null) ...[
                                      Text(
                                        'Budget: \$${request.budget!.toStringAsFixed(2)}',
                                        style: robotoRegular.copyWith(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                    ],
                                    if (request.stylistNotes != null &&
                                        request.stylistNotes!.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'Stylist Response Note:',
                                        style: robotoBold.copyWith(
                                          fontSize: 11,
                                          color: AppConstants.ugBlack,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        request.stylistNotes!,
                                        style: robotoRegular.copyWith(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                    if (request.quoteAmount != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'Quote Offered: \$${request.quoteAmount!.toStringAsFixed(2)}',
                                        style: robotoBold.copyWith(
                                          fontSize: 12,
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 6),
                                    Text(
                                      backendSynced
                                          ? 'Backend connected: submitted for Stylist Review.'
                                          : 'Request was not accepted by the backend.',
                                      style: robotoRegular.copyWith(
                                        fontSize: 11,
                                        color: AppConstants.ugBlack.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
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
                    color: AppConstants.canvas.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppConstants.seasoningOrange.withValues(
                        alpha: 0.25,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Creator Space Fashion Education',
                        style: robotoBold.copyWith(
                          fontSize: 15,
                          color: AppConstants.ugBlack,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Browse public fashion drops, Stylist showcases, and measurement prep tips. Private customer measurement photos stay out of Creator Space and public feeds.',
                        style: robotoRegular.copyWith(
                          fontSize: 12,
                          color: AppConstants.ugBlack.withValues(alpha: 0.78),
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
                          foregroundColor: AppConstants.ugBlack,
                          side: BorderSide(
                            color: AppConstants.seasoningOrange.withValues(
                              alpha: 0.65,
                            ),
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
                      const Icon(
                        Icons.security,
                        color: AppConstants.seasoningOrange,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Photo-Assisted Disclaimer',
                              style: robotoBold.copyWith(
                                fontSize: 14,
                                color: AppConstants.ugBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'AI measurements are estimates and require your approval. Raw photos remain private unless you separately authorize a selected provider.',
                              style: robotoRegular.copyWith(
                                fontSize: 12,
                                color: AppConstants.ugBlack.withValues(
                                  alpha: 0.8,
                                ),
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
              Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
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
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: robotoBold.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black87,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: robotoRegular.copyWith(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.85),
                        shadows: [
                          const Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black87,
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
}
