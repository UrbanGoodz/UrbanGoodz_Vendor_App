# driver_app/ was removed from this repo

This repo carried a stale duplicate of the Urban Goodz **driver** app.

**Authoritative source:**
`UrbanGoodz_Driver_App/driver_app` (package `urban_goodz_driver`)

## Why it was removed

It was measurably behind, and the gap was not cosmetic:

| copy | dart files | has `lib/utils/json_number.dart` |
|---|---|---|
| `UrbanGoodz_Driver_App/driver_app` — authoritative | 69 | yes |
| `UrbanGoodz_Vendor_App/driver_app` — removed | 59 | no |

`json_number.dart` is the fix for the crash that took down the Assigned
Dedicated Routes screen: PHP serialises MySQL `DECIMAL` columns as JSON
*strings*, so `pickup_lat` arrives as `"29.7604000"` and a bare `as num?` cast
throws `type 'String' is not a subtype of type 'num?' in type cast`. That
screen sits upstream of the package manifest, so with it dead, scanning was
unreachable regardless of the camera.

A copy without that fix is not a slightly older driver app. It is a driver app
whose dedicated-routes feature does not work, sitting in a repo where someone
could reasonably mistake it for the real one and build from it. That has
already happened once in this project: the only signed vendor APK on the build
machine had been built from the *stalest* of three vendor copies.

## The layout that causes this

The repo root here is the 6amtech **customer** template, with the real vendor
app nested at `vendor_app/`. Because the root looks like an app, sibling app
directories get added next to it and drift. The same shape produced three
copies of the vendor app; `UrbanGoodz_Driver_App` removed its stale
`vendor_app` in `8996933` for the same reason, and left a matching
`VENDOR_APP_MOVED.md`.

The layout itself is unchanged and will keep inviting this until the real apps
are moved out of template roots.

## If you need the removed copy

It is in git history, not lost:

```
git log --oneline --all -- driver_app
git checkout <commit> -- driver_app
```
