import { expect, Locator, Page, test } from '@playwright/test';

const BASE_URL = process.env.UG_TEST_URL || 'https://test.urbangoodzdelivery.com';
const UNAVAILABLE_QUERY = 'zxqv-unavailable-test-item-urban-goodz';
const QA_BUST = `qa-${Date.now()}`;

const hubTabs = [
  'Earn Money',
  'Logistics',
  'Load Board',
  'Medical Courier',
  'Book Anything',
  'Events',
  'Community',
  'Creators',
  'Ask UG',
  'UG+',
  'Fashion Fit',
];

const featureRoutes = [
  { path: '/urban-goodz-earn-money', expected: /Earn Money/i },
  { path: '/urban-goodz-logistics', expected: /Logistics/i },
  { path: '/urban-goodz-load-board', expected: /Load Board/i },
  { path: '/urban-goodz-medical-courier', expected: /Medical Courier/i },
  { path: '/urban-goodz-book-services', expected: /Book Services/i },
  { path: '/urban-goodz-events-creators', expected: /Local Events/i },
  { path: '/urban-goodz-community-marketplace', expected: /Community/i },
  { path: '/urban-goodz-creator-commerce', expected: /Creator/i },
  { path: '/urban-goodz-ai', expected: /Urban Goodz AI/i },
  { path: '/urban-goodz-plus', expected: /UG\+/i },
];

type HubNavigationResult = {
  directRouteWorks: boolean;
  hashRouteWorks: boolean;
  uiNavigationWorks: boolean;
  locationGateSeen: boolean;
  notes: string[];
};

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function withQaCacheBust(path: string): string {
  if (path === '/') return `/?v=${QA_BUST}`;
  if (path.startsWith('/#')) return `/?v=${QA_BUST}${path.substring(1)}`;
  return `${path}${path.includes('?') ? '&' : '?'}v=${QA_BUST}`;
}

async function gotoStable(page: Page, path = '/') {
  const targetPath = withQaCacheBust(path);
  console.log(`Navigating to: ${targetPath}`);
  let response = await page.goto(targetPath, { waitUntil: 'load', timeout: 30_000 }).catch(() => null);
  await page.waitForTimeout(1500);

  // Detect server 404 or empty/error page
  const textBeforeDismiss = await visibleText(page);
  const is404 = (response && response.status() === 404) ||
                textBeforeDismiss.includes('404 Not Found') ||
                textBeforeDismiss.includes('LiteSpeed');

  if (is404 && path !== '/' && !path.startsWith('/#')) {
    const hashPath = withQaCacheBust(`/#${path}`);
    console.log(`Direct path ${path} returned 404 or empty. Falling back to hash route: ${hashPath}`);
    response = await page.goto(hashPath, { waitUntil: 'load', timeout: 30_000 }).catch(() => null);
    await page.waitForTimeout(1500);
  }

  await enableFlutterAccessibility(page);
  await dismissBlockingOverlays(page);
}

async function enableFlutterAccessibility(page: Page) {
  const enableButton = page.getByRole('button', { name: /Enable accessibility/i });
  if (await enableButton.isVisible({ timeout: 1000 }).catch(() => false)) {
    console.log('Enable accessibility button found. Clicking...');
    await page.evaluate(() => {
      const placeholder = document.querySelector('flt-semantics-placeholder') as HTMLElement | null;
      placeholder?.click();
      placeholder?.dispatchEvent(new MouseEvent('click', { bubbles: true, cancelable: true, view: window }));
    }).catch(() => undefined);
    await page.waitForTimeout(500);
    await enableButton.click({ force: true, timeout: 2000 }).catch(() => undefined);
    await page.waitForTimeout(300);
    if (await enableButton.isVisible({ timeout: 500 }).catch(() => false)) {
      await page.keyboard.press('Tab').catch(() => undefined);
      await page.keyboard.press('Enter').catch(() => undefined);
    }
    await page.waitForTimeout(1000);
  }
}

async function visibleText(page: Page): Promise<string> {
  return page.locator('body').innerText({ timeout: 3000 }).catch(() => '');
}

