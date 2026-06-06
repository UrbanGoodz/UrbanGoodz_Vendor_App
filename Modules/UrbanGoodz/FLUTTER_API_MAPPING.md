# Urban Goodz Flutter API Mapping

Scope: Flutter-side mapping only. No Flutter source files were modified.

Contract source requested:
- docs/urban-goodz/flutter-backend-api-contract.md

Current note:
- The contract file was not found on branch `9-continue-urban-goodz-platform-sprint` through direct GitHub fetch.
- This mapping uses the confirmed backend endpoints supplied in the current implementation thread and the existing Flutter repo as source of truth.

Do not modify:
- lib/helper/route_helper.dart
- lib/features/menu/screens/menu_screen.dart
- lib/util/app_constants.dart

Do not create duplicate rental APIs.
Do not create a second rental Flutter module.

## 1. Existing Rental Flutter Module Paths

Existing rental functionality is already present in the Flutter app under:

- lib/features/rental_module/
- lib/features/rental_module/domain/repository/taxi_repository.dart
- lib/features/rental_module/domain/services/taxi_location_service.dart
- lib/features/rental_module/home/controllers/taxi_home_controller.dart
- lib/features/rental_module/home/domain/services/taxi_home_service.dart
- lib/features/rental_module/home/domain/repositories/taxi_home_repository.dart
- lib/features/rental_module/rental_cart_screen/controllers/taxi_cart_controller.dart
- lib/features/rental_module/rental_cart_screen/domain/services/taxi_cart_service.dart
- lib/features/rental_module/rental_cart_screen/domain/repository/taxi_cart_repository.dart
- lib/features/rental_module/rental_favourite/controllers/taxi_favourite_controller.dart
- lib/features/rental_module/rental_favourite/domain/services/taxi_favourite_service.dart
- lib/features/rental_module/rental_favourite/domain/repositories/taxi_favourite_repository.dart
- lib/features/rental_module/rental_location_screen/controller/taxi_location_controller.dart
- lib/features/rental_module/rental_location_screen/domain/services/taxi_location_service.dart
- lib/features/rental_module/rental_location_screen/domain/repository/taxi_repository.dart
- lib/features/rental_module/rental_order/controllers/taxi_order_controller.dart
- lib/features/rental_module/rental_order/domain/services/taxi_order_service.dart
- lib/features/rental_module/rental_order/domain/repository/taxi_order_repository.dart
- lib/features/rental_module/vendor/controllers/taxi_vendor_controller.dart
- lib/features/rental_module/vendor/domain/services/taxi_vendor_service.dart
- lib/features/rental_module/vendor/domain/repositories/taxi_vendor_repository.dart

## 2. Existing Rental AppConstants Endpoints To Reuse

Existing rental endpoints already present in lib/util/app_constants.dart:

