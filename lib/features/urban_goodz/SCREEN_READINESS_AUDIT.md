# Urban Goodz Screen Readiness Audit & UI Polish Plan

This document audits the compiler status, data connectivity, state safety, visual consistency, and route readiness for all ten Urban Goodz feature screens.

---

## 1. Screen Audit Profiles

### EarnMoneyScreen (`earn_money_screen_placeholder.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Calls `EarnMoneyApiService().getOpportunities()` live backend calls.
3. **State Safety**: **Polished**. Handled loading state, API failure errors (`snapshot.hasError`), and empty state lists (`opportunities.isEmpty`).
4. **Branding**: Uses `AppConstants.ugBlack` and `AppConstants.seasoningOrange`.
5. **Safe to Expose?**: Yes.
6. **Needs Polish?**: Already polished.

### LogisticsLoadBoardScreen (`logistics_load_board_screen_placeholder.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Uses static placeholder list.
3. **State Safety**: Display static rows with `_PreviewBanner` alert.
4. **Branding**: Uses `AppConstants.canvas` and `AppConstants.seasoningOrange`.
5. **Safe to Expose?**: Yes, as preview model only.
6. **Needs Polish?**: Needs live API binding to `LogisticsApiService().getLoads()` later.

### MedicalCourierScreen (`medical_courier_screen_placeholder.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Static placeholder data.
3. **State Safety**: Lists static items with HIPAA caution banner.
4. **Branding**: Uses `AppConstants.seasoningOrange` accents.
5. **Safe to Expose?**: Yes, as preview model only.
6. **Needs Polish?**: Needs live API binding to `MedicalCourierApiService().getJobs()` later.

### BookServicesScreen (`book_services_screen_placeholder.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Static placeholder data.
3. **State Safety**: Displays static coming soon list.
4. **Branding**: Standard theme.
5. **Safe to Expose?**: Yes, as preview model only.
6. **Needs Polish?**: Needs live API binding to `BookingApiService().getBookAnythingRecords()` later.

### LocalEventsCreatorsScreen (`local_events_creators_screen.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Static placeholder data.
3. **State Safety**: Tapping items triggers app searches for event titles.
4. **Branding**: Uses standard theme styling.
5. **Safe to Expose?**: Yes.
6. **Needs Polish?**: Needs live API binding to `EventsApiService().getEvents()` later.

### CommunityMarketplaceScreen (`community_marketplace_screen_placeholder.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Static placeholder.
3. **State Safety**: Lists static preview cards.
4. **Branding**: Standard theme.
5. **Safe to Expose?**: Yes, as preview model only.
6. **Needs Polish?**: Needs community post API wiring later.

### CreatorCommerceScreen (`creator_commerce_screen_placeholder.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Static placeholder.
3. **State Safety**: Static preview list.
4. **Branding**: Standard theme.
5. **Safe to Expose?**: Yes, as preview model only.
6. **Needs Polish?**: Needs shoppable reels API integration later.

### UrbanGoodzAiScreen (`urban_goodz_ai_screen.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Static guided prompts mapping to search and taxi routes.
3. **State Safety**: Handled safely.
4. **Branding**: Primary color schema.
5. **Safe to Expose?**: Yes.
6. **Needs Polish?**: Needs real AI chat backend integration later.

### UrbanGoodzPlusScreen (`urban_goodz_plus_screen.dart`)
1. **Compiles?**: Yes.
2. **Connectivity**: Static waitlist submission.
3. **State Safety**: Static list of benefits.
4. **Branding**: Standard theme.
5. **Safe to Expose?**: Yes.
6. **Needs Polish?**: Needs actual subscription billing and user tier check bindings later.

---

## 2. Expose Readiness Summary

* **Safe to Expose Now**:
  * **Earn Money** (Data-bound and fully state-safe).
  * **Logistics & Load Board** (Ready as static preview).
  * **Medical Courier** (Ready as static preview).
  * **Book Services** (Ready as static preview).
  * **Events & Creators** (Ready as interactive search links).
  * **Urban Goodz AI / Plus** (Ready as guided/waitlist interfaces).
* **Do NOT Expose Yet**:
  * **Fashion Measurements** (Needs to remain hidden / architecture-only until alteration endpoints are fully live).

---

## 3. UI Polish Applied
* Modified `FutureBuilder` inside `EarnMoneyScreen` to handle `ConnectionState.waiting`, `snapshot.hasError` (renders a red error icon with retry-later instructions), and `opportunities.isEmpty` (renders a clean search-empty state description).
