# Urban Goodz Flutter Integration Checklist

Source of truth: Modules/UrbanGoodz/PROJECT_STATUS_REPORT.md

Protected files. Do not edit until safe targeted patching is available:

- lib/helper/route_helper.dart
- lib/features/menu/screens/menu_screen.dart
- lib/util/app_constants.dart

## 1. Placeholder Screens Created

- lib/features/urban_goodz/screens/earn_money_screen_placeholder.dart
- lib/features/urban_goodz/screens/logistics_load_board_screen_placeholder.dart
- lib/features/urban_goodz/screens/medical_courier_screen_placeholder.dart
- lib/features/urban_goodz/screens/book_services_screen_placeholder.dart
- lib/features/urban_goodz/screens/creator_commerce_screen_placeholder.dart
- lib/features/urban_goodz/screens/community_marketplace_screen_placeholder.dart

## 2. Model / Service Files Created

### Shared
- lib/features/urban_goodz/domain/models/urban_goodz_zone_context_model.dart

### Earn Money
- lib/features/urban_goodz/domain/models/earn_money_opportunity_model.dart
- lib/features/urban_goodz/domain/services/earn_money_api_service.dart

### Logistics
- lib/features/urban_goodz/domain/models/logistics_opportunity_model.dart
- lib/features/urban_goodz/domain/services/logistics_api_service.dart

### Medical Courier
- lib/features/urban_goodz/domain/models/medical_courier_job_model.dart
- lib/features/urban_goodz/domain/services/medical_courier_api_service.dart

### Book Anything / Services
- lib/features/urban_goodz/domain/models/service_booking_provider_model.dart
- lib/features/urban_goodz/domain/models/booking_service_model.dart
- lib/features/urban_goodz/domain/models/booking_appointment_model.dart
- lib/features/urban_goodz/domain/services/booking_api_service.dart

### Creator Commerce
- lib/features/urban_goodz/domain/models/creator_profile_model.dart
- lib/features/urban_goodz/domain/models/shoppable_reel_model.dart
- lib/features/urban_goodz/domain/services/creator_commerce_api_service.dart

### Community Marketplace
- lib/features/urban_goodz/domain/models/community_group_model.dart
- lib/features/urban_goodz/domain/models/community_post_model.dart
- lib/features/urban_goodz/domain/models/community_comment_model.dart
- lib/features/urban_goodz/domain/services/community_marketplace_api_service.dart

## 3. Required RouteHelper Additions

File: lib/helper/route_helper.dart

Do not overwrite the file. Add targeted imports and route entries only.

### Imports

```dart
import 'package:sixam_mart/features/urban_goodz/screens/earn_money_screen.dart';
import 'package:sixam_mart/features/urban_goodz/screens/logistics_load_board_screen.dart';
import 'package:sixam_mart/features/urban_goodz/screens/medical_courier_screen.dart';
import 'package:sixam_mart/features/urban_goodz/screens/book_services_screen.dart';
import 'package:sixam_mart/features/urban_goodz/screens/creator_commerce_screen.dart';
import 'package:sixam_mart/features/urban_goodz/screens/community_marketplace_screen.dart';
```

### Route Constants

```dart
static const String earnMoney = '/earn-money';
static const String logisticsLoadBoard = '/logistics-load-board';
static const String medicalCourier = '/medical-courier';
static const String bookServices = '/book-services';
static const String creatorCommerce = '/creator-commerce';
static const String communityMarketplace = '/community-marketplace';
```

### Route Getters

```dart
static String getEarnMoneyRoute() => earnMoney;
static String getLogisticsLoadBoardRoute() => logisticsLoadBoard;
static String getMedicalCourierRoute() => medicalCourier;
static String getBookServicesRoute() => bookServices;
static String getCreatorCommerceRoute() => creatorCommerce;
static String getCommunityMarketplaceRoute() => communityMarketplace;
```

### GetPage Entries

```dart
GetPage(name: earnMoney, page: () => const EarnMoneyScreen()),
GetPage(name: logisticsLoadBoard, page: () => const LogisticsLoadBoardScreen()),
GetPage(name: medicalCourier, page: () => const MedicalCourierScreen()),
GetPage(name: bookServices, page: () => const BookServicesScreen()),
GetPage(name: creatorCommerce, page: () => const CreatorCommerceScreen()),
GetPage(name: communityMarketplace, page: () => const CommunityMarketplaceScreen()),
```

Note: placeholder screen filenames currently include `_placeholder`. Either rename the files when safe or import the placeholder files and keep production class names inside them until backend integration is complete.

## 4. Required MenuScreen Additions

File: lib/features/menu/screens/menu_screen.dart

Do not overwrite the file. Add menu entries only.

Recommended entries:

```dart
PortionWidget(
  icon: Images.dmIcon,
  title: 'Earn Money',
  route: RouteHelper.getEarnMoneyRoute(),
),
PortionWidget(
  icon: Images.dmIcon,
  title: 'Load Board',
  route: RouteHelper.getLogisticsLoadBoardRoute(),
),
PortionWidget(
  icon: Images.dmIcon,
  title: 'Medical Courier',
  route: RouteHelper.getMedicalCourierRoute(),
),
PortionWidget(
  icon: Images.dmIcon,
  title: 'Book Services',
  route: RouteHelper.getBookServicesRoute(),
),
PortionWidget(
  icon: Images.dmIcon,
  title: 'Creator Commerce',
  route: RouteHelper.getCreatorCommerceRoute(),
),
PortionWidget(
  icon: Images.dmIcon,
  title: 'Community',
  route: RouteHelper.getCommunityMarketplaceRoute(),
),
```

