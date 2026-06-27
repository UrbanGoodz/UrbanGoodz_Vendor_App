# Critical Urban Goodz Module Image Fix Handoff

Repo:
`C:\Users\D'Andre Good\Documents\GitHub\UrbanGoodz2026-Revised`

Live tester:
`https://test.urbangoodzdelivery.com/?v=module-preview2`

Reference:
`https://www.urbangoodzdelivery.com`

## Guardrails

- Do not deploy.
- Do not commit.
- Do not push.
- Do not touch backend/admin/vendor files.
- Do not touch `lib/features/dashboard/screens/dashboard_screen.dart`.
- Do not break Favorites/Favourite files.
- Do not remove modules.
- Do not use fake generated replacement images.

## Current Truth

This Codex session can read the GitHub checkout but cannot write to it. Direct patching is blocked by the sandbox.

The module text helper already exists and the repo has progressed since the previous handoff:

- `lib/common/models/module_model.dart` now includes `thumbnail`, `icon`, `image`, `imageFullUrl`, `coverImage`, `coverImageFullUrl`.
- `lib/features/home/widgets/module_preview_panel.dart` already has `cleanModuleDescription`.
- `lib/features/home/widgets/module_view.dart` already uses compact-ish card sizing: image `122/96`, aspect `1.18/0.98`.
- `lib/features/home/widgets/web/module_widget.dart` already uses `modulePreviewImage`.
- `lib/common/widgets/custom_image.dart` shows a beige Urban Goodz fallback when the selected image is empty or fails to load.

The remaining visible issue is image truth, not text. The beige block means the selected URL/path is empty, invalid, rejected, or rendered through the wrong image path.

## Actual Parsed Module Fields Found In Code

The module API is fetched from:

`AppConstants.baseUrl + AppConstants.moduleUri`

Resolved from code:

- `AppConstants.baseUrl = https://admin.urbangoodzdelivery.com`
- `AppConstants.moduleUri = /api/v1/module`

Fetching path:

- `lib/features/splash/domain/repositories/splash_repository.dart`
- `getModules(...)`
- `apiClient.getData(AppConstants.moduleUri, headers: headers)`
- `response.body.forEach((storeCategory) => moduleList!.add(ModuleModel.fromJson(storeCategory)))`

Fields parsed by `ModuleModel.fromJson`:

- `id`
- `module_name` -> `moduleName`
- `module_type` -> `moduleType`
- `slug` -> `slug`
- `thumbnail_full_url` -> `thumbnailFullUrl`
- `icon_full_url` -> `iconFullUrl`
- `description` -> `description`
- `stores_count` -> `storesCount`
- `theme_id` -> `themeId`
- `created_at` -> `createdAt`
- `updated_at` -> `updatedAt`
- `zones` -> `zones`
- `thumbnail` -> `thumbnail`
- `icon` -> `icon`
- `image` -> `image`
- `image_full_url` -> `imageFullUrl`
- `cover_image` -> `coverImage`
- `cover_image_full_url` -> `coverImageFullUrl`

Searched but not parsed in ModuleModel/module mapping:

- `logo`
- `logo_full_url`
- `module_image`
- `module_image_full_url`
- `media`
- `translations`

Network limitation:

- This sandbox could not connect to `https://admin.urbangoodzdelivery.com/api/v1/module`.
- Because of that, real runtime API values must be proven with debug logs inside Antigravity/OpenCode or the browser console after the app runs.

## Real Module Assets Included In This Handoff

Copy this folder into the repo:

`outputs/urban-goodz-critical-module-image-fix/assets/image/urban_goodz_modules/`

Target location:

`C:\Users\D'Andre Good\Documents\GitHub\UrbanGoodz2026-Revised\assets\image\urban_goodz_modules\`

Included real user-provided assets:

- `home_based_businesses.png`
- `thc_cbd.png`
- `liquor_beverages.png`
- `courier_parcel.png`
- `pharmacy_health.png`
- `local_events_creators.png`
- `food_trucks.png`
- `car_rental.png`

These are real provided Urban Goodz module images, not fake replacements.

Missing from the provided image set/local repo search:

- Retail/Shopping
- Grocery/Markets
- Restaurants/Brick and Mortar
- Beauty Supply/Hair Providers

For those missing modules, use backend real image URLs if present. Do not substitute unrelated art unless the user provides those exact module pictures.

## Required Code Change 1: CustomImage Must Support Assets

File:
`lib/common/widgets/custom_image.dart`

Problem:
If `modulePreviewImage` returns `assets/image/urban_goodz_modules/pharmacy_health.png`, current `CustomImage` treats it as a backend-relative URL:

`https://admin.urbangoodzdelivery.com/assets/image/...`

That fails and shows the beige fallback.

Add local asset handling near the top of `build()` after `imageUrl` is resolved from the original raw value:

