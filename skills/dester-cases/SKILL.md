---
name: dester-cases
description: "Write test cases for a module, feature or screen of any product, from a link you can open, a code repo (read only), a derived spec or exploration map, tickets or docs. One-line use: /dester-cases [module] [product] [link] [repo]. Newbie-friendly, plain language. Produces cases in five categories (happy path, positive, negative, edge, boundary) with traceability to a requirement or spec row, in Markdown and CSV ready to import into a test tool, saved per module in the product's Test Cases repo (dester-init) when there is one. Use when the user says /dester-cases, 'write test cases', 'make a test plan', 'cases for this screen', 'cases for this module', or after dester-explore or dester-modules."
metadata:
  author: Destine April
  version: 0.2.1
  license: MIT
  suite: dester
---

# dester-cases v0.2.1

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

## Quick start (one line)

```
/dester-cases <module> <product> <link> [repo] [notes]
/dester-cases Inventory "Acme Shop" https://staging.example.com
/dester-cases "Job Orders" "Acme Shop" https://staging.example.com https://github.com/org/acme-shop "focus on pricing"
```

| User gives | Do |
|---|---|
| module, product, link (and maybe repo) | Skip the Inputs questions they answer; use defaults for the rest; say the defaults in one line; go to Fast path |
| only `/dester-cases` | Inputs below, one group at a time |
| "next module" | Read `MODULES.md`, take the recommended module (dester-modules Step 4), confirm in one line |
| "answers for <module>: ..." | Match each answer to its question in `questions.md`. Update the case's Expected and set Basis `Confirmed (owner)` (or keep `Observed` if the answer is unsure). If the answer says the app is wrong, keep the expected result from the answer and note "app differs, possible bug". Move answered questions to an "Answered" list with the date. Update `coverage.md` |
| "mark <module> as reviewed" | Only after the user says they reviewed the cases. Change `cases.md` Status to `REVIEWED by <name>, <date>`, set the module's `MODULES.md` Status to `Cases reviewed`. Open questions stay listed |

Arguments in quotes when they have spaces. Anything that is not a module, product name or URL is notes. A second
URL that points to a code host (GitHub, GitLab, Azure DevOps, Bitbucket) or a local path is the repo.

## Where the cases go

1. Look for a Test Cases repo (`.dester-cases-repo` in the current folder, a parent, or `./*-test-cases/`) whose
   product matches. Found: write to `modules/<module-slug>/` there (`cases.md`, `cases.csv`, `coverage.md`,
   `questions.md`), take the module code from `MODULES.md` (add a row if the module is new), and follow the repo's
   case format if `README.md` says it differs.
2. Not found: offer `/dester-init <product> <link>` first. *Default: yes, it takes a minute.* If the user says no,
   use the project folder files at the end of this skill.

## Fast path: link and code, no spec yet

When there is no `02_DERIVED_SPEC.md` for the module (the usual case with the one-line call):
1. **Gate:** say the system, that it is staging or a test copy, which role the human will sign in as, and that you
   will only look (no create, edit, delete) unless the user allows creating `QA ` data. Wait for a yes.
2. **Screen (Seen):** the human signs in. Open each screen of the module: read labels, fields (type, required
   mark, placeholder, max length if shown), buttons, tabs, table columns, filters and empty states. Trigger
   validation messages only if the user allowed it, and never submit a real record. Save one screenshot per screen
   to the QA project folder `evidence/` (no project folder yet? create `qa-<product-slug>/evidence/` next to the
   cases repo), never into the cases repo. If the browser tool cannot save a screenshot to disk, record the
   observed values as text with the time. Screenshots can lag behind the page: before you trust one, read the
   value from the page itself (field value, message text).
3. **Code (Hypothesis, only if a repo was given):** read only, rules of `dester-repo`. Find the module's pages,
   form schemas and validators (required, min, max, regex, enums), permission checks, calculations, status changes
   and API handlers. Note file and line for each rule.
4. **Rule list:** merge into one numbered list `R-<CODE>-01 ...`, each with Basis (Seen, Hypothesis, Standard,
   Confirmed if a ticket or doc says it) and where it came from. Where screen and code disagree, write both and add
   a question. Show the list; the user can add or cut rows. This list replaces the spec in Method step 1.
5. Continue with Method. Any expected result that rests only on what the screen did is `Observed`, never
   `Confirmed`.

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
     For money, add a half-cent case (a result like 0.075 or 1.005): computers often round these the wrong way,
     so write the expected rounding as `TBD, ask owner` unless a source states the rule.
3. Add **role cases**: for each role and each key action, allowed or denied, and what the user sees (menu, button,
   direct URL). Add **data accuracy cases**: the calculation done by hand (show the working) versus what the
   system shows.
4. Prioritize with risk (`~/.claude/skills/dester-explore/references/charters.md`): P1 money, data loss, security, core flow;
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

## Files

In a Test Cases repo (preferred), per module:

```
modules/<module-slug>/cases.md       status block, coverage table, then cases grouped by category
modules/<module-slug>/cases.csv      one row per case: ID, Module, Title, Priority, Category, Source, Basis, Preconditions, Steps, Expected, Data, Status
modules/<module-slug>/coverage.md    rule or requirement -> case IDs; rows with no case; cases with no source
modules/<module-slug>/questions.md   Observed and Hypothesis expectations waiting for the owner
```

Then update that module's row in `MODULES.md` (Status `Cases drafted`, case count) and `STATE.md` RESUME HERE.
Adding to a module that already has cases: continue the numbering, never renumber or overwrite existing cases;
mark replaced ones `Retired`.

No cases repo (project folder; create it if missing):

```
05_TEST_CASES.md        grouped by module, then category, with a coverage table at the top
05_TEST_CASES.csv       same columns as above
05_COVERAGE.md          spec row or requirement -> case IDs; rows with no case; cases with no source
```

Show a preview (counts, the rule list, 3 sample cases, the questions) before writing files. Writing local files
is fine after the preview; `git commit` and `git push` each need their own yes.

## Self-check before handing over

- Every case has a Source and a Basis. Every spec row in scope has at least one case, or is listed as uncovered.
- No expected result is `Observed` without being flagged for confirmation.
- Counts add up: cases per category and per priority match the lists. CSV row count equals the case count.
- Fictional data only. No secrets. No case claims Pass without evidence.
- In a cases repo: no existing case was renumbered or overwritten, `MODULES.md` row and `STATE.md` are updated, and
  no screenshot or evidence file landed in the repo.

## Hand-off

Show: counts by priority and category, what is uncovered, what needs owner confirmation (first). Ask whether to run
some cases now (record results with evidence), automate the P1 cases (`dester-check`), do the next module
(`dester-modules`), or continue to `dester-docs`. Never push to a test tool or repo without a yes for that exact
action.
