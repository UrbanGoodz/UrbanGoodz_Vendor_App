import 'package:carousel_slider/carousel_slider.dart';
import 'package:sixam_mart/common/widgets/hover/text_hover.dart';
import 'package:sixam_mart/features/banner/controllers/banner_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/basic_campaign_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/store/screens/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebNewBannerViewWidget extends StatelessWidget {
  final bool isFeatured;
  final double bannerHeight;
  const WebNewBannerViewWidget({
    super.key,
    required this.isFeatured,
    this.bannerHeight = 350,
  });

  static const List<String> _testerBannerMessages = [
    'Your Connection To Local Everything',
    'Everything Local. One App.',
    'Shop. Book. Rent. Discover. Earn.',
    'Find It. Book It. Rent It. Get It.',
    'Houston Starts It. Built For Everywhere.',
  ];

  bool get _isTesterWeb => Uri.base.host == 'test.urbangoodzdelivery.com';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(
      builder: (bannerController) {
        List<String?>? bannerList = isFeatured
            ? bannerController.featuredBannerList
            : bannerController.bannerImageList;
        List<dynamic>? bannerDataList = isFeatured
            ? bannerController.featuredBannerDataList
            : bannerController.bannerDataList;

        return (_isTesterWeb || (bannerList != null && bannerList.isEmpty))
            ? _buildFallbackBanner(context)
            : Container(
                width: MediaQuery.of(context).size.width,
                height: GetPlatform.isDesktop
                    ? bannerHeight
                    : MediaQuery.of(context).size.width * 0.45,
                padding: const EdgeInsets.only(
                  top: Dimensions.paddingSizeDefault,
                  bottom: Dimensions.paddingSizeSmall,
                ),
                child: bannerList != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: CarouselSlider.builder(
                              options: CarouselOptions(
                                autoPlay: true,
                                enlargeCenterPage: true,
                                disableCenter: true,
                                viewportFraction: 1,
                                autoPlayInterval: const Duration(seconds: 7),
                                onPageChanged: (index, reason) {
                                  bannerController.setCurrentIndex(index, true);
                                },
                              ),
                              itemCount: bannerList.isEmpty
                                  ? 1
                                  : bannerList.length,
                              itemBuilder: (context, index, _) {
                                return InkWell(
                                  onTap: () async {
                                    if (bannerDataList![index] is Item) {
                                      Item? item = bannerDataList[index];
                                      Get.find<ItemController>()
                                          .navigateToItemPage(item, context);
                                    } else if (bannerDataList[index] is Store) {
                                      Store? store = bannerDataList[index];
                                      if (isFeatured &&
                                          Get.find<SplashController>()
                                                  .moduleList !=
                                              null) {
                                        for (ModuleModel module
                                            in Get.find<SplashController>()
                                                .moduleList!) {
                                          if (module.id == store!.moduleId) {
                                            Get.find<SplashController>()
                                                .setModule(module);
                                            break;
                                          }
                                        }
                                      }
                                      Get.toNamed(
                                        RouteHelper.getStoreRoute(
                                          id: store!.id,
                                          page: isFeatured
                                              ? 'module'
                                              : 'banner',
                                          slug: store.slug ?? '',
                                        ),
                                        arguments: StoreScreen(
                                          store: store,
                                          fromModule: isFeatured,
                                        ),
                                      );
                                    } else if (bannerDataList[index]
                                        is BasicCampaignModel) {
                                      BasicCampaignModel campaign =
                                          bannerDataList[index];
                                      Get.toNamed(
                                        RouteHelper.getBasicCampaignRoute(
                                          campaign,
                                        ),
                                      );
                                    } else {
                                      String url = bannerDataList[index];
                                      if (await canLaunchUrlString(url)) {
                                        await launchUrlString(
                                          url,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      } else {
                                        showCustomSnackBar(
                                          'unable_to_found_url'.tr,
                                        );
                                      }
                                    }
                                  },
                                  child: TextHover(
                                    builder: (hovered) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault,
                                          ),
                                          child: GetBuilder<SplashController>(
                                            builder: (splashController) {
                                              return CustomImage(
                                                isHovered: hovered,
                                                image: '${bannerList[index]}',
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: bannerController.bannerImageList!.map((
                              bnr,
                            ) {
                              int index = bannerController.bannerImageList!
                                  .indexOf(bnr);
                              int totalBanner =
                                  bannerController.bannerImageList!.length;
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: index == bannerController.currentIndex
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 1,
                                        ),
                                        child: Text(
                                          '${(index) + 1}/$totalBanner',
                                          style: robotoRegular.copyWith(
                                            color: Theme.of(context).cardColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 5,
                                        width: 6,
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).primaryColor.withValues(alpha: 0.5),
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radiusDefault,
                                          ),
                                        ),
                                      ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                    : Shimmer(
                        duration: const Duration(seconds: 2),
                        enabled: bannerList == null,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusDefault,
                            ),
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                      ),
              );
      },
    );
  }

  Widget _buildCollage(BuildContext context, bool isSmall) {
    final double cardSize = isSmall ? 70 : 145;
    return SizedBox(
      width: isSmall ? 180 : 380,
      height: isSmall ? 120 : 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 10,
            top: 10,
            child: Transform.rotate(
              angle: -0.1,
              child: _buildCollageItem('assets/image/urban_goodz_modules/food_trucks.png', cardSize),
            ),
          ),
          Positioned(
            left: isSmall ? 25 : 55,
            bottom: isSmall ? 0 : 10,
            child: Transform.rotate(
              angle: 0.05,
              child: _buildCollageItem('assets/image/urban_goodz_modules/home_based_businesses.png', cardSize),
            ),
          ),
          Positioned(
            left: isSmall ? 55 : 110,
            top: isSmall ? 10 : 40,
            child: Transform.rotate(
              angle: 0.15,
              child: _buildCollageItem('assets/image/urban_goodz_modules/thc_cbd.png', cardSize),
            ),
          ),
          Positioned(
            right: 10,
            bottom: isSmall ? 10 : 20,
            child: Transform.rotate(
              angle: -0.05,
              child: _buildCollageItem('assets/image/urban_goodz_modules/pharmacy_health.png', cardSize),
            ),
          ),
          Positioned(
            right: isSmall ? 25 : 55,
            top: isSmall ? 0 : 10,
            child: Transform.rotate(
              angle: -0.15,
              child: _buildCollageItem('assets/image/urban_goodz_modules/courier_parcel.png', cardSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollageItem(String assetPath, double size) {
    return Container(
      width: size,
      height: size * 0.72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 6, spreadRadius: 1, offset: Offset(0, 3)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFallbackBanner(BuildContext context) {
    final bool isSmall = MediaQuery.of(context).size.width < 750;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: GetPlatform.isDesktop
          ? (bannerHeight < 420 ? 420 : bannerHeight)
          : MediaQuery.of(context).size.width * 0.45,
      padding: const EdgeInsets.only(
        top: Dimensions.paddingSizeDefault,
        bottom: Dimensions.paddingSizeSmall,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE2D3BF),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          border: Border.all(color: const Color(0xFFED9914), width: 1.2),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: isSmall
            ? Stack(
                children: [
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Opacity(
                      opacity: 0.28,
                      child: _buildCollage(context, true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _testerBannerMessages.first,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF161616),
                            fontSize: isSmall ? 18 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                          _testerBannerMessages[1],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF161616).withValues(alpha: 0.76),
                            fontSize: isSmall ? 13 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: Dimensions.paddingSizeExtraSmall,
                          runSpacing: Dimensions.paddingSizeExtraSmall,
                          children: _testerBannerMessages.skip(2).map((message) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeExtraSmall,
                              ),
                              decoration: BoxDecoration(
                                color: message.startsWith('Houston')
                                    ? const Color(0xFFE5E276)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: const Color(0xFFED9914).withValues(alpha: 0.35),
                                ),
                              ),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: const Color(0xFF161616),
                                  fontSize: isSmall ? 10 : 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _testerBannerMessages.first,
                            style: const TextStyle(
                              color: Color(0xFF161616),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                            _testerBannerMessages[1],
                            style: TextStyle(
                              color: const Color(0xFF161616).withValues(alpha: 0.76),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Wrap(
                            spacing: Dimensions.paddingSizeExtraSmall,
                            runSpacing: Dimensions.paddingSizeExtraSmall,
                            children: _testerBannerMessages.skip(2).map((message) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeExtraSmall,
                                ),
                                decoration: BoxDecoration(
                                  color: message.startsWith('Houston')
                                      ? const Color(0xFFE5E276)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: const Color(0xFFED9914).withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  message,
                                  style: const TextStyle(
                                    color: Color(0xFF161616),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                      child: Center(
                        child: _buildCollage(context, false),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
