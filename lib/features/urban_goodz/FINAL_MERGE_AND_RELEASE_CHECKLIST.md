# Urban Goodz Final Merge & Release Checklist

This checklist defines the steps, merge sequences, conflict scopes, and QA verification points for integrating all Urban Goodz feature branches into the main workspace.

---

## 1. Feature Branches to Merge
* **`fix/base-url-home-landing`**: Base URL load order and cache policies.
* **`feature/discovery-search-capture`**: Inline demand/search capture widget inside search views.
* **`feature/opportunity-logistics-medical`**: Opportunity network models, API services, list views, and routing.
* **`feature/fashion-measurements-planning`**: *Architecture-only*. Keep this branch isolated from live menus or navigation pathways for now.

---

## 2. Integrated Commits Reference
* `d928cd689624c778cd48c5b1582ed240bdf6c4f8`: Base URL configuration loading order fix.
* `e936938917b0ffd786c3e7dacea94e50307583ec`: Discovery empty state capture frontend widget.
* `5f3686efd88dbe1e8851b502dfa43ff1ec93b57b`: Opportunity, Logistics, and Medical Courier API bindings.
* `c6919f3a7d676d4078af4917fd06fe42deed2c6a`: Route & menu initial planning documentation.
* `4975857e4e138a4cd5596328c11e3b6eb4ee47be`: Final route/menu execution patch guide.
* `af1ddb593158d00e16ccc9f70e22971a2a071a61`: Custom alterations and fashion sizing package (arch-only).

---

## 3. High-Risk Conflict Files

> [!WARNING]
> Exercise extreme care during merges. Resolve conflicts line-by-line in the following files:
> * **`lib/util/app_constants.dart`**: High merge conflict risk. Both Discovery and Opportunity branches added endpoint URLs at line 368.
> * **`lib/helper/route_helper.dart`**: Ensure all RouteHelper getters and GetPage blocks for all custom modules are preserved.
> * **`lib/features/menu/screens/menu_screen.dart`**: Merge list items in the drawer menu carefully to avoid dropping options.
> * **`lib/features/dashboard/screens/dashboard_screen.dart`**: Merge bottom navigation and tab callbacks safely.

---

## 4. Deployed Live Backend Status
The backend APIs and routes have been successfully updated and cached on the live administration panel:
* **Discovery Routes**: Active and live.
* **Opportunity / Logistics / Medical / Events / Bookings Routes**: Active and live.

### Live Route Verification URLs (GET):
* **Earn Money Opportunities**:
  `https://admin.urbangoodzdelivery.com/api/v1/urban-goodz/earn-money/opportunities`
* **Local Events & Creators**:
  `https://admin.urbangoodzdelivery.com/api/v1/urban-goodz/events`

---

## 5. Integration Execution Sequence

Follow this sequence when Codex is available:
1. **Prepare Integration Branch**: Checkout a new branch `feature/urban-goodz-sprint-integration` from the latest production baseline.
2. **Merge Base URL Fix**: Run `git merge fix/base-url-home-landing`.
3. **Merge Discovery**: Run `git merge feature/discovery-search-capture`.
4. **Merge Opportunity**: Run `git merge feature/opportunity-logistics-medical`.
5. **Resolve Conflicts**: Carefully align the endpoint blocks in `app_constants.dart`.
6. **Apply Menu Patch**: Expose the remaining PortionWidgets in `menu_screen.dart` (as outlined in `ROUTE_MENU_MANUAL_PATCH.md`).
7. **Validate Code Health**: Run `flutter analyze` and resolve any analyzer or compile warnings.
8. **Staging Build**: Compile the release bundle (`flutter build web --release --base-href /`), restore configuration backups, and compress to the final ZIP.
9. **Deploy Staging**: Push the compiled ZIP to the visual tester server.
10. **QA Run**: Validate all new routes and listings in the live staging environment.
11. **Commit & Push**: Finalize and push the consolidated integration branch.

---

## 6. Critical Release Rules

> [!CAUTION]
> * **No Live Fashion Menu**: Do **not** expose the Fashion Measurements feature in the drawer menu or main app routing yet. It must remain architecture-only.
> * **No ZIP Commit**: Do **not** commit the compiled staging `urban-goodz-tester-web-build.zip` output to git history unless explicit project rules dictate it.
> * **No Visual Baseline Overwrites**: Do **not** modify or overwrite the verified hero banner, module category category tiles, or store fallback watermarks.
> * **No Parallel Builds**: Do **not** run multiple compiler or build tasks simultaneously to avoid disk lock contention.
