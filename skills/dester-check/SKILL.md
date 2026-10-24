---
name: dester-check
description: "Turn tested cases into repeatable Playwright checks, and provide the browser helpers used by the other dester skills: a login helper where the human signs in (never the skill), and a read-only recon crawler. Creates a small checks project in the QA folder, writes one test per case with stable locators and cleanup, runs it, and records results with evidence. Use when the user says /dester-check, 'automate this', 'make a Playwright test', 'repeat these checks', 'regression pack', 'sign in helper', 'crawl the pages', or after cases passed and will be retested."
metadata:
  author: Destine April
  version: 0.1.0
  license: TBD (placeholder, MIT planned)
  suite: dester
---

# dester-check v0.1.0

Author: Destine April. Read `references/core-rules.md` first; those rules win.

**What it does:** (1) provides the browser helpers: `scripts/login.mjs` and `scripts/recon.mjs`; (2) turns cases that
were run by hand into repeatable Playwright checks; (3) runs them and records honest results.

Automate **after** a human or the skill has run the case once and understood it. Do not automate guesses.

## Helpers (installed with the skill at `~/.claude/skills/dester-check/scripts/`)

**Setup once per project** (inside `qa-<system>/checks/`, never inside the skills folder):
```
cd qa-<system>/checks && npm init -y && npm i -D playwright@latest @playwright/test
```
Playwright needs a browser. If the user has Google Chrome installed, the helpers use it (`CHANNEL=chrome`, the
default); otherwise run `npx playwright install chromium` (ask first; it downloads a browser).

**login.mjs**: opens a visible browser. The human signs in, including 2FA. The session is saved to
`~/.dester-sessions/<project>.json` (outside the project, mode 600). It never types credentials, never prints the
session. Session files are secrets: never commit, share or paste them. Sessions expire; ask the human to sign in
again.
```
SITE=https://app.example.com SESSION=~/.dester-sessions/<project>.json node scripts/login.mjs
```
One session per role (use a different `SESSION` file for each role).
It saves when the password field appears and goes away. For SSO, Google sign-in or magic links, add
`DONE_URL="/dashboard"` (a regex for a page that only shows after sign-in), or when the human says "done" run
`touch <SESSION>.done`. Check the printed landing path: if it is still the sign-in page, the session is not signed in;
do not use it.

**recon.mjs**: read-only crawl after login. Navigates only; never clicks buttons or submits; skips links matching
logout, delete, remove, revoke, reset (change with `SKIP=`). Writes `evidence/recon.json` and screenshots.
```
SITE=https://app.example.com SESSION=~/.dester-sessions/<project>.json OUT=./evidence START=/dashboard node scripts/recon.mjs
```
Screenshots may show real names and emails: redact before sharing.

If the user's machine has a different setup (no Node), say what is needed and ask; do not install system software
without a yes.

## Quick start

| User says | Do |
|---|---|
| "set up the browser helper" | Setup, then login helper |
| "crawl the app" | recon after login |
| "automate cases for <area>" | Steps 1 to 6 |
| "run the checks" | Step 5 |
| "recheck after the fix" | Step 5, compare with the previous run |

## Step 1: Choose what to automate (ask, with defaults)

Pick cases from `05_TEST_CASES.md` that are: stable, repeatable, valuable (core flows, bugs that were fixed, role
boundaries), and do not need real email or SMS. *Default: P1 cases that Passed or are Bug, read-only first.* Show the
list and get a yes. Skip: visual judgment, one-time setups, anything touching real emails, payments or other people.

## Step 2: Write the specs (`checks/tests/<area>.spec.ts`)

Rules:
- **One test per case.** Title starts with the case id: `test('TC-ORD-004 negative: empty quantity is rejected', ...)`.
- **Steps come from the case.** The expected result is asserted explicitly with a visible check. No `expect(true)`.
- **Locators, best first:** `getByRole`, `getByLabel`, `getByTestId` (only if seen in code or page), then text.
  Never invent a locator; if none is stable, mark the check `blocked: needs a test id` and tell the owner.
- **No fixed sleeps.** Wait for a condition (`expect(...).toBeVisible()`, `waitForResponse`).
- **No credentials in code.** Use `storageState` from the human-created session file via an environment variable.
- **Own data only:** a test that creates records names them `QA Auto <unique suffix>`, and cleanup is a **separate**
  step that verifies the result. Default is read-only.
- **No dependence on one account's data:** create what you need, or state a placeholder precondition and skip with a
  clear message if it is missing (a skipped test is reported as Not run, never as Pass).
- **Production:** none, unless the owner's written permission says so. Keep the base URL in an environment variable.
- **Roles:** one session file per role; check allowed and denied on the menu, the direct URL and the request.
- **Accessibility smoke (optional):** `@axe-core/playwright` scan per page; report as basic only.
- Mark known bugs `test.fail()` with the bug id so the test turns red when it is fixed.

Use `references/templates.md` for `playwright.config.ts`, a spec example, and a role check example.

## Step 3: Dry run on the human's session

Ask the human to sign in with `login.mjs` first. Run one spec headed (`--headed`) so the user can watch, then fix
locators. Do not "fix" a failing test by weakening its assertion; a failure is data (Step 5).

## Step 4: Evidence settings

Config: trace and screenshot on failure, video on first retry, retries 1 (a pass only on retry is `Flaky`).
Reports to `checks/report/`. Evidence for the cases goes to `evidence/` with the case id in the name.

## Step 5: Run and record

1. Run: `npx playwright test --reporter=list,html`. Quote the actual output. Never claim a result without the run.
2. For every test map: passed -> case Status Pass with evidence path; failed -> referee (repeat, setup check) and
   label with `dester-report`; skipped -> Not run with reason; passed on retry -> Flaky.
3. Update `05_TEST_CASES.md` and `05_TEST_CASES.csv` statuses only for tests that really ran. Recount totals.
4. Write `checks/RUNS.md`: date, build or date of the system, command, counts, failures and labels.

## Step 6: Keep it repeatable

- Tag checks (`@smoke`, `@roles`, `@regression`) so the user can run only some.
- After a bug fix: run the expected-fail check; it turns red when the bug is fixed; then remove `test.fail()` and add
  the neighbors to the regression list.
- Document in `checks/README.md`: how to sign in, run, and which cases are covered.

## Self-check before handing over

- Every spec traces to a case id. No credentials, tokens or session files inside the project. No real data.
- Commands shown were really run, with the real result. Counts recounted. Skips reported as Not run.
- Cleanup steps exist and were verified for tests that write.

## Hand-off

Show counts first (pass, fail, flaky, not run), failures with labels, and what is not automated and why. Do not push
the checks to a repository, CI or the client without a separate yes.
