# Urban Goodz Flutter Integration Checklist

Source of truth:
- Modules/UrbanGoodz/PROJECT_STATUS_REPORT.md
- Modules/UrbanGoodz/NEXT_IMPLEMENTATION_HANDOFF.md
- Modules/UrbanGoodz/ARCHITECTURE.md

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

## 3. Confirmed Backend API Endpoints

OpenCode Phase 4 API status: COMPLETE.
OpenCode Phase 5 Discovery/Search Capture status: COMPLETE.

Do not add these to AppConstants until safe targeted patching is available.

### Phase 4 Endpoints

#### Earn Money
- GET api/urban-goodz/earn-money/opportunities
- GET api/urban-goodz/earn-money/opportunities/{record}
- POST api/urban-goodz/earn-money/opportunities/{record}/accept

#### Logistics
- GET api/urban-goodz/logistics/jobs
- GET api/urban-goodz/logistics/jobs/{record}
- POST api/urban-goodz/logistics/jobs/{record}/accept
- POST api/urban-goodz/logistics/jobs/{record}/status

#### Load Board
- GET api/urban-goodz/load-board/loads
- GET api/urban-goodz/load-board/loads/{record}
- POST api/urban-goodz/load-board/loads/{record}/accept
- POST api/urban-goodz/load-board/loads/{record}/status

#### Medical Courier
- GET api/urban-goodz/medical-courier/jobs
- GET api/urban-goodz/medical-courier/jobs/{record}
- POST api/urban-goodz/medical-courier/jobs/{record}/accept
- POST api/urban-goodz/medical-courier/jobs/{record}/status
- POST api/urban-goodz/medical-courier/jobs/{record}/custody

#### Book Anything
- GET api/urban-goodz/book-anything/records
- GET api/urban-goodz/book-anything/records/{record}
- POST api/urban-goodz/book-anything/request

#### Events
- GET api/urban-goodz/events
- GET api/urban-goodz/events/{record}
- POST api/urban-goodz/events/{record}/interest
- POST api/urban-goodz/events/{record}/vendor-opportunity
- POST api/urban-goodz/events/{record}/creator-opportunity
- POST api/urban-goodz/events/{record}/logistics-support

### Phase 5 Discovery / Search Capture Endpoints

- POST api/urban-goodz/discovery/search-capture
- GET api/urban-goodz/discovery/entities
- GET api/urban-goodz/discovery/entities/{id}
- POST api/urban-goodz/discovery/entities/{id}/action
- GET api/urban-goodz/discovery/opportunities
- POST api/urban-goodz/discovery/opportunities/{id}/accept

## 4. Required AppConstants Endpoint Additions

File: lib/util/app_constants.dart

Do not overwrite the file. Add endpoint constants only with safe targeted patching.

Suggested constants:

```dart
static const String ugEarnMoneyOpportunitiesUri = 'api/urban-goodz/earn-money/opportunities';
static const String ugLogisticsJobsUri = 'api/urban-goodz/logistics/jobs';
static const String ugLoadBoardLoadsUri = 'api/urban-goodz/load-board/loads';
static const String ugMedicalCourierJobsUri = 'api/urban-goodz/medical-courier/jobs';
static const String ugBookAnythingRecordsUri = 'api/urban-goodz/book-anything/records';
static const String ugBookAnythingRequestUri = 'api/urban-goodz/book-anything/request';
static const String ugEventsUri = 'api/urban-goodz/events';
static const String ugDiscoverySearchCaptureUri = 'api/urban-goodz/discovery/search-capture';
static const String ugDiscoveryEntitiesUri = 'api/urban-goodz/discovery/entities';
static const String ugDiscoveryOpportunitiesUri = 'api/urban-goodz/discovery/opportunities';
```

Dynamic actions should append the record/id path segment in the service layer:

- opportunities/{record}/accept
- jobs/{record}/accept
- jobs/{record}/status
- jobs/{record}/custody
- loads/{record}/accept
- loads/{record}/status
- events/{record}/interest
- events/{record}/vendor-opportunity
- events/{record}/creator-opportunity
- events/{record}/logistics-support
- entities/{id}/action
- opportunities/{id}/accept

## 5. Required RouteHelper Additions

File: lib/helper/route_helper.dart

Do not overwrite the file. Add targeted imports and route entries only.

Required screens to expose first:

1. Earn Money
2. Logistics
3. Medical Courier
4. Book Services
5. Events
6. Community Marketplace
7. Creator Commerce
8. Discovery/Search Capture

Existing placeholder screen imports still need safe final naming decisions.

Expected route constants:

```dart
static const String earnMoney = '/earn-money';
static const String logisticsLoadBoard = '/logistics-load-board';
static const String medicalCourier = '/medical-courier';
static const String bookServices = '/book-services';
static const String events = '/urban-goodz-events';
static const String communityMarketplace = '/community-marketplace';
static const String creatorCommerce = '/creator-commerce';
static const String discoverySearchCapture = '/discovery-search-capture';
```

## 6. Required MenuScreen Additions

File: lib/features/menu/screens/menu_screen.dart

Do not overwrite the file. Add menu entries only.

Recommended order:

