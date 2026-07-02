# Urban Goodz Functionality Inventory

This inventory consolidates the Urban Goodz product surface mentioned in Phase 13. The goal is to ensure every function moves in the sprint and ties back to the backend, while improving existing functionality instead of rebuilding from scratch.

## Foundation

| Functionality | Estimate | Needed next |
|---|---:|---|
| Multi-role auth: customer, provider/vendor, driver, admin | 55% | Audit existing 6amMart roles/guards/tokens and specialize provider/driver roles |
| Role-based tokens | 50% | Verify API middleware and role permissions |
| Stripe Payment Intents | 30% | Implement/verify reusable authorization/capture service |
| Stripe Connect / split payouts | 20% | Connected accounts, transfers, payout records |
| Escrow/hold engine | 20% | Escrow states, release/refund/dispute logic |
| Payment-first enforcement | 30% | Enforce in backend services/controllers, not only UI |
| Refund/dispute engine | 25% | Admin actions, statuses, audit trail |
| Admin dashboard framework | 65% | Verify screens and add missing operational controls |
| Admin permissions | 60% | Verify `urban_goodz_platform` role access |
| Notifications | 40% | Reuse existing 6amMart notifications for Urban Goodz events |
| Chat/messaging | 35% | Reuse existing chat where possible, add workflow threads |

## Customer / Commerce / Services Modules

| Module | Estimate | Needed next |
|---|---:|---|
| Urban Goodz home/module hub | 55% | Runtime click-through and route audit |
| Order Anywhere / Buy Anywhere | 40% | Payment authorization, shopper lifecycle, receipt upload |
| Business Claim / Discovery | 55% | Customer search/detail, claim queue, premium subscription flow |
| Medical Courier | 45% | Capture-before-dispatch, proof/PIN flow, driver verification |
| Load Board / Logistics | 45% | Escrow, carrier verification, BOL/POD, payout release |
| Fashion & Tailoring | 25% | Decide reuse path, quote/deposit/progress/balance flow |
| Book Anything | 45% | Availability, booking deposit/full payment, cancellation policy |
| Events / Creators | 45% | Ticket tiers, QR tickets, creator verification, payout schedule |
| Delivery Services | 55% | Backend API wiring, pricing, payment gates |
| Marketplace | 50% | API wiring, checkout, catalog ownership, admin moderation |
| Local Events | 55% | API wiring, detail routing, ticketing if monetized |
| Rentals | 45% | Availability, deposit, return/damage disputes |
| Vending | 40% | Inventory sync, machine locations, restock workflow |
| Earn Money | 55% | API wiring, eligibility, payout safety |
| Reels-to-opportunities | 55% | Event ingestion, app integration, scoring validation |
| AI Concierge | 35% | Tool calling, safe confirmations, action schemas |
| Trust / Identity profiles | 65% | Stripe Identity/Onfido integration and admin verification runtime test |
| Photo-assisted measurements | 15% | Choose provider path: RoomPlan, ARCore, OpenCV, Magicplan/PLNAR |
| Revenue attribution | 60% | Event capture, dashboards, revenue reconciliation |
| Automation engine | 55% | Verify observers/jobs, failures, retries, payment-safe gates |

## Order Anywhere / Buy Anywhere Subfunctions

| Function | Estimate | Needed next |
|---|---:|---|
| Item description request | 35% | Form and backend validation |
| Photo attachment | 30% | Upload/storage validation |
| Product link attachment | 30% | URL validation/storage |
| Max budget | 40% | Budget validation and authorization cap |
| Address/time window | 40% | Reuse existing address flow |
| Estimate calculation | 35% | Backend estimator and price breakdown UI |
| Payment authorization | 25% | Stripe authorization-only flow |
| Shopper/provider request board | 25% | Provider UI/API/radius filtering |
| Provider acceptance | 25% | Payment-authorized gate |
| Chat | 30% | Reuse chat or add workflow thread |
| Receipt upload | 30% | Actual cost validation |
| Additional charge approval | 20% | Customer approval for over-budget purchase |
| Refund/release excess hold | 20% | Partial capture/release logic |
| Delivery timeline | 35% | Requested/accepted/purchased/picked up/delivered |
| Provider earnings | 25% | Payout accounting |
| Admin assignment | 35% | Admin action and audit trail |
| Disputes/refunds | 20% | Admin dispute workflow |

## Medical Courier Subfunctions

| Function | Estimate | Needed next |
|---|---:|---|
| Delivery type selector | 45% | Verify options/API |
| Special handling | 35% | Pricing and driver requirements |
| Prescription/document upload | 30% | Secure storage and visibility |
| Real-time quote | 30% | Estimator service |
| Full payment before dispatch | 25% | Hard backend gate |
| Driver assignment | 35% | Certification and payment gate |
| Pickup proof | 30% | Upload/tracking event |
| Dropoff proof | 30% | Photo/signature/PIN |
| Customer PIN | 25% | Generate/verify PIN |
| Tracking events | 35% | Driver location/status updates |
| Driver verification | 35% | Admin verification queue |
| Compliance dashboard | 20% | Expiry/insurance/HIPAA-aware monitoring |

## Load Board / Logistics Subfunctions

| Function | Estimate | Needed next |
|---|---:|---|
| Post load | 40% | Verify fields/API/UI |
| Carrier browse | 35% | Filters and role access |
| Bidding | 25% | Bid model/API/UI |
| Accept bid | 25% | Escrow gate |
| Fixed-rate loads | 25% | Status/payment flow |
| Escrow deposit | 20% | 100% shipper funding before pickup |
| Carrier verification | 25% | MC/DOT/insurance workflow |
| Pickup BOL upload | 25% | File/status upload |
| Delivery POD upload | 25% | File/status upload |
| Payment release | 20% | Payout logic |
| Disputes | 20% | Admin dispute workflow |

## Advanced / Integration Candidates

| Capability | Recommended reuse/reference |
|---|---|
| iOS measurements | Apple RoomPlan / ARKit |
| Android depth | ARCore Depth API |
| Deterministic image measurement | OpenCV |
| Measurement report UX | Magicplan, PLNAR, Canvas |
| Identity/KYC | Stripe Identity, Onfido / Entrust, Persona |
| Payments/splits | Stripe Payment Intents, Stripe Connect |
| Courier fulfillment | Uber Direct, DoorDash Drive |
| Routing/ETA | Google Maps, Google Route Optimization |
| Search/discovery | Typesense, Meilisearch, Algolia |
| Booking references | Calendly, Thumbtack, TaskRabbit |
| Freight/load board references | DAT, Truckstop, Uber Freight |
| Ticketing references | Eventbrite, QR ticket patterns |
| Automation references | Zapier-style trigger/action model |
| AI concierge | OpenAI function calling and structured outputs |