| Existing constant | Existing endpoint | Reuse purpose |
|---|---|---|
| getTopRatedCarsUri | /api/v1/rental/vehicle/top-rated | Car rental discovery |
| getTaxiBannerUri | /api/v1/rental/banners | Rental banners |
| getTaxiCouponUri | /api/v1/rental/coupon/list | Rental coupons |
| taxiCouponApplyUri | /api/v1/rental/coupon/apply | Coupon application |
| getVehicleDetailsUri | /api/v1/rental/vehicle/get-vehicle-details | Vehicle detail |
| getVehicleCategoriesUri | /api/v1/rental/vehicle/category-list | Rental categories |
| getSelectVehiclesUri | /api/v1/rental/vehicle/search/ | Vehicle search |
| getSearchVehicleSuggestionUri | /api/v1/rental/vehicle/search/suggestion | Vehicle search suggestions |
| addToCarCartUri | /api/v1/rental/user/cart/add-to-cart | Rental cart add |
| updateCarCartUri | /api/v1/rental/user/cart/update-cart | Rental cart update |
| removeCarCartUri | /api/v1/rental/user/cart/remove-vehicle | Rental cart remove |
| getCarCartListUri | /api/v1/rental/user/cart/get-cart | Rental cart list |
| tripBookingUri | /api/v1/rental/user/trip/trip-booking | Rental booking |
| tripUpdateUserDataUri | /api/v1/rental/user/cart/update-user-data | Rental user data |
| removeAllCarCartUri | /api/v1/rental/user/cart/remove-cart | Clear rental cart |
| removeMultipleCarCartUri | /api/v1/rental/user/cart/remove-multiple-cart | Bulk remove rental cart |
| tripListUri | /api/v1/rental/user/trip/get-trip-list | Trip/rental history |
| tripDetailsUri | /api/v1/rental/user/trip/get-trip-details | Trip detail |
| tripCancelUri | /api/v1/rental/user/trip/cancel-trip | Trip cancellation |
| getProviderDetailsUri | /api/v1/rental/provider/get-provider-details | Rental provider detail |
| getProviderVehicleListUri | /api/v1/rental/vehicle/get-provider-vehicles | Provider vehicles |
| getProviderVehicleCategoryListUri | /api/v1/rental/vehicle/category-list | Provider vehicle categories |
| tripPaymentUri | /api/v1/rental/user/trip/payment | Rental payment |
| addTaxiWishListUri | /api/v1/rental/user/wish-list/add | Rental wishlist add |
| removeTaxiWishListUri | /api/v1/rental/user/wish-list/remove | Rental wishlist remove |
| getTaxiWishListUri | /api/v1/rental/user/wish-list | Rental wishlist list |
| getTaxiBrandListUri | /api/v1/rental/vehicle/brand-list | Vehicle brands |
| getTaxiProviderReviewUri | /api/v1/rental/provider/get-provider-reviews | Provider reviews |
| addTaxiReviewUri | /api/v1/rental/user/review/add | Add rental review |
| getPopularTaxiSuggestionUri | /api/v1/rental/vehicle/popular-suggestion/ | Popular vehicle suggestions |
| getProviderBannerUri | /api/v1/rental/banners | Provider banners |
| getTripTaxUri | /api/v1/rental/user/trip/get-tax | Rental tax quote |

## 3. Existing Rental Screens / Controllers / Services

### Controllers
- TaxiHomeController
- TaxiCartController
- TaxiFavouriteController
- TaxiLocationController
- TaxiOrderController
- TaxiVendorController

### Services
- TaxiHomeService
- TaxiCartService
- TaxiFavouriteService
- TaxiLocationService
- TaxiOrderService
- TaxiVendorService

### Repositories
- TaxiRepository
- TaxiHomeRepository
- TaxiCartRepository
- TaxiFavouriteRepository
- TaxiOrderRepository
- TaxiVendorRepository

## 4. Confirmed Urban Goodz API Mapping Table

