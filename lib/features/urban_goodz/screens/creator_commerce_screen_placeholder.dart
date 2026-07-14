import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/features/urban_goodz/domain/services/creator_commerce_api_service.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_status_badge.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';

class CreatorCommerceScreen extends StatefulWidget {
  const CreatorCommerceScreen({super.key});

  @override
  State<CreatorCommerceScreen> createState() => _CreatorCommerceScreenState();
}

class _CreatorCommerceScreenState extends State<CreatorCommerceScreen> {
  final CreatorCommerceApiService _creatorService = CreatorCommerceApiService();
  List<Map<String, dynamic>> _creatorSubmissions = [];
  bool _isLoadingSubmissions = true;

  static const List<Map<String, String>> _features = [];

  @override
  void initState() {
    super.initState();
    _loadCreatorSubmissions();
  }

  Future<void> _loadCreatorSubmissions() async {
    final submissions = await _creatorService.getMyCreatorApplications();
    if (!mounted) return;
    setState(() {
      _creatorSubmissions = submissions;
      _isLoadingSubmissions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: const Text(
          'Creator Commerce',
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
                message:
                'Creator commerce features are not yet available. Shop tag integrations and local influencer networks are under development.',
            icon: Icons.storefront_outlined,
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: AppConstants.ugWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppConstants.seasoningOrange.withValues(alpha: 0.25),
                ),
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
                    'Local Influencer Storefronts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppConstants.ugBlack,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Explore shoppable video feeds and campaigns. Creators can tag products from local restaurants, boutiques, and rental services.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.ugBlack.withValues(alpha: 0.7),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppConstants.canvas.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppConstants.seasoningOrange.withValues(
                          alpha: 0.2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fashion + Measurement Privacy Boundary',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppConstants.ugBlack,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Creator Space can show fashion drops, Stylist showcases, before/after examples with approval, and measurement education. Private customer measurement photos are never posted to public feeds.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppConstants.ugBlack.withValues(alpha: 0.72),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Get.toNamed(
                        RouteHelper.getUrbanGoodzFashionMeasurementsRoute(),
                      ),
                      icon: const Icon(Icons.checkroom_outlined),
                      label: const Text('Open Fashion Measurement Preview'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.ugBlack,
                        side: BorderSide(
                          color: AppConstants.seasoningOrange.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: UrbanGoodzActionButton(
                      label: 'Apply as Urban Goodz Creator',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final nameController = TextEditingController();
                            final nicheController = TextEditingController();
                            final socialController = TextEditingController();
                            final cityController = TextEditingController();
                            final bioController = TextEditingController();
                            final pitchController = TextEditingController();
                            final formKey = GlobalKey<FormState>();

                            return AlertDialog(
                              title: const Text('Creator Interest Form', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              content: SingleChildScrollView(
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Register your interest to sell or promote products in your area.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: nameController,
                                        decoration: const InputDecoration(labelText: 'Creator Name *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: nicheController,
                                        decoration: const InputDecoration(labelText: 'Category / Niche (e.g. Fashion, Food) *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: socialController,
                                        decoration: const InputDecoration(labelText: 'Social Media Link / Handle *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: cityController,
                                        decoration: const InputDecoration(labelText: 'City *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: bioController,
                                        maxLines: 2,
                                        decoration: const InputDecoration(labelText: 'Bio / Pitch *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: pitchController,
                                        maxLines: 2,
                                        decoration: const InputDecoration(labelText: 'What do you want to sell/promote? *', border: OutlineInputBorder()),
                                        validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppConstants.seasoningOrange, foregroundColor: AppConstants.ugBlack),
                                  onPressed: () async {
                                    if (formKey.currentState?.validate() ?? false) {
                                      final result = await _creatorService.submitCreatorApplication({
                                        'creator_name': nameController.text.trim(),
                                        'niche_category': nicheController.text.trim(),
                                        'city': cityController.text.trim(),
                                        'social_link': socialController.text.trim(),
                                        'bio_pitch': bioController.text.trim(),
                                        'sell_promote': pitchController.text.trim(),
                                      });
                                      if (context.mounted) {
                                        setState(() {
                                          _creatorSubmissions = [result, ..._creatorSubmissions];
                                        });
                                      }
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Application Submitted'),
                                          content: Text(
                                            result['backend_limited'] == true
                                                ? 'Creator application saved. ${_creatorService.lastBackendMessage ?? ''}'
                                                : 'Creator application submitted to backend for admin review.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Submit Application'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showPromotionDialog,
                      icon: const Icon(Icons.campaign_outlined),
                      label: const Text('Submit Creator Promotion Idea'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.ugBlack,
                        side: const BorderSide(color: AppConstants.seasoningOrange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCreatorStatusLoop(),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
                bottom:
                    Dimensions.paddingSizeDefault + 80, // Safe bottom spacing
              ),
              itemCount: _features.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: Dimensions.paddingSizeSmall),
              itemBuilder: (context, index) {
                final feat = _features[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.ugWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppConstants.ugBlack.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppConstants.seasoningOrange.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppConstants.seasoningOrange.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: const Icon(
                          Icons.video_library_outlined,
                          color: AppConstants.seasoningOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feat['title'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: AppConstants.ugBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              feat['desc'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppConstants.ugBlack.withValues(
                                  alpha: 0.6,
                                ),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              feat['metric'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                color: AppConstants.seasoningOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const UrbanGoodzStatusBadge(
                        status: 'Preview',
                        isCompact: true,
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

  void _showPromotionDialog() {
    final titleController = TextEditingController();
    final typeController = TextEditingController();
    final detailsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Creator Promotion'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Profile / reel idea title *', border: OutlineInputBorder()),
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Promotion type *', hintText: 'Product, service, event, community, opportunity', border: OutlineInputBorder()),
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: detailsController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Promotion details *', border: OutlineInputBorder()),
                  validator: (v) => v?.trim().isEmpty ?? true ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppConstants.seasoningOrange, foregroundColor: AppConstants.ugBlack),
            onPressed: () async {
              if (!(formKey.currentState?.validate() ?? false)) return;
              final result = await _creatorService.submitCreatorPromotion({
                'title': titleController.text.trim(),
                'promotion_type': typeController.text.trim(),
                'details': detailsController.text.trim(),
              });
              if (!mounted) return;
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result['backend_limited'] == true
                      ? 'Promotion saved locally; backend unavailable.'
                      : 'Promotion submitted to backend for admin review.'),
                  backgroundColor: AppConstants.seasoningOrange,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatorStatusLoop() {
    if (_isLoadingSubmissions) {
      return const LinearProgressIndicator(color: AppConstants.seasoningOrange);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppConstants.canvas.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.seasoningOrange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Creator Submissions',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppConstants.ugBlack),
          ),
          const SizedBox(height: 8),
          if (_creatorSubmissions.isEmpty)
            const Text(
              'No creator applications submitted yet. Applications and promotion ideas will show status here after submit.',
              style: TextStyle(fontSize: 12, color: AppConstants.ugBlack),
            )
          else
            ..._creatorSubmissions.take(3).map((submission) {
              final status = (submission['status'] ?? 'submitted').toString().replaceAll('_', ' ');
              final backendLimited = submission['backend_limited'] == true;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      backendLimited ? Icons.warning_amber_outlined : Icons.check_circle_outline,
                      size: 18,
                      color: backendLimited ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${submission['creator_name'] ?? submission['title'] ?? 'Creator submission'} - ${status.toUpperCase()}${backendLimited ? ' (backend-limited)' : ''}\n${submission['admin_notes'] ?? 'Admin notes will appear here when available.'}',
                        style: const TextStyle(fontSize: 12, color: AppConstants.ugBlack, height: 1.35),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
