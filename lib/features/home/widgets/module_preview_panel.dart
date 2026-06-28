import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/models/module_model.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

const Color _ugCanvas = Color(0xFFE2D3BF);
const Color _ugOrange = Color(0xFFED9914);
const Color _ugBlack = Color(0xFF161616);
const Color _ugDijon = Color(0xFFE5E276);

String modulePreviewImage(ModuleModel module) {
  final String? localAsset = _urbanGoodzLocalModuleAsset(module);
  if (localAsset != null &&
      localAsset.isNotEmpty &&
      localAsset.startsWith('assets/')) {
    _debugModuleImageSelection(module, localAsset, const []);
    return localAsset;
  }

  final List<_ModuleImageCandidate> candidates = <_ModuleImageCandidate>[
    _ModuleImageCandidate('thumbnailFullUrl', module.thumbnailFullUrl),
    _ModuleImageCandidate('imageFullUrl', module.imageFullUrl),
    _ModuleImageCandidate('coverImageFullUrl', module.coverImageFullUrl),
    _ModuleImageCandidate('iconFullUrl', module.iconFullUrl),
  ];

  String? selected;
  final List<String> rejected = <String>[];

  for (final _ModuleImageCandidate candidate in candidates) {
    final String value = (candidate.value ?? '').trim();
    if (_hasUsableImageUrl(value)) {
      selected = value;
      break;
    }
    if (_hasUsableValue(value)) {
      rejected.add('${candidate.name}: $value');
    }
  }

  _debugModuleImageSelection(module, selected, rejected);
  return selected ?? '';
}

class _ModuleImageCandidate {
  final String name;
  final String? value;

  const _ModuleImageCandidate(this.name, this.value);
}

class _PharmacyModuleInfo {
  final int index;
  final String searchKey;
  const _PharmacyModuleInfo({required this.index, required this.searchKey});
}

String cleanModuleDescription(String? value) {
  final String raw = (value ?? '').trim();
  if (!_hasUsableValue(raw)) {
    return 'Description needs review in backend.';
  }

  final String withoutTags = raw
      .replaceAll(RegExp(r'<\s*br\s*/?\s*>', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'<[^>]*>'), ' ');

  final String decoded = withoutTags
      .replaceAll('&nbsp;', ' ')
      .replaceAll(String.fromCharCode(160), ' ')
      .replaceAll(String.fromCharCodes(<int>[194, 160]), ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');

  final String cleaned = decoded.replaceAll(RegExp(r'\s+'), ' ').trim();
  return _hasUsableValue(cleaned)
      ? cleaned
      : 'Description needs review in backend.';
}

String modulePreviewDescription(ModuleModel module) {
  final String description = cleanModuleDescription(module.description);
  if (description != 'Description needs review in backend.') {
    return description;
  }

  final String key = [
    module.moduleName,
    module.moduleType,
    module.slug,
  ].whereType<String>().join(' ').toLowerCase();

  for (final MapEntry<String, String> entry
      in _websiteModuleDescriptions.entries) {
    if (key.contains(entry.key)) {
      return entry.value;
    }
  }

  return 'Description needs review in backend.';
}

List<int> visibleUrbanGoodzModuleIndexes(List<ModuleModel> modules) {
  final List<_PharmacyModuleInfo> pharmacyModules = [];

  for (int i = 0; i < modules.length; i++) {
    final key = _moduleSearchKey(modules[i]);
    if (key.contains('pharmacy')) {
      pharmacyModules.add(_PharmacyModuleInfo(index: i, searchKey: key));
    }
  }

  final Set<int> removeIndices = <int>{};
  if (pharmacyModules.length > 1) {
    for (final pm in pharmacyModules) {
      if (!pm.searchKey.contains('health')) {
        removeIndices.add(pm.index);
      }
    }
  }

  final Set<String> seenKeys = {};
  final Set<int> seenIds = {};
  final Set<String> seenAssets = {};
  final List<int> result = [];

  for (int i = 0; i < modules.length; i++) {
    if (removeIndices.contains(i)) continue;

    final module = modules[i];
    if (module.id != null) {
      if (seenIds.contains(module.id)) continue;
      seenIds.add(module.id!);
    }

    final String asset = modulePreviewImage(module);
    if (asset.isNotEmpty && asset.contains('urban_goodz_modules/')) {
      if (seenAssets.contains(asset)) {
        continue;
      }
      seenAssets.add(asset);
    }

    final String nameKey = (module.moduleName ?? '').trim().toLowerCase();
    if (nameKey.isNotEmpty) {
      if (seenKeys.contains(nameKey)) continue;
      seenKeys.add(nameKey);
    }

    result.add(i);
  }

  return result;
}

String _moduleSearchKey(ModuleModel module) {
  return <String?>[
    module.moduleName,
    module.moduleType,
    module.slug,
  ].whereType<String>().join(' ').toLowerCase().replaceAll('-', ' ');
}

Future<void> showModulePreviewPanel(
  BuildContext context, {
  required ModuleModel module,
  required VoidCallback onOpen,
}) async {
  final bool isDesktop = ResponsiveHelper.isDesktop(context);
  final Widget content = _ModulePreviewContent(
    module: module,
    onOpen: onOpen,
    isDesktop: isDesktop,
  );

  if (isDesktop) {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: content,
        ),
      ),
    );
  } else {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(child: content),
    );
  }
}

