import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart/common/widgets/address_widget.dart';
import 'package:sixam_mart/common/widgets/custom_ink_well.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/address/controllers/address_controller.dart';
import 'package:sixam_mart/features/address/domain/models/address_model.dart';
import 'package:sixam_mart/helper/address_helper.dart';
import 'package:sixam_mart/helper/auth_helper.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/custom_loader.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/popular_store_view.dart';
import 'package:sixam_mart/features/home/widgets/module_preview_panel.dart';

class ModuleView extends StatelessWidget {
  final SplashController splashController;
  const ModuleView({super.key, required this.splashController});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final int moduleColumns = isDesktop
        ? 4
        : (ResponsiveHelper.isTab(context) ? 3 : 2);
    final List<int> visibleModuleIndexes = splashController.moduleList == null
        ? <int>[]
        : visibleUrbanGoodzModuleIndexes(splashController.moduleList!);
    final bool hasLocalArt =
        splashController.moduleList == null
        ? false
        : visibleModuleIndexes.any(
            (moduleIndex) => modulePreviewImage(
              splashController.moduleList![moduleIndex],
            ).contains('urban_goodz_modules/'),
          );

    final double moduleImageBoxSize = isDesktop
        ? (hasLocalArt ? 172 : 132)
        : (ResponsiveHelper.isTab(context)
              ? (hasLocalArt ? 144 : 108)
              : (hasLocalArt ? 116 : 92));

    final double wideImageAreaHeight = isDesktop
        ? 140
        : (ResponsiveHelper.isTab(context) ? 118 : 100);