| Backend endpoint | Flutter screen | Flutter service | Flutter model | Needed AppConstants constant | Needed RouteHelper route | Needed MenuScreen entry | Auth requirement |
|---|---|---|---|---|---|---|---|
| GET api/urban-goodz/earn-money/opportunities | earn_money_screen_placeholder.dart | earn_money_api_service.dart | earn_money_opportunity_model.dart | ugEarnMoneyOpportunitiesUri | /earn-money | Earn Money | Auth recommended / driver-user context |
| GET api/urban-goodz/earn-money/opportunities/{record} | earn_money_screen_placeholder.dart | earn_money_api_service.dart | earn_money_opportunity_model.dart | ugEarnMoneyOpportunitiesUri + /{record} | /earn-money | Earn Money | Auth recommended |
| POST api/urban-goodz/earn-money/opportunities/{record}/accept | earn_money_screen_placeholder.dart | earn_money_api_service.dart | earn_money_opportunity_model.dart | dynamic from ugEarnMoneyOpportunitiesUri | /earn-money | Earn Money | Auth required |
| GET api/urban-goodz/logistics/jobs | logistics_load_board_screen_placeholder.dart | logistics_api_service.dart | logistics_opportunity_model.dart | ugLogisticsJobsUri | /logistics-load-board | Load Board / Logistics | Auth recommended |
| GET api/urban-goodz/logistics/jobs/{record} | logistics_load_board_screen_placeholder.dart | logistics_api_service.dart | logistics_opportunity_model.dart | ugLogisticsJobsUri + /{record} | /logistics-load-board | Load Board / Logistics | Auth recommended |
| POST api/urban-goodz/logistics/jobs/{record}/accept | logistics_load_board_screen_placeholder.dart | logistics_api_service.dart | logistics_opportunity_model.dart | dynamic from ugLogisticsJobsUri | /logistics-load-board | Load Board / Logistics | Auth required |
| POST api/urban-goodz/logistics/jobs/{record}/status | logistics_load_board_screen_placeholder.dart | logistics_api_service.dart | logistics_opportunity_model.dart | dynamic from ugLogisticsJobsUri | /logistics-load-board | Load Board / Logistics | Auth required |
| GET api/urban-goodz/load-board/loads | logistics_load_board_screen_placeholder.dart | logistics_api_service.dart | logistics_opportunity_model.dart | ugLoadBoardLoadsUri | /logistics-load-board | Load Board / Logistics | Auth recommended |
| GET api/urban-goodz/load-board/loads/{record} | logistics_load_board_screen_placeholder.dart | logistics_api_service.dart | logistics_opportunity_model.dart | ugLoadBoardLoadsUri + /{record} | /logistics-load-board | Load Board / Logistics | Auth recommended |
| POST api/urban-goodz/load-board/loads/{record}/accept | logistics_load_board_screen_placeholder.dart | logistics_api_service.dart | logistics_opportunity_model.dart | dynamic from ugLoadBoardLoadsUri | /logistics-load-board | Load Board / Logistics | Auth required |
| POST api/urban-goodz/load-board/loads/{record}/status | logistics_load_board_screen_placeholder.dart | logistics_api_service.dart | logistics_opportunity_model.dart | dynamic from ugLoadBoardLoadsUri | /logistics-load-board | Load Board / Logistics | Auth required |
| GET api/urban-goodz/medical-courier/jobs | medical_courier_screen_placeholder.dart | medical_courier_api_service.dart | medical_courier_job_model.dart | ugMedicalCourierJobsUri | /medical-courier | Medical Courier | Auth recommended |
| GET api/urban-goodz/medical-courier/jobs/{record} | medical_courier_screen_placeholder.dart | medical_courier_api_service.dart | medical_courier_job_model.dart | ugMedicalCourierJobsUri + /{record} | /medical-courier | Medical Courier | Auth recommended |
| POST api/urban-goodz/medical-courier/jobs/{record}/accept | medical_courier_screen_placeholder.dart | medical_courier_api_service.dart | medical_courier_job_model.dart | dynamic from ugMedicalCourierJobsUri | /medical-courier | Medical Courier | Auth required |
| POST api/urban-goodz/medical-courier/jobs/{record}/status | medical_courier_screen_placeholder.dart | medical_courier_api_service.dart | medical_courier_job_model.dart | dynamic from ugMedicalCourierJobsUri | /medical-courier | Medical Courier | Auth required |
| POST api/urban-goodz/medical-courier/jobs/{record}/custody | medical_courier_screen_placeholder.dart | medical_courier_api_service.dart | medical_courier_job_model.dart | dynamic from ugMedicalCourierJobsUri | /medical-courier | Medical Courier | Auth required |
| GET api/urban-goodz/book-anything/records | book_services_screen_placeholder.dart | booking_api_service.dart | service_booking_provider_model.dart / booking_service_model.dart | ugBookAnythingRecordsUri | /book-services | Book Services | Auth optional for browse, required for booking |
| GET api/urban-goodz/book-anything/records/{record} | book_services_screen_placeholder.dart | booking_api_service.dart | booking_service_model.dart / booking_appointment_model.dart | ugBookAnythingRecordsUri + /{record} | /book-services | Book Services | Auth optional for detail |
| POST api/urban-goodz/book-anything/request | book_services_screen_placeholder.dart | booking_api_service.dart | booking_appointment_model.dart | ugBookAnythingRequestUri | /book-services | Book Services | Auth required |
| GET api/urban-goodz/events | Future Events screen | Future events service | Future event model | ugEventsUri | /urban-goodz-events | Events | Auth optional for browse |
| GET api/urban-goodz/events/{record} | Future Events screen | Future events service | Future event model | ugEventsUri + /{record} | /urban-goodz-events | Events | Auth optional for detail |
| POST api/urban-goodz/events/{record}/interest | Future Events screen | Future events service | Future event model | dynamic from ugEventsUri | /urban-goodz-events | Events | Auth required |
| POST api/urban-goodz/events/{record}/vendor-opportunity | Future Events screen | Future events service | Future event model | dynamic from ugEventsUri | /urban-goodz-events | Events | Auth required |
| POST api/urban-goodz/events/{record}/creator-opportunity | Future Events screen | Future events service | Future event model | dynamic from ugEventsUri | /urban-goodz-events | Events | Auth required |
| POST api/urban-goodz/events/{record}/logistics-support | Future Events screen | Future events service | Future event model | dynamic from ugEventsUri | /urban-goodz-events | Events | Auth required |
| POST api/urban-goodz/discovery/search-capture | Future Discovery/Search Capture screen | Future discovery service | Future discovery/search model | ugDiscoverySearchCaptureUri | /discovery-search-capture | Discovery/Search Capture | Auth optional; attach user if available |
| GET api/urban-goodz/discovery/entities | Future Discovery/Search Capture screen | Future discovery service | Future discovery entity model | ugDiscoveryEntitiesUri | /discovery-search-capture | Discovery/Search Capture | Auth optional |
| GET api/urban-goodz/discovery/entities/{id} | Future Discovery/Search Capture screen | Future discovery service | Future discovery entity model | ugDiscoveryEntitiesUri + /{id} | /discovery-search-capture | Discovery/Search Capture | Auth optional |
| POST api/urban-goodz/discovery/entities/{id}/action | Future Discovery/Search Capture screen | Future discovery service | Future discovery entity model | dynamic from ugDiscoveryEntitiesUri | /discovery-search-capture | Discovery/Search Capture | Auth required for tracked actions |
| GET api/urban-goodz/discovery/opportunities | Future Discovery/Search Capture screen | Future discovery service | Future discovery opportunity model | ugDiscoveryOpportunitiesUri | /discovery-search-capture | Discovery/Search Capture | Auth recommended |
| POST api/urban-goodz/discovery/opportunities/{id}/accept | Future Discovery/Search Capture screen | Future discovery service | Future discovery opportunity model | dynamic from ugDiscoveryOpportunitiesUri | /discovery-search-capture | Discovery/Search Capture | Auth required |

