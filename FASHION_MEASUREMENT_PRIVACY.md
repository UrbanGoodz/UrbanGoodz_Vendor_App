# Urban Goodz Sizing Photo Privacy Guidelines

## Status
- **Ready**: Face blur toggles, default redaction overrides (`faceBlurEnabled = true`), and copy disclaimers warning customer testers.
- **Preview-only**: Secure AWS S3 token-based signed private file path indicator references.
- **Blocked**: Production token encryption filters and automated land-mark blur image processors.

---

## 1. Safety Policies
- **Facial Privacy**: Customers stand straight but faces are not needed for landmark measurements. The app defaults to face blur redaction before visual reference upload.
- **Private Storage**: Body silhouette photos are stored in private secure directories (with short-lived tokens) and are never exposed publicly or sent to public search engines.
- **Data Retention**: Posture photos must be automatically scrubbed from servers 30 days after custom alterations/orders are finalized.

---

## 2. Platform Privacy Settings
* `faceBlurEnabled`: Boolean (Default: true)
* `faceBlurStatus`: 'Blur active (faces automatically redacted)'
* `privacyReviewStatus`: 'Safe for tailor review'
* `vendorPhotoVersion`: 'Version 1.0 (Face redacted)'

---

## 3. Production Blockers
- Implementation of server-side face blurring or silhouette edge masking prior to S3 persistence.
- Auto-cleanup cron jobs to purge photo references after 30 days.
