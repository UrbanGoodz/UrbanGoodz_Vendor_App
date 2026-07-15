# Fashion Fit Camera Workflow — E2E Test Plan

## Current Implementation Status
All Customer-facing Fashion Fit screens are implemented in `lib/features/urban_goodz/fashion_measurements/`:
- `FashionMeasurementHomeScreen` — Dashboard with action cards (Profile, Photo Guides, Requests, Quotes)
- `FashionMeasurementIntakeScreen` → `MeasurementPhotoGuideScreen` — Guided camera flow
- `MeasurementPhotoGuideScreen` — Full guided capture (consent, calibration height, front/side/back photos with silhouette overlay, preview/retake/delete, confirmed upload, AI analysis polling)
- `MeasurementProfileScreen` — View measurements, per-measurement confidence/source, corrections, approve/revoke/delete
- `TailorServiceRequestScreen` — Submit approved profile to authorized providers with budget/date/photo-consent
- `TailorQuoteReviewScreen` — Review/accept/decline provider estimates

API service (`FashionMeasurementApiService`) implements the `/api/v1/fashion-fit` contract:
- `createAiProfile` (consent, calibration, preferences)
- `uploadMeasurementPhoto` (with `confirmed_for_upload: '1'`)
- `submitAndWaitForAnalysis` (posts to `/analyses`, polls status)
- `correctMeasurement`, `approveProfile`, `revokeSharing`, `deleteProfile`
- `getTailorServices`, `submitMeasurementRequest`, `getTailorQuotes`, `acceptQuote`/`declineQuote`

Contract test (`test/features/urban_goodz/fashion_fit_ai_contract_test.dart`) validates:
1. Backend UUID ownership preserved in request models
2. Provider estimates map authoritative amount/status
3. Release build uses server AI only (`/analyses`, `confirmed_for_upload`, `/approve`); no local engine (`heightInches *`)
4. Camera screen uses `CameraPreview`, `_SilhouettePainter`, raw-photo sharing opt-in
5. API client does not log tokens, headers, or sensitive bodies

## Runtime E2E Test Requirements (Blocked by DCP Blockers)

### Prerequisites
- **Live backend** at `admin.urbangoodzdelivery.com/api/v1` with Fashion Fit endpoints deployed
- **Approved customer account** with valid auth token (FCM registered)
- **External AI provider** credentials configured on backend (model endpoint/key)
- **Physical Android device** (camera + GPU required for CameraPreview/silhouette overlay)
- **Network** allowing HTTPS to production API

### Test Scenarios

| # | Scenario | Expected |
|---|----------|----------|
| 1 | Open Fashion Fit from Urban Goodz AI screen | Navigates to `FashionMeasurementHomeScreen` |
| 2 | Tap "Photo Guides" → grant camera permission | `MeasurementPhotoGuideScreen` opens with camera preview |
| 3 | Read consent, enter height (in/cm), accept | Calibration stored; photo guide overlays visible |
| 4 | Capture front photo → preview → confirm upload | Photo sent with `confirmed_for_upload=1`; local draft updated |
| 5 | Capture side photo → preview → confirm upload | Same as above |
| 6 | (Optional) Capture back photo → preview → confirm | Same as above |
| 7 | Tap "Confirm upload and analyze" | POST `/profiles/{uuid}/analyses` → returns 202 + analysis UUID |
| 8 | Poll analysis status every 2s until `completed`/`needs_retake`/`failed` | UI shows loading spinner, then results or retake instructions |
| 9 | On `completed`: view measurements with confidence % and source (AI/customer) | Structured list rendered; each row shows confidence badge |
| 10 | Correct a measurement value | PATCH `/profiles/{uuid}/measurements/{id}` → value updates, source becomes "customer_corrected" |
| 11 | Tap "Approve final profile" | POST `/profiles/{uuid}/approve` → status becomes `approved` |
| 12 | Submit request to approved provider | `TailorServiceRequestScreen` loads providers, submits with profile UUID |
| 13 | Provider returns quote → customer accepts | `TailorQuoteReviewScreen` shows amount/status; accept POSTs decision |
| 14 | Revoke sharing → profile no longer visible to providers | POST `/consent` with all false → subsequent provider requests fail |
| 15 | Delete profile → all local + server data cleared | DELETE `/profiles/{uuid}` → local state reset |

### Non-Functional Checks
- No tokens/headers/measurements/photos logged by `ApiClient`
- AI analysis timeout (2 min default) shows retry message, does not fabricate measurements
- Retake instructions from backend displayed verbatim
- Silhouette overlay renders correctly on front/side camera (landscape/portrait handling)
- App handles camera permission denial gracefully (shows rationale, opens settings)

## Next Steps
1. Resolve DCP blockers: deploy backend, provision AI credentials, configure approved test accounts
2. Attach physical Android device via ADB
3. Run `flutter install` + manual E2E walkthrough of scenarios 1–15
4. Capture screenshots/video for handoff
5. Update DCP with test results and any fixes required