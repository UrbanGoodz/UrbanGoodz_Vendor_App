Urban Goodz Customer Tester RC1

APK:
outputs/UrbanGoodz_Customer_Tester_RC1.apk

Build type:
debug fallback

Backend:
https://admin.urbangoodzdelivery.com

Tester focus:
- Sign in or continue through the available customer flow.
- Confirm Urban Goodz home branding loads.
- Check Order Anywhere request, review, and status screens.
- Check Fashion Fit measurement profile, intake, photo guide, and stylist request flows.
- Confirm push notification permission prompts and customer notification screen behavior where device permissions allow it.

Known blocker:
Release build did not complete in this environment. It first failed in Android lint with a google_maps_flutter_android lint Metaspace error, then after disabling release lint it failed Jetifier transforms on Flutter release engine jars with Java heap space, and a final release retry timed out after 10 minutes. Debug APK was built successfully for internal smoke testing.
