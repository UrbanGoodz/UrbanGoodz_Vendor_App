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
- isNationwide

Modules:
- Earn Money: opportunities, referrals, campaigns
- Logistics: pickup_zone_id, dropoff_zone_id, multi-zone routes
- Medical Courier: pickup_zone_id, dropoff_zone_id, healthcare accounts
- Bookings: providers and appointments by zone
- Creator Commerce: local, multi-zone, nationwide creators and reels
- Community Marketplace: groups and posts by zone
- Business Discovery: demand records and merchant leads by zone
- Order Anywhere: requests and auto-created merchants by zone
- Rentals: inventory and delivery zones
- Services: provider service areas across one or more zones
- Food: continue using native 6amMart zone logic

Houston may be used as launch-market demo data only.
Architecture must support nationwide expansion.
