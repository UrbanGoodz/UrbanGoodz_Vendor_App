import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/store/controllers/store_controller.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class CarRentalPreviewWidget extends StatelessWidget {
  final String title;
  const CarRentalPreviewWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 550, maxHeight: 420),
        margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          border: Border.all(color: const Color(0xFFED9914).withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_rounded,
              size: 72,
              color: Color(0xFFED9914), // UG Orange
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Text(
              title,
              textAlign: TextAlign.center,
              style: robotoBold.copyWith(
                fontSize: 22,
                color: const Color(0xFF161616),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Text(
              'Car Rental add-on is installed separately and requires module wiring/backend validation.',
              textAlign: TextAlign.center,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: const Color(0xFF161616).withValues(alpha: 0.74),
                height: 1.45,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED9914),
                foregroundColor: const Color(0xFF161616),
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeExtraLarge,
                  vertical: Dimensions.paddingSizeDefault,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
              ),
              onPressed: () {
                final splashController = Get.find<SplashController>();
                if (splashController.module != null &&
                    splashController.configModel!.module == null &&
                    splashController.moduleList != null &&
                    splashController.moduleList!.length != 1) {
                  splashController.removeModule();
                  Get.find<StoreController>().resetStoreData();
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, size: 18),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text(
                    'Return to Home',
                    style: robotoBold.copyWith(color: const Color(0xFF161616)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