## 5. Urban Goodz APIs That Are New

New non-rental Urban Goodz APIs that require new AppConstants constants once protected files can be patched:

- ugEarnMoneyOpportunitiesUri
- ugLogisticsJobsUri
- ugLoadBoardLoadsUri
- ugMedicalCourierJobsUri
- ugBookAnythingRecordsUri
- ugBookAnythingRequestUri
- ugEventsUri
- ugDiscoverySearchCaptureUri
- ugDiscoveryEntitiesUri
- ugDiscoveryOpportunitiesUri

These should not duplicate existing rental constants.

## 6. Placeholders That Can Now Become Live

Can become live once protected files can be safely patched and services are converted:

- Earn Money
- Logistics / Load Board
- Medical Courier
- Book Services

Still needs explicit new Flutter screen approval before live UI exposure:

- Events
- Discovery/Search Capture

Remain placeholder-only until dedicated backend APIs are confirmed:

- Creator Commerce / Shoppable Reels
- Community Marketplace

## 7. Placeholders / Features That Should Reuse Existing Rental Module APIs

Rental/Car Rental must reuse the existing rental Flutter module and existing AppConstants rental endpoints.

Do not create:
- a second rental service
- a second rental controller set
- a second rental cart
- duplicate rental endpoint constants
- duplicate vehicle model flow unless extending existing rental models safely

