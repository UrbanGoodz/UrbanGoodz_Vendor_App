# Urban Goodz Public QA Runbook

## Purpose

This browser QA suite validates the public Urban Goodz tester site at `https://test.urbangoodzdelivery.com` without changing Flutter app code.

## Test Framework

- Playwright Test
- Test file: `tests/urban_goodz_public_qa.spec.ts`
- Config: `playwright.config.ts`

## Install Test Dependencies

PowerShell may block `npm.ps1`, so use `npm.cmd` on Windows:

```powershell
npm.cmd install
npx.cmd playwright install chromium
```

Optional custom target URL:

```powershell
$env:UG_TEST_URL = "https://test.urbangoodzdelivery.com"
```

## Run Tests

```powershell
npm.cmd run qa:urban-goodz
```

Headed mode:

```powershell
npm.cmd run qa:urban-goodz:headed
```

Open HTML report:

```powershell
npm.cmd run qa:urban-goodz:report
```

## Coverage

The suite covers:

- Home / Shell load and branding smoke check
- Urban Goodz Hub direct route `/urban-goodz-hub`
- Required Hub tabs: Earn Money, Logistics, Load Board, Medical Courier, Book Anything, Events, Community, Creators, Ask UG, UG+
- Earn Money Live badge and preview treatment for other Hub sections
- Direct feature routes for Earn Money, Logistics, Load Board, Medical Courier, Book Services, Events/Creators, Community Marketplace, Creator Commerce, AI, and UG+
- Hidden feature check for Fashion Measurements / Tailor Sizing
- Discovery no-results search capture flow using `zxqv-unavailable-test-item-urban-goodz`
- Mobile smoke checks for iPhone and Android viewports
- Screenshots for Home, Urban Goodz Hub, Earn Money tab, Community route, Creator Commerce route, and Discovery no-results

## Screenshot Output

Screenshots and failure artifacts are written under:

```text
test-results/urban-goodz-public-qa/
```

The HTML report is written under:

```text
playwright-report/
```

## Known Limitations

- Flutter web may render some text into canvas or semantics layers. If Playwright cannot locate visible text that is clearly present on screen, inspect the screenshot artifact first.
- The Discovery test submits a safe artificial query. It accepts either a success message or a graceful error/retry message.
- POST-only backend endpoints should not be manually tested by browser GET except to confirm Method Not Allowed.
- Tests run against the live tester environment, so failures can be caused by deployment cache, backend downtime, API errors, or network issues.

## Reading Failures

- Start with the Playwright error message and attached screenshot.
- If a text assertion fails, open the screenshot to confirm whether the content is visually absent or only inaccessible to DOM-based selectors.
- If route tests fail with blank screens, check browser console/network traces in the retained trace artifact.
- If Discovery submission fails, confirm whether the UI displays a graceful error message and whether the backend route is deployed.

## App Source Changes

This QA suite is isolated to Playwright tooling and tests. It should not modify Flutter app behavior, routes, UI, Fashion Measurements visibility, or deployment files.
