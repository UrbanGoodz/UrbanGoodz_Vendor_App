# Urban Goodz Sprint Execution Instructions

## Owner Intent

All Urban Goodz functions should be worked on simultaneously as coordinated sprint tracks, then tied into the backend through shared APIs, models, payment rules, admin controls, and verification gates.

Do not treat modules as isolated one-off builds. The goal is parallel progress across the whole Urban Goodz product surface.

## Sprint Principle

Move every module forward at the same time, but keep them connected by shared contracts.

Each sprint track should produce:

- updated or verified Flutter screens
- matching models
- matching controllers
- matching repos/services
- API contract expectations
- backend route/controller/service alignment
- payment-first gate status
- admin visibility status
- mock-to-real-data transition status

## Parallel Workstreams

1. Customer app workstream
   - screens, navigation, data models, controllers, repos/services, loading/error states, Houston/UrbanGoodz content

2. Backend API workstream
   - routes, controllers, services, models, migrations, API resources, validation requests, payment-first enforcement

3. Admin/operations workstream
   - admin screens, CRUD tables, filters, verification queues, dispute/refund controls, payment/escrow visibility, automation controls

4. Payment/revenue workstream
   - Stripe Payment Intents, authorization-only flows, capture flows, escrow holds, deposits, subscriptions, split payouts, refunds, dispute holds

5. Provider/driver/vendor workstream
   - dashboards, available jobs, accept/decline flows, proof upload, earnings, payout status, verification requirements

6. Branding/content workstream
   - Urban Goodz brand assets, no generic/lorem content, Houston-specific examples, naming/copy alignment

7. Integration/provider-adapter workstream
   - Stripe Identity / Onfido, Uber Direct / DoorDash Drive, Google Maps, Typesense/Meilisearch/Algolia, Apple RoomPlan / ARCore / OpenCV, OpenAI tool calling

## Modules To Move In Parallel

- Order Anywhere / Buy Anywhere
- Business Claim / Discovery
- Medical Courier
- Load Board / Logistics
- Fashion & Tailoring
- Book Anything
- Events / Creators
- Delivery Services
- Marketplace
- Local Events
- Rentals
- Vending
- Earn Money
- Reels-to-opportunities
- AI Concierge
- Trust / Identity
- Revenue Attribution
- Automation
- Photo-assisted Measurements

## Backend Tie-In Rule

Every frontend module should eventually map to:

- backend route group
- controller
- service
- model
- migration/table if persistent
- request validation
- API resource/response shape
- admin view/control if operational
- payment gate if money or dispatch is involved
- audit log if status or money changes

## Shared Contract Per Module

```text
Module:
Customer screens:
Provider/driver/vendor screens:
Admin screens:
Flutter models:
Flutter controllers:
Flutter repos/services:
Laravel routes:
Laravel controllers:
Laravel services:
Laravel models:
Tables/migrations:
Payment gate:
Assignment gate:
Payout rule:
Mock data status:
Backend integration status:
Open issues:
Completion estimate:
```

## Definition Of Done Per Module

A module is not done until:

- Flutter analyzer passes
- screens render
- detail screens route correctly
- no stale model names remain
- mock data is Urban Goodz/Houston branded or replaced with API data
- backend endpoint exists or module is explicitly mock-only
- payment-first gate exists if money/dispatch is involved
- admin can see/manage operational records
- status lifecycle is clear
- errors/loading states exist
- module is represented in the completion matrix

## What Not To Do

- Do not build one module deeply while leaving others untouched.
- Do not create new parallel systems when existing 6amMart or Urban Goodz code can be extended.
- Do not dispatch providers/drivers before funds are authorized/captured/escrowed.
- Do not build custom AR measurement, KYC, courier dispatch, route optimization, or search before checking provider/adaptor options.
- Do not leave mock data generic.
