import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  timeout: 90_000,
  expect: { timeout: 15_000 },
  fullyParallel: false,
  retries: process.env.CI ? 1 : 0,
  reporter: [['list'], ['html', { outputFolder: 'playwright-report', open: 'never' }]],
  use: {
    baseURL: process.env.UG_TEST_URL || 'https://test.urbangoodzdelivery.com',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
    actionTimeout: 20_000,
    navigationTimeout: 60_000,
    permissions: ['geolocation'],
    geolocation: { latitude: 29.7604, longitude: -95.3698 },
  },
  projects: [
    { name: 'desktop-chromium', use: { ...devices['Desktop Chrome'], browserName: 'chromium', viewport: { width: 1440, height: 1000 } } },
    { name: 'mobile-iphone-chromium', use: { ...devices['Desktop Chrome'], browserName: 'chromium', viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true } },
    { name: 'mobile-android-chromium', use: { ...devices['Desktop Chrome'], browserName: 'chromium', viewport: { width: 412, height: 915 }, isMobile: true, hasTouch: true } },
  ],
  outputDir: 'test-results/urban-goodz-public-qa',
});
