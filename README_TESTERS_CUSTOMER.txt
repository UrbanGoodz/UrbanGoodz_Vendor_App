Urban Goodz Customer Tester RC2

APK:
outputs/UrbanGoodz_Customer_Tester_RC2.apk

Application ID:
com.urbangoodz.customer

Build type:
debug fallback

Backend:
https://admin.urbangoodzdelivery.com

Install notes:
- Uninstall any previous Urban Goodz tester build if Android reports an install conflict.
- RC1 used com.sixamtech.sixam_mart_user. RC2 uses com.urbangoodz.customer, so RC1 and RC2 may install as separate apps.
- Allow location and notification permissions when prompted.
- Select a service zone/location before testing home, stores, products, cart, checkout entry, and Urban Goodz flows.

Tester focus:
- Startup, splash, location/zone selection, login, registration, and password reset.
- Home, store list, product list, prices, store details, search, categories, cart, and checkout entry.
- Order Anywhere request, review, and status screens.
- Fashion Fit measurement profile, intake, photo guide, and stylist request flows.
- AI Concierge, Creator/Reels, notifications, and support/contact.

Provider limitations:
- Firebase Android configuration is not ready for RC2 until android/app/google-services.json is replaced with a Firebase Android app registered for com.urbangoodz.customer.
- Google Sign-In, Firebase Auth phone/reCAPTCHA, Firebase Messaging, Crashlytics, and provider-side notification delivery may require package/SHA updates before production testing.
- Google Maps and Android app links may require provider console/domain assetlinks updates for com.urbangoodz.customer.
- Facebook login may require Android package and key-hash updates in the Meta developer console.
- Apple sign-in callback was migrated to the new Android package namespace, but provider callback configuration should be rechecked.

Payment warning:
- Do not use real payments unless explicitly instructed by the project owner.
- Order Anywhere payment UI is tester-only unless backend payment/reconciliation is confirmed live.

Known blockers:
- Release build timed out in this environment after 15 minutes, so RC2 was produced from a successful direct Gradle debug assemble.
- Firebase provider file replacement path: android/app/google-services.json

Checksum:
SHA-256 9BD952095241B3CEEEBE92B54FCC89286C521094EB9A8A3FC138CD2401BCB59E

Bug report format:
- Device model and Android version
- APK filename and application ID
- Test account or guest mode
- Location/zone selected
- Screen and action taken
- Expected result
- Actual result
- Screenshot or screen recording if available
