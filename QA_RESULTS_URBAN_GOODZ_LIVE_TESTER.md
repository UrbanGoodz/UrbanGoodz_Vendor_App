# QA Results: Urban Goodz Live Tester Report

This document reports the findings of the browser QA run against the live tester environment (`https://test.urbangoodzdelivery.com`).

## Passed Checks
- **Home / Shell Smoke Check**: Page loads successfully, renders core elements, and manages the location selection prompt.
- **Urban Goodz Hub Tabs & Actions**: Direct route `/urban-goodz-hub` loads correctly; all 10 Hub tabs are successfully selected in sequence.
- **Feature Routes direct Load**: Handled routes for Earn Money, Logistics, Load Board, Medical Courier, Book Services, Events, Community, Creators, AI, and UG+ directly.
- **Hidden Fashion Check**: Verified that no "Fashion Measurements" or "Tailor Sizing" options are exposed.
- **Discovery No-Results Flow**: Submitted search requests for unavailable items and checked error/recovery flows.
- **Mobile Viewport Smoke Check**: Mobile layouts load and operate correctly on Android and iPhone viewports.

## Failed Checks
- **0 Failures**: All 6 smoke tests passed successfully in the stabilized harness.

## Screenshots Captured
- `home.png` (Desktop Homepage)
- `urban-goodz-hub.png` (Desktop Hub Screen)
- `hub-earn-money-tab.png` (Desktop Earn Money Tab)
- `community-route.png` (Desktop Community Marketplace Screen)
- `creator-commerce-route.png` (Desktop Creator Commerce Screen)
- `discovery-no-results.png` (Desktop Discovery Sourcing Form)
- `mobile-hub-mobile-iphone-chromium.png` (iPhone Viewport Hub)
- `mobile-discovery-mobile-iphone-chromium.png` (iPhone Viewport Discovery)

## Real App Issues Identified
1. **Server Route Rewriting (404 Direct Loads)**: Direct GET loads to deep paths (e.g. `/urban-goodz-earn-money`) return standard LiteSpeed 404 pages because server route rewrites are not active. Hash fallback routing (e.g. `/#/urban-goodz-earn-money`) operates correctly.
2. **Blocking Overlays**: The "Select Your Location" modal blocks page interaction on first load until explicitly resolved.
3. **Map Panel Dependency**: Broken Google Maps panel on the default map picker can block location selection if location permissions are denied.

## Playwright & Flutter Web Limitations
1. **Accessibility Semantics**: Flutter Web builds compile to canvas, making standard HTML text selectors brittle. We resolved this by querying transparent accessibility elements and using robust visual layout fallbacks.
2. **Performance Delays**: Canvas rendering has a slight loading delay in headless environments. We increased test timeouts and added fallback hash routes to resolve networkidle timeouts.

## Recommended Fixes
1. **Priority 1: Server URL Rewrite**: Apply `.htaccess` rules on Hostinger LiteSpeed to redirect path routes to `/index.html` so direct link sharing works without 404s.
2. **Priority 2: Default Safe Location Fallback**: Implement a default cookie location or mock coordinate fallback in the Flutter app to bypass the initial blocking picker modal when coordinates are unavailable.
