# Urban Goodz Opportunity / Logistics / Medical Handoff

## Files Inspected

- `lib/features/urban_goodz/`
- `lib/features/urban_goodz/screens/earn_money_screen_placeholder.dart`
- `lib/features/urban_goodz/screens/logistics_load_board_screen_placeholder.dart`
- `lib/features/urban_goodz/screens/medical_courier_screen_placeholder.dart`
- `lib/features/urban_goodz/screens/book_services_screen_placeholder.dart`
- `lib/features/urban_goodz/screens/local_events_creators_screen.dart`
- `lib/features/urban_goodz/domain/models/earn_money_opportunity_model.dart`
- `lib/features/urban_goodz/domain/models/logistics_opportunity_model.dart`
- `lib/features/urban_goodz/domain/models/medical_courier_job_model.dart`
- `lib/features/urban_goodz/domain/services/earn_money_api_service.dart`
- `lib/features/urban_goodz/domain/services/logistics_api_service.dart`
- `lib/features/urban_goodz/domain/services/medical_courier_api_service.dart`
- `lib/features/urban_goodz/domain/services/booking_api_service.dart`
- `lib/util/app_constants.dart`
- `lib/api/api_client.dart`
- Discovery files were only read as an ApiClient integration pattern.

## Existing State

- Earn Money had a placeholder screen already using `EarnMoneyApiService().getOpportunities()`.
- Earn Money, Logistics, and Medical Courier had model classes with `fromJson` support.
- Earn Money, Logistics, and Medical Courier services returned hardcoded placeholder data.
- Booking API service existed but was empty.
- Load Board, Medical Courier, Book Services, and Local Events screens are still placeholder/static UI.
- `ApiClient` does not prepend `/api/v1`; endpoint constants must include the full `/api/v1/...` path.

## Files Created

- `lib/features/urban_goodz/domain/models/book_anything_record_model.dart`
- `lib/features/urban_goodz/domain/models/urban_goodz_event_model.dart`
- `lib/features/urban_goodz/domain/services/events_api_service.dart`

## Files Changed

- `lib/util/app_constants.dart`
- `lib/features/urban_goodz/domain/services/earn_money_api_service.dart`
- `lib/features/urban_goodz/domain/services/logistics_api_service.dart`
- `lib/features/urban_goodz/domain/services/medical_courier_api_service.dart`
- `lib/features/urban_goodz/domain/services/booking_api_service.dart`

## Endpoint Constants Updated

- `ugEarnMoneyOpportunitiesUri = /api/v1/urban-goodz/earn-money/opportunities`
- `ugLogisticsJobsUri = /api/v1/urban-goodz/logistics/jobs`
- `ugLoadBoardLoadsUri = /api/v1/urban-goodz/load-board/loads`
- `ugMedicalCourierJobsUri = /api/v1/urban-goodz/medical-courier/jobs`
- `ugBookAnythingRecordsUri = /api/v1/urban-goodz/book-anything/records`
- `ugBookAnythingRequestUri = /api/v1/urban-goodz/book-anything/request`
- `ugEventsUri = /api/v1/urban-goodz/events`

## Services Ready

- `EarnMoneyApiService`
  - `getOpportunities()`
  - `getOpportunity(record)`
  - `acceptOpportunity(record)`
- `LogisticsApiService`
  - `getJobs()`
  - `getJob(record)`
  - `acceptJob(record)`
  - `updateJobStatus(record, status)`
  - `getLoads()`
  - `getLoad(record)`
  - `acceptLoad(record)`
  - `updateLoadStatus(record, status)`
- `MedicalCourierApiService`
  - `getJobs()`
  - `getJob(record)`
  - `acceptJob(record)`
  - `updateJobStatus(record, status)`
  - `updateCustody(record, custody)`
- `BookingApiService`
  - `getBookAnythingRecords()`
  - `getBookAnythingRecord(record)`
  - `submitBookAnythingRequest(request)`
- `EventsApiService`
  - `getEvents()`
  - `getEvent(record)`
  - `expressInterest(record)`
  - `requestVendorOpportunity(record, body)`
  - `requestCreatorOpportunity(record, body)`
  - `requestLogisticsSupport(record, body)`

## Screens Ready

- `EarnMoneyScreen` is partially wired because it already calls `EarnMoneyApiService().getOpportunities()`.
- Logistics / Load Board, Medical Courier, Book Services, and Local Events screens remain static placeholders and need UI wiring to the new services.

## Routes / Menu Patches Needed Later

- No route/menu files were changed in this pass.
- Later route/menu integration likely needs controlled updates to:
  - `lib/helper/route_helper.dart`
  - `lib/features/menu/screens/menu_screen.dart`
- Add detail screens or action sheets before wiring accept/status/custody actions into navigation.

## Backend Route Assumptions

- All listed endpoints are under `/api/v1` for the customer Flutter app, matching the existing 6amMart ApiClient pattern.
- List endpoints may return either a JSON list or an object with one of these list keys: `data`, `records`, `opportunities`, `jobs`, `loads`, or `events`.
- POST action endpoints accept JSON bodies; empty action bodies are sent as `{}` where no extra data is required.

## Testing Checklist

- Verify Earn Money list loads live opportunities instead of placeholder data.
- Verify empty API lists render gracefully in `EarnMoneyScreen`.
- Verify accept endpoints require expected auth state and return usable success/error responses.
- Wire and test Logistics Jobs list/detail/action UI.
- Wire and test Load Board list/detail/action UI.
- Wire and test Medical Courier list/detail/status/custody UI.
- Wire and test Book Anything records and request submission UI.
- Wire and test Events interest, vendor, creator, and logistics support actions.
- Confirm no protected visual baseline, module artwork, Favorites, Rental visibility, checkout/cart/auth behavior changed.
