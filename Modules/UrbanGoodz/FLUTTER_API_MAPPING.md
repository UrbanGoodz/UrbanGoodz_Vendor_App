# Urban Goodz Flutter API Mapping

Scope: Flutter-side only.

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

## 2. Existing Rental AppConstants Endpoints

Existing rental endpoints already present in lib/util/app_constants.dart:

- getTopRatedCarsUri = /api/v1/rental/vehicle/top-rated
- getTaxiBannerUri = /api/v1/rental/banners
- getTaxiCouponUri = /api/v1/rental/coupon/list
- taxiCouponApplyUri = /api/v1/rental/coupon/apply
- getVehicleDetailsUri = /api/v1/rental/vehicle/get-vehicle-details
- getVehicleCategoriesUri = /api/v1/rental/vehicle/category-list
- getSelectVehiclesUri = /api/v1/rental/vehicle/search/
- getSearchVehicleSuggestionUri = /api/v1/rental/vehicle/search/suggestion
- addToCarCartUri = /api/v1/rental/user/cart/add-to-cart
- updateCarCartUri = /api/v1/rental/user/cart/update-cart
- removeCarCartUri = /api/v1/rental/user/cart/remove-vehicle
- getCarCartListUri = /api/v1/rental/user/cart/get-cart
- tripBookingUri = /api/v1/rental/user/trip/trip-booking
- tripUpdateUserDataUri = /api/v1/rental/user/cart/update-user-data
- removeAllCarCartUri = /api/v1/rental/user/cart/remove-cart
- removeMultipleCarCartUri = /api/v1/rental/user/cart/remove-multiple-cart
- tripListUri = /api/v1/rental/user/trip/get-trip-list
- tripDetailsUri = /api/v1/rental/user/trip/get-trip-details
- tripCancelUri = /api/v1/rental/user/trip/cancel-trip
- getProviderDetailsUri = /api/v1/rental/provider/get-provider-details
- getProviderVehicleListUri = /api/v1/rental/vehicle/get-provider-vehicles
- getProviderVehicleCategoryListUri = /api/v1/rental/vehicle/category-list
- tripPaymentUri = /api/v1/rental/user/trip/payment
- addTaxiWishListUri = /api/v1/rental/user/wish-list/add
- removeTaxiWishListUri = /api/v1/rental/user/wish-list/remove
- getTaxiWishListUri = /api/v1/rental/user/wish-list
- getTaxiBrandListUri = /api/v1/rental/vehicle/brand-list
- getTaxiProviderReviewUri = /api/v1/rental/provider/get-provider-reviews
- addTaxiReviewUri = /api/v1/rental/user/review/add
- getPopularTaxiSuggestionUri = /api/v1/rental/vehicle/popular-suggestion/
- getProviderBannerUri = /api/v1/rental/banners
- getTripTaxUri = /api/v1/rental/user/trip/get-tax

## 3. Existing Rental Screens / Controllers / Services

Verified Flutter-side rental layer includes:

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

## 4. Urban Goodz Placeholder Screens

Existing Urban Goodz placeholder screens:

- lib/features/urban_goodz/screens/earn_money_screen_placeholder.dart
- lib/features/urban_goodz/screens/logistics_load_board_screen_placeholder.dart
- lib/features/urban_goodz/screens/medical_courier_screen_placeholder.dart
- lib/features/urban_goodz/screens/book_services_screen_placeholder.dart
- lib/features/urban_goodz/screens/creator_commerce_screen_placeholder.dart
- lib/features/urban_goodz/screens/community_marketplace_screen_placeholder.dart

## 5. Placeholder To Confirmed Backend API Mapping

### Earn Money
Screen:
- earn_money_screen_placeholder.dart

Service:
- earn_money_api_service.dart

Confirmed backend APIs:
- GET api/urban-goodz/earn-money/opportunities
- GET api/urban-goodz/earn-money/opportunities/{record}
- POST api/urban-goodz/earn-money/opportunities/{record}/accept

### Logistics
Screen:
- logistics_load_board_screen_placeholder.dart

Service:
- logistics_api_service.dart

Confirmed backend APIs:
- GET api/urban-goodz/logistics/jobs
- GET api/urban-goodz/logistics/jobs/{record}
- POST api/urban-goodz/logistics/jobs/{record}/accept
- POST api/urban-goodz/logistics/jobs/{record}/status

### Load Board
Screen:
- logistics_load_board_screen_placeholder.dart

Service:
- logistics_api_service.dart