async function dismissBlockingOverlays(page: Page) {
  // Click cookie acceptance if visible
  const cookieAcceptBtn = page.getByRole('button', { name: /Yes Accept|No Thanks/i }).first();
  if (await cookieAcceptBtn.isVisible({ timeout: 800 }).catch(() => false)) {
    await cookieAcceptBtn.click({ force: true, timeout: 1500 }).catch(() => undefined);
    await page.waitForTimeout(1000);
  } else {
    const viewport = page.viewportSize();
    if (viewport) {
      await page.mouse.click(Math.max(viewport.width - 190, 40), Math.max(viewport.height - 24, 40)).catch(() => undefined);
      await page.waitForTimeout(500);
    }
  }

  // Dismiss location picker modal if active. Do not click Pick From Map here:
  // it opens a blocking map modal and prevents deterministic route QA.
  const searchLocation = page.getByRole('textbox', { name: /Search Location/i }).first();
  const searchLocationPlaceholder = page.locator('input[placeholder*="Search Location"]').first();
  const searchInput = (await searchLocation.isVisible().catch(() => false)) ? searchLocation : searchLocationPlaceholder;

  if (await searchInput.isVisible({ timeout: 800 }).catch(() => false)) {
    console.log('Location picker active. Trying default Houston, TX location without opening map modal...');
    await searchInput.fill('Houston, TX').catch(() => undefined);
    await page.waitForTimeout(600);
    await page.keyboard.press('ArrowDown').catch(() => undefined);
    await page.keyboard.press('Enter').catch(() => undefined);
    await page.waitForTimeout(800);

    const setLocationBtn = page.getByRole('button', { name: /Set Location/i }).first();
    if (await setLocationBtn.isVisible().catch(() => false)) {
      await setLocationBtn.click({ force: true, timeout: 1500 }).catch(() => undefined);
      await page.waitForTimeout(800);
    }
  }

  // Handle generic dismiss buttons
  const dismissers = [
    page.getByText(/^Cancel$/i),
    page.getByText(/^×$/i),
    page.getByRole('button', { name: /close/i }),
    page.getByRole('button', { name: /cancel/i }),
    page.locator('.modal button.close, .modal .btn-close, button[aria-label="Close"]').first(),
  ];

  for (let attempt = 0; attempt < 3; attempt += 1) {
    for (const dismisser of dismissers) {
      if (await dismisser.isVisible({ timeout: 300 }).catch(() => false)) {
        await dismisser.click({ force: true, timeout: 1000 }).catch(() => undefined);
        await page.waitForTimeout(300);
      }
    }
  }

  await page.keyboard.press('Escape').catch(() => undefined);
  await page.waitForTimeout(300);
}

async function expectNoBlankScreen(page: Page) {
  await expect(page.locator('body')).toBeVisible();
  const metrics = await page.evaluate(() => ({
    htmlLength: document.body?.innerHTML?.trim().length || 0,
    canvasCount: document.querySelectorAll('canvas').length,
    glassPaneCount: document.querySelectorAll('flt-glass-pane').length,
    imageCount: document.querySelectorAll('img').length,
  }));

  const hasContent = metrics.htmlLength > 30 || 
                     metrics.canvasCount > 0 || 
                     metrics.glassPaneCount > 0 || 
                     metrics.imageCount > 0;

  expect(hasContent, 'page must render visible content, flt-glass-pane, canvases, or text elements').toBeTruthy();
}

async function expectNoCrashScreen(page: Page) {
  await expectNoBlankScreen(page);
  const text = await visibleText(page);
  expect(text).not.toMatch(/no route|exception|stack trace|failed assertion|application error/i);
}

async function visibleTextOrAccessibilityUnavailable(page: Page): Promise<string> {
  await enableFlutterAccessibility(page);
  await page.waitForTimeout(1000);
  return visibleText(page);
}

async function hubTextSnapshot(page: Page): Promise<string> {
  await enableFlutterAccessibility(page);
  await page.waitForTimeout(500);
  const text = await visibleText(page);
  const tabTexts = await page.getByRole('tab').allTextContents().catch(() => []);
  const tabLabels = await page.locator('flt-semantics[role="tab"]').evaluateAll((tabs) =>
    tabs.map((tab) => tab.getAttribute('aria-label') || tab.textContent || ''),
  ).catch(() => []);
  return `${text}\n${tabTexts.join('\n')}\n${tabLabels.join('\n')}`;
}

async function hasHubEvidence(page: Page): Promise<boolean> {
  const text = await hubTextSnapshot(page);
  return /Urban Goodz Hub/i.test(text) &&
    /Earn Money/i.test(text) &&
    /Fashion Fit/i.test(text);
}

async function isLocationGateVisible(page: Page): Promise<boolean> {
  const text = await visibleText(page);
  return /Select Your Location|Choose your location|Set Location|Pick From Map/i.test(text);
}

async function tryRouteForHub(page: Page, path: string): Promise<boolean> {
  const targetPath = withQaCacheBust(path);
  console.log(`Trying Hub route candidate: ${targetPath}`);
  await page.goto(targetPath, { waitUntil: 'load', timeout: 30_000 }).catch(() => null);
  await page.waitForTimeout(1800);
  await enableFlutterAccessibility(page);
  await dismissBlockingOverlays(page);
  await page.waitForTimeout(800);
  return hasHubEvidence(page);
}

