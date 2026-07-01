# Urban Goodz Live Tester Blockers

## Current Customer-App Blocker Verdict
No Critical customer Flutter blocker remains.

---

## Remaining Blockers

| Severity | Surface | File/path | Issue | Tester Blocker | Production Blocker | Recommended next fix |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **High** | Admin | Admin Panel (Separate Repo) | Platform settings controls are blocked from customer repo | No | Yes | Audit the separate Laravel/Admin repository to implement settings |
| **High** | Vendor | Vendor Backend (Separate Repo) | Review fee persistence and notes storage are simulated locally | No | Yes | Hook up real CRUD database endpoints for tailoring bids |
| **Medium** | General | Payment Gateways | Financial transaction pipelines are simulated | No | Yes | Integrate Stripe/Merchant APIs |
| **Medium** | General | Image processing | Face blur redaction is a local toggle override | No | Yes | Integrate server-side face-blur algorithms (e.g., OpenCV/MediaPipe) |
| **Medium** | General | AI measurement | silhouette land-mark estimation uses height scale proportions | No | Yes | Hook up real body mesh estimation model endpoints |
