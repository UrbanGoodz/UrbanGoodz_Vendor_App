# Route & Menu Manual Patch Guide

This document is a manual patch guide showing the exact code changes needed later to expose the remaining Urban Goodz features in the drawer menu.

---

## 1. Menu Screen Registration (`menu_screen.dart`)

To display Events, Community Marketplace, Creator Commerce, Urban Goodz AI, and Plus in the drawer list, apply this patch:

### Target File:
`lib/features/menu/screens/menu_screen.dart`

### Code Target block:
```dart
                  child: Column(children: [
                    PortionWidget(icon: Images.dmIcon, title: 'Earn Money', route: RouteHelper.getUrbanGoodzEarnMoneyRoute()),
                    PortionWidget(icon: Images.dmIcon, title: 'Logistics', route: RouteHelper.getUrbanGoodzLogisticsRoute()),
                    PortionWidget(icon: Images.dmIcon, title: 'Load Board', route: RouteHelper.getUrbanGoodzLoadBoardRoute()),
                    PortionWidget(icon: Images.dmIcon, title: 'Medical Courier', route: RouteHelper.getUrbanGoodzMedicalCourierRoute()),
                    PortionWidget(icon: Images.storeIcon, title: 'Book Services', route: RouteHelper.getUrbanGoodzBookServicesRoute(), hideDivider: true),
                  ]),
```

### Proposed Patch:
Replace the above list block with:
```dart
                  child: Column(children: [
                    PortionWidget(icon: Images.dmIcon, title: 'Earn Money', route: RouteHelper.getUrbanGoodzEarnMoneyRoute()),
                    PortionWidget(icon: Images.dmIcon, title: 'Logistics', route: RouteHelper.getUrbanGoodzLogisticsRoute()),
                    PortionWidget(icon: Images.dmIcon, title: 'Load Board', route: RouteHelper.getUrbanGoodzLoadBoardRoute()),
                    PortionWidget(icon: Images.dmIcon, title: 'Medical Courier', route: RouteHelper.getUrbanGoodzMedicalCourierRoute()),
                    PortionWidget(icon: Images.storeIcon, title: 'Book Services', route: RouteHelper.getUrbanGoodzBookServicesRoute()),
                    PortionWidget(icon: Images.storeIcon, title: 'Events & Creators', route: RouteHelper.getLocalEventsCreatorsRoute()),
                    PortionWidget(icon: Images.storeIcon, title: 'Community Marketplace', route: RouteHelper.getUrbanGoodzCommunityMarketplaceRoute()),
                    PortionWidget(icon: Images.storeIcon, title: 'Creator Commerce', route: RouteHelper.getUrbanGoodzCreatorCommerceRoute()),
                    PortionWidget(icon: Images.storeIcon, title: 'Urban Goodz AI', route: RouteHelper.urbanGoodzAI),
                    PortionWidget(icon: Images.storeIcon, title: 'Urban Goodz Plus', route: RouteHelper.urbanGoodzPlus, hideDivider: true),
                  ]),
```

---

## 2. Main Dashboard Page Mappings

If any top-level dashboard buttons or quick-links are added to redirect the customer directly to these new screens, use the standard `Get.toNamed` format:

### Code Snippets:
* **Events Shortcut**:
  `Get.toNamed(RouteHelper.getLocalEventsCreatorsRoute());`
* **Earn Money Opportunity Hub**:
  `Get.toNamed(RouteHelper.getUrbanGoodzEarnMoneyRoute());`
* **Medical Courier Portal**:
  `Get.toNamed(RouteHelper.getUrbanGoodzMedicalCourierRoute());`

---

## 3. Fashion Measurements Warning

> [!CAUTION]
> Do NOT expose `lib/features/urban_goodz/fashion_measurements/` routes inside any manual menu patches. That feature must remain architecture/placeholder-only until client authorization flows are fully verified.