Confirmed backend APIs:
- GET api/urban-goodz/load-board/loads
- GET api/urban-goodz/load-board/loads/{record}
- POST api/urban-goodz/load-board/loads/{record}/accept
- POST api/urban-goodz/load-board/loads/{record}/status

### Medical Courier
Screen:
- medical_courier_screen_placeholder.dart

Service:
- medical_courier_api_service.dart

Confirmed backend APIs:
- GET api/urban-goodz/medical-courier/jobs
- GET api/urban-goodz/medical-courier/jobs/{record}
- POST api/urban-goodz/medical-courier/jobs/{record}/accept
- POST api/urban-goodz/medical-courier/jobs/{record}/status
- POST api/urban-goodz/medical-courier/jobs/{record}/custody

### Book Anything / Services
Screen:
- book_services_screen_placeholder.dart

Service:
- booking_api_service.dart

Confirmed backend APIs:
- GET api/urban-goodz/book-anything/records
- GET api/urban-goodz/book-anything/records/{record}
- POST api/urban-goodz/book-anything/request

### Events
Flutter screen status:
- Not yet scaffolded in current Urban Goodz placeholder set.

Confirmed backend APIs:
- GET api/urban-goodz/events
- GET api/urban-goodz/events/{record}
- POST api/urban-goodz/events/{record}/interest
- POST api/urban-goodz/events/{record}/vendor-opportunity
- POST api/urban-goodz/events/{record}/creator-opportunity
- POST api/urban-goodz/events/{record}/logistics-support

### Discovery / Search Capture
Flutter screen status:
- Not yet scaffolded in current Urban Goodz placeholder set.

Confirmed backend APIs:
- POST api/urban-goodz/discovery/search-capture
- GET api/urban-goodz/discovery/entities
- GET api/urban-goodz/discovery/entities/{id}
- POST api/urban-goodz/discovery/entities/{id}/action
- GET api/urban-goodz/discovery/opportunities
- POST api/urban-goodz/discovery/opportunities/{id}/accept

### Creator Commerce
Screen:
- creator_commerce_screen_placeholder.dart

Current backend API status:
- No confirmed dedicated Creator Commerce API provided in the Phase 4/5 endpoint list.

Recommended mapping for now:
- Reels/promotions should wait for confirmed backend endpoints.
- Creator opportunities from Events can use event creator-opportunity API once a real Events UI exists.

### Community Marketplace
Screen:
- community_marketplace_screen_placeholder.dart

Current backend API status:
- No confirmed dedicated Community Marketplace API provided in the Phase 4/5 endpoint list.

Recommended mapping for now:
- Do not wire to guessed endpoints.
- Wait for confirmed Community Marketplace backend routes.

## 6. Placeholders That Should Reuse Existing Rental Module APIs

Rental/Car Rental should reuse the existing rental Flutter module and AppConstants endpoints.

Do not create:
- a second rental service
- a second rental controller set
- a second rental cart
- duplicate rental endpoint constants
- duplicate vehicle model flow unless extending existing rental models safely

Recommended reuse:

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

## 7. Endpoints Still Unconfirmed From OpenCode

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

## 8. Safe Integration Order Once Protected Files Can Be Patched

1. Preserve existing rental module and run current rental flow smoke tests.
2. Add AppConstants constants only for confirmed non-rental Urban Goodz APIs.
3. Do not add duplicate rental constants.
4. Add RouteHelper entries for existing placeholder screens.
5. Add MenuScreen entries with Rental surfaced as a first-class Fulfillment Engine but routed through existing rental module entry point.
6. Convert Earn Money service to live APIs.
7. Convert Logistics / Load Board service to live APIs.
8. Convert Medical Courier service to live APIs.
9. Convert Book Anything service to live APIs.
10. Add Events Flutter screen only after explicit approval, since placeholder creation is currently paused.
11. Add Discovery/Search Capture Flutter screen only after explicit approval, since placeholder creation is currently paused.
12. Keep Creator Commerce and Community Marketplace placeholder-only until dedicated backend APIs are confirmed.
13. Run route/menu/app constants smoke tests.
14. Run rental regression tests.
15. Build debug APK, then release APK/AAB.

## 9. Key Risk Rules

- Rental is a first-class Fulfillment Engine.
- Car Rental must not be buried under Book Anything.
- Existing rental addon functionality must be preserved.
- Do not create duplicate rental systems.
- Do not create duplicate rental endpoint constants.
- Do not modify protected files until safe targeted patching is available.
- Do not claim backend routes exist from Flutter alone.
