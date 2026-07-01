# Urban Goodz Live Tester Known Issues

## 1. Sizing Photo Upload & Camera Picker
* **Status**: **Ready (Local File Refs)**
* **Details**: Customers can select actual photo files from their device using the gallery image picker. Picked photo file names display directly in the UI.
* **Limitations**: Uploads are simulated locally with a mock progress spinner; photo files are not persisted on remote S3 private storage.
* **Blocks live testing**: No.

---

## 2. AI Measurement Engine
* **Status**: **Ready (Mock Estimator Service)**
* **Details**: Once both front and side photos are picked and height is entered, the mock AI proportional calculation auto-populates all sizing fields.
* **Limitations**: Proportions are estimated using standard scale ratios based on human height. Real landmark mesh scanners (e.g. MediaPipe Pose Landmark Detection) are not integrated.
* **Blocks live testing**: No.

---

## 3. Sizing Payment & Checkout
* **Status**: **Ready (Simulated Billing)**
* **Details**: Pricing summary ($4.99 platform fee, $10.00 review fee, $14.99 total due) is fully visible. Testers can select "Free tester mode" to bypass fees or click "Simulate Payment Checkout" to transition payment status to paid.
* **Limitations**: Financial transactions are simulated; no active merchant gateway integration (e.g., Stripe) is connected.
* **Blocks live testing**: No.

---

## 4. Privacy Guard & Redaction
* **Status**: **Ready (Face-Blur Toggle)**
* **Details**: Face blur redaction switch is active and defaults to enabled. Private sizing photos are blocked from being shared on public feeds.
* **Blocks live testing**: No.

---

## 5. Vendor & Admin Management
* **Status**: **Blocked (Separate Repositories)**
* **Details**: While local provider preview dashboards (`ProviderMeasurementReviewScreen`) exist, real backend synchronization requires audits of the separate Laravel vendor/admin codebases.
* **Blocks live testing**: No, for customer preview testing. Yes, for end-to-end multi-app validation.