Recommended placement:

- Earn Money section: Earn Money, Load Board, Medical Courier, Creator Commerce
- Services / Marketplace section: Book Services, Community Marketplace

## 5. Required AppConstants Endpoint Additions

File: lib/util/app_constants.dart

Do not overwrite the file. Add endpoint constants only after backend routes exist.

```dart
static const String earnMoneyOpportunitiesUri = '/api/v1/urban-goodz/earn-money/opportunities';
static const String logisticsLoadsUri = '/api/v1/urban-goodz/logistics/loads';
static const String medicalCourierJobsUri = '/api/v1/urban-goodz/medical-courier/jobs';
static const String bookServicesProvidersUri = '/api/v1/urban-goodz/bookings/providers';
static const String creatorCommerceReelsUri = '/api/v1/urban-goodz/creator-commerce/reels';
static const String communityMarketplaceUri = '/api/v1/urban-goodz/community-marketplace';
```

## 6. Required Imports

Each production screen should import its matching models/services:

- EarnMoneyScreen -> EarnMoneyApiService, EarnMoneyOpportunityModel
- LogisticsLoadBoardScreen -> LogisticsApiService, LogisticsOpportunityModel
- MedicalCourierScreen -> MedicalCourierApiService, MedicalCourierJobModel
- BookServicesScreen -> BookingApiService, provider/service/appointment models
- CreatorCommerceScreen -> CreatorCommerceApiService, CreatorProfileModel, ShoppableReelModel
- CommunityMarketplaceScreen -> CommunityMarketplaceApiService, CommunityGroupModel, CommunityPostModel, CommunityCommentModel

## 7. Required Localization Strings

Add localization keys when safe, depending on existing app localization conventions:

- earn_money
- load_board
- logistics
- medical_courier
- book_services
- creator_commerce
- shoppable_reels
- community_marketplace
- view_business
- order_anywhere
- book_service
- request_delivery
- rent_now
- follow
- nationwide
- worldwide
- launch_zone
- active_zone

## 8. Required Dependency / Controller Bindings

Current placeholder services are instantiated directly or are not fully wired.

Before production wiring, decide whether each service should use:

- direct service instantiation
- GetX dependency injection
- repository/service/controller pattern matching the existing 6amMart feature style

Expected future controllers if following GetX feature convention:

- EarnMoneyController
- LogisticsController
- MedicalCourierController
- BookingController
- CreatorCommerceController
- CommunityMarketplaceController

No controller bindings should be added until backend endpoint behavior is confirmed.

## 9. Required API Connection Steps Once Backend Routes Exist

1. Confirm backend endpoint paths from admin-source / Laravel implementation.
2. Add endpoint constants to AppConstants with targeted patch only.
3. Replace placeholder service data with HTTP requests using existing 6amMart API client conventions.
4. Map API response fields to normalized model fields.
5. Preserve geographic fields:
   - countryCode
   - state
   - city
   - zoneId
   - zoneName
   - isNationwide
   - isWorldwide
   - isLaunchMarket
6. Handle unauthenticated, empty, loading, and error states.
7. Validate Houston launch zone behavior.
8. Validate country-wide and worldwide visibility behavior.

## 10. Required Testing Checklist

### Static / Compile
- flutter analyze
- dart format on new Urban Goodz files
- verify imports resolve
- verify no unused imports
- verify no route name collisions

### Navigation
- open menu
- tap each Urban Goodz menu item
- confirm each placeholder screen opens
- confirm back navigation works

### Data
- confirm placeholder data renders
- confirm empty states render
- confirm API error states render after backend wiring
- confirm Houston launch zone data is not labeled demo/sample/test

### Geography
- specific zone record visible only in selected zone
- country-wide record visible across all active zones in selected country
- worldwide record visible globally
- null scope treated as intentional, not missing data

### Regression
- existing 6amMart food/store/order flows still work
- existing Urban Goodz branding still intact
- existing Order Anywhere MVP not rebuilt or broken
- existing Urban Goodz control center shell not rebuilt or broken

## 11. Customer App APK/AAB Build Checklist

1. Confirm Flutter SDK version matches project requirements.
2. Run `flutter clean` only when necessary.
3. Run `flutter pub get`.
4. Run `flutter analyze`.
5. Run debug build.
6. Run release APK build.
7. Run release AAB build.
8. Verify app name remains Urban Goodz.
9. Verify package identifiers remain unchanged unless intentionally updated.
10. Verify environment/base URL settings before release build.
11. Verify Android signing configuration before production AAB.
12. Smoke test major tabs and Urban Goodz routes after install.

## 12. Known Blockers

- Backend/admin source is not yet available in the repo.
- Laravel routes, controllers, migrations, permissions, and admin screens are not implemented yet.
- Protected Flutter files cannot be safely patched through the current connector:
  - lib/helper/route_helper.dart
  - lib/features/menu/screens/menu_screen.dart
  - lib/util/app_constants.dart
- Earlier placeholder models need geographic normalization when full-file safe updates are available.
- Some placeholder services still use raw Map data or lightweight placeholder structures.
- `_placeholder.dart` screen naming needs a final production import strategy.
- AppConstants endpoint constants should wait until backend endpoints are confirmed.

## 13. Integration Rule

All integration work must be additive.

Do not remove existing 6amMart behavior.
Do not rebuild Order Anywhere.
Do not rebuild the Urban Goodz control center shell.
Do not hardcode Houston as the only market.
Houston is the first live launch zone, while the architecture remains worldwide-capable through native 6amMart geography.
