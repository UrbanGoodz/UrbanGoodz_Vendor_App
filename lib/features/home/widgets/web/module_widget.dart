import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/home/widgets/module_preview_panel.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (splashController) {
        final List<int> visibleModuleIndexes =
            splashController.moduleList == null
            ? <int>[]
            : visibleUrbanGoodzModuleIndexes(splashController.moduleList!);

        return (ResponsiveHelper.isDesktop(context) &&
                splashController.configModel!.module == null &&
                splashController.moduleList != null &&
                visibleModuleIndexes.length > 1)
            ? Container(
                width: 88,
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeExtraSmall,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(Dimensions.radiusExtraLarge),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: visibleModuleIndexes.length + 1,
                    padding: const EdgeInsets.only(
                      top: Dimensions.paddingSizeSmall,
                    ),
                    itemBuilder: (context, index) {
                      if (index == visibleModuleIndexes.length) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: Dimensions.paddingSizeSmall,
                          ),
                          child: Tooltip(
                            message: 'Order Anywhere',
                            padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(Dimensions.radiusSmall),
                              ),
                            ),
                            textStyle: robotoRegular.copyWith(
                              color: Colors.white,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                            preferBelow: false,
                            verticalOffset: 20,
                            child: InkWell(
                              onTap: () => Get.toNamed(RouteHelper.getOrderAnywhereRequestRoute()),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radiusLarge,
                                  ),
                                  color: Theme.of(
                                    context,
                                  ).disabledColor.withValues(alpha: 0.2),
                                ),
                                padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall,
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall,
                                    ),
                                    child: SizedBox.square(
                                      dimension: 58,
                                      child: Image.asset(
                                        'assets/image/urban_goodz_features/order_anywhere.png',
                                        height: 58,
                                        width: 58,
                                        fit: BoxFit.contain,
                                        filterQuality: FilterQuality.high,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final int moduleIndex = visibleModuleIndexes[index];
                      final module = splashController.moduleList![moduleIndex];

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeSmall,
                        ),
                        child: Tooltip(
                          message: module.moduleName,
                          padding: const EdgeInsets.all(
                            Dimensions.paddingSizeExtraSmall,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(Dimensions.radiusSmall),
                            ),
                          ),
                          textStyle: robotoRegular.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                          preferBelow: false,
                          verticalOffset: 20,
                          child: InkWell(
                            onTap: () => showModulePreviewPanel(
                              context,
                              module: module,
                              onOpen: () =>
                                  splashController.switchModule(
                                    moduleIndex,
                                    false,
                                  ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radiusLarge,
                                ),
                                color:
                                    (splashController.module != null &&
                                        splashController
                                                .moduleList![moduleIndex]
                                                .id ==
                                            splashController.module!.id)
                                    ? Theme.of(
                                        context,
                                      ).primaryColor.withValues(alpha: 0.2)
                                    : Theme.of(
                                        context,
                                      ).disabledColor.withValues(alpha: 0.2),
                                border:
                                    (splashController.module != null &&
                                        splashController
                                                .moduleList![moduleIndex]
                                                .id ==
                                            splashController.module!.id)
                                    ? Border.all(
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : null,
                              ),
                              padding: const EdgeInsets.all(
                                Dimensions.paddingSizeSmall,
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall,
                                  ),
                                  child: SizedBox.square(
                                    dimension: 58,
                                    child: CustomImage(
                                      image: modulePreviewImage(module),
                                      height: 58,
                                      width: 58,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
