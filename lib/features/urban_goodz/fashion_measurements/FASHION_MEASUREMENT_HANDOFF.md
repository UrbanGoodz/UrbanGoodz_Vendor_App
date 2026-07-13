# Fashion Fit AI Measurement Customer Handoff

The Customer app now uses the authenticated `/api/v1/fashion-fit` contract. There is no proportional, random, hardcoded, manual-primary, or local-success measurement engine.

## Real workflow

1. Customer reads the estimate/privacy explanation and explicitly consents.
2. Customer enters calibration height and units.
3. Native camera capture displays a full-body silhouette and pose/distance/lighting guidance for front, side, and optional back views.
4. The Customer previews, retakes, or deletes each photo.
5. Pressing Analyze explicitly creates the consented profile, privately uploads each confirmed photo, and submits the asynchronous analysis job.
6. The app polls real analysis status and displays structured measurements, per-measurement confidence/source, overall confidence, or server retake instructions.
7. The Customer can correct a value. Corrections remain identified by the backend as manual corrections.
8. The Customer approves the profile before it can be shared.
9. Provider requests use an approved backend profile, approved provider ID, separate measurement/photo permissions, notes, budget, and completion date.
10. Provider estimates load from the backend and accept/decline decisions are persisted.
11. The Customer can revoke sharing and delete the profile through authenticated endpoints.

The shared API client no longer logs tokens, authenticated headers, request payloads, images, or measurements. Backend authorization and private storage remain authoritative. External AI analysis still requires the deployed server provider endpoint/key/model; failure or timeout never creates measurements locally.
