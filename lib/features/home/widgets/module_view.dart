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
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
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
                      itemCount: visibleModuleIndexes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
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
                            color: Theme.of(context).cardColor,
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.18),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).disabledColor.withValues(alpha: 0.16),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
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
                            child: Padding(
                              padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.radiusSmall,
                                      ),
                                      child: Container(
                                        height: isLocalModuleArt
                                            ? moduleImageBoxSize
                                            : wideImageAreaHeight,
                                        width: isLocalModuleArt
                                            ? moduleImageBoxSize
                                            : double.infinity,
                                        alignment: Alignment.center,
                                        color: const Color(
                                          0xFFE2D3BF,
                                        ).withValues(alpha: 0.25),
                                        padding: EdgeInsets.all(
                                          isLocalModuleArt ? 4 : 8,
                                        ),
                                        child: CustomImage(
                                          image: moduleImage,
                                          height: isLocalModuleArt
                                              ? moduleImageBoxSize - 8
                                              : wideImageAreaHeight - 16,
                                          width: isLocalModuleArt
                                              ? moduleImageBoxSize - 8
                                              : double.infinity,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.paddingSizeExtraSmall,
                                    ),
                                    child: Text(
                                      module.moduleName ?? '',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: robotoBold.copyWith(
                                        fontSize: isDesktop
                                            ? Dimensions.fontSizeDefault
                                            : Dimensions.fontSizeSmall,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: Dimensions.paddingSizeExtraSmall,
                                  ),

                                  Text(
                                    moduleDescription,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: robotoRegular.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withValues(alpha: 0.74),
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
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
