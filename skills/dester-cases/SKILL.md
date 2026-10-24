---
name: dester-cases
description: "Write test cases for a system, feature or screen from a derived spec, an exploration map, a link you can open, or a repo. Newbie-friendly, plain language. Produces cases in five categories (happy path, positive, negative, edge, boundary) with traceability to a requirement or spec row, in Markdown and CSV ready to import into a test tool. Use when the user says /dester-cases, 'write test cases', 'make a test plan', 'cases for this screen', or after dester-explore."
metadata:
  author: Destine April
  version: 0.1.0
  license: TBD (placeholder, MIT planned)
  suite: dester
---

# dester-cases v0.1.0

Author: Destine April. Read `references/core-rules.md` first; those rules win.

**What it does:** turns what is known about a system into test cases a person (or a Playwright spec later) can run.
Each case says what to do, what should happen, and **where that expectation comes from**.

## Where the expectation comes from (this decides everything)

A test case is only as good as its expected result. Never take the expected result only from what the app did.

| Source | Label on the case |
|---|---|
| Owner or developer confirmed it, or a real document | `Confirmed` |
| A derived spec row with confidence Seen, confirmed by the owner | `Confirmed` |
| A derived spec row Seen but not confirmed | `Observed (needs owner confirmation)` |
| From code or guess | `Hypothesis` |
| Common sense or standard behavior (a password field hides input, required field cannot be empty) | `Standard` |

Cases labelled Observed or Hypothesis are listed in `questions.md` so the owner can confirm them.

## Inputs (ask, with defaults)

1. **Scope:** which module, screen, flow or role? *Default: the highest-risk charter from `03_CHARTERS.md`.*
2. **Source:** `02_DERIVED_SPEC.md` and `01_MAP.md` if they exist (best). Otherwise a link (open it, see Access mode in
   `dester-explore`), a repo (read only), screenshots, or the user's description. If nothing exists yet, offer to run
   `dester-explore` first, or to do a quick look at only this screen.
3. **Detail level:** short (title, steps, expected) or full (add preconditions, data, priority). *Default: full.*
4. **Output:** Markdown, CSV for import (Testiny, TestRail, Jira Xray, Excel), or both. *Default: both.*
5. **Cases are for:** manual run now, handing to a client, or automation later. This only changes wording.

## Method

1. List the **requirements or spec rows** in scope. One row of the spec becomes one or more cases. Show the list
   and let the user add or remove rows.
2. For each row write cases in five categories (skip a category only if it truly does not apply, and say so):
   - **Happy path:** everything valid, normal user.
   - **Positive:** valid but different (optional fields empty, other valid options, other role that is allowed).
   - **Negative:** invalid input, forbidden role, wrong order, missing data.
   - **Edge:** unusual but valid (long text, special characters, duplicates, empty states, many records).
   - **Boundary:** just below, at and just over each limit (0, 1, max, max+1); dates and amounts at cut-offs.
3. Add **role cases**: for each role and each key action, allowed or denied, and what the user sees (menu, button,
   direct URL). Add **data accuracy cases**: the calculation done by hand (show the working) versus what the
   system shows.
4. Prioritize with risk (`dester-explore` references/charters.md): P1 money, data loss, security, core flow;
   P2 common features; P3 cosmetic or rare.
5. Never invent limits, formulas or message text. If unknown: write the case with `Expected: TBD, ask owner` and add a
   question. A guessed expected result is a trap.

## Case format

```
TC-<MODULE>-<nnn> | <title: action and condition> | P1/P2/P3 | Category
Source: <spec row, requirement or "Standard"> | Basis: Confirmed / Observed / Hypothesis / Standard
Preconditions: <role, data, state>
Steps:
1. ...
Expected: <specific, checkable result>
Data: <fictional values>
Status: Not run | Pass | Bug | Blocked | Flaky   (Pass only with evidence, core rules 5 and 7)
Evidence: <path or "-">
```

Automation-ready cases (when the cases will become Playwright checks with `dester-check`):
- One action per step, from a known start (a page, or sign-in as a role). Use the verb the user performs and the exact
  on-screen label in quotes: `Click the "Save" button`, `Type in the "Name" field`.
- Add a locator hint only when it was actually seen in the page or code: `{testid: save}`, `{role: button, name: Save}`.
  Never invent one.
- Say what to wait for before the next step ("wait for the 'Saved' message").
- **Never depend on one account's data.** Do not name records that exist only in the account you explored (customers,
  invoices, ids, emails, amounts copied from the screen). Make the case create its own data with a unique `QA ` name,
  or state a placeholder precondition ("an active customer with an unpaid invoice exists, set up by the tester").
  System reference data (fixed statuses, roles, dropdown options) is fine.

Rules for good cases: one idea per case; steps a newbie can follow; expected is observable (a message, a number, a
visible state), not "works fine"; fictional data only (`QA Test Merchant 01`).

## Files (in the project folder; create it if missing)

```
05_TEST_CASES.md        grouped by module, then category, with a coverage table at the top
05_TEST_CASES.csv       one row per case: ID, Module, Title, Priority, Category, Source, Basis, Preconditions, Steps, Expected, Data, Status
05_COVERAGE.md          spec row or requirement -> case IDs; rows with no case; cases with no source
```

## Self-check before handing over

- Every case has a Source and a Basis. Every spec row in scope has at least one case, or is listed as uncovered.
- No expected result is `Observed` without being flagged for confirmation.
- Counts add up: cases per category and per priority match the lists. CSV row count equals the case count.
- Fictional data only. No secrets. No case claims Pass without evidence.

## Hand-off

Show: counts by priority and category, what is uncovered, what needs owner confirmation (first). Ask whether to run
some cases now (record results with evidence), export, or continue to `dester-docs`. Never push to a test tool or
repo without a yes for that exact action.
