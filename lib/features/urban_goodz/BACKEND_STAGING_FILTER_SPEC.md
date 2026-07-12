# Backend Staging Filter Implementation Spec

**Date:** July 9, 2026
**Status:** Ready for backend team
**Goal:** Prevent staging/test records from reaching client apps via API responses

---

## Problem

431 staging candidate records exist in the backend database. The Flutter customer app has **zero client-side filtering** — all 23 category/store/item API endpoints return unfiltered data directly to the UI. Staging records will be visible to safe testers and production users.

---

## Solution

Add a `status` field to all content tables and filter out non-published records at the API query level.

---

## 1. Database Schema Changes

### Categories Table
```sql
ALTER TABLE categories ADD COLUMN status ENUM('draft', 'staging', 'published') DEFAULT 'published';
CREATE INDEX idx_categories_status ON categories(status);
```

### Stores Table
```sql
ALTER TABLE stores ADD COLUMN status ENUM('draft', 'staging', 'published') DEFAULT 'published';
CREATE INDEX idx_stores_status ON stores(status);
```

### Items Table
```sql
ALTER TABLE items ADD COLUMN status ENUM('draft', 'staging', 'published') DEFAULT 'published';
CREATE INDEX idx_items_status ON items(status);
```

### Migration Note
- All existing records should be set to `published` by default
- Only explicitly marked records should be `staging` or `draft`
- Run: `UPDATE categories SET status = 'published' WHERE status IS NULL;` (and same for stores, items)

---

## 2. API Endpoint Changes

Every endpoint that returns categories, stores, or items must add `WHERE status = 'published'` to its query.

### Category Endpoints (6)

| Endpoint | Current Query | Required Change |
|----------|--------------|-----------------|
| `GET /api/v1/categories` | `SELECT * FROM categories` | Add `WHERE status = 'published'` |
| `GET /api/v1/categories/childes/$id` | `SELECT * FROM categories WHERE parent_id = $id` | Add `AND status = 'published'` |
| `GET /api/v1/categories/items/$id` | `SELECT * FROM items WHERE category_id = $id` | Add `AND status = 'published'` |
| `GET /api/v1/categories/stores/$id` | `SELECT * FROM stores WHERE category_id = $id` | Add `AND status = 'published'` |
| `GET /api/v1/categories/featured/items` | `SELECT * FROM items WHERE featured = 1` | Add `AND status = 'published'` |
| `GET /api/v1/categories/popular` | `SELECT * FROM categories ORDER BY popularity` | Add `WHERE status = 'published'` |

### Store Endpoints (8)

| Endpoint | Current Query | Required Change |
|----------|--------------|-----------------|
| `GET /api/v1/stores/get-stores/$filter` | `SELECT * FROM stores` | Add `WHERE status = 'published'` |
| `GET /api/v1/stores/popular` | `SELECT * FROM stores ORDER BY popularity` | Add `WHERE status = 'published'` |
| `GET /api/v1/stores/latest` | `SELECT * FROM stores ORDER BY created_at DESC` | Add `WHERE status = 'published'` |
| `GET /api/v1/stores/top-offer-near-me` | `SELECT * FROM stores WHERE top_offer = 1` | Add `AND status = 'published'` |
| `GET /api/v1/stores/get-stores/all?featured=1` | `SELECT * FROM stores WHERE featured = 1` | Add `AND status = 'published'` |
| `GET /api/v1/customer/visit-again` | `SELECT * FROM stores` (via customer visit) | Add `AND status = 'published'` |
| `GET /api/v1/stores/details/$id` | `SELECT * FROM stores WHERE id = $id` | Add `AND status = 'published'` |
| `GET /api/v1/stores/recommended` | `SELECT * FROM stores` | Add `WHERE status = 'published'` |

### Item Endpoints (7)

| Endpoint | Current Query | Required Change |
|----------|--------------|-----------------|
| `GET /api/v1/items/latest` | `SELECT * FROM items` | Add `WHERE status = 'published'` |
| `GET /api/v1/items/popular` | `SELECT * FROM items ORDER BY popularity` | Add `WHERE status = 'published'` |
| `GET /api/v1/items/most-reviewed` | `SELECT * FROM items ORDER BY reviews` | Add `WHERE status = 'published'` |
| `GET /api/v1/items/discounted` | `SELECT * FROM items WHERE discount > 0` | Add `AND status = 'published'` |
| `GET /api/v1/items/recommended` | `SELECT * FROM items` | Add `WHERE status = 'published'` |
| `GET /api/v1/items/basic` | `SELECT * FROM items WHERE module_type = 'basic'` | Add `AND status = 'published'` |
| `GET /api/v1/items/details/$id` | `SELECT * FROM items WHERE id = $id` | Add `AND status = 'published'` |

