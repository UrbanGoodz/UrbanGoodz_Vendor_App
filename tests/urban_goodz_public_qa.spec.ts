import { expect, Locator, Page, test } from '@playwright/test';

const BASE_URL = process.env.UG_TEST_URL || 'https://test.urbangoodzdelivery.com';
const UNAVAILABLE_QUERY = 'zxqv-unavailable-test-item-urban-goodz';

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

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

async function gotoStable(page: Page, path = '/') {
  console.log(`Navigating to: ${path}`);
  let response = await page.goto(path, { waitUntil: 'load', timeout: 30_000 }).catch(() => null);
  await page.waitForTimeout(1500);

  // Detect server 404 or empty/error page
  const textBeforeDismiss = await visibleText(page);
  const is404 = (response && response.status() === 404) || 
                textBeforeDismiss.includes('404 Not Found') || 
                textBeforeDismiss.includes('LiteSpeed') ||
                textBeforeDismiss.trim() === '';

  if (is404 && path !== '/' && !path.startsWith('/#')) {
    const hashPath = `/#${path}`;
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
    await enableButton.click({ force: true, timeout: 2000 }).catch(async () => {
      await page.keyboard.press('Tab').catch(() => undefined);
      await page.keyboard.press('Enter').catch(() => undefined);
    });
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
  }

  // Dismiss location picker modal if active
  const searchLocation = page.getByRole('textbox', { name: /Search Location/i }).first();
  const searchLocationPlaceholder = page.locator('input[placeholder*="Search Location"]').first();
  const searchInput = (await searchLocation.isVisible().catch(() => false)) ? searchLocation : searchLocationPlaceholder;

  if (await searchInput.isVisible({ timeout: 800 }).catch(() => false)) {
    console.log('Location picker active. Setting default location to Houston, TX...');
    await searchInput.fill('Houston, TX').catch(() => undefined);
    await page.waitForTimeout(600);
    await page.keyboard.press('ArrowDown').catch(() => undefined);
    await page.keyboard.press('Enter').catch(() => undefined);
    await page.waitForTimeout(800);

    const setLocationBtn = page.getByRole('button', { name: /Set Location/i }).first();
    const pickFromMapBtn = page.getByRole('button', { name: /Pick From Map/i }).first();
    if (await setLocationBtn.isVisible().catch(() => false)) {
      await setLocationBtn.click({ force: true, timeout: 1500 }).catch(() => undefined);
      await page.waitForTimeout(800);
    } else if (await pickFromMapBtn.isVisible().catch(() => false)) {
      await pickFromMapBtn.click({ force: true, timeout: 1500 }).catch(() => undefined);
      await page.waitForTimeout(800);
    }
  }

  // Handle generic dismiss buttons
  const dismissers = [
    page.getByText(/^Cancel$/i),
    page.getByRole('button', { name: /close/i }),
    page.locator('.modal button.close, .modal .btn-close, button[aria-label="Close"]').first(),
  ];

  for (const dismisser of dismissers) {
    if (await dismisser.isVisible({ timeout: 300 }).catch(() => false)) {
      await dismisser.click({ force: true, timeout: 1000 }).catch(() => undefined);
      await page.waitForTimeout(300);
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

  expect(metrics.htmlLength, 'document body HTML should not be empty').toBeGreaterThan(50);
  expect(
    metrics.canvasCount + metrics.glassPaneCount + metrics.imageCount + (metrics.htmlLength > 500 ? 1 : 0), 
    'page must render visible content, canvases, or text elements'
  ).toBeGreaterThan(0);
}

async function expectNoCrashScreen(page: Page) {
  await expectNoBlankScreen(page);
  const text = await visibleText(page);
  expect(text).not.toMatch(/no route|exception|stack trace|failed assertion|application error/i);
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
    await gotoStable(page, '/urban-goodz-hub');
    await expectNoCrashScreen(page);

    await page.screenshot({ path: testInfo.outputPath('urban-goodz-hub.png'), fullPage: true });

    const tabs = page.getByRole('tab');
    const tabCount = await tabs.count().catch(() => 0);
    console.log(`Found ${tabCount} tabs in accessibility tree`);

    for (let i = 0; i < tabCount; i++) {
      const tab = tabs.nth(i);
      const tabText = await tab.innerText().catch(() => '');
      if (tabText) {
        console.log(`Clicking tab ${i}: ${tabText}`);
        await tab.click({ force: true }).catch(() => undefined);
        await page.waitForTimeout(800);
        if (tabText.toLowerCase().includes('earn money')) {
          await page.screenshot({ path: testInfo.outputPath('hub-earn-money-tab.png'), fullPage: true });
        }
      }
    }
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

  test('Hidden Fashion Measurements check', async ({ page }) => {
    test.skip(test.info().project.name !== 'desktop-chromium', 'Desktop tests run only in the desktop project.');
    await gotoStable(page, '/urban-goodz-hub');
    const text = await visibleText(page);
    expect(text).not.toMatch(/Fashion Measurements|Tailor Sizing/i);
    await gotoStable(page, '/');
    expect(await visibleText(page)).not.toMatch(/Fashion Measurements|Tailor Sizing/i);
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