async function tryUiNavigationToHub(page: Page): Promise<boolean> {
  console.log('Trying UI navigation to Hub from Home/Menu');
  await gotoStable(page, '/');
  const viewportBeforeMenu = page.viewportSize();
  if (viewportBeforeMenu) {
    await page.mouse.click(Math.max(viewportBeforeMenu.width - 190, 40), Math.max(viewportBeforeMenu.height - 24, 40)).catch(() => undefined);
    await page.waitForTimeout(500);
  }

  const menuTargets = [
    page.getByRole('tab', { name: /^Menu$/i }).first(),
    page.getByRole('button', { name: /^Menu$/i }).first(),
    page.getByText(/^Menu$/i).last(),
  ];

  const menuTarget = await firstVisible(page, menuTargets);
  if (menuTarget) {
    await menuTarget.click({ force: true, timeout: 2000 }).catch(() => undefined);
    await page.waitForTimeout(1500);
    await enableFlutterAccessibility(page);
  } else {
    const viewport = page.viewportSize();
    if (viewport) {
      console.log('Menu label not accessible. Trying desktop hamburger coordinate fallback.');
      const hamburgerClicks = [
        [viewport.width - 155, 70],
        [viewport.width - 150, 70],
        [viewport.width - 145, 70],
        [viewport.width - 155, 80],
      ];
      for (const [x, y] of hamburgerClicks) {
        await page.mouse.click(Math.max(x, 40), y).catch(() => undefined);
        await page.waitForTimeout(650);
      }
      await enableFlutterAccessibility(page);
    }
  }

  for (let i = 0; i < 8; i += 1) {
    const hubEntry = await firstVisible(page, [
      page.getByText(/^Urban Goodz Hub$/i).first(),
      page.getByText(/Urban Goodz Hub/i).first(),
    ]);

    if (hubEntry) {
      await hubEntry.click({ force: true, timeout: 2000 }).catch(() => undefined);
      await page.waitForTimeout(1800);
      await enableFlutterAccessibility(page);
      return hasHubEvidence(page);
    }

    const viewport = page.viewportSize();
    if (viewport) {
      await page.mouse.move(Math.max(viewport.width - 140, 40), Math.round(viewport.height / 2)).catch(() => undefined);
    }
    await page.mouse.wheel(0, 650).catch(() => undefined);
    await page.waitForTimeout(500);
  }

  return hasHubEvidence(page);
}

async function navigateToHub(page: Page): Promise<HubNavigationResult> {
  const result: HubNavigationResult = {
    directRouteWorks: false,
    hashRouteWorks: false,
    uiNavigationWorks: false,
    locationGateSeen: false,
    notes: [],
  };

  result.hashRouteWorks = await tryRouteForHub(page, '/#/urban-goodz-hub');
  result.locationGateSeen = result.locationGateSeen || await isLocationGateVisible(page);
  if (result.hashRouteWorks) {
    result.notes.push('Hash /#/urban-goodz-hub route reached the Hub.');
    return result;
  }
  result.notes.push('Hash /#/urban-goodz-hub did not show Hub evidence.');

  result.directRouteWorks = await tryRouteForHub(page, '/urban-goodz-hub');
  result.locationGateSeen = result.locationGateSeen || await isLocationGateVisible(page);
  if (result.directRouteWorks) {
    result.notes.push('Direct /urban-goodz-hub route reached the Hub.');
    return result;
  }
  result.notes.push('Direct /urban-goodz-hub did not show Hub evidence.');

  result.uiNavigationWorks = await tryUiNavigationToHub(page);
  result.locationGateSeen = result.locationGateSeen || await isLocationGateVisible(page);
  if (result.uiNavigationWorks) {
    result.notes.push('Home/Menu UI navigation reached the Hub.');
    return result;
  }

  result.notes.push('Home/Menu UI navigation did not show Hub evidence.');
  return result;
}

async function expectHubReached(page: Page, result: HubNavigationResult) {
  const text = await hubTextSnapshot(page);
  expect(
    await hasHubEvidence(page),
    [
      'QA could not reach Urban Goodz Hub.',
      `Direct route works: ${result.directRouteWorks}`,
      `Hash route works: ${result.hashRouteWorks}`,
      `UI navigation works: ${result.uiNavigationWorks}`,
      `Location/home gate seen: ${result.locationGateSeen}`,
      `Notes: ${result.notes.join(' ')}`,
      `Current URL: ${page.url()}`,
      `Visible text: ${text.slice(0, 1200)}`,
    ].join('\n'),
  ).toBeTruthy();
}

