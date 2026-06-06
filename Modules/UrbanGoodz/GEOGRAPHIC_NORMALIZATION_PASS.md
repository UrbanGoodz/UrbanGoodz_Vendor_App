# Phase A-F Geographic Normalization Pass

This pass normalizes all Urban Goodz placeholder modules around the geographic scope rules in:

- Modules/UrbanGoodz/ARCHITECTURE.md
- Modules/UrbanGoodz/ZONE_ARCHITECTURE_GUIDELINES.md

## Standard Fields

Use these fields where appropriate:

```dart
String? countryCode;
String? state;
String? city;
int? zoneId;
String? zoneName;
bool isNationwide;
bool isWorldwide;
bool isLaunchMarket;
```

## Scope Rules

### Houston Live Launch Zone

```dart
countryCode = 'US';
state = 'TX';
city = 'Houston';
zoneName = 'Houston';
isLaunchMarket = true;
isNationwide = false;
isWorldwide = false;
```

Houston is a real live launch zone, not demo, sample, fake, or test data.

### Nationwide U.S. Records

```dart
countryCode = 'US';
zoneId = null;
isNationwide = true;
isWorldwide = false;
```

### Worldwide Records

```dart
countryCode = null;
zoneId = null;
isNationwide = false;
isWorldwide = true;
```

## Modules To Normalize

- Earn Money
- Logistics / Load Board
- Medical Courier
- Book Anything / Services
- Creator Commerce / Shoppable Reels
- Community Marketplace

## Large Files Not To Touch

Do not modify:

- lib/helper/route_helper.dart
- lib/features/menu/screens/menu_screen.dart
- lib/util/app_constants.dart

until safe targeted patching is available.