    final double gridRatio = isDesktop
        ? (hasLocalArt ? 1.02 : 1.25)
        : (ResponsiveHelper.isTab(context)
              ? (hasLocalArt ? 0.95 : 1.2)
              : (hasLocalArt ? 0.82 : 1.05));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        splashController.moduleList != null
            ? visibleModuleIndexes.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: moduleColumns,
                        mainAxisSpacing: Dimensions.paddingSizeSmall,
                        crossAxisSpacing: Dimensions.paddingSizeSmall,
                        childAspectRatio: gridRatio,
                      ),
                      padding: const EdgeInsets.all(
                        Dimensions.paddingSizeSmall,
                      ),
                      itemCount: visibleModuleIndexes.length + 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == visibleModuleIndexes.length) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault,
                              ),
                              color: const Color(0xFFE2D3BF),
                              border: Border.all(
                                color: const Color(0xFFED9914).withValues(alpha: 0.35),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  spreadRadius: 1,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Dimensions.radiusDefault,
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      color: const Color(0xFFE2D3BF),
                                      child: Image.asset(
                                        'assets/image/urban_goodz_features/order_anywhere.png',
                                        fit: BoxFit.contain,
                                        alignment: Alignment.center,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: CustomInkWell(
                                      onTap: () => Get.toNamed(RouteHelper.getOrderAnywhereRequestRoute()),
                                      radius: Dimensions.radiusDefault,
                                      child: const SizedBox(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        final int moduleIndex = visibleModuleIndexes[index];
                        final module = splashController.moduleList![moduleIndex];
                        final String moduleImage = modulePreviewImage(module);
                        final String moduleDescription =
                            modulePreviewDescription(module);
                        final bool isLocalModuleArt = moduleImage.contains(
                          'urban_goodz_modules/',
                        );

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusDefault,
                            ),
                            color: const Color(0xFFE2D3BF), // Urban Goodz Canvas background
                            border: Border.all(
                              color: const Color(0xFFED9914).withValues(alpha: 0.35), // Urban Goodz Orange border
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radiusDefault,
                            ),
                            child: Stack(
                              children: [
                                // Full-card background image (contain for local artwork, cover for network images)
                                Positioned.fill(
                                  child: Container(
                                    color: const Color(0xFFE2D3BF),
                                    child: CustomImage(
                                      image: moduleImage,
                                      fit: isLocalModuleArt ? BoxFit.contain : BoxFit.cover,
                                      placeholder: Images.placeholder,
                                    ),
                                  ),
                                ),

                                // Bottom gradient overlay for text readability
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.25),
                                          Colors.black.withValues(alpha: 0.8),
                                        ],
                                        stops: const [0.4, 0.7, 1.0],
                                      ),
                                    ),
                                  ),
                                ),

                                // Module Details Overlay (Title & Subtitle/Description)
                                Positioned(
                                  left: Dimensions.paddingSizeSmall,
                                  right: Dimensions.paddingSizeSmall,
                                  bottom: Dimensions.paddingSizeSmall,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        module.moduleName ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: robotoBold.copyWith(
                                          fontSize: isDesktop
                                              ? Dimensions.fontSizeDefault
                                              : Dimensions.fontSizeSmall,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        moduleDescription,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: robotoRegular.copyWith(
                                          color: Colors.white.withValues(alpha: 0.85),
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Tappable inkwell covering the entire card
                                Positioned.fill(
                                  child: CustomInkWell(
                                    onTap: () => showModulePreviewPanel(
                                      context,
                                      module: module,
                                      onOpen: () =>
                                          splashController.switchModule(
                                            moduleIndex,
                                            true,
                                          ),
                                    ),
                                    radius: Dimensions.radiusDefault,
                                    child: const SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: Dimensions.paddingSizeSmall,
                        ),
                        child: Text('no_module_found'.tr),
                      ),
                    )
            : ModuleShimmer(isEnabled: splashController.moduleList == null),

        GetBuilder<AddressController>(
          builder: (locationController) {
            List<AddressModel?> addressList = [];
            if (AuthHelper.isLoggedIn() &&
                locationController.addressList != null) {
              addressList = [];
              bool contain = false;
              if (AddressHelper.getUserAddressFromSharedPref()!.id != null) {
                for (
                  int index = 0;
                  index < locationController.addressList!.length;
                  index++
                ) {
                  if (locationController.addressList![index].id ==
                      AddressHelper.getUserAddressFromSharedPref()!.id) {
                    contain = true;
                    break;
                  }
                }
              }
              if (!contain) {
                addressList.add(AddressHelper.getUserAddressFromSharedPref());
              }
              addressList.addAll(locationController.addressList!);
            }
            return (!AuthHelper.isLoggedIn() ||
                    locationController.addressList != null)
                ? addressList.isNotEmpty
                      ? Column(
                          children: [
                            const SizedBox(height: Dimensions.paddingSizeLarge),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                              ),
                              child: TitleWidget(title: 'deliver_to'.tr),
                            ),
                            const SizedBox(
                              height: Dimensions.paddingSizeExtraSmall,
                            ),

                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: addressList.length,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(
                                  left: Dimensions.paddingSizeSmall,
                                  right: Dimensions.paddingSizeSmall,
                                  top: Dimensions.paddingSizeExtraSmall,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 300,
                                    padding: const EdgeInsets.only(
                                      right: Dimensions.paddingSizeSmall,
                                    ),
                                    child: AddressWidget(
                                      address: addressList[index],
                                      fromAddress: false,
                                      onTap: () {
                                        if (AddressHelper.getUserAddressFromSharedPref()!
                                                .id !=
                                            addressList[index]!.id) {
                                          Get.dialog(
                                            const CustomLoaderWidget(),
                                            barrierDismissible: false,
                                          );
                                          Get.find<LocationController>()
                                              .saveAddressAndNavigate(
                                                addressList[index],
                                                false,
                                                null,
                                                false,
                                                ResponsiveHelper.isDesktop(
                                                  context,
                                                ),
                                              );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : const SizedBox()
                : AddressShimmer(
                    isEnabled:
                        AuthHelper.isLoggedIn() &&
                        locationController.addressList == null,
                  );
          },
        ),

        const PopularStoreView(isPopular: false, isFeatured: true),

        const SizedBox(height: 120),
      ],
    );
  }
}

class ModuleShimmer extends StatelessWidget {
  final bool isEnabled;
  const ModuleShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : 2,
        mainAxisSpacing: Dimensions.paddingSizeSmall,
        crossAxisSpacing: Dimensions.paddingSizeSmall,
        childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1.18 : 0.98,
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
            ],
          ),
          child: Shimmer(
            duration: const Duration(seconds: 2),
            enabled: isEnabled,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: ResponsiveHelper.isDesktop(context) ? 122 : 96,
                  width: ResponsiveHelper.isDesktop(context) ? 122 : 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeExtraSmall,
                  ),
                  child: Container(
                    height: 15,
                    width: 80,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddressShimmer extends StatelessWidget {
  final bool isEnabled;
  const AddressShimmer({super.key, required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
          ),
          child: TitleWidget(title: 'deliver_to'.tr),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        SizedBox(
          height: 70,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeSmall,
            ),
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                padding: const EdgeInsets.only(
                  right: Dimensions.paddingSizeSmall,
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.isDesktop(context)
                        ? Dimensions.paddingSizeDefault
                        : Dimensions.paddingSizeSmall,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: ResponsiveHelper.isDesktop(context) ? 50 : 40,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Shimmer(
                          duration: const Duration(seconds: 2),
                          enabled: isEnabled,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 15,
                                width: 100,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeExtraSmall,
                              ),
                              Container(
                                height: 10,
                                width: 150,
                                color: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
