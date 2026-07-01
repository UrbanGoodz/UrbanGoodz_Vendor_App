import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_preview_banner.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_action_button.dart';
import 'package:sixam_mart/features/urban_goodz/widgets/urban_goodz_feature_asset_image.dart';

class UrbanGoodzPlusScreen extends StatelessWidget {
  const UrbanGoodzPlusScreen({super.key});

  static const List<_MembershipBenefit> _benefits = [
    _MembershipBenefit(Icons.stars_outlined, 'Rewards points on every order'),
    _MembershipBenefit(Icons.local_offer_outlined, 'Member-only local deals'),
    _MembershipBenefit(Icons.key_outlined, 'Priority rental access'),
    _MembershipBenefit(Icons.delivery_dining_outlined, 'Free or discounted delivery offers'),
    _MembershipBenefit(Icons.storefront_outlined, 'Spotlight perks from local businesses'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.canvas,
      appBar: AppBar(
        title: Text(
          'Urban Goodz Plus',
          style: robotoBold.copyWith(
            color: AppConstants.ugBlack,
            fontSize: Dimensions.fontSizeOverLarge,
          ),
        ),
        backgroundColor: AppConstants.canvas,
        foregroundColor: AppConstants.ugBlack,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
          right: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
          top: Dimensions.paddingSizeDefault,
          bottom: Dimensions.paddingSizeDefault + 80, // Safe bottom spacing
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UrbanGoodzPreviewBanner(
                  message: 'Urban Goodz Plus is an exclusive membership club. Waitlist members get early access to beta zones and local premium perks.',
                  icon: Icons.workspace_premium_outlined,
                ),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                UrbanGoodzFeatureAssetImage(
                  assetPath: 'assets/image/urban_goodz_features/urban_goodz_plus.png',
                  maxHeight: ResponsiveHelper.isDesktop(context) ? 320 : 220,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.transparent,
                  hasBorder: false,
                  padding: EdgeInsets.zero,
                  hasShadow: true,
                ),
 
                const SizedBox(height: Dimensions.paddingSizeLarge),
 
                // Premium Dijon Accent Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFAF9EE), Color(0xFFEFECC9)], // Custom light premium cream-dijon blend
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5E276).withValues(alpha: 0.8), // Dijon border accent
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.ugBlack.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E276), // Dijon
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'PREMIUM PERKS',
                              style: TextStyle(
                                color: AppConstants.ugBlack,
                                fontWeight: FontWeight.w900,
                                fontSize: 9,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Unlock local perks with Urban Goodz+',
                            style: TextStyle(
                              color: AppConstants.ugBlack,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),
                      Text(
                        'Unlock unlimited possibilities. Earn rewards, access local deals, and get member benefits across food, retail, rentals, and events.',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          height: 1.5,
                          color: AppConstants.ugBlack.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: Dimensions.paddingSizeLarge),
                
                Text(
                  'Membership benefits',
                  style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge,
                    color: AppConstants.ugBlack,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                
                Column(
                  children: _benefits.map((benefit) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(
                          color: AppConstants.ugWhite,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppConstants.ugBlack.withValues(alpha: 0.08), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.ugBlack.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: AppConstants.seasoningOrange.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                              ),
                              child: Icon(benefit.icon, color: AppConstants.seasoningOrange, size: 20),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeDefault),
                            Expanded(
                              child: Text(
                                benefit.title,
                                style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: AppConstants.ugBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: Dimensions.paddingSizeLarge),
                
                SizedBox(
                  width: double.infinity,
                  child: UrbanGoodzActionButton(
                    label: 'Join Membership Waitlist',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MembershipBenefit {
  final IconData icon;
  final String title;

  const _MembershipBenefit(this.icon, this.title);
}
