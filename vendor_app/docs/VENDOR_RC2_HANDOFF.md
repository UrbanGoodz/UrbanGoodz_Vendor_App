# Urban Goodz Vendor RC2 Handoff

Build date: 2026-07-12

- Package: `com.urbangoodz.vendor`
- Version: `1.1.0+2`
- Backend: `https://admin.urbangoodzdelivery.com/api/v1`
- Artifact: `UrbanGoodz_Vendor_Tester_2026-07-12_RC2.apk`
- Size: 54,219,174 bytes
- SHA-256: `7A9F07524454519A1C6E067699B9000120CDB1F9FB24535CCAEB36AA8E4A1D89`
- Firebase Android client package: `com.urbangoodz.vendor`
- Mock repository/runtime flag: absent

## Implemented Vendor surfaces

Login/session restore/logout, approval states, store profile/status, products with multipart image create/edit, inventory, order lifecycle, wallet/withdrawals, FCM registration and token refresh, notifications, support conversations, Fashion Fit approved-measurement requests/estimates, service-provider profile/services/availability/bookings/earnings, Creator profile/reel multipart upload/moderation/revenue, real coupons, reviews, and order-derived analytics.

All screens expose loading, empty, API error/retry, and expired-token behavior through the shared authenticated client. Server authorization remains authoritative.

## Verification

- `flutter pub get`: PASS
- `dart format lib test`: PASS
- `flutter analyze`: PASS, no issues
- `flutter test`: PASS, 9 tests
- Release APK: PASS
- AAPT package/version/Internet permission: PASS
- Firebase package match: PASS
- Install/launch: NOT RUN — no ADB device or emulator attached

AGP 9.0.1 repeatedly exhausted 2–4 GB of Metaspace inside Android lint while analyzing Flutter plugin bytecode. The build skips release-lint invocation after clean Flutter analysis/tests; explicit lint remains configured to abort on errors. This toolchain workaround must be re-evaluated when AGP/Flutter plugins are upgraded.

## Controlled tester procedure

1. Verify the APK SHA-256.
2. Install with the Android SDK `adb install -r UrbanGoodz_Vendor_Tester_2026-07-12_RC2.apk`.
3. Launch `com.urbangoodz.vendor` and sign in with an approved test Vendor.
4. Confirm the profile/store identity, real products, orders, wallet, notifications, and support.
5. Complete the controlled commerce order lifecycle.
6. For an approved Fashion Fit provider, open the Fashion Fit order tab, verify only customer-approved measurements appear, submit an estimate, and complete after sandbox payment.
7. For an approved service provider, configure profile/services/availability, quote a test booking, progress it through completion, and verify earnings.
8. For an approved creator, upload a real video/thumbnail, tag a store-owned product, submit for moderation, and verify attributed test commerce after Admin approval.
9. Record screenshots and server-side audit/ledger/notification IDs without exposing tokens or customer-sensitive data.