bool _hasUsableValue(String value) {
  final String normalized = value.trim().toLowerCase();
  return normalized.isNotEmpty &&
      normalized != 'null' &&
      normalized != 'undefined' &&
      normalized != '[]';
}

bool _hasUsableImageUrl(String value) {
  final String normalized = value.trim().toLowerCase();
  final bool hasExtension =
      normalized.contains('.png') ||
      normalized.contains('.jpg') ||
      normalized.contains('.jpeg') ||
      normalized.contains('.gif') ||
      normalized.contains('.webp') ||
      normalized.contains('.svg');
  return _hasUsableValue(value) &&
      hasExtension &&
      !normalized.contains('/store.png') &&
      !normalized.contains('/store.svg') &&
      !normalized.contains('store.png') &&
      !normalized.contains('store.svg') &&
      !normalized.contains('placeholder') &&
      !normalized.contains('default') &&
      !normalized.contains('no_image') &&
      !normalized.contains('no-image') &&
      !normalized.contains('assets/admin/img') &&
      !normalized.contains('/img1.jpg') &&
      !normalized.contains('/img2.jpg') &&
      !normalized.contains('/img3.jpg') &&
      !normalized.contains('/img1.png') &&
      !normalized.contains('/img2.png') &&
      !normalized.contains('/img3.png');
}

String? _urbanGoodzLocalModuleAsset(ModuleModel module) {
  return CustomImage.getModuleFallbackArtwork(
    moduleName: module.moduleName,
    moduleType: module.moduleType,
    moduleId: module.id,
    moduleSlug: module.slug,
  );
}

bool _containsAny(String value, List<String> needles) {
  return needles.any(value.contains);
}

void _debugModuleImageSelection(
  ModuleModel module,
  String? selected,
  List<String> rejected,
) {
  if (!kDebugMode) return;

  final String renderMode = selected == null || selected.isEmpty
      ? 'fallback'
      : selected.startsWith('assets/')
      ? 'asset'
      : 'network';

  debugPrint('[UG_MODULE_PREVIEW_IMAGE]');
  debugPrint('moduleName: ${module.moduleName}');
  debugPrint('moduleType: ${module.moduleType}');
  debugPrint('moduleId: ${module.id}');
  debugPrint('thumbnailFullUrl: ${module.thumbnailFullUrl}');
  debugPrint('imageFullUrl: ${module.imageFullUrl}');
  debugPrint('coverImageFullUrl: ${module.coverImageFullUrl}');
  debugPrint('iconFullUrl: ${module.iconFullUrl}');
  debugPrint('selectedImage: ${selected ?? ''}');
  debugPrint('renderMode: $renderMode');
  debugPrint('fallbackUsed: ${selected == null || selected.isEmpty}');
  debugPrint(
    'fallbackReason: ${selected == null || selected.isEmpty ? 'backend module image missing/placeholder' : 'none'}',
  );
}

