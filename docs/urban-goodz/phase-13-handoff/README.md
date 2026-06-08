# Urban Goodz Phase 13 Handoff

Date: 2026-06-08

This handoff captures the Phase 13 Urban Goodz work, deployment review, completion estimates, and sprint instructions.

## Status

Recommended GitHub storage plan:

- Commit handoff docs, manifests, prompts, and completion matrix to Git.
- Do not commit the 92 MB handoff zip or 71 MB backend deploy zip directly into normal Git history.
- Upload large zip artifacts as GitHub Release assets or store with Git LFS if long-term binary tracking is required.

## Local Artifacts Created

- `urban-goodz-phase-13-complete-handoff-with-branding-20260608-072818.zip`
- `urban-goodz-full-backend-deploy-safe.zip`
- `urban-goodz-branding-client-folder.zip`
- `urban-goodz-missing-route-files-delta-20260608-051551.zip`
- route delta file lists

## Completed In This Thread

1. Built a focused Urban Goodz missing-route delta zip.
2. Included matching Urban Goodz controllers, API controllers, views, and sidebar partial.
3. Verified final route delta archive uses Linux-safe forward-slash paths.
4. Reviewed Phase 13H full backend deployment package.
5. Confirmed the rebuilt package passed exclusion checks and Urban Goodz coverage checks.
6. Added the Urban Goodz branding/client zip to the handoff package.
7. Created a detailed product/backend/frontend handoff.
8. Created a full functionality inventory.
9. Created a completion matrix with percentages.
10. Added sprint instructions to work all functions simultaneously and tie them into the backend.

## Non-Negotiable Business Rule

Urban Goodz must never reimburse drivers or providers from its own operating funds.

Every revenue workflow must be payment-first:

- authorize before dispatch
- capture before fulfillment where appropriate
- escrow before pickup/work begins
- split payout after completion
- never assign a driver/provider before customer funds are authorized or captured

## Current Completion Estimates

| Track | Estimate |
|---|---:|
| Backend package readiness for controlled deployment | 90% |
| Existing Urban Goodz admin backend coverage | 75% |
| Flutter customer app consistency | 70% |
| Flutter customer app production readiness | 45% |
| Payment-safe revenue workflow readiness | 30% |
| Brand/content consistency | 60% |
| Overall Urban Goodz Phase 13 readiness | 55% |

## Sprint Rule

All Urban Goodz functions should be worked on simultaneously in coordinated sprint tracks, then tied into the backend through shared APIs, models, payment gates, admin controls, and provider workflows.

Do not treat modules as isolated one-off builds. Each sprint should move every module forward at least once.

## Workstreams

1. Customer app: screens, navigation, data models, controllers, repos/services, loading/error states, branded content.
2. Backend API: routes, controllers, services, models, migrations, API resources, validation, payment-first enforcement.
3. Admin/operations: CRUD, filters, verification queues, disputes/refunds, escrow visibility, automation controls.
4. Payment/revenue: Stripe Payment Intents, authorization, capture, escrow, deposits, subscriptions, split payouts, refunds.
5. Provider/driver/vendor: dashboards, available jobs, accept/decline, proof uploads, earnings, payout status.
6. Branding/content: Urban Goodz assets, Houston-specific copy, no generic/lorem content.
7. Integrations/adapters: Stripe Identity, Uber Direct, DoorDash Drive, Google Maps, search provider, RoomPlan/ARCore/OpenCV, OpenAI.

## Immediate Next Tasks

1. Run Flutter analyzer.
2. Search stale symbols: `EarnMoneyOption`, `CreatorItem`, `LocalEvent`, `isAvailable`, old `.title` references.
3. Open every Urban Goodz customer module screen.
4. Deploy backend only after backup and `migrate --pretend` review.
5. Verify server routes and admin sidebar.
6. Confirm `urban_goodz_platform` admin permission.
7. Wire existing Flutter repos to backend APIs.
8. Add payment gates before provider/driver assignment.
9. Add admin dispute/refund/escrow visibility.
10. Apply branding assets and Houston-specific content consistently.
