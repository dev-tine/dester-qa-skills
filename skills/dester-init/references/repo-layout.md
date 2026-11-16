# Test Cases repo layout

Author: Destine April | dester-init v0.1.0

```
<product-slug>-test-cases/
  README.md              how to read and add cases, ID rules, case format, status words
  PRODUCT.md             product, links, environments, roles, sources of truth, open questions
  MODULES.md             module index: code, risk, source, status, case count (dester-modules fills it)
  STATE.md               where work stopped, RESUME HERE
  .dester-cases-repo     marker file so dester skills know this is a cases repo (holds product name and code)
  templates/
    case-template.md     one case in dester format
    cases-template.csv   CSV header for import
  modules/
    <module-slug>/
      cases.md           the cases, grouped by category, coverage table on top
      cases.csv          same cases, one row each, ready to import
      coverage.md        requirement or spec row -> case IDs; uncovered rows; cases with no source
      questions.md       expected results that need owner confirmation
  automation/            optional: Playwright specs made from the cases by dester-check
  .gitignore             evidence, sessions, secrets and node_modules never go in
```

## IDs

- Module code: 2 to 5 capital letters, unique in `MODULES.md` (`INV`, `JOB`, `PAY`).
- Case ID: `TC-<MODULE>-<nnn>`, three digits, never reused even if a case is deleted (mark it `Retired`).
- Requirement or spec row IDs come from the source (`R-INV-03`, `DS-12`, a ticket ID).

## Module status words (in MODULES.md)

| Status | Means |
|---|---|
| Not started | no cases yet |
| Mapped | screens and rules listed, no cases |
| Cases drafted | cases written, not reviewed |
| Cases reviewed | a human reviewed them; Observed and Hypothesis rows still flagged |
| Automated (partial) / Automated | some or all cases have Playwright checks |
| Out of scope | agreed not to test, with the reason |

## What never goes in the repo

Passwords, tokens, cookies, `.env` files, browser storage-state files, real customer or employee data, screenshots
with real data, raw session notes. Evidence stays in the QA project folder.