final Map<String, String> _websiteModuleDescriptions = <String, String>{
  'restaurant':
      'Black-owned and local food vendors customers can order from for delivery or pickup',
  'brick':
      'Black-owned and local food vendors customers can order from for delivery or pickup',
  'grocery':
      'Local grocery and specialty market vendors offering everyday essentials and cultural food products.',
  'market':
      'Local grocery and specialty market vendors offering everyday essentials and cultural food products.',
  'home-based':
      'Urban Goodz Home-Based Businesses connects customers with trusted local entrepreneurs, independent sellers, creators, and small business owners operating from home. Customers can shop unique products, custom orders, handmade goods, specialty items, and local services while supporting community-based businesses beyond traditional storefronts.',
  'home based':
      'Urban Goodz Home-Based Businesses connects customers with trusted local entrepreneurs, independent sellers, creators, and small business owners operating from home. Customers can shop unique products, custom orders, handmade goods, specialty items, and local services while supporting community-based businesses beyond traditional storefronts.',
  'thc':
      'Urban Goodz connects eligible customers with local CBD, hemp, wellness, smoke shop, and legally approved cannabis-related retailers. Availability depends on local laws, age requirements, business licensing, and product eligibility in each service area.',
  'cbd':
      'Urban Goodz connects eligible customers with local CBD, hemp, wellness, smoke shop, and legally approved cannabis-related retailers. Availability depends on local laws, age requirements, business licensing, and product eligibility in each service area.',
  'liquor':
      'Urban Goodz connects eligible customers with local beverage retailers, liquor stores, drink shops, mixers, non-alcoholic beverages, and legally approved adult beverage providers. Availability depends on local laws, age requirements, delivery rules, licensing, and product eligibility in each service area.',
  'beverage':
      'Urban Goodz connects eligible customers with local beverage retailers, liquor stores, drink shops, mixers, non-alcoholic beverages, and legally approved adult beverage providers. Availability depends on local laws, age requirements, delivery rules, licensing, and product eligibility in each service area.',
  'courier':
      'Urban Goodz Courier / Parcel gives customers and businesses a simple, local way to move packages, documents, errands, and business deliveries across their community. Built for small businesses, vendors, professionals, and everyday customers, this module offers convenient delivery support while creating earning opportunities for trusted local couriers.',
  'parcel':
      'Urban Goodz Courier / Parcel gives customers and businesses a simple, local way to move packages, documents, errands, and business deliveries across their community. Built for small businesses, vendors, professionals, and everyday customers, this module offers convenient delivery support while creating earning opportunities for trusted local couriers.',
  'pharmacy':
      'Urban Goodz Pharmacy / Health gives customers a convenient way to discover and shop trusted local health and wellness providers. From pharmacy-related essentials and first-aid items to vitamins, personal care products, wellness goods, and approved over-the-counter items, this module supports families, caregivers, seniors, and busy customers while helping local providers serve their communities.',
  'health':
      'Urban Goodz Pharmacy / Health gives customers a convenient way to discover and shop trusted local health and wellness providers. From pharmacy-related essentials and first-aid items to vitamins, personal care products, wellness goods, and approved over-the-counter items, this module supports families, caregivers, seniors, and busy customers while helping local providers serve their communities.',
  'event':
      'Urban Goodz Local Events / Creators gives customers a direct way to discover community events, pop-up markets, local creators, vendor showcases, cultural experiences, and emerging brands. Built for shoppers, families, creators, entrepreneurs, and community supporters, this module brings local culture, commerce, and creativity into one easy marketplace.',
  'creator':
      'Urban Goodz Local Events / Creators gives customers a direct way to discover community events, pop-up markets, local creators, vendor showcases, cultural experiences, and emerging brands. Built for shoppers, families, creators, entrepreneurs, and community supporters, this module brings local culture, commerce, and creativity into one easy marketplace.',
  'food truck':
      'Urban Goodz Food Trucks gives customers a simple way to find and support mobile food vendors, Black-owned food trucks, pop-up kitchens, and local food entrepreneurs. From quick bites and late-night eats to cultural dishes and event vendors, this module brings neighborhood flavor and community-driven food options directly to customers.',
  'retail':
      'Urban Goodz Retail / Shopping brings local commerce, culture, and community into one marketplace. Customers can discover boutiques, fashion brands, sneakers, accessories, beauty retail, gifts, lifestyle products, and independent online sellers while helping small businesses reach more customers and grow beyond traditional storefronts.',
  'shopping':
      'Urban Goodz Retail / Shopping brings local commerce, culture, and community into one marketplace. Customers can discover boutiques, fashion brands, sneakers, accessories, beauty retail, gifts, lifestyle products, and independent online sellers while helping small businesses reach more customers and grow beyond traditional storefronts.',
  'beauty':
      'Shop premium hair, beauty, and self-care products from local beauty suppliers, hair providerz, and Black-owned businesses. Discover wigs, bundles, braiding hair, lace frontals, edge control, hair care products, cosmetics, lashes, skincare, barber supplies, and beauty essentials. Support local entrepreneurs while enjoying convenient pickup or delivery through Urban Goodz.',
  'hair':
      'Shop premium hair, beauty, and self-care products from local beauty suppliers, hair providerz, and Black-owned businesses. Discover wigs, bundles, braiding hair, lace frontals, edge control, hair care products, cosmetics, lashes, skincare, barber supplies, and beauty essentials. Support local entrepreneurs while enjoying convenient pickup or delivery through Urban Goodz.',
};