1. Earn Money
2. Load Board / Logistics
3. Medical Courier
4. Book Services
5. Events
6. Community Marketplace
7. Creator Commerce
8. Discovery/Search Capture

Recommended placement:

- Earn Money section: Earn Money, Logistics, Medical Courier, Creator Commerce
- Services / Marketplace section: Book Services, Community Marketplace, Events, Discovery/Search Capture

## 7. Required Imports

Each production screen should import its matching models/services:

- EarnMoneyScreen -> EarnMoneyApiService, EarnMoneyOpportunityModel
- LogisticsLoadBoardScreen -> LogisticsApiService, LogisticsOpportunityModel
- MedicalCourierScreen -> MedicalCourierApiService, MedicalCourierJobModel
- BookServicesScreen -> BookingApiService, provider/service/appointment models
- CreatorCommerceScreen -> CreatorCommerceApiService, CreatorProfileModel, ShoppableReelModel
- CommunityMarketplaceScreen -> CommunityMarketplaceApiService, CommunityGroupModel, CommunityPostModel, CommunityCommentModel
- Future Events screen -> confirmed Phase 4 events endpoints
- Future Discovery/Search Capture screen -> confirmed Phase 5 discovery endpoints

## 8. Required Localization Strings

Add localization keys when safe, depending on existing app localization conventions:

- earn_money
- load_board
- logistics
- medical_courier
- book_services
- creator_commerce
- shoppable_reels
- community_marketplace
- events
- discovery
- search_capture
- view_business
- order_anywhere
- book_service
- request_delivery
- rent_now
- follow
- accept
- update_status
- chain_of_custody
- nationwide
- worldwide
- launch_zone
- active_zone

## 9. Required Dependency / Controller Bindings

No controller bindings should be added until protected files can be patched safely and backend payload behavior is verified.

Expected future controllers if following GetX feature convention:

- EarnMoneyController
- LogisticsController
- MedicalCourierController
- BookingController
- CreatorCommerceController
- CommunityMarketplaceController
- EventsController
- DiscoveryController

## 10. Required API Connection Steps

1. Add confirmed endpoint constants to AppConstants by targeted patch only.
2. Add RouteHelper routes by targeted patch only.
3. Add MenuScreen entries by targeted patch only.
4. Convert placeholder services to live API calls.
5. Map backend response fields into normalized models.
6. Preserve worldwide geography fields:
   - countryCode
   - state
   - city
   - zoneId
   - zoneName
   - isNationwide
   - isWorldwide
   - isLaunchMarket
7. Add loading, empty, error, auth-required, accepted, and status-updated states.
8. Validate Houston launch zone behavior.
9. Validate country-wide and worldwide visibility behavior.

## 11. Required Testing Checklist

### Static / Compile
- flutter pub get
- dart format on Urban Goodz files
- flutter analyze
- verify imports resolve
- verify no unused imports
- verify no route name collisions

### Navigation
- open menu
- tap each Urban Goodz menu item
- confirm each screen opens
- confirm back navigation works

### API
- Earn Money list/detail/accept
- Logistics list/detail/accept/status
- Load Board list/detail/accept/status
- Medical Courier list/detail/accept/status/custody
- Book Anything list/detail/request
- Events list/detail/interest/vendor/creator/logistics actions
- Discovery search capture/entities/entity action/opportunities/accept

### Geography
- Houston live launch zone renders as production content
- specific zone record visible only in selected zone
- country-wide record visible across all active zones in selected country
- worldwide record visible globally
- null scope treated as intentional, not missing data

### Regression
- existing 6amMart food/store/order flows still work
- existing Urban Goodz branding still intact
- existing Order Anywhere MVP not rebuilt or broken
- existing Urban Goodz control center shell not rebuilt or broken

## 12. Customer App APK/AAB Build Checklist

1. Confirm Flutter SDK version matches project requirements.
2. Run `flutter clean` only when necessary.
3. Run `flutter pub get`.
4. Run `flutter analyze`.
5. Build debug APK.
6. Smoke test installed debug APK.
7. Build release APK.
8. Build release AAB.
9. Verify app name remains Urban Goodz.
10. Verify package identifiers remain unchanged unless intentionally updated.
11. Verify environment/base URL settings before release build.
12. Verify Android signing configuration before production AAB.
13. Smoke test major tabs and Urban Goodz routes after install.

## 13. Known Blockers

- Protected Flutter files cannot be safely patched through the current connector:
  - lib/helper/route_helper.dart
  - lib/features/menu/screens/menu_screen.dart
  - lib/util/app_constants.dart
- Earlier placeholder models need geographic normalization when full-file safe updates are available.
- Some placeholder services still use raw Map data or lightweight placeholder structures.
- `_placeholder.dart` screen naming needs a final production import strategy.
- Events and Discovery/Search Capture screens are not yet scaffolded in Flutter because new placeholder creation is paused.

## 14. Integration Rule

All integration work must be additive.

Do not remove existing 6amMart behavior.
Do not rebuild Order Anywhere.
Do not rebuild the Urban Goodz control center shell.
Do not hardcode Houston as the only market.
Houston is the first live launch zone, while the architecture remains worldwide-capable through native 6amMart geography.
