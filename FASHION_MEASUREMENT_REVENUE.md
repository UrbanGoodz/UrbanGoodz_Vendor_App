# Urban Goodz Fashion Measurement Revenue Settings

## Status
- **Ready**: Sizing profile pricing preview and simulated checkout actions are available in the customer profile screen.
- **Preview-only**: Vendor review fee toggles and customize fee inputs are ready in the provider review preview screen.
- **Blocked**: Admin fee settings are blocked from persistence (requires Laravel admin/vendor codebase updates).

---

## 1. Customer Sizing Fees
* **Urban Goodz AI-assisted measurement estimate**: $4.99 (Bypassable)
* **Tailor measurement review**: $10.00 (Bypassable)
* **Total measurement fee**: $14.99
* **Free tester mode**: Toggle switch that resets fees to $0.00 and updates billing status to `not_required`.

---

## 2. Simulated Payment Statuses
* `not_required` (Waived / Tester Mode default)
* `pending` (Default when tester mode is disabled and payment is required)
* `paid` (Triggered via checkout simulator)
* `waived` (Manually adjusted)
* `failed` (Error preview)
* `refunded` (Status log)

---

## 3. Production Blockers
* Real Stripe/Merchant payment gateways must be hooked up in the backend API to handle financial transactions.
* Admin panel global platform fee configurations and payout split balances must be wired to database tables.
