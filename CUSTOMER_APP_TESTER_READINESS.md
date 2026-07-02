# Customer App Tester Readiness

## Ready
- Fashion Fit is visible from Urban Goodz Hub.
- Fashion Fit dashboard opens named tester routes for profile, photo guide, tailor request, and quote review.
- Manual measurement fallback remains visible before photo-assisted intake.
- Photo wording uses "Take or upload photo".
- Urban Goodz unavailable features stay in preview/placeholder screens.

## Tester-safe
- Paid checkout is disabled in Fashion Fit tester profile flow.
- Face blur is labeled as preview/pending, not production-ready.
- Photo guide and tailor flows clearly state preview limitations.

## Blocked
- Production photo storage, production face blur, and live tailor submission still require backend/staging validation.

## Exact next action
- Run `tools/urban_goodz_release_check.ps1` from the repo root and publish only the generated tester web zip to staging after validation.
