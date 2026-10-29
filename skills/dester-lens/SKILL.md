---
name: dester-lens
description: "Review one area of a system through a chosen lens: senior QA engineer, end user per role (admin, merchant, employee...), UX and UI, accessibility, business process and flow, data accuracy (calculations, totals, reports), or negative and edge cases. Gives a focused checklist per lens, records results with evidence, and feeds findings to dester-report. Newbie-friendly: picks a sensible lens if the user is unsure. Use when the user says /dester-lens, 'review this as a user', 'check the UX', 'check accessibility', 'check the numbers', 'think like a senior QA', 'review this module', or after dester-explore."
metadata:
  author: Destine April
  version: 0.1.0
  license: MIT
  suite: dester
---

# dester-lens v0.1.0

Author: Destine April. Read `references/core-rules.md` first; those rules win.

**What it does:** looks at **one area** (a module, screen or flow) through **one lens at a time**, so nothing is
skimmed. A lens is a way of looking, with its own questions. Same screen, different lens, different bugs.

It follows a charter from `dester-explore` when one exists. It does not replace `dester-cases` (planned cases) or
`dester-secure` (security).

## Quick start

| User says | Do |
|---|---|
| "/dester-lens" | Step 1 (choose area and lens) |
| "review <area> as <role>" | Lens 2 for that role |
| "check the numbers on <report>" | Lens 6 |
| "all lenses on <area>" | Run the lenses in order 1, 2, 5, 6, 7, 3, 4, one note each |

## Step 1: Choose (ask, with defaults)

1. **Area:** which module, screen or flow? *Default: the top charter in `03_CHARTERS.md`, or the most-used screen.*
2. **Lens:** pick one or more. If the user is unsure, recommend: money or numbers on screen -> Lens 6; several roles
   -> Lens 2; a multi-step flow -> Lens 5; otherwise Lens 1.
3. **Role and account:** which role signs in (the human signs in; never type a password).
4. **Time:** 30 to 45 minutes per lens. *Default: 40.*
5. Confirm the gate from core rules for any writes (records named `QA ...`, cleanup list in `00_SCOPE.md`).

## The lenses (full checklists in `references/lenses.md`)

| # | Lens | One-line question |
|---|---|---|
| 1 | Senior QA | What would break this, and what did the builder not think about? |
| 2 | End user (per role) | Can this person do their job here, and see only what they should? |
| 3 | UX and UI | Is it clear, consistent and pleasant, on desktop and phone? |
| 4 | Accessibility | Can someone use it with a keyboard, a screen reader, low vision? |
| 5 | Business process and flow | Does the whole flow work end to end across roles and modules? |
| 6 | Data accuracy | Are the numbers right, the same everywhere, and traceable? |
| 7 | Negative and edge | What happens with wrong, extreme, odd or repeated input? |

## Step 2: Run one lens

1. Open `references/lenses.md`, take that lens' checklist, and select the items that fit the area (skip with a
   reason, never silently).
2. Work through the items. For each: what you did, what you saw, evidence file, label (Pass, Bug, Blocked, Flaky,
   Setup, Not run, Observation).
3. Expected result comes from the spec (`02_DERIVED_SPEC.md`), the Discovery Pack, or the owner. If it comes only from
   what the app did, say `(observed only)`; do not call it a bug without a trusted source (use Observation).
4. Anything odd goes in the note at once. Do not stop to investigate; note and continue.
5. Repeat each suspected bug once more to see if it repeats.

## Step 3: Write the lens note

`04_SESSIONS/L<nn>_<lens>_<area>.md`:

```
Author: <tester> | Skill: dester-lens v0.1.0 | Date: <date>
Status: DRAFT
Area / Lens / Role / Time / Environment
Covered: <checklist items done>
Not covered and why: <items skipped, blocked, no time>
Results: table of item, result, label, evidence
Suspected bugs: <ids and one line each, for dester-report>
New spec rows: <R-xxx added or changed>
Questions for the owner: <...>
```

Add new rules to `02_DERIVED_SPEC.md` (Seen, with evidence) and update `01_MAP.md` cells.

## Self-check before handover

- Every row has evidence on disk (`test -s`) or is Not run. Counts add up (covered + skipped = items selected).
- Hypotheses are labelled. No result claimed that was not run. Cleanup list updated. No secrets or real data.

## Hand-off

Five-line debrief: what was covered, what was not, top suspicions (first), what needs the user's yes. Suggest:
`dester-report` for confirmed suspicions, `dester-cases` to turn new rules into cases, another lens on the same
area, or `dester-check` to automate what passed and will be retested.
