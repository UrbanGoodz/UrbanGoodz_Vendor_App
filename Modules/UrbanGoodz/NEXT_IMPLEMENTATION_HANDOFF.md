# Urban Goodz Next Implementation Handoff

Source of truth:
- Modules/UrbanGoodz/PROJECT_STATUS_REPORT.md
- Modules/UrbanGoodz/ARCHITECTURE.md
- Modules/UrbanGoodz/FLUTTER_INTEGRATION_CHECKLIST.md

## 1. Current Repo Status

Flutter placeholder foundations are complete for Phases A-F. The repo is scaffolded but not wired into the protected Flutter integration files.

Backend/admin implementation is blocked until admin-source is uploaded or pushed into the repository.

No new Flutter feature modules should be created until the existing placeholders are normalized and integrated.

## 2. Completed Flutter Placeholder Modules

### Phase A - Earn Money
- Screen: lib/features/urban_goodz/screens/earn_money_screen_placeholder.dart
- Model: lib/features/urban_goodz/domain/models/earn_money_opportunity_model.dart
- Service: lib/features/urban_goodz/domain/services/earn_money_api_service.dart
- Manual patch: Modules/UrbanGoodz/EarnMoney/FLUTTER_MANUAL_PATCH.md

### Phase B - Logistics / Load Board
- Screen: lib/features/urban_goodz/screens/logistics_load_board_screen_placeholder.dart
- Model: lib/features/urban_goodz/domain/models/logistics_opportunity_model.dart
- Service: lib/features/urban_goodz/domain/services/logistics_api_service.dart
- Manual patch: Modules/UrbanGoodz/Logistics/FLUTTER_MANUAL_PATCH.md

### Phase C - Medical Courier
- Screen: lib/features/urban_goodz/screens/medical_courier_screen_placeholder.dart
- Model: lib/features/urban_goodz/domain/models/medical_courier_job_model.dart
- Service: lib/features/urban_goodz/domain/services/medical_courier_api_service.dart
- Manual patch: Modules/UrbanGoodz/MedicalCourier/FLUTTER_MANUAL_PATCH.md

### Phase D - Book Anything / Services
- Screen: lib/features/urban_goodz/screens/book_services_screen_placeholder.dart
- Models:
  - lib/features/urban_goodz/domain/models/service_booking_provider_model.dart
  - lib/features/urban_goodz/domain/models/booking_service_model.dart
  - lib/features/urban_goodz/domain/models/booking_appointment_model.dart
- Service: lib/features/urban_goodz/domain/services/booking_api_service.dart
- Manual patch: Modules/UrbanGoodz/Bookings/FLUTTER_MANUAL_PATCH.md

### Phase E - Creator Commerce / Shoppable Reels
- Screen: lib/features/urban_goodz/screens/creator_commerce_screen_placeholder.dart
- Models:
  - lib/features/urban_goodz/domain/models/creator_profile_model.dart
  - lib/features/urban_goodz/domain/models/shoppable_reel_model.dart
- Service: lib/features/urban_goodz/domain/services/creator_commerce_api_service.dart
- Manual patch: Modules/UrbanGoodz/CreatorCommerce/FLUTTER_MANUAL_PATCH.md

### Phase F - Community Marketplace
- Screen: lib/features/urban_goodz/screens/community_marketplace_screen_placeholder.dart
- Models:
  - lib/features/urban_goodz/domain/models/community_group_model.dart
  - lib/features/urban_goodz/domain/models/community_post_model.dart
  - lib/features/urban_goodz/domain/models/community_comment_model.dart
- Service: lib/features/urban_goodz/domain/services/community_marketplace_api_service.dart
- Manual patch: Modules/UrbanGoodz/CommunityMarketplace/FLUTTER_MANUAL_PATCH.md

## 3. Protected Files Still Needing Manual Patching

Do not modify these files until safe targeted patching or local full-file access is available:

- lib/helper/route_helper.dart
- lib/features/menu/screens/menu_screen.dart
- lib/util/app_constants.dart

These files require additive changes only. Do not overwrite them.

## 4. Exact Next Flutter Integration Order

1. Confirm backend endpoint names from OpenCode/admin-source.
2. Normalize A-F placeholder models to match Modules/UrbanGoodz/ARCHITECTURE.md.
3. Rename or formally import placeholder screen files.
4. Add RouteHelper imports, constants, getters, and GetPage entries.
5. Add MenuScreen entries in existing menu sections.
6. Add AppConstants endpoint constants after backend routes are final.
7. Replace placeholder services with real API calls.
8. Add loading, empty, error, and auth-required UI states.
9. Add localization keys.
10. Run Flutter analysis/build testing.

