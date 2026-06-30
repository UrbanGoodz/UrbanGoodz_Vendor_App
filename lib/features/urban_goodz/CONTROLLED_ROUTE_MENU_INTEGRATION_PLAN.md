# Urban Goodz Route & Menu Integration Plan

This plan details the safe integration steps, route mappings, menu registrations, endpoint mappings, and safety guidelines required to expose Urban Goodz custom features later when Codex is available.

---

## 1. Current Available Urban Goodz Screens

These screens are already created in the directory `lib/features/urban_goodz/screens/`:
* `EarnMoneyScreen` (`earn_money_screen_placeholder.dart`): Displays list of income-generating tasks/opportunities.
* `LogisticsLoadBoardScreen` (`logistics_load_board_screen_placeholder.dart`): Renders logistics and carrier loads.
* `MedicalCourierScreen` (`medical_courier_screen_placeholder.dart`): Custom workflows for transport of medical specimens and supplies.
* `BookServicesScreen` (`book_services_screen_placeholder.dart`): Booking and scheduling hub for general custom service offerings.
* `LocalEventsCreatorsScreen` (`local_events_creators_screen.dart`): Event listings, ticketing placeholders, and creator opportunities.
* `BlackOwnedSpotlightScreen` (`black_owned_spotlight_screen.dart`): Highlight carousel of verified black-owned merchants.
* `UrbanGoodzAiScreen` (`urban_goodz_ai_screen.dart`): Voice and text chatbot assistance.
* `UrbanGoodzPlusScreen` (`urban_goodz_plus_screen.dart`): Subscription plan dashboard.
* `CommunityMarketplaceScreen` (`community_marketplace_screen_placeholder.dart`): Neighborhood-centric trade listings.
* `CreatorCommerceScreen` (`creator_commerce_screen_placeholder.dart`): Merch showcase for local creators.
* `DiscoveryNoResultsWidget` (`lib/features/urban_goodz/discovery/discovery_no_results_widget.dart`): Demand capture widget rendered inline on search empty states.

---

## 2. Missing Screens & Detail Flows

* **General Discovery Hub**: A dashboard to review and manage all pending Discovery opportunities and search captures in one central screen.
* **Detail Views**: Detail screens for Logistics Jobs, Load Board postings, Medical Courier assignments, and Events. Currently, clicking items in list views displays snackbar popups instead of pushing subroutes.

---

## 3. Recommended Routes & RouteHelper Definitions

The route string names and page registrations are already mapped in `lib/helper/route_helper.dart`:

| Feature Screen | Route Constant | Path String |
| :--- | :--- | :--- |
| **Earn Money** | `RouteHelper.urbanGoodzEarnMoney` | `'/urban-goodz-earn-money'` |
| **Logistics / Jobs** | `RouteHelper.urbanGoodzLogistics` | `'/urban-goodz-logistics'` |
| **Load Board** | `RouteHelper.urbanGoodzLoadBoard` | `'/urban-goodz-load-board'` |
| **Medical Courier** | `RouteHelper.urbanGoodzMedicalCourier` | `'/urban-goodz-medical-courier'` |
| **Book Services** | `RouteHelper.urbanGoodzBookServices` | `'/urban-goodz-book-services'` |
| **Events** | `RouteHelper.localEventsCreators` | `'/local-events-creators'` |
| **Community Marketplace** | `RouteHelper.urbanGoodzCommunityMarketplace` | `'/urban-goodz-community-marketplace'` |
| **Creator Commerce** | `RouteHelper.urbanGoodzCreatorCommerce` | `'/urban-goodz-creator-commerce'` |
| **AI Concierge** | `RouteHelper.urbanGoodzAI` | `'/urban-goodz-ai'` |
| **Urban Goodz Plus** | `RouteHelper.urbanGoodzPlus` | `'/urban-goodz-plus'` |
| **Black-Owned Spotlight** | `RouteHelper.blackOwnedSpotlight` | `'/black-owned-spotlight'` |

---

## 4. Current AppConstants API Endpoints

The following constants are mapped in `lib/util/app_constants.dart` for the backend client services:
* `AppConstants.ugEarnMoneyOpportunitiesUri` -> `'/api/v1/urban-goodz/earn-money/opportunities'`
* `AppConstants.ugLogisticsJobsUri` -> `'/api/v1/urban-goodz/logistics/jobs'`
* `AppConstants.ugLoadBoardLoadsUri` -> `'/api/v1/urban-goodz/load-board/loads'`
* `AppConstants.ugMedicalCourierJobsUri` -> `'/api/v1/urban-goodz/medical-courier/jobs'`
* `AppConstants.ugBookAnythingRecordsUri` -> `'/api/v1/urban-goodz/book-anything/records'`
* `AppConstants.ugBookAnythingRequestUri` -> `'/api/v1/urban-goodz/book-anything/request'`
* `AppConstants.ugEventsUri` -> `'/api/v1/urban-goodz/events'`
* `AppConstants.ugDiscoverySearchCaptureUri` -> `'/api/v1/urban-goodz/discovery/search-capture'`
* `AppConstants.ugDiscoveryEntitiesUri` -> `'/api/v1/urban-goodz/discovery/entities'`
* `AppConstants.ugDiscoveryOpportunitiesUri` -> `'/api/v1/urban-goodz/discovery/opportunities'`

---

## 5. Future File Edit Scope

### Files to EDIT:
* `lib/features/menu/screens/menu_screen.dart`: Needs `PortionWidget` additions to expose missing screens (Events, Community Marketplace, Creator Commerce, AI, Plus) in the Drawer.
* `lib/features/dashboard/screens/dashboard_screen.dart`: Edit if adding bottom navigation shortcuts for opportunities or earning hubs.

### Files to NOT touch:
* `lib/features/urban_goodz/fashion_measurements/`: Must remain architecture-only. Do NOT link fashion measurements into menus or route navigation helper methods.
* Core authentication, store checkouts, favorites, base URL configuration, and network cache files.

---

## 6. Safe Integration Order
1. **API Validation**: Verify backend endpoints in staging using mock JSON responses, verifying lists handle empty sets without crashing.
2. **Detail Routing**: Create detail widgets for specific Logistics Jobs and Courier tasks, registering them in `RouteHelper`.
3. **Menu Registration**: Add the verified screens to `menu_screen.dart` under the "Urban Goodz" portion block.
4. **Dashboard Banners**: Integrate quick-access cards in the home screens.

---

## 7. QA Verification Checklist
- [ ] Drawer Menu loads all options without overflow or layout shifts.
- [ ] Clicking menu choices opens correct routes and pushes the corresponding widget.
- [ ] Back buttons on custom pages safely return user to previous screen.
- [ ] Access is correctly blocked or prompts login for authenticated endpoints when user is guest.
- [ ] Empty state lists render the correct friendly feedback copy rather than spin loops.

---

## 8. AppConstants Merge Alert

> [!WARNING]
> Both the **Discovery** branch and the **Opportunity Network** features modified `app_constants.dart` around line 368 in parallel. Merging these features into the target branch will require manual line-by-line conflict resolution to ensure both sets of URIs remain active.