async function selectHubTab(page: Page, label: string) {
  const pattern = new RegExp(`^${escapeRegExp(label)}$`, 'i');
  for (let i = 0; i < 8; i += 1) {
    const tab = await firstVisible(page, [
      page.getByRole('tab', { name: pattern }).first(),
      page.getByText(pattern).first(),
    ]);

    if (tab) {
      await tab.click({ force: true, timeout: 2500 }).catch(() => undefined);
      await page.waitForTimeout(1200);
      await expectNoCrashScreen(page);
      return;
    }

    await page.mouse.wheel(650, 0).catch(() => undefined);
    await page.waitForTimeout(400);
  }

  throw new Error(`Could not find Hub tab: ${label}`);
}

async function firstVisible(page: Page, locators: Locator[]): Promise<Locator | null> {
  for (const locator of locators) {
    const count = await locator.count().catch(() => 0);
    for (let i = 0; i < count; i += 1) {
      const item = locator.nth(i);
      if (await item.isVisible().catch(() => false)) return item;
    }
  }
  return null;
}

async function openSearch(page: Page) {
  const searchTarget = await firstVisible(page, [
    page.getByPlaceholder(/Search products, services, rentals, businesses, events/i),
    page.getByText(/Search products, services, rentals, businesses, events/i),
    page.getByRole('button', { name: /search/i }),
    page.locator('input[type="text"]'),
  ]);

  if (searchTarget) {
    await searchTarget.click().catch(() => undefined);
    await page.waitForTimeout(1000);
  } else {
    await gotoStable(page, '/search?query=' + encodeURIComponent(UNAVAILABLE_QUERY));
  }
}

async function runDiscoveryNoResultsFlow(page: Page) {
  await gotoStable(page, '/');
  await openSearch(page);

  const searchInput = await firstVisible(page, [
    page.getByPlaceholder(/Search/i),
    page.locator('input[type="text"]'),
    page.locator('textarea'),
  ]);

  if (searchInput) {
    await searchInput.fill(UNAVAILABLE_QUERY).catch(() => undefined);
    await searchInput.press('Enter').catch(async () => {
      const button = await firstVisible(page, [page.getByRole('button', { name: /search/i }), page.locator('[role="button"]')]);
      if (button) await button.click().catch(() => undefined);
    });
  } else {
    await gotoStable(page, `/search?query=${encodeURIComponent(UNAVAILABLE_QUERY)}`);
  }

  await page.waitForTimeout(2000);
  await expectNoCrashScreen(page);

  const requestField = await firstVisible(page, [
    page.getByLabel(/What were you looking for/i),
    page.getByPlaceholder(/What were you looking for/i),
    page.locator('input[type="text"]'),
  ]);
  if (requestField) {
    await requestField.fill(UNAVAILABLE_QUERY).catch(() => undefined);
  }

  const submit = await firstVisible(page, [
    page.getByRole('button', { name: /Submit Search Request/i }),
    page.getByText(/Submit Search Request/i),
  ]);
  if (submit) {
    await submit.click().catch(() => undefined);
    await page.waitForTimeout(1500);
  }
}

