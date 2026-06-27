# Antigravity / OpenCode Prompt: Fix Urban Goodz Module Preview Cards

Use this in the writable repo:

`C:\Users\D'Andre Good\Documents\GitHub\UrbanGoodz2026-Revised`

Branch:
`9-continue-urban-goodz-platform-sprint`

## Guardrails

- Do not deploy.
- Do not commit.
- Do not push.
- Do not touch backend/admin/vendor files.
- Do not touch `lib/features/dashboard/screens/dashboard_screen.dart`.
- Do not break Favorites/Favourite.
- Do not remove modules.
- Do not replace real module images with fake generated images.

## What To Fix

The tester deployment at:
`https://test.urbangoodzdelivery.com/?v=module-preview1`

has module cards that:
- show generic Urban Goodz/store icons instead of real module artwork
- show raw HTML descriptions like `<p>Pharmacy</p>`
- are too tall and mostly blank
- do not match the live Urban Goodz website module experience

Reference website:
`https://www.urbangoodzdelivery.com`

The attached module pictures are the intended module artwork references. Use real existing API/module image URLs when present. Do not use generated placeholders.

## Files To Edit

Only edit these if needed:

- `lib/common/models/module_model.dart`
- `lib/features/home/widgets/module_preview_panel.dart`
- `lib/features/home/widgets/module_view.dart`
- `lib/features/home/widgets/web/module_widget.dart`

## Step 1: Expand ModuleModel Image Fields

In `lib/common/models/module_model.dart`, keep existing fields and add optional fields so API data is not thrown away:

- `thumbnail`
- `icon`
- `image`
- `imageFullUrl`
- `coverImage`
- `coverImageFullUrl`

Parse these JSON keys:

- `thumbnail`
- `icon`
- `image`
- `image_full_url`
- `cover_image`
- `cover_image_full_url`

Serialize them back in `toJson()`.

Existing useful fields already present:

- `moduleName`
- `moduleType`
- `slug`
- `thumbnailFullUrl`
- `iconFullUrl`
- `description`

## Step 2: Add HTML Cleanup Helper

In `lib/features/home/widgets/module_preview_panel.dart`, add:

```dart
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
```

Then update `modulePreviewDescription(ModuleModel module)` so it uses:

```dart
final String description = cleanModuleDescription(module.description);
if (description != 'Description needs review in backend.') {
  return description;
}
```

Keep the existing website fallback description map.

## Step 3: Fix Image Priority

In `module_preview_panel.dart`, update `modulePreviewImage(ModuleModel module)` to prioritize:

1. `module.thumbnailFullUrl`
2. `module.imageFullUrl`
3. `module.coverImageFullUrl`
4. `module.iconFullUrl`
5. empty fallback only if all are missing/invalid

Use this helper:

```dart
bool _hasUsableImageUrl(String value) {
  final String normalized = value.trim().toLowerCase();
  return _hasUsableValue(value) &&
      !normalized.contains('placeholder') &&
      !normalized.endsWith('/store.png') &&
      !normalized.endsWith('/store.svg');
}
```

Recommended `modulePreviewImage`:

```dart
String modulePreviewImage(ModuleModel module) {
  final List<String?> candidates = <String?>[
    module.thumbnailFullUrl,
    module.imageFullUrl,
    module.coverImageFullUrl,
    module.iconFullUrl,
  ];

  for (final String? candidate in candidates) {
    final String url = (candidate ?? '').trim();
    if (_hasUsableImageUrl(url)) {
      return url;
    }
  }

  return '';
}
```

## Step 4: Compact Module Cards

In `lib/features/home/widgets/module_view.dart`:

Current card sizing is too tall:

- desktop image around `150`
- mobile image around `112`
- desktop aspect around `0.9`
- mobile aspect around `0.78`

Change to:

```dart
final double moduleImageSize = isDesktop ? 122 : 96;
```

Grid ratio:

```dart
childAspectRatio: isDesktop ? 1.18 : 0.98,
```

Keep:

```dart
fit: BoxFit.contain
```

Keep description on cards to `maxLines: 2`.

Use full cleaned description only in the preview panel.

Also update `ModuleShimmer` to match:

```dart
childAspectRatio: ResponsiveHelper.isDesktop(context) ? 1.18 : 0.98,
height: ResponsiveHelper.isDesktop(context) ? 122 : 96,
width: ResponsiveHelper.isDesktop(context) ? 122 : 96,
```

## Step 5: Web Side Module Widget

In `lib/features/home/widgets/web/module_widget.dart`, keep using:

```dart
image: modulePreviewImage(module)
fit: BoxFit.contain
```

Slightly increase visible artwork from 52 to 58 if the side rail still looks too generic:

```dart
height: 58,
width: 58,
```

## Step 6: Favorites Verification

Run these checks and do not “fix” the expected British-spelled internal code:

```powershell
Select-String -Path .\lib\**\*.dart -Pattern "FavoriteScreen","Favorite_screen.dart","rental_Favorite","Images.FavoriteSelect","Images.FavouriteUnselect","_pageIndex == 4,,"
Select-String -Path .\lib\**\*.dart -Pattern "Favorites","FavouriteScreen","favourite_screen","favouriteSelect","favouriteUnselect","rental_favourite"
```

Expected:

- no new `FavoriteScreen`
- no `Favorite_screen.dart`
- no `rental_Favorite`
- no `Images.FavoriteSelect`
- no `Images.FavouriteUnselect`
- no `_pageIndex == 4,,`
- visible nav label remains `Favorites`
- internal existing code may still use `FavouriteScreen`, `favourite_screen`, `favouriteSelect`, `favouriteUnselect`, `rental_favourite`

## Step 7: Analyze, Build, Package

Run:

```powershell
cd "C:\Users\D'Andre Good\Documents\GitHub\UrbanGoodz2026-Revised"
C:\src\flutter\bin\flutter.bat analyze 2>&1 | Select-String "error -"
```

If no real error lines:

```powershell
C:\src\flutter\bin\flutter.bat build web --release --base-href /
New-Item -ItemType Directory -Force -Path .\outputs | Out-Null
Compress-Archive -Path ".\build\web\*" -DestinationPath ".\outputs\urban-goodz-tester-web-build.zip" -Force
```

Return:

- files inspected
- files changed
- exact module model fields available for images/descriptions
- image priority implemented
- HTML stripping helper location
- before/after card image sizing
- before/after card height/layout
- confirmation raw `<p>` tags no longer display
- confirmation real module images display instead of generic store icons where URLs exist
- confirmation Favorites untouched
- analyze result
- build result
- ZIP path
- NO DEPLOY, NO COMMIT, NO PUSH
