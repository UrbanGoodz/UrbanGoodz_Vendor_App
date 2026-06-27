import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/util/dimensions.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  final bool isHovered;
  final Color? color;

  // New optional parameters for fallback mapping
  final bool isCategory;
  final String? categoryName;
  final bool isStoreLogo;
  final bool isStoreCover;
  final String? storeName;
  final int? storeModuleId;

  const CustomImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isNotification = false,
    this.placeholder = '',
    this.isHovered = false,
    this.color,
    this.isCategory = false,
    this.categoryName,
    this.isStoreLogo = false,
    this.isStoreCover = false,
    this.storeName,
    this.storeModuleId,
  });

  String _resolvedImageUrl(String pathValue) {
    final String value = pathValue.trim();
    final String normalized = value.toLowerCase();

    if (value.isEmpty ||
        normalized == 'null' ||
        normalized == 'undefined' ||
        normalized == '[]') {
      return '';
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    if (value.startsWith('//')) {
      return 'https:$value';
    }

    if (value.startsWith('assets/') || value.startsWith('asset/') || value.startsWith('packages/')) {
      return value;
    }

    final String baseUrl = AppConstants.baseUrl.endsWith('/')
        ? AppConstants.baseUrl.substring(0, AppConstants.baseUrl.length - 1)
        : AppConstants.baseUrl;
    final String path = value.startsWith('/') ? value : '/$value';

    return '$baseUrl$path';
  }

  bool _isLocalAsset(String pathValue) {
    final String value = pathValue.trim().toLowerCase();
    return value.startsWith('assets/') ||
        value.startsWith('asset/') ||
        value.startsWith('packages/');
  }

  static bool _isImageMissing(String? imagePath) {
    if (imagePath == null) return true;
    final String trimmed = imagePath.trim();
    final String normalized = trimmed.toLowerCase();
    final bool hasExtension = normalized.contains('.png') ||
        normalized.contains('.jpg') ||
        normalized.contains('.jpeg') ||
        normalized.contains('.gif') ||
        normalized.contains('.webp') ||
        normalized.contains('.svg') ||
        normalized.startsWith('assets/') ||
        normalized.startsWith('asset/');
    return trimmed.isEmpty ||
        normalized == 'null' ||
        normalized == 'undefined' ||
        normalized == '[]' ||
        !hasExtension ||
        normalized.contains('/store.png') ||
        normalized.contains('/store.svg') ||
        normalized.contains('store.png') ||
        normalized.contains('store.svg') ||
        normalized.contains('placeholder') ||
        normalized.contains('default') ||
        normalized.contains('no_image') ||
        normalized.contains('no-image') ||
        normalized.contains('assets/admin/img') ||
        normalized.contains('/img1.jpg') ||
        normalized.contains('/img2.jpg') ||
        normalized.contains('/img3.jpg') ||
        normalized.contains('/img1.png') ||
        normalized.contains('/img2.png') ||
        normalized.contains('/img3.png');
  }

  static bool _containsAny(String value, List<String> needles) {
    return needles.any(value.contains);
  }

  static String? _getValidBackendModuleArt(dynamic module) {
    if (module == null) return null;
    final String? cover = module.coverImageFullUrl;
    if (cover != null && cover.isNotEmpty && !_isImageMissing(cover)) {
      return cover;
    }
    final String? img = module.imageFullUrl;
    if (img != null && img.isNotEmpty && !_isImageMissing(img)) {
      return img;
    }
    return null;
  }

  static String? getModuleFallbackArtwork({
    String? moduleName,
    String? moduleType,
    int? moduleId,
    String? categoryName,
    String? moduleSlug,
  }) {
    // 1. Try to find the module's real backend cover/banner artwork first
    final SplashController splashController = Get.find<SplashController>();
    if (moduleId != null && splashController.moduleList != null) {
      for (var m in splashController.moduleList!) {
        if (m.id == moduleId) {
          final String? realArt = _getValidBackendModuleArt(m);
          if (realArt != null) return realArt;
          break;
        }
      }
    }
    final activeModule = splashController.module;
    if (activeModule != null) {
      final String? realArt = _getValidBackendModuleArt(activeModule);
      if (realArt != null) return realArt;
    }

    // 2. Map context keywords to local assets
    final List<String?> parts = [
      moduleName,
      moduleType,
      moduleId?.toString(),
      categoryName,
      moduleSlug,
    ];
    if (moduleName == null && moduleType == null && moduleId == null && moduleSlug == null && activeModule != null) {
      parts.add(activeModule.moduleName);
      parts.add(activeModule.moduleType);
      parts.add(activeModule.id?.toString());
      parts.add(activeModule.slug);
    }
    final String key = parts.whereType<String>().join(' ').toLowerCase();

    if (_containsAny(key, const ['food truck', 'foodtruck', 'truckz'])) {
      return 'assets/image/urban_goodz_modules/food_trucks.png';
    }
    if (_containsAny(key, const ['pharmacy', 'health', 'wellness', 'medical', 'baby care', 'vitamins', 'personal care'])) {
      return 'assets/image/urban_goodz_modules/pharmacy_health.png';
    }
    if (_containsAny(key, const ['thc', 'cbd', 'smoke', 'pre-roll', 'grinder', 'glassware', 'rolling papers', 'batteries', 'storage containers', 'accessories', 'cannabis', 'hemp'])) {
      return 'assets/image/urban_goodz_modules/thc_cbd.png';
    }
    if (_containsAny(key, const ['home-based', 'home based', 'homebased', 'local business', 'independent seller'])) {
      return 'assets/image/urban_goodz_modules/home_based_businesses.png';
    }
    if (_containsAny(key, const ['liquor', 'beverage', 'drink', 'alcohol'])) {
      return 'assets/image/urban_goodz_modules/liquor_beverages.png';
    }
    if (_containsAny(key, const ['courier', 'parcel', 'package', 'delivery'])) {
      return 'assets/image/urban_goodz_modules/courier_parcel.png';
    }
    if (_containsAny(key, const ['event', 'creator', 'pop-up', 'pop up'])) {
      return 'assets/image/urban_goodz_modules/local_events_creators.png';
    }
    if (_containsAny(key, const ['rental', 'car rental', 'vehicle'])) {
      return 'assets/image/urban_goodz_modules/car_rental.png';
    }

    return null;
  }

  String? _getCategoryFallbackImage(String? catName) {
    return getModuleFallbackArtwork(categoryName: catName);
  }

  String? _getModuleFallbackImage() {
    return getModuleFallbackArtwork();
  }

  String? _getStoreModuleFallbackImage(int? modId) {
    return getModuleFallbackArtwork(moduleId: modId);
  }

  @override
  Widget build(BuildContext context) {
    final String fallbackAsset = placeholder.isNotEmpty
        ? placeholder
        : (isNotification
              ? Images.notificationPlaceholder
              : Images.placeholder);

    final bool isImgMissing = _isImageMissing(image);
    String selectedImage = image;
    String renderMode = 'network';
    bool fallbackUsed = false;
    String fallbackReason = 'none';

    if (isCategory) {
      if (isImgMissing) {
        fallbackUsed = true;
        fallbackReason = 'backend category image missing/placeholder';
        final String? localFallback = _getCategoryFallbackImage(categoryName) ?? _getModuleFallbackImage();
        if (localFallback != null) {
          selectedImage = localFallback;
          renderMode = (localFallback.startsWith('http://') || localFallback.startsWith('https://')) ? 'network' : 'asset';
        } else {
          selectedImage = '';
          renderMode = 'fallback_ui';
        }
      } else {
        selectedImage = _resolvedImageUrl(image);
        renderMode = _isLocalAsset(selectedImage) ? 'asset' : 'network';
      }

      if (kDebugMode) {
        final String currentModuleName = Get.find<SplashController>().module?.moduleName ?? '';
        debugPrint('[UG_CATEGORY_IMAGE]');
        debugPrint('categoryName: $categoryName');
        debugPrint('moduleName: $currentModuleName');
        debugPrint('backendImage: $image');
        debugPrint('selectedImage: $selectedImage');
        debugPrint('renderMode: $renderMode');
        debugPrint('fallbackUsed: $fallbackUsed');
        debugPrint('fallbackReason: $fallbackReason');
      }
    } else if (isStoreCover || isStoreLogo) {
      if (isImgMissing) {
        fallbackUsed = true;
        fallbackReason = 'backend store image missing/placeholder';
        if (isStoreCover) {
          final String? localFallback = _getStoreModuleFallbackImage(storeModuleId);
          if (localFallback != null) {
            selectedImage = localFallback;
            renderMode = (localFallback.startsWith('http://') || localFallback.startsWith('https://')) ? 'network' : 'asset';
          } else {
            selectedImage = '';
            renderMode = 'fallback_ui';
          }
        } else {
          selectedImage = '';
          renderMode = 'fallback_ui';
        }
      } else {
        selectedImage = _resolvedImageUrl(image);
        renderMode = _isLocalAsset(selectedImage) ? 'asset' : 'network';
      }

      if (kDebugMode) {
        String? moduleName;
        if (storeModuleId != null && Get.find<SplashController>().moduleList != null) {
          for (var m in Get.find<SplashController>().moduleList!) {
            if (m.id == storeModuleId) {
              moduleName = m.moduleName;
              break;
            }
          }
        }
        moduleName ??= Get.find<SplashController>().module?.moduleName ?? '';

        debugPrint('[UG_STORE_IMAGE]');
        debugPrint('storeName: $storeName');
        debugPrint('moduleName: $moduleName');
        debugPrint('logo: ${isStoreLogo ? image : ''}');
        debugPrint('coverPhoto: ${isStoreCover ? image : ''}');
        debugPrint('selectedLogo: ${isStoreLogo ? selectedImage : ''}');
        debugPrint('selectedCover: ${isStoreCover ? selectedImage : ''}');
        debugPrint('renderMode: $renderMode');
        debugPrint('fallbackUsed: $fallbackUsed');
        debugPrint('fallbackReason: $fallbackReason');
      }
    } else {
      if (isImgMissing) {
        selectedImage = '';
        renderMode = 'fallback_ui';
      } else {
        selectedImage = _resolvedImageUrl(image);
        renderMode = _isLocalAsset(selectedImage) ? 'asset' : 'network';
      }
    }

    final String activeModuleCover = Get.find<SplashController>().module?.coverImageFullUrl ?? '';
    final String activeModuleImage = Get.find<SplashController>().module?.imageFullUrl ?? '';
    final bool isModuleArt = selectedImage.toLowerCase().contains('urban_goodz_modules/') ||
        (activeModuleCover.isNotEmpty && selectedImage == activeModuleCover) ||
        (activeModuleImage.isNotEmpty && selectedImage == activeModuleImage);
    final BoxFit finalFit = isModuleArt ? BoxFit.contain : (fit ?? BoxFit.cover);

    Widget getFallbackErrorWidget(String fallbackAsset) {
      if (isCategory) {
        final String? localFallback = _getCategoryFallbackImage(categoryName) ?? _getModuleFallbackImage();
        if (localFallback != null && !localFallback.startsWith('http')) {
          return Image.asset(
            localFallback,
            height: height,
            width: width,
            fit: finalFit,
            color: color,
          );
        }
        return UrbanGoodzCategoryFallback(
          height: height,
          width: width,
          categoryName: categoryName ?? 'Category',
        );
      }
      if (isStoreCover) {
        final String? localFallback = _getStoreModuleFallbackImage(storeModuleId);
        if (localFallback != null && !localFallback.startsWith('http')) {
          return Image.asset(
            localFallback,
            height: height,
            width: width,
            fit: finalFit,
            color: color,
          );
        }
        return UrbanGoodzStoreCoverFallback(
          height: height,
          width: width,
          storeName: storeName ?? 'Urban Goodz Store',
        );
      }
      if (isStoreLogo) {
        return UrbanGoodzStoreLogoFallback(
          height: height,
          width: width,
          storeName: storeName ?? 'Urban Goodz Store',
        );
      }
      
      final String? localFallback = _getModuleFallbackImage();
      if (localFallback != null && !localFallback.startsWith('http')) {
        return Image.asset(
          localFallback,
          height: height,
          width: width,
          fit: finalFit,
          color: color,
        );
      }
      return UrbanGoodzStoreCoverFallback(
        height: height,
        width: width,
        storeName: storeName ?? 'Urban Goodz',
      );
    }

    if (renderMode == 'fallback_ui') {
      return getFallbackErrorWidget(fallbackAsset);
    }

    if (renderMode == 'asset') {
      return Image.asset(
        selectedImage.trim(),
        height: height,
        width: width,
        fit: finalFit,
        color: color,
        errorBuilder: (_, __, ___) => getFallbackErrorWidget(fallbackAsset),
      );
    }

    return AnimatedScale(
      scale: isHovered ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: CachedNetworkImage(
        color: color,
        imageUrl: selectedImage,
        height: height,
        width: width,
        fit: finalFit,
        placeholder: (context, url) => placeholder.isNotEmpty || isNotification
            ? Image.asset(
                fallbackAsset,
                height: height,
                width: width,
                fit: fit,
                color: color,
              )
            : _UrbanGoodzImageFallback(
                height: height,
                width: width,
                fit: fit,
                color: color,
              ),
        errorWidget: (context, url, error) => getFallbackErrorWidget(fallbackAsset),
      ),
    );
  }
}

