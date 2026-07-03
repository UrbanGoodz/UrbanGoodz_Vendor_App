import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class FashionFitHomeScreen extends StatelessWidget {
  const FashionFitHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fashion Fit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get custom styling & alterations',
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text(
                    '[TESTER PREVIEW] Measure yourself, connect with local Stylists, and track your projects.',
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      height: 1.6,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              'Quick actions',
              style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeLarge,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            InkWell(
              onTap: () => Get.toNamed(RouteHelper.getFashionMeasurementProfileRoute()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), width: 0.5),
                  boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
                      child: Icon(Icons.straighten, color: Theme.of(context).primaryColor, size: 22),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create measurement profile', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text('Add your measurements or take photos', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            InkWell(
              onTap: () => Get.toNamed(RouteHelper.getFashionMeasurementIntakeRoute()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                  border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), width: 0.5),
                  boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
                      child: Icon(Icons.photo_camera, color: Theme.of(context).primaryColor, size: 22),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Photo-assisted measurements', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyLarge!.color)),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text('[Tester Preview] Take or upload photos for helper', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About this preview', style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Text('This is a tester preview of Fashion Fit. Measurement profiles are stored locally. Photo-assisted measurements use manual entry fallback. Face blur and AI accuracy are not available in preview.', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, height: 1.5, color: Theme.of(context).disabledColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
