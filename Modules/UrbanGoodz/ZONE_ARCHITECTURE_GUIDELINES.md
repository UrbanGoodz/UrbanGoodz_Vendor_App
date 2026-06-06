# Urban Goodz Zone Architecture

All Urban Goodz modules must use existing 6amMart Zone Setup as the geographic foundation.

Required where applicable:
- zone_id
- zone_name
- city
- state
- service_area
- latitude
- longitude
- is_active
- is_launch_market
- is_nationwide

Houston is the first real live launch zone and initial production market.

Houston should be represented as:
- zone_name: Houston
- city: Houston
- state: TX
- is_active: true
- is_launch_market: true
- is_nationwide: false

If no other zone is selected, Houston may be used as the default active zone for launch operations.
Do not label Houston content as demo, sample, placeholder, fake data, or test market.

Nationwide content should use:
- is_nationwide: true
- zone_id: null or all-zones depending on existing app conventions

Modules:
- Earn Money: opportunities, referrals, and campaigns must be zone-based or nationwide.
- Logistics: loads require pickup_zone_id and dropoff_zone_id; enterprise routes may be multi-zone or nationwide.
- Medical Courier: jobs require pickup_zone_id and dropoff_zone_id; STAT jobs filter eligible nearby drivers by zone/location.
- Bookings: providers and appointments resolve by zone/service area; mobile providers may support multiple zones.
- Creator Commerce: creators and reels may be local, multi-zone, or nationwide.
- Community Marketplace: groups and posts are zone-based and nationwide-capable.
- Business Discovery: demand records, discovered businesses, and leads must track zone_id.
- Order Anywhere: requests and auto-created businesses must capture zone_id.
- Rentals: inventory and delivery/pickup zones must be supported.
- Retail: stores, products, and discovery should inherit vendor/store zone logic.
- Services: providers and service areas may include multiple zones.
- Food: continue using native 6amMart zone logic.

Architecture must support nationwide expansion while allowing Houston to operate immediately as a real production launch market.