## 5. Backend Dependency Status

Backend/admin work is not available in this repo yet.

Expected admin-source location from prior local work:

C:\Users\D'Andre Good\Documents\Codex\2026-06-05\find-where-the-admin-landing-page\work\admin-source

Expected contents:
- app/
- routes/
- resources/views/
- database/migrations/
- UrbanGoodzPlatformController.php
- routes/admin/urban_goodz_platform.php

Backend dependency by module:

- Earn Money: opportunities, opportunity types, incentives, referrals, driver earnings, payouts
- Logistics: loads, stops, route status, proof of delivery, fleet partners, enterprise accounts
- Medical Courier: medical jobs, chain of custody, temperature logs, certifications, incidents
- Book Anything: providers, services, availability, bookings, deposits/payments, reviews
- Creator Commerce: creator profiles, reels, product/service tagging, campaigns, earnings
- Community Marketplace: groups, posts, comments, media, commerce actions

## 6. Required API Endpoints From OpenCode Phase 4

Final endpoint paths must be confirmed by OpenCode after Laravel/admin-source analysis.

Expected placeholder endpoint plan:

```dart
static const String earnMoneyOpportunitiesUri = '/api/v1/urban-goodz/earn-money/opportunities';
static const String logisticsLoadsUri = '/api/v1/urban-goodz/logistics/loads';
static const String medicalCourierJobsUri = '/api/v1/urban-goodz/medical-courier/jobs';
static const String bookServicesProvidersUri = '/api/v1/urban-goodz/bookings/providers';
static const String creatorCommerceReelsUri = '/api/v1/urban-goodz/creator-commerce/reels';
static const String communityMarketplaceUri = '/api/v1/urban-goodz/community-marketplace';
```

Do not add these to AppConstants until backend routes are confirmed.

## 7. Testing Order After API Integration

1. Run `flutter pub get`.
2. Run `dart format` on Urban Goodz files.
3. Run `flutter analyze`.
4. Confirm app launches.
5. Confirm existing 6amMart home/menu/cart/order flows still work.
6. Confirm existing Urban Goodz branding remains intact.
7. Confirm Order Anywhere MVP was not rebuilt or broken.
8. Confirm each Urban Goodz route opens.
9. Confirm each screen handles:
   - loading
   - empty
   - error
   - authenticated user
   - unauthenticated user where applicable
10. Validate geography rules:
   - Houston live launch zone
   - country-wide records
   - worldwide records
   - null scope is intentional, not missing data
11. Validate backend response mapping to models.
12. Regression test Android debug build.

## 8. APK/AAB Build Order

1. Confirm Flutter SDK and dependency versions.
2. Run `flutter clean` only if needed.
3. Run `flutter pub get`.
4. Run `flutter analyze`.
5. Build debug APK.
6. Smoke test installed debug APK.
7. Build release APK.
8. Build release AAB.
9. Verify Android signing configuration.
10. Verify app name remains Urban Goodz.
11. Verify package identifiers are correct.
12. Verify base URL/environment configuration before release.
13. Smoke test release build.

## 9. Deployment Risks

- Protected core Flutter files are not wired yet.
- Backend routes are not confirmed.
- Placeholder services still return local/static data.
- Earlier placeholder models need geographic normalization.
- Some services use raw Map data instead of typed response models.
- `_placeholder.dart` naming must be resolved before production imports.
- AppConstants endpoints must wait for backend confirmation.
- Route/menu changes could break navigation if applied by full-file overwrite.
- Houston must remain first live launch zone, not demo/sample/test data.
- Worldwide scope must follow native 6amMart geography.
- Order Anywhere MVP and Urban Goodz Control Center shell must not be rebuilt.

## 10. Do-Not-Touch List

Do not modify without safe targeted patching or full local access:

- lib/helper/route_helper.dart
- lib/features/menu/screens/menu_screen.dart
- lib/util/app_constants.dart

Do not rebuild:

- Order Anywhere MVP
- Urban Goodz Admin Control Center shell
- Urban Goodz branding layer
- Existing 6amMart core food/order/store flows

Do not create new placeholder modules until:

1. A-F integration plan is applied, or
2. backend/admin-source endpoints are ready, or
3. project owner explicitly requests new module scaffolding.

## Bottom Line

The repo is ready for integration, not more scaffolding.

Next serious work depends on either:

1. OpenCode completing backend/admin-source analysis and endpoint definitions, or
2. safe full-file access becoming available for Flutter route/menu/constants integration.
