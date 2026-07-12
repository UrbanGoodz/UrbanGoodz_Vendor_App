# Staging Visibility Guard Plan

Audit of client-side data surfaces to identify where staging/test records from the backend could leak to production safe testers.

**Date:** July 9, 2026
**Scope:** All category, store, and item API endpoints and their UI consumers

---

## Executive Summary

**Zero client-side gating exists** to separate staging/test records from production data. All 17+ API endpoints return unfiltered backend responses directly to the UI. Any backend record marked as `draft`, `test`, or `staging` will be visible to safe testers and production users alike.

**Recommended fix:** Backend-side filtering (single point of control). Client-side model/field filtering is a secondary option but requires changes across 6+ repository files.

---

## 1. Vulnerable API Endpoints (17 total)

### Categories (4 endpoints)
| # | Endpoint | Repository File:Line | UI Consumer |
|---|----------|---------------------|-------------|
| 1 | `GET /api/v1/categories` | `category_repository.dart:46` | `category_screen.dart`, `home_screen.dart` |
| 2 | `GET /api/v1/categories/childes/$id` | `category_repository.dart:71` | Sub-category dialogs |
| 3 | `GET /api/v1/categories/items/$id` | `category_repository.dart:81` | `category_item_screen.dart` |
| 4 | `GET /api/v1/categories/stores/$id` | `category_repository.dart:90` | `category_screen.dart` |
| 5 | `GET /api/v1/categories/featured/items` | `item_repository.dart:222` | `home_screen.dart` |
| 6 | `GET /api/v1/categories/popular` | `app_constants.dart:173` | Home search |

### Stores (8 endpoints)
| # | Endpoint | Repository File:Line | UI Consumer |
|---|----------|---------------------|-------------|
| 7 | `GET /api/v1/stores/get-stores/$filter` | `store_repository.dart:58` | `all_store_screen.dart` |
| 8 | `GET /api/v1/stores/popular` | `store_repository.dart:80` | `home_screen.dart`, `popular_store_view.dart` |
| 9 | `GET /api/v1/stores/latest` | `store_repository.dart:104` | `home_screen.dart`, `new_on_mart_view.dart` |
| 10 | `GET /api/v1/stores/top-offer-near-me` | `store_repository.dart:128` | `home_screen.dart`, `top_offers_near_me.dart` |
| 11 | `GET /api/v1/stores/get-stores/all?featured=1` | `store_repository.dart:150` | `home_screen.dart` |
| 12 | `GET /api/v1/customer/visit-again` | `store_repository.dart:178` | `home_screen.dart`, `visit_again_view.dart` |
| 13 | `GET /api/v1/stores/details/$id` | `store_repository.dart:198` | `store_screen.dart` |
| 14 | `GET /api/v1/stores/recommended` | `store_repository.dart:284` | `home_screen.dart` |

### Items (7 endpoints)
| # | Endpoint | Repository File:Line | UI Consumer |
|---|----------|---------------------|-------------|
| 15 | `GET /api/v1/items/latest` | `item_repository.dart` | `store_screen.dart`, `item_view_all_screen.dart` |
| 16 | `GET /api/v1/items/popular` | `item_repository.dart:113` | `home_screen.dart`, `popular_item_screen.dart` |
| 17 | `GET /api/v1/items/most-reviewed` | `item_repository.dart:155` | `home_screen.dart`, `popular_item_screen.dart` |
| 18 | `GET /api/v1/items/discounted` | `item_repository.dart:197` | `home_screen.dart`, `special_offer_view.dart` |
| 19 | `GET /api/v1/items/recommended` | `item_repository.dart:245` | `home_screen.dart`, `just_for_you_view.dart` |
| 20 | `GET /api/v1/items/basic` | `item_repository.dart:26` | `home_screen.dart` |
| 21 | `GET /api/v1/items/details/$id` | `item_repository.dart:52` | `item_details_screen.dart` |

### Search
| # | Endpoint | Repository File:Line | UI Consumer |
|---|----------|---------------------|-------------|
| 22 | `GET /api/v1/items/search` | `category_repository.dart:99` | Search results |
| 23 | `GET /api/v1/stores/search` | `store_repository.dart` | Search results |

---

## 2. Model Fields Available for Filtering

| Model | File | Relevant Fields | Staging Filter? |
|-------|------|----------------|-----------------|
| `CategoryModel` | `category_model.dart` | `id`, `name`, `imageFullUrl`, `slug` | **NONE** |
| `Store` | `store_model.dart` | `active` (bool), `open` (int), `featured` (int) | **NONE** (operational only) |
| `Item` | `item_model.dart` | `stock`, `moduleType`, `status` (sub-model only) | **NONE** |

**None of the three primary models have `is_test`, `is_staging`, `is_published`, or `environment` fields.**

---

## 3. Existing Filtering (None Relevant)

The only filtering in the codebase is operational, not staging-related:
- `StoreController.isOpenNow()` checks `store.open == 1 && store.active` (line 618)
- `ItemController` filter toggles: `available_now`, `top_rated`, `most_loved`, `popular`, `latest` (lines 197-255)
- `ItemRepository` query params: `search`, `category_ids`, `filter`, `rating_count`, `min_price`, `max_price`

---

## 4. Risk Assessment

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Staging categories visible in category grid | **High** — users see test categories | **High** — 431 staging records confirmed in backend | Backend filter or client-side guard |
| Staging stores visible in home/store lists | **High** — users see test stores | **High** | Backend filter or client-side guard |
| Staging items visible in item lists/details | **High** — users see test items, prices, descriptions | **High** | Backend filter or client-side guard |
| Search results include staging records | **Medium** — only if user searches for test terms | **Medium** | Backend filter |
| Staging records in "Featured" or "Popular" lists | **Critical** — highest visibility surfaces | **Medium** — depends on backend ranking | Backend filter |

