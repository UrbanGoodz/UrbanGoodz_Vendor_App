# VENDOR PRODUCTION PROMOTION — COMPLETE

Date: 2026-08-09
Status: **PROMOTED**

## Summary

| Field | Value |
|---|---|
| Old production SHA | `4b8323d0af096620f7a2cdd71d8b06153a645856` |
| New production SHA | `eb5ddea7e8314eeac931433584bc7e4b0c57428b` |
| Promotion timestamp | 2026-08-09 (local), push `4b8323d..eb5ddea` exit 0 |
| Branch promoted | `origin/vendor-driver-tester-sprint` → `vendor-origin/main` |
| Promotion type | Fast-forward (no merge, no squash, no rewrite, no force) |
| Post-push state | `vendor-origin/main = eb5ddea…`; 36 ahead / 0 behind (no divergence); fetch confirmed |

## Pre-Promotion Gates (all PASSED)

- `flutter pub get` — PASS
- `flutter analyze` — PASS (No issues found, Flutter 3.44.6 / Dart 3.12.2)
- `flutter test` — PASS (53/53: api_client, feature_contract, dashboard_chart, login_contract, realtime_contract, password_reset, widget, signup_entry)
- Release APK build — PASS (`app-release.apk`, 57.7 MB, Gradle assembleRelease 947.1s)
- Signing verification — PASS (apksigner SHA-256 `f531915630dbb0fc1aec9b2540b73ff8438cc33b88b452f2bd9751ec4b59a7b5` matches upload keystore)
- Package ID — PASS (`com.urbangoodz.vendor`, versionName `3.9.3`, versionCode `10` = 3.9.3+10)
- Realtime — safely disabled (no production Pusher keys; `isConfigured == false`, fails closed)

## APK Artifact

- Path: `build/app/outputs/flutter-apk/app-release.apk` (gate worktree `C:\UG\vendor-promotion-gate-20260809`)
- Archived: `C:\UG\evidence\vendor-release\apk\app-release-eb5ddea-v3.9.3+10.apk` (60,488,169 bytes)
- Package: `com.urbangoodz.vendor`; Version: `3.9.3+10`; Signature: matches upload keystore (verified on archived copy)

## Smoke Test

**Physical smoke test unavailable** — no Android device or emulator/AVD present (`adb devices` empty, no AVDs). Not blocking. Static verification complete (valid signature, correct package/SDK, minSdk 24 / targetSdk 36). Perform one physical-device smoke install at rollout: app launches, vendor login works, dashboard/orders/payment screens load, no startup crash.

## Rollback Procedure

Fast-forward promotion → rollback is a single forced reset; no reverse merge, no data loss.

```
git -C "C:\Users\D'Andre Good\Documents\GitHub\UrbanGoodz2026-Revised" fetch vendor-origin
git -C "C:\Users\D'Andre Good\Documents\GitHub\UrbanGoodz2026-Revised" push --force vendor-origin 4b8323d0af096620f7a2cdd71d8b06153a645856:main
git -C "C:\Users\D'Andre Good\Documents\GitHub\UrbanGoodz2026-Revised" fetch vendor-origin   # expect 4b8323d…
```

Rollback point recorded: `4b8323d0af096620f7a2cdd71d8b06153a645856`. Candidate remains intact on `origin/vendor-driver-tester-sprint` for re-promotion. No DB migrations in this release; package-ID change requires uninstall of the old vendor app before installing the new build.

## Remaining Risks

1. **No physical device smoke test** — static verification only; one install/launch on a real Android device recommended at rollout.
2. **`origin` remote authentication** — the private monorepo remote rejects the stored PAT ("Invalid username or token"); GCM store holds no valid github.com credential. `origin` fetch was not possible this session. Re-authenticate before the next cross-repo release. Push to `vendor-origin` succeeded after a one-time interactive GCM login.
3. **Realtime deferred** — Pusher realtime shipped disabled. Enable only with production `UG_PUSHER_APP_KEY`/`UG_PUSHER_APP_CLUSTER` via `--dart-define`, then soak on `private-ug.vendor.<id>.orders` / `private-ug.payment.vendor.<id>.statuses` before flipping.
4. **Signing key custody** — `key.properties`/`upload-keystore.jks` are gitignored and exist only on this build host (recovered from the driver-card worktree). Back them up off-host before they are lost.

## Attestation

- Verified candidate SHA `eb5ddea…` was pushed to `vendor-origin/main` (fast-forward, no force), confirmed by post-push fetch.
- APK archived from the clean worktree at exactly the promoted SHA.
- Promotion performed end-to-end by the Release Manager/Deployment Engineer; no production data or client devices affected.