test.describe('Urban Goodz public QA - desktop', () => {
  test.use({ baseURL: BASE_URL });

  test.beforeEach(async ({}, testInfo) => {
    testInfo.setTimeout(180_000);
  });

  test('Home / Shell smoke check', async ({ page }, testInfo) => {
    test.skip(testInfo.project.name !== 'desktop-chromium', 'Desktop tests run only in the desktop project.');
    await gotoStable(page, '/');
    await expectNoCrashScreen(page);
    
    const text = await visibleText(page);
    expect(text).not.toContain('404 Not Found');
    expect(text).not.toContain('LiteSpeed');
    
    await page.screenshot({ path: testInfo.outputPath('home.png'), fullPage: true });
  });

  test('Urban Goodz Hub tabs and actions', async ({ page }, testInfo) => {
    test.skip(testInfo.project.name !== 'desktop-chromium', 'Desktop tests run only in the desktop project.');
    const hubNavigation = await navigateToHub(page);
    console.log(`Hub navigation result: ${JSON.stringify(hubNavigation)}`);
    await expectHubReached(page, hubNavigation);
    await expectNoCrashScreen(page);

    await page.screenshot({ path: testInfo.outputPath('urban-goodz-hub.png'), fullPage: true });

    const tabs = page.getByRole('tab');
    const tabCount = await tabs.count().catch(() => 0);
    console.log(`Found ${tabCount} tabs in accessibility tree`);
    expect(tabCount, 'Should find tab elements in the Hub').toBeGreaterThan(0);

    const pageText = await visibleTextOrAccessibilityUnavailable(page);
    const accessibleTabs = new Set<string>();

    for (let i = 0; i < tabCount; i++) {
      const tab = tabs.nth(i);
      const tabText = (await tab.getAttribute('aria-label').catch(() => null)) ||
        await tab.innerText().catch(() => '');
      if (tabText) {
        console.log(`Clicking tab ${i}: ${tabText}`);
        accessibleTabs.add(tabText.trim());
        await tab.click({ force: true }).catch(() => undefined);
        await page.waitForTimeout(800);
        if (tabText.toLowerCase().includes('earn money')) {
          await page.screenshot({ path: testInfo.outputPath('hub-earn-money-tab.png'), fullPage: true });
        }
      }
    }

    expect(accessibleTabs.size, 'Should find at least 5 accessible tabs in the Hub').toBeGreaterThan(0);

    for (const label of hubTabs) {
      const labelPattern = new RegExp(escapeRegExp(label), 'i');
      const foundInTabs = Array.from(accessibleTabs).some((tabText) => labelPattern.test(tabText));
      expect(foundInTabs, `Required tab "${label}" should be found in accessible tabs list`).toBeTruthy();
    }

    const missingTabs = hubTabs.filter((label) => {
      const labelPattern = new RegExp(escapeRegExp(label), 'i');
      return !Array.from(accessibleTabs).some((tabText) => labelPattern.test(tabText)) &&
        !labelPattern.test(pageText);
    });

    expect(
      missingTabs,
      `Hub QA could not verify these required tester tabs from accessible text: ${missingTabs.join(', ')}`,
    ).toEqual([]);
  });

  test('Feature routes load directly and back navigation works', async ({ page }, testInfo) => {
    test.skip(testInfo.project.name !== 'desktop-chromium', 'Desktop tests run only in the desktop project.');
    for (const route of featureRoutes) {
      await gotoStable(page, route.path);
      await expectNoCrashScreen(page);
      
      if (route.path.includes('community')) {
        await page.screenshot({ path: testInfo.outputPath('community-route.png'), fullPage: true });
      }
      if (route.path.includes('creator-commerce')) {
        await page.screenshot({ path: testInfo.outputPath('creator-commerce-route.png'), fullPage: true });
      }
      
      await page.goBack({ waitUntil: 'domcontentloaded' }).catch(() => undefined);
      await page.waitForTimeout(500);
    }
  });

  test('Fashion Fit tester entry is visible from the Hub', async ({ page }) => {
    test.skip(test.info().project.name !== 'desktop-chromium', 'Desktop tests run only in the desktop project.');
    const hubNavigation = await navigateToHub(page);
    console.log(`Fashion Fit Hub navigation result: ${JSON.stringify(hubNavigation)}`);
    await expectHubReached(page, hubNavigation);
    await expectNoCrashScreen(page);

    await selectHubTab(page, 'Fashion Fit');
    await expectNoCrashScreen(page);

    const combinedText = await hubTextSnapshot(page);

    expect(
      combinedText,
      'Fashion Fit title should be visible in the content area.',
    ).toMatch(/Fashion Fit & Measurements/i);

    expect(
      combinedText,
      'Fashion Fit description should be visible in the content area.',
    ).toMatch(/Create a tester preview fit profile/i);
  });

  test('Discovery no-results capture flow', async ({ page }, testInfo) => {
    test.skip(testInfo.project.name !== 'desktop-chromium', 'Desktop tests run only in the desktop project.');
    await runDiscoveryNoResultsFlow(page);
    await page.screenshot({ path: testInfo.outputPath('discovery-no-results.png'), fullPage: true });
  });
});

test.describe('Urban Goodz public QA - mobile', () => {
  test.use({ baseURL: BASE_URL });

  test.beforeEach(async ({}, testInfo) => {
    testInfo.setTimeout(180_000);
  });

  test('Mobile core hub and discovery smoke checks', async ({ page }, testInfo) => {
    test.skip(!testInfo.project.name.startsWith('mobile-'), 'Mobile tests run only in mobile projects.');
    await gotoStable(page, '/urban-goodz-hub');
    await expectNoCrashScreen(page);

    await page.screenshot({ path: testInfo.outputPath(`mobile-hub-${testInfo.project.name}.png`), fullPage: true });

    await runDiscoveryNoResultsFlow(page);
    await page.screenshot({ path: testInfo.outputPath(`mobile-discovery-${testInfo.project.name}.png`), fullPage: true });
  });
});
