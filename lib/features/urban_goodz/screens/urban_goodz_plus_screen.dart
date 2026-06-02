import 'package:flutter/material.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Urban Goodz+')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeDefault,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unlock local perks with Urban Goodz+',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    'Earn rewards, access local deals, and get member benefits across food, retail, rentals, and events.',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      height: 1.6,
                      color: theme.textTheme.bodyLarge!.color,
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
                color: theme.textTheme.bodyLarge!.color,
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
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12), width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.05),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          ),
                          child: Icon(benefit.icon, color: theme.primaryColor, size: 22),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeDefault),
                        Expanded(
                          child: Text(
                            benefit.title,
                            style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: theme.textTheme.bodyLarge!.color,
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
              width: ResponsiveHelper.isDesktop(context) ? 260 : double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                  ),
                ),
                child: Text(
                  'Join waitlist',
                  style: robotoMedium.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeDefault),
                ),
              ),
            ),
          ],
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