### Search Endpoints (2)

| Endpoint | Current Query | Required Change |
|----------|--------------|-----------------|
| `GET /api/v1/items/search` | `SELECT * FROM items WHERE name LIKE ...` | Add `AND status = 'published'` |
| `GET /api/v1/stores/search` | `SELECT * FROM stores WHERE name LIKE ...` | Add `AND status = 'published'` |

### Other Endpoints (3)

| Endpoint | Current Query | Required Change |
|----------|--------------|-----------------|
| `GET /api/v1/common-condition` | `SELECT * FROM conditions` | Add `WHERE status = 'published'` (if table has status) |
| `GET /api/v1/common-condition/items/$id` | `SELECT * FROM items WHERE condition_id = $id` | Add `AND status = 'published'` |
| `GET /api/v1/banners/$storeId` | `SELECT * FROM banners WHERE store_id = $id` | Add `AND status = 'published'` (if table has status) |

---

## 3. Admin Panel Changes

### Category Management
- Add "Status" column to categories list view (badge: draft=gray, staging=yellow, published=green)
- Add status dropdown to category create/edit form
- Add status filter tabs: All | Draft | Staging | Published

### Store Management
- Add "Status" column to stores list view
- Add status dropdown to store create/edit form
- Add status filter tabs

### Item Management
- Add "Status" column to items list view
- Add status dropdown to item create/edit form
- Add status filter tabs

### Bulk Actions
- Add "Mark as Staging" / "Mark as Published" bulk action to all three list views
- Add "Export Staging Records" option for audit purposes

---

## 4. Safe Tester Override (Optional)

For safe testers who need to see staging records, add a query parameter:

```
GET /api/v1/categories?include_staging=true
GET /api/v1/stores/popular?include_staging=true
GET /api/v1/items/popular?include_staging=true
```

**Implementation:**
```php
// In each controller
$query = $query->where('status', 'published');
if (request('include_staging') === 'true' && auth()->user()->role === 'safe_tester') {
    $query = $query->whereIn('status', ['published', 'staging']);
}
```

**Security:** Only users with `safe_tester` role can use this override. Regular users get `published` only regardless of the parameter.

---

## 5. Response Format Change

No client-side changes needed. The API response format stays the same — records with `status: 'staging'` simply won't be included in responses.

If you want to expose the status field in the response (for future client-side use):

```json
{
  "id": 1,
  "name": "Fashion & Apparel",
  "status": "published",
  "image": "...",
  "slug": "fashion-apparel"
}
```

The Flutter models already ignore unknown fields, so adding `status` to the response won't break anything.

---

## 6. Testing Checklist

After deployment, verify:

- [ ] `GET /api/v1/categories` returns only `status = 'published'` records
- [ ] `GET /api/v1/stores/popular` returns only `status = 'published'` stores
- [ ] `GET /api/v1/items/popular` returns only `status = 'published'` items
- [ ] `GET /api/v1/categories/1/items` returns only `status = 'published'` items
- [ ] `GET /api/v1/stores/details/1` returns 404 or empty for `status = 'staging'` stores
- [ ] `GET /api/v1/items/details/1` returns 404 or empty for `status = 'staging'` items
- [ ] Search endpoints exclude staging records
- [ ] Admin panel shows status column and filter tabs
- [ ] `?include_staging=true` works for safe_tester role users only
- [ ] Regular users cannot access staging records even with `?include_staging=true`

---

## 7. Rollback Plan

If issues arise after deployment:

1. Remove `WHERE status = 'published'` from all queries
2. OR set all records to `published`: `UPDATE categories, stores, items SET status = 'published';`
3. Redeploy

The `status` column can remain in the schema — it won't cause issues if unfiltered.

---

## 8. Timeline Recommendation

| Task | Effort | Priority |
|------|--------|----------|
| DB migration (add status column) | 30 min | P0 |
| Backend query filters (23 endpoints) | 2-3 hours | P0 |
| Admin panel status UI | 2-3 hours | P1 |
| Safe tester override | 1 hour | P2 |
| Testing | 1 hour | P0 |

**Total estimated effort:** 6-8 hours

**Target:** Complete before safe tester APK distribution.
