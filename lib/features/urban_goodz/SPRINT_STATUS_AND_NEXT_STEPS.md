# Urban Goodz Sprint Status & Next Steps Handoff

This document consolidates the current state of completed commits, live deployment statuses, feature branches, pending integrations, and instructions for the next sprint tasks when Codex is online.

---

## 1. Completed Commits & History

* **Visual Tester Baseline**: Checked in and verified.
* **Base URL / Cache Fix**: `d928cd689624c778cd48c5b1582ed240bdf6c4f8` (Corrected configuration loading order and storage caching logic).
* **Discovery / Search Capture Frontend**: `e936938917b0ffd786c3e7dacea94e50307583ec` (Demand capture and no-results widgets integrated into search pages).
* **Discovery Backend Route**: Deployed live.
* **Opportunity / Logistics / Medical API Wiring**: `5f3686efd88dbe1e8851b502dfa43ff1ec93b57b` (Integrated model classes and data binding services).
* **Route / Menu Integration Planning Docs**: `c6919f3a7d676d4078af4917fd06fe42deed2c6a` (Integration plan and manual patch guides).
* **Fashion / Measurement Architecture**: `af1ddb593158d00e16ccc9f70e22971a2a071a61` (Isolated tailor/alterations fitting models, services, and widgets).

---

## 2. Live Deployment Status

* **Visual Tester**: Running successfully at `test.urbangoodzdelivery.com` with updated hero banner assets.
* **Base URL Cache Policy**: Successfully resolved local config cache misses.
* **Discovery Backend API**: Live and configured. Requests to `/api/v1/urban-goodz/discovery/search-capture` correctly receive and log demand inputs.

---

## 3. Active Feature Branches

* `fix/base-url-home-landing`: Home page base URL configurations.
* `feature/discovery-search-capture`: Inline demand capture widget integration in search.
* `feature/opportunity-logistics-medical`: Logistics, Load Board, Medical Courier, and Event API wiring.
* `feature/fashion-measurements-planning`: Isolated fashion measurements and custom fitting architecture.

---

## 4. Still Pending Tasks

* **Route/Menu Live Integration Execution**: Apply the manual patch guides to expose navigation endpoints in the live UI.
* **Feature Branch Consolidation**: Merge completed feature branches into a unified integration branch.
* **Conflict Resolution**: Resolve parallel edits in `app_constants.dart` between the Discovery and Opportunity/Logistics commits.
* **Active Routing Expose**: Expose Earn Money, Logistics, Load Board, Medical Courier, Book Services/Anything, and Events.
* **Fashion Isolation Enforcement**: Ensure Fashion Measurements is **not** exposed in live routes or drawer menu lists.

---

## 5. Danger Files (Avoid modifying until integration phase)

> [!CAUTION]
> The following files are critical to main routing, authentication, and layout stability. Do NOT modify them until ready to execute the integration patch:
> * `lib/helper/route_helper.dart`
> * `lib/features/menu/screens/menu_screen.dart`
> * `lib/util/app_constants.dart`
> * `lib/features/dashboard/screens/dashboard_screen.dart`
> * `lib/features/splash/controllers/splash_controller.dart`

---

## 6. Next Codex Tasks

1. **Create Integration Branch**: Branch off main or staging.
2. **Merge Features**: Carefully merge `feature/discovery-search-capture` and `feature/opportunity-logistics-medical`.
3. **Resolve Conflicts**: Carefully align the endpoint constants blocks inside `app_constants.dart`.
4. **Apply Patch Guide**: Implement the menu modifications in `menu_screen.dart` as defined in `ROUTE_MENU_MANUAL_PATCH.md`.
5. **Compile & Package**: Run `flutter analyze` and compile the Flutter Web release to verify build health.
6. **Deploy & Stage**: Package the web ZIP output and push updates to the tester staging server.