class _ModulePreviewContent extends StatelessWidget {
  final ModuleModel module;
  final VoidCallback onOpen;
  final bool isDesktop;

  const _ModulePreviewContent({
    required this.module,
    required this.onOpen,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final String image = modulePreviewImage(module);
    final String title = module.moduleName ?? 'Urban Goodz Module';
    final String description = modulePreviewDescription(module);
    final bool isLocalModuleArt = image.contains('urban_goodz_modules/');
    final double imageBoxSize = isLocalModuleArt
        ? (isDesktop ? 340 : 260)
        : (isDesktop ? 220 : 180);

    return Container(
      margin: EdgeInsets.all(isDesktop ? 0 : Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
        border: Border.all(color: _ugOrange.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: _ugBlack.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close, color: _ugBlack),
                ),
              ),
              Center(
                child: Container(
                  width: isLocalModuleArt ? imageBoxSize : double.infinity,
                  height: imageBoxSize,
                  padding: EdgeInsets.all(
                    isLocalModuleArt
                        ? Dimensions.paddingSizeSmall
                        : Dimensions.paddingSizeDefault,
                  ),
                  decoration: BoxDecoration(
                    color: _ugCanvas.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  ),
                  child: CustomImage(
                    image: image,
                    height: imageBoxSize,
                    width: isLocalModuleArt ? imageBoxSize : double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              Text(
                title,
                style: robotoBold.copyWith(
                  color: _ugBlack,
                  fontSize: isDesktop ? 26 : 22,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(
                description,
                style: robotoRegular.copyWith(
                  color: _ugBlack.withValues(alpha: 0.82),
                  height: 1.45,
                  fontSize: isDesktop
                      ? Dimensions.fontSizeDefault
                      : Dimensions.fontSizeSmall,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ugOrange,
                    foregroundColor: _ugBlack,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.paddingSizeDefault,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.radiusDefault,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    onOpen();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Open Module',
                        style: robotoBold.copyWith(color: _ugBlack),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall,
                  vertical: Dimensions.paddingSizeExtraSmall,
                ),
                decoration: BoxDecoration(
                  color: _ugDijon.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                ),
                child: Text(
                  'Original Urban Goodz module artwork is preserved here.',
                  style: robotoMedium.copyWith(
                    color: _ugBlack,
                    fontSize: Dimensions.fontSizeExtraSmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
