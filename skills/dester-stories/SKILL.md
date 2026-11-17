---
name: dester-stories
description: "Write user stories with acceptance criteria for a module or flow, and turn them into UAT scenarios, for a new product or one that is already built. One-line use: /dester-stories [module] [product] [link]. Plain language. Uses roles, the 3 Cs and INVEST; acceptance criteria as rules or Given / When / Then; every story traced to its source, its test cases and its UAT scenario. Saves per module in the product's Test Cases repo (dester-init) when there is one. Use when the user says /dester-stories, 'write user stories', 'acceptance criteria', 'prepare for UAT', 'UAT scenarios', or the owner asks for stories before UAT."
metadata:
  author: Destine April
  version: 0.1.0
  license: MIT
  suite: dester
---

# dester-stories v0.1.0

Author: Destine April. Read `references/core-rules.md` first; those rules win.

**What it does:** writes user stories the owner can agree to, with acceptance criteria that can pass or fail, then
joins them into UAT scenarios the business runs to accept the system.

## Quick start (one line)

```
/dester-stories <module> <product> <link> [notes]
/dester-stories "Company Calendar" "Acme ERP" https://staging.example.com
/dester-stories uat "Acme ERP"            # build UAT scenarios from agreed stories
```

| User gives | Do |
|---|---|
| module, product, link | Use defaults for the rest, say them in one line, go to Steps |
| only `/dester-stories` | Ask: product, module or flow, who the users are, new or already built. One group at a time |
| `uat <product>` | Go to Step 6 with the stories marked Agreed |
| "answers for <module>: ..." | Update the stories, set Status `Agreed with <name>, <date>` where the owner said yes |

## Words used

| Word | Means |
|---|---|
| Story | `As a <role>, I want <goal>, so that <value>.` A reminder of a conversation, not the whole requirement |
| 3 Cs | Card (the line), Conversation (where details are agreed), Confirmation (acceptance criteria and tests) |
| Acceptance criteria (AC) | Conditions the story must meet to be accepted; each one pass or fail |
| Epic | A story too big to test in one go; split it |
| UAT scenario | An end-to-end business flow made from several stories, run by real users |

## Where the story comes from (decides its Status)

| Source | Status on the story |
|---|---|
| Owner, client or a real document said so | `Agreed with <name>, <date>` |
| Seen in the app, no one confirmed it | `Draft (from app)` and a question in `questions.md` |
| Guess, common practice | `Draft` and a question in `questions.md` |

Never copy the app's current behaviour into a story as if it were agreed. That turns bugs into requirements.

## Steps

1. **Roles.** List the real roles (from `PRODUCT.md` or the user): e.g. estimator, office coordinator, installer,
   manager, customer. Never "As a user" when a real role exists.
2. **Backbone.** Write the main flow left to right (story map). For a business system this is usually the
   lifecycle, e.g. `Lead -> Estimate -> Proposal -> Approved -> Install -> Invoice -> Paid`. Put the module in it.
3. **Epics, then stories.** One epic per big capability. Split with these patterns, simplest first:
   workflow steps, business rule variations, data variations, operations (add, edit, move, delete),
   simple then complex. Each story fits INVEST (table below).
4. **Acceptance criteria.** 2 to 6 per story. Rules for forms and validation; Given / When / Then for flows.
   At least one happy path and one "goes wrong". Numbers where it matters (seconds, counts, limits).
   Describe what the user sees, never code, tables or API calls.
5. **Show the list first.** Before writing files, show a table: ID, role, story, AC count, source. Wait for the
   user's OK, like the rule list in dester-cases.
6. **UAT scenarios.** Only from stories the owner agreed. Join stories along the backbone into business flows.
   Each scenario: ID, objective, role who runs it, stories covered, preconditions and test data, steps with
   expected results, pass or fail, comments. Focus on the flow, not field checks (system testing covers those).
   Add for systems replacing an old one: data moved over correctly, and the old system's pain points are gone.
7. **Trace.** Fill the links: story -> AC -> test cases (`TC-...` from dester-cases) -> UAT scenario -> defects.
   If a Test Cases repo exists, reuse its rule IDs (`R-<CODE>-nn`) as the base for AC instead of starting over.

## INVEST check (run on every story)

| | Check | Fix if no |
|---|---|---|
| Independent | Can it be tested on its own? | Note the dependency, or merge |
| Negotiable | Says what the user needs, not the exact screen? | Remove UI wording |
| Valuable | Would the business care? | Drop it, or say the value in "so that" |
| Estimable | Clear enough for the developer to size? | Add a question for the owner |
| Small | Testable in one sitting? | Split it |
| Testable | Every AC has a clear pass or fail? | Rewrite the AC with a number or an outcome |

## Already-built systems

The usual order (story, then build) is reversed. Start from the business flow and roles, not from screens; use what
the owner already agreed (calls, docs, the old system the client wants copied); send anything only seen in the app
to the owner as a question.

## Files (per module, in the Test Cases repo)

| File | Holds |
|---|---|
| `modules/<module>/stories.md` | Stories with AC, grouped by epic |
| `modules/<module>/stories.csv` | Same, one row per AC, for import |
| `uat/scenarios.md` | UAT scenarios across modules |
| `modules/<module>/questions.md` | Add story questions under "Stories" |

Story format:

```
### US-<CODE>-<nn> | <short title>
Epic: <epic> | Role: <role> | Priority: Must / Should / Could
Story: As a <role>, I want <goal>, so that <value>.
Acceptance criteria:
AC-1 Given ... When ... Then ...
AC-2 <rule>
Notes: <out of scope, open points>
Source: <who agreed, when> | Status: Draft / Agreed with <name>, <date> / Accepted in UAT
Test cases: TC-... | UAT: UAT-..
```

## Self-check before saying done

- Every story has a real role, a "so that", 2 to 6 AC and a Source.
- No AC uses "fast", "easy", "properly", "user-friendly" without a number or outcome.
- Every Draft story has a question in `questions.md`.
- CSV rows = total AC count.
- UAT scenarios use only Agreed stories, and every Must story is in at least one scenario.

## Sources this skill is based on

Bill Wake, INVEST (2003); Ron Jeffries, Card Conversation Confirmation (2001); Mike Cohn, User Stories Applied
(2004) and mountaingoatsoftware.com; Jeff Patton, User Story Mapping (2014); Richard Lawrence, story splitting
patterns (2009); Cucumber Gherkin reference; ISTQB glossary (acceptance testing); Appian UAT overview.