### Car Rental Discovery / Browse
Use existing:
- getTopRatedCarsUri
- getTaxiBannerUri
- getVehicleCategoriesUri
- getSelectVehiclesUri
- getSearchVehicleSuggestionUri
- getTaxiBrandListUri
- getPopularTaxiSuggestionUri

### Vehicle Details
Use existing:
- getVehicleDetailsUri
- getProviderDetailsUri
- getProviderVehicleListUri
- getProviderVehicleCategoryListUri
- getTaxiProviderReviewUri

### Cart / Booking
Use existing:
- addToCarCartUri
- updateCarCartUri
- removeCarCartUri
- getCarCartListUri
- tripBookingUri
- tripUpdateUserDataUri
- removeAllCarCartUri
- removeMultipleCarCartUri
- getTripTaxUri
- tripPaymentUri

### Trip / Rental Order Management
Use existing:
- tripListUri
- tripDetailsUri
- tripCancelUri

### Wishlist / Reviews / Coupons
Use existing:
- addTaxiWishListUri
- removeTaxiWishListUri
- getTaxiWishListUri
- getTaxiCouponUri
- taxiCouponApplyUri
- addTaxiReviewUri

## 8. Endpoints Still Unconfirmed For Flutter Wiring

Do not wire Flutter to guessed endpoints for:

- Rental demand assets
- Rental opportunities
- Rental trust assets
- Renter verification
- Owner verification
- Pickup/dropoff workflow extensions
- Delivery workflow extensions
- Tracking consent
- Revenue attribution
- Creator Commerce dedicated reels APIs
- Community Marketplace dedicated APIs
- AI Concierge rental recommendation APIs
- Trust/Identity verification APIs

If these are implemented by extending existing rental endpoints, document the payload mapping before changing Flutter services.

## 9. Safe Patch Order For Protected Files

Protected files:
- lib/util/app_constants.dart
- lib/helper/route_helper.dart
- lib/features/menu/screens/menu_screen.dart

Patch order once safe targeted patching is available:

1. Run current rental flow smoke test first.
2. Patch AppConstants with confirmed non-rental Urban Goodz constants only.
3. Do not add duplicate rental constants.
4. Patch RouteHelper routes for existing placeholder screens only:
   - /earn-money
   - /logistics-load-board
   - /medical-courier
   - /book-services
5. Add Events and Discovery/Search Capture routes only after explicit approval to create those Flutter screens.
6. Patch MenuScreen entries:
   - Earn Money
   - Load Board / Logistics
   - Medical Courier
   - Book Services
   - Rental / Car Rental routed through existing rental module entry point
7. Convert Earn Money service to live APIs.
8. Convert Logistics / Load Board service to live APIs.
9. Convert Medical Courier service to live APIs.
10. Convert Book Anything service to live APIs.
11. Run route/menu/app constants smoke tests.
12. Run rental regression tests.
13. Build debug APK, then release APK/AAB.

## 10. Key Risk Rules

- Rental is a first-class Fulfillment Engine.
- Car Rental must not be buried under Book Anything.
- Existing rental addon functionality must be preserved.
- Do not create duplicate rental systems.
- Do not create duplicate rental endpoint constants.
- Do not modify protected files until safe targeted patching is available.
- Do not claim backend routes exist from Flutter alone.
- Do not create new Events or Discovery Flutter screens without explicit approval.
