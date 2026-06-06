# Urban Goodz Architecture

Urban Goodz extends 6amMart as a worldwide-capable local commerce platform.

## Geographic Scope Definitions

Urban Goodz uses the native 6amMart geographic hierarchy:

Country -> State/Province -> City -> Zone

All Urban Goodz modules must inherit this structure.

### Scope Rules

#### 1. Zone-Specific Record

country_code = US
city = Houston
zone_id = 1

Meaning:
Visible only to users, drivers, merchants, providers, creators, fleet partners, and healthcare accounts operating in that zone.

#### 2. Country-Wide Record

country_code = US
zone_id = null

Meaning:
Visible across all active United States zones.

* zone_id = null means "all zones within the specified country."

#### 3. Worldwide Record

country_code = null
zone_id = null

Meaning:
Visible across all countries and all zones where Urban Goodz operates.

* country_code = null means "all countries."
* zone_id = null means "all zones."

### Important

* null does NOT mean missing data.
* null does NOT mean unknown.
* null is an intentional geographic scope designation.

### Scope Summary

| country_code | zone_id | meaning |
|---|---:|---|
| US | 1 | Specific Houston zone |
| US | null | All United States zones |
| CA | null | All Canadian zones |
| null | null | Worldwide |

### Houston Rule

Houston is not demo data.
Houston is the first live launch zone.

Represent Houston as:

country_code = US
state = TX
city = Houston
zone_name = Houston
is_active = true
is_launch_market = true
is_nationwide = false

### Nationwide U.S. Records

country_code = US
zone_id = null
is_nationwide = true

### Worldwide Records

country_code = null
zone_id = null
is_worldwide = true

## Modules Covered

This geographic scope applies to:

- Earn Money
- Logistics
- Medical Courier
- Book Anything
- Creator Commerce
- Community Marketplace
- Business Discovery
- Search Capture
- Order Anywhere Business Capture
- Rentals
- Retail
- Services
- Food

## Required Placeholder Fields

Where practical, Urban Goodz placeholder models and services should include:

- countryCode
- state
- city
- zoneId
- zoneName
- isNationwide
- isWorldwide
- isLaunchMarket
