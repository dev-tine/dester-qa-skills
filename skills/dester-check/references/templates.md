# Playwright templates

Author: Destine April | dester-check v0.1.0

## playwright.config.ts

```ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  retries: 1,                       // pass only on retry = Flaky
  workers: 1,                       // one at a time against a shared test system
  reporter: [['list'], ['html', { outputFolder: 'report', open: 'never' }]],
  use: {
    baseURL: process.env.BASE_URL,  // required, never hard-coded; never production without written permission
    storageState: process.env.SESSION, // session file made by login.mjs (human signed in)
    channel: process.env.CHANNEL || 'chrome',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
});
```

Run: `BASE_URL=https://staging.example.com SESSION=~/.dester-sessions/admin.json npx playwright test`

## Spec example (read-only check from a case)

```ts
import { test, expect } from '@playwright/test';

test.describe('Meetings list', () => {
  test('TC-MTG-001 happy: list shows scheduled meetings with status', async ({ page }) => {
    await page.goto('/meetings');
    await expect(page.getByRole('heading', { name: 'Meetings' })).toBeVisible();
    await page.getByRole('tab', { name: 'Scheduled' }).click();
    const rows = page.getByRole('row');
    await expect(rows.first()).toBeVisible();
  });
});
```

## Negative check example (writes nothing)

```ts
test('TC-ORD-004 negative: empty name is rejected', async ({ page }) => {
  await page.goto('/organizations');
  await page.getByRole('button', { name: 'Add organization' }).click();
  await page.getByRole('button', { name: 'Save' }).click();          // submit empty
  await expect(page.getByText(/required/i)).toBeVisible();           // expected: from the spec
  await expect(page).toHaveURL(/organizations/);                     // nothing was created
});
```

## Role check example (two sessions)

```ts
import { test, expect } from '@playwright/test';

test.use({ storageState: process.env.SESSION_EMPLOYEE });          // the lower role
test('TC-ROLE-010 negative: employee cannot open admin settings by URL', async ({ page }) => {
  const res = await page.goto('/settings/team');
  await expect(page.getByRole('heading', { name: /team|access/i })).toHaveCount(0);
  expect(res?.status()).not.toBe(200);                               // adjust to the real expected behavior
});
```
Always also check the menu (hidden?) and the request (blocked?). A hidden menu alone proves nothing.

## Known bug, turns red when fixed

```ts
test('BUG-001 Past meeting listed as upcoming', async ({ page }) => {
  test.fail(true, 'BUG-001 open');                                 // remove when fixed
  await page.goto('/dashboard');
  // assert the intended behavior here
});
```

## Accessibility smoke (optional)

```ts
import AxeBuilder from '@axe-core/playwright';
test('A11Y-001 dashboard has no detectable serious issues (basic)', async ({ page }) => {
  await page.goto('/dashboard');
  const results = await new AxeBuilder({ page }).analyze();
  expect(results.violations.filter(v => ['serious', 'critical'].includes(v.impact ?? ''))).toEqual([]);
});
```