```dart
bool get _isLocalAsset {
  final String value = image.trim().toLowerCase();
  return value.startsWith('assets/') ||
      value.startsWith('asset/') ||
      value.startsWith('packages/');
}
```

Then in `build`, before `CachedNetworkImage`:

```dart
if (_isLocalAsset) {
  return Image.asset(
    image.trim(),
    height: height,
    width: width,
    fit: fit,
    color: color,
    errorBuilder: (_, __, ___) => placeholder.isNotEmpty || isNotification
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
  );
}
```

## Required Code Change 2: Strong Image Selection With Debug Proof

File:
`lib/features/home/widgets/module_preview_panel.dart`

Add imports:

```dart
import 'package:flutter/foundation.dart';
```

Replace/upgrade image selection with this logic:

```dart
String? modulePreviewImage(ModuleModel module) {
  final List<_ModuleImageCandidate> candidates = <_ModuleImageCandidate>[
    _ModuleImageCandidate('thumbnailFullUrl', module.thumbnailFullUrl),
    _ModuleImageCandidate('imageFullUrl', module.imageFullUrl),
    _ModuleImageCandidate('coverImageFullUrl', module.coverImageFullUrl),
    _ModuleImageCandidate('iconFullUrl', module.iconFullUrl),
    _ModuleImageCandidate('localAsset', _urbanGoodzLocalModuleAsset(module)),
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
  return selected;
}

class _ModuleImageCandidate {
  final String name;
  final String? value;

  const _ModuleImageCandidate(this.name, this.value);
}
```

Update call sites if needed:

```dart
final String moduleImage = modulePreviewImage(module) ?? '';
```

and:

```dart
final String image = modulePreviewImage(module) ?? '';
```

## Required Code Change 3: Reject Generic Placeholder URLs

Use these rejection rules:

```dart
bool _hasUsableImageUrl(String value) {
  final String normalized = value.trim().toLowerCase();
  return _hasUsableValue(value) &&
      !normalized.contains('/store.png') &&
      !normalized.contains('/store.svg') &&
      !normalized.contains('store.png') &&
      !normalized.contains('store.svg') &&
      !normalized.contains('placeholder') &&
      !normalized.contains('default') &&
      !normalized.contains('no_image') &&
      !normalized.contains('no-image');
}
```

Important:
Do not reject URLs just because they contain `urban-goodz` or `module`.

## Required Code Change 4: Add Local Urban Goodz Asset Mapping

Still in `module_preview_panel.dart`:

```dart
String? _urbanGoodzLocalModuleAsset(ModuleModel module) {
  final String key = <String?>[
    module.moduleName,
    module.moduleType,
    module.slug,
  ].whereType<String>().join(' ').toLowerCase();

  if (_containsAny(key, const ['home-based', 'home based', 'homebased'])) {
    return 'assets/image/urban_goodz_modules/home_based_businesses.png';
  }
  if (_containsAny(key, const ['thc', 'cbd', 'hemp', 'cannabis'])) {
    return 'assets/image/urban_goodz_modules/thc_cbd.png';
  }
  if (_containsAny(key, const ['liquor', 'beverage', 'drink', 'alcohol'])) {
    return 'assets/image/urban_goodz_modules/liquor_beverages.png';
  }
  if (_containsAny(key, const ['courier', 'parcel', 'package'])) {
    return 'assets/image/urban_goodz_modules/courier_parcel.png';
  }
  if (_containsAny(key, const ['pharmacy', 'health', 'wellness'])) {
    return 'assets/image/urban_goodz_modules/pharmacy_health.png';
  }
  if (_containsAny(key, const ['event', 'creator'])) {
    return 'assets/image/urban_goodz_modules/local_events_creators.png';
  }
  if (_containsAny(key, const ['food truck', 'foodtruck', 'truckz'])) {
    return 'assets/image/urban_goodz_modules/food_trucks.png';
  }
  if (_containsAny(key, const ['rental', 'car rental', 'vehicle'])) {
    return 'assets/image/urban_goodz_modules/car_rental.png';
  }

  return null;
}

bool _containsAny(String value, List<String> needles) {
  return needles.any(value.contains);
}
```

This mapping must be last after real backend URLs, so real API artwork wins.

## Required Code Change 5: Debug Logs

Add:

