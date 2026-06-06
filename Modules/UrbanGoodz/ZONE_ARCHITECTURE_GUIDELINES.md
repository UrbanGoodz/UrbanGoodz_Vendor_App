# Urban Goodz Zone Architecture

All Urban Goodz modules must use existing 6amMart geography and Zone Setup as the geographic foundation.

Urban Goodz is worldwide capable by design and must follow the 6amMart geographic hierarchy:

Country -> State/Province/Region -> City -> Zone

Required where applicable:
- country_code
- country_name
- state
- province
- region
- city
- zone_id
- zone_name
- service_area
- latitude
- longitude
- is_active
- is_launch_market
- is_nationwide

Houston is the first real live launch zone and initial production market.

Houston should be represented as:
- country_code: US
- country_name: United States
- zone_name: Houston
- city: Houston
- state: TX
- is_active: true
- is_launch_market: true
- is_nationwide: false

If no other zone is selected during launch operations, Houston may be used as the default active zone.
Do not label Houston content as demo, sample, fake data, or test market.

## Geographic Scope Definitions

Specific zone content:
- country_code: US
- zone_id: 1
- Meaning: visible only in that specific zone.

Country-wide content:
- country_code: US
- zone_id: null
- Meaning: visible across all active zones in the specified country.

Worldwide content:
- country_code: null
- zone_id: null
- Meaning: visible across all countries and all zones where Urban Goodz operates.

* `null` does not mean missing data.
* `null` does not mean unknown.
* `null` is an intentional geographic scope designation.

Modules:
- Earn Money: opportunities, referrals, and campaigns must be zone-based, country-wide, or worldwide.
- Logistics: loads require pickup_zone_id and dropoff_zone_id; enterprise routes may be multi-zone, country-wide, or worldwide where applicable.
- Medical Courier: jobs require pickup_zone_id and dropoff_zone_id; STAT jobs filter eligible nearby drivers by zone/location and must respect country-specific compliance.
- Bookings: providers and appointments resolve by zone/service area; mobile providers may support multiple zones.
- Creator Commerce: creators and reels may be local, multi-zone, country-wide, or worldwide.
- Community Marketplace: groups and posts are zone-based, country-wide, and worldwide-capable.
- Business Discovery: demand records, discovered businesses, and leads must track geographic scope.
- Order Anywhere: requests and auto-created businesses must capture zone_id when local.
- Rentals: inventory and delivery/pickup zones must be supported.
- Retail: stores, products, and discovery should inherit vendor/store zone logic.
- Services: providers and service areas may include multiple zones.
- Food: continue using native 6amMart zone logic.

Architecture must support worldwide expansion while allowing Houston to operate immediately as a real production launch market.
