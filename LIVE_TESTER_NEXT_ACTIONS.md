# Urban Goodz Live Tester Next Actions

## 1. Deploy & Staging Server Upload
- **Action**: Upload the rebuilt tester ZIP (`outputs\urban-goodz-tester-web-build.zip`) to the cPanel deployment folder: `/home/urbakkej/test.urbangoodzdelivery.com`.
- **Status**: **Ready for Deploy**.

---

## 2. Interactive Browser Smoke Check
- **Actions**:
  1. Open [https://test.urbangoodzdelivery.com](https://test.urbangoodzdelivery.com).
  2. Verify caching bypass: Confirm the app lands on HOME (not a cached module screen or blank splash screen).
  3. Navigate to **Urban Goodz Hub** -> **Fashion Fit** -> **Open Fashion Fit**.
  4. In **Measurement Profile**:
     - Enter Height (e.g. 70).
     - Select gallery photo files for Front and Side views.
     - Verify simulated upload progress spinner runs and displays file names.
     - Confirm mock AI proportional sizing calculations automatically populate Chest, Waist, Hips, Inseam, Sleeve, and Shoulder.
     - Toggle Free Tester Mode or click "Simulate Payment Checkout" to paid.
     - Save Profile and confirm safe navigation.
  5. In **Creator Space** (`/urban-goodz-creator-commerce`), click "Open Fashion Measurement Preview" to verify back-link.

---

## 3. Multi-Repo Cross-Checks (Production Blockers)
- **Vendor Admin Verification**: Audit the separate vendor repository to verify persistence hooks for customer-adjusted measurements, notes, and custom tailor services.
- **Admin Panel Verification**: Audit the separate admin repository to verify database migration schemas for platform measurement fee splits, global photo-assisted toggles, and creator content moderation.