```dart
void _debugModuleImageSelection(
  ModuleModel module,
  String? selected,
  List<String> rejected,
) {
  if (!kDebugMode) return;

  debugPrint('[UG_MODULE_IMAGE] ${module.moduleName ?? 'Unknown'}');
  debugPrint('id: ${module.id}');
  debugPrint('type: ${module.moduleType}');
  debugPrint('thumbnailFullUrl: ${module.thumbnailFullUrl}');
  debugPrint('imageFullUrl: ${module.imageFullUrl}');
  debugPrint('coverImageFullUrl: ${module.coverImageFullUrl}');
  debugPrint('iconFullUrl: ${module.iconFullUrl}');
  debugPrint('localAsset: ${_urbanGoodzLocalModuleAsset(module)}');
  debugPrint('selected: ${selected ?? ''}');
  debugPrint('fallbackUsed: ${selected == null || selected.isEmpty}');
  if (rejected.isNotEmpty) {
    debugPrint('rejected: ${rejected.join(' | ')}');
  }
}
```

Required debug proof after running:

- Retail/Shopping
- Pharmacy/Health
- Courier/Parcel
- Local Events/Creators

If Retail/Shopping has no backend real image and no local asset mapping, report that plainly:

`Retail/Shopping real artwork is not present in the Flutter module API response and no matching local asset was provided.`

## Required Code Change 6: HTML Description Cleanup

Current helper is already mostly correct. Improve entity decoding to include visible mojibake/nbsp cases:

```dart
final String decoded = withoutTags
    .replaceAll('&nbsp;', ' ')
    .replaceAll('Â ', ' ')
    .replaceAll('&amp;', '&')
    .replaceAll('&quot;', '"')
    .replaceAll('&#39;', "'")
    .replaceAll('&apos;', "'")
    .replaceAll('&lt;', '<')
    .replaceAll('&gt;', '>');
```

Use `modulePreviewDescription(module)` in all card/preview text.

## Required Code Change 7: Card Layout Final Values

`lib/features/home/widgets/module_view.dart`

Use:

- desktop image: `122`
- mobile image: `96`
- desktop aspect: `1.18`
- mobile aspect: `0.98`
- `BoxFit.contain`
- card description `maxLines: 2`

If cards still look blank after real images display, change the column to:

```dart
mainAxisAlignment: MainAxisAlignment.start,
```

and reduce the image container padding to:

```dart
padding: const EdgeInsets.all(6),
```

## Required Code Change 8: Tester Banner Sanity

`lib/features/home/widgets/banner_view.dart` already has tester-domain fallback logic:

`Uri.base.host == 'test.urbangoodzdelivery.com'`

Verify the fallback banner appears on tester and does not show backend car/rental banners.

## Favorites Verification

Run:

```powershell
Select-String -Path .\lib\**\*.dart -Pattern "FavoriteScreen","Favorite_screen.dart","rental_Favorite","Images.FavoriteSelect","Images.FavouriteUnselect","_pageIndex == 4,,","'Favorites'.tr"
Select-String -Path .\lib\**\*.dart -Pattern "FavouriteScreen","favourite_screen.dart","rental_favourite","Images.favouriteSelect","Images.favouriteUnselect","'Favorites'"
```

This Codex session saw expected existing Favourite references in:

- `lib/helper/get_di.dart`
- `lib/helper/route_helper.dart`

Do not edit those unless there is a real compile error.

## Build And Package

After applying changes in the writable repo:

```powershell
cd "C:\Users\D'Andre Good\Documents\GitHub\UrbanGoodz2026-Revised"
C:\src\flutter\bin\flutter.bat analyze 2>&1 | Select-String "error -"
```

If no real error lines:

```powershell
C:\src\flutter\bin\flutter.bat build web --release --base-href /
```

Ensure these exist:

- `build\web\.htaccess`
- `build\web\tester-guide.html`

If missing, restore them from the repo/tester package before zipping.

Package:

```powershell
New-Item -ItemType Directory -Force -Path .\outputs | Out-Null
Compress-Archive -Path ".\build\web\*" -DestinationPath ".\outputs\urban-goodz-tester-web-build.zip" -Force
```

ZIP must include:

- `index.html`
- `main.dart.js`
- `flutter.js`
- `flutter_bootstrap.js`
- `manifest.json`
- `.htaccess`
- `tester-guide.html`
- `assets/`
- `canvaskit/`

## Return Report Requirements

Do not say fixed unless module cards and preview modal visibly show real artwork or the debug logs prove the backend lacks art and the local asset fallback is selected.

Return:

1. files inspected
2. files changed
3. actual module JSON fields found
4. actual image fields available in ModuleModel
5. debug image selection results for Retail/Shopping, Pharmacy/Health, Courier/Parcel, Local Events/Creators
6. final selected image URL/path for those modules
7. whether backend API contains real artwork or only placeholder
8. whether local asset mapping was needed
9. exact image fallback rejection rules
10. HTML cleanup helper location
11. confirmation no raw `<p>` tags display
12. before/after card layout values
13. confirmation preview modal uses real image
14. confirmation Favorites untouched
15. analyzer result
16. build result
17. ZIP verification result
18. ZIP path
19. NO DEPLOY, NO COMMIT, NO PUSH