---

## 5. Recommended Fix Strategy

### Option A: Backend-Side Filtering (RECOMMENDED)
**Single point of control.** Add `WHERE is_staging = 0` or equivalent to all 23 endpoints on the API server.

**Pros:**
- One fix covers all 23 endpoints
- No client-side changes needed
- Immediate effect for all apps (customer + driver)
- Staging records never leave the server

**Cons:**
- Requires backend deploy
- Must coordinate with backend team

**Implementation:**
1. Add `is_staging` (bool) or `status` (enum: `draft`/`staging`/`published`) field to all category, store, and item tables
2. Add filter to all API endpoints: `WHERE status = 'published'` or `WHERE is_staging = 0`
3. Admin panel gets a toggle to view/manage staging records separately
4. Safe tester builds can optionally override this filter via a query param: `?include_staging=1`

### Option B: Client-Side Model Filtering (FALLBACK)
Add `isStaging` or `isPublished` field to client models and filter in each repository method.

**Pros:**
- No backend changes needed immediately
- Works even if backend doesn't filter

**Cons:**
- Requires changes to 6+ repository files (23 endpoints)
- Staging data still transmitted over the network (wasted bandwidth)
- Inconsistent if driver app doesn't apply same filters
- Must be applied to every new endpoint added in the future

**Implementation:**
1. Add `isStaging` field to `CategoryModel`, `Store`, and `Item`
2. In each repository `getList` method, filter: `items.where((i) => !i.isStaging).toList()`
3. Add staging toggle in debug/settings screen for safe testers

### Option C: Hybrid (RECOMMENDED for Sprint)
Backend filter as primary (Option A) + client-side safety net (Option B) as defense-in-depth.

---

## 6. Home Screen Exposure Map

The home screen (`home_screen.dart:88-127`) loads the most surfaces and is the highest-risk entry point:

| Section | Data Source | Staging Risk |
|---------|-------------|-------------|
| Category grid | `GET /api/v1/categories` | **HIGH** |
| Popular items | `GET /api/v1/items/popular` | **HIGH** |
| Best reviewed items | `GET /api/v1/items/most-reviewed` | **HIGH** |
| Special offers | `GET /api/v1/items/discounted` | **HIGH** |
| Just for you | `GET /api/v1/items/recommended` | **HIGH** |
| Latest stores | `GET /api/v1/stores/latest` | **HIGH** |
| Popular stores | `GET /api/v1/stores/popular` | **HIGH** |
| Top offers near me | `GET /api/v1/stores/top-offer-near-me` | **HIGH** |
| Recommended stores | `GET /api/v1/stores/recommended` | **HIGH** |
| Featured stores | `GET /api/v1/stores/get-stores/all?featured=1` | **HIGH** |
| Visit again | `GET /api/v1/customer/visit-again` | **MEDIUM** |
| Basic medicine | `GET /api/v1/items/basic` | **MEDIUM** |
| Common conditions | `GET /api/v1/common-condition` | **LOW** |
| Campaign items | `GET /api/v1/campaign` | **MEDIUM** |

---

## 7. Immediate Safe Tester Mitigations

Before the backend filter is deployed, these client-side guards can reduce exposure:

1. **Home screen loading gate:** Wrap the 14 home sections behind a `if (!_isPreviewMode)` check so staging records only appear when the tester explicitly opts in
2. **Category screen guard:** Add a "Preview Mode" toggle in the category screen that hides staging categories by default
3. **Store/item detail guard:** On store detail and item detail screens, show a "This record may be staging data" banner if the record name contains test/demo markers

These are **temporary** measures. The backend filter (Option A) is the permanent solution.

---

## 8. Backend Admin Panel Considerations

The backend admin panel (`AdminPanel_Update_V39`) should:
1. Visually distinguish staging records (e.g., yellow badge on staging categories/stores/items)
2. Add a "Staging" filter tab to the categories, stores, and items list views
3. Add a "Mark as Staging" toggle on the create/edit forms
4. Prevent staging records from appearing in the default API query unless `include_staging=true` is passed

---

## 9. Testing Checklist

Before safe tester release, verify:
- [ ] No staging categories visible in category grid (default view)
- [ ] No staging stores visible in popular/latest/top-offer lists
- [ ] No staging items visible in item lists or search results
- [ ] Staging records only visible when explicitly toggled on (if client-side guard deployed)
- [ ] Search results exclude staging records by default
- [ ] Store detail pages don't render staging store data
- [ ] Item detail pages don't render staging item data
- [ ] Home screen loads without staging records in any section

---

## 10. Files Requiring Changes (If Client-Side Filter Applied)

| File | Change |
|------|--------|
| `category_model.dart` | Add `isStaging` field |
| `store_model.dart` | Add `isStaging` field to `Store` |
| `item_model.dart` | Add `isStaging` field to `Item` |
| `category_repository.dart` | Filter staging records in 4 methods |
| `store_repository.dart` | Filter staging records in 8 methods |
| `item_repository.dart` | Filter staging records in 7 methods |
| `home_screen.dart` | Optional: hide staging sections in preview mode |
| `category_screen.dart` | Optional: staging guard UI |
| `store_screen.dart` | Optional: staging record banner |
| `item_details_screen.dart` | Optional: staging record banner |

---

## 11. Decision Required

**Question for project owner:** Which fix strategy should be implemented?

- **Option A (Backend filter)** — requires backend team coordination, single deploy
- **Option B (Client filter)** — 10+ file changes across repositories and models
- **Option C (Hybrid)** — both, for defense-in-depth

**Recommendation:** Option A (backend) as the primary fix. Option B is only needed if backend deploy timeline doesn't align with safe tester release.