class UrbanGoodzStoreCoverFallback extends StatelessWidget {
  final double? height;
  final double? width;
  final String storeName;

  const UrbanGoodzStoreCoverFallback({
    super.key,
    this.height,
    this.width,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE2D3BF), // Canvas
            const Color(0xFFED9914).withValues(alpha: 0.15), // Orange blend
            const Color(0xFFE5E276).withValues(alpha: 0.12), // Dijon blend
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFED9914).withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            bottom: -15,
            child: Icon(
              Icons.storefront,
              size: (height != null && height! < 100) ? 60 : 90,
              color: const Color(0xFF161616).withValues(alpha: 0.05),
            ),
          ),
          Positioned(
            left: -10,
            top: -10,
            child: Icon(
              Icons.blur_on,
              size: 50,
              color: const Color(0xFFED9914).withValues(alpha: 0.06),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    storeName,
                    style: robotoBold.copyWith(
                      color: const Color(0xFF161616),
                      fontSize: (height != null && height! < 90) ? Dimensions.fontSizeSmall : Dimensions.fontSizeLarge,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (height == null || height! >= 80) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFED9914).withValues(alpha: 0.15), width: 0.5),
                      ),
                      child: Text(
                        'URBAN GOODZ MARKETPLACE',
                        style: robotoBold.copyWith(
                          color: const Color(0xFFED9914),
                          fontSize: 8,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UrbanGoodzStoreLogoFallback extends StatelessWidget {
  final double? height;
  final double? width;
  final String storeName;

  const UrbanGoodzStoreLogoFallback({
    super.key,
    this.height,
    this.width,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    final String initials = storeName.trim().isNotEmpty
        ? storeName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'UG';

    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF161616), // UG Black
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Text(
        initials,
        style: robotoBold.copyWith(
          color: const Color(0xFFE2D3BF), // Canvas
          fontSize: Dimensions.fontSizeLarge,
        ),
      ),
    );
  }
}

class UrbanGoodzCategoryFallback extends StatelessWidget {
  final double? height;
  final double? width;
  final String categoryName;

  const UrbanGoodzCategoryFallback({
    super.key,
    this.height,
    this.width,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE2D3BF), Color(0xFFED9914)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.15,
            child: Icon(
              Icons.category_outlined,
              size: (width != null && width! < 60) ? 24 : 40,
              color: Colors.black,
            ),
          ),
          if (width == null || width! >= 60)
            Positioned(
              bottom: 8,
              left: 4,
              right: 4,
              child: Text(
                categoryName,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF161616),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

class _UrbanGoodzImageFallback extends StatelessWidget {
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;

  const _UrbanGoodzImageFallback({
    required this.height,
    required this.width,
    required this.fit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFE2D3BF).withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FittedBox(
        fit: fit ?? BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.storefront,
                color: color ?? const Color(0xFFED9914),
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                'Urban Goodz',
                style: TextStyle(
                  color: (color ?? const Color(0xFF161616)),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
