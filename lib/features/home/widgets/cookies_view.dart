import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class CookiesView extends StatelessWidget {
  const CookiesView({super.key});

  @override
  Widget build(BuildContext context) {
    double padding = (MediaQuery.of(context).size.width - Dimensions.webMaxWidth) / 2;
    return Container(
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: Get.isDarkMode ? 1 : 0.8)),
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: ResponsiveHelper.isDesktop(context) ? padding : Dimensions.paddingSizeDefault,
      ),
      child: Padding(padding:  EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeDefault),
        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
            child: Text(
              Get.find<SplashController>().configModel!.cookiesText ?? 'This is dummy cookies text',
              style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.white70),
              maxLines: 3, textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis,
            ),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.end, children: [

            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40,24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: (){
                Get.find<SplashController>().saveCookiesData(false);
              }, child:  Text(
              'no_thanks'.tr,
              style: robotoRegular.copyWith(color: Colors.white70,fontSize: Dimensions.fontSizeExtraSmall),
            )),
            SizedBox(width: ResponsiveHelper.isDesktop(context)?Dimensions.paddingSizeLarge:Dimensions.paddingSizeDefault,),

            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.zero,
                minimumSize: const Size(60,28),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: (){
                Get.find<SplashController>().saveCookiesData(true);
                Get.find<SplashController>().cookiesStatusChange(Get.find<SplashController>().configModel!.cookiesText ?? "This is dummy cookies text");
              },
              child:  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: 3),
                child: Center(
                  child: Text(
                  'yes_accept'.tr, style: robotoRegular.copyWith(color: Colors.white70,fontSize: Dimensions.fontSizeExtraSmall),
                  ),
                ),
              )),

          ])

        ]),
      ),
    );
  }
}
