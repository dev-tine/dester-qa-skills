---
name: dester-explore
description: "Explore a system that has no documentation (no BRD, no specs) and turn it into a map, a derived spec and charter-based test sessions. Works for ERPs with many modules and for small apps with admin, merchant and employee sides. Newbie-friendly: asks guided questions with defaults. Use when the user says /dester-explore, 'explore this system', 'I have no specs', 'map this app', 'where do I start testing', 'derive a spec', or gives a URL or repo with no docs."
metadata:
  author: Destine April
  version: 0.1.0
  license: MIT
  suite: dester
---

# dester-explore v0.1.0

Author: Destine April. Part of the dester QA suite. Read `references/core-rules.md` first; those rules win.

**What it does:** learns an undocumented system by using it (and, if given, reading its code read-only), then writes:
a map of modules, roles, flows and data, a **derived spec** (what the system seems to do, marked by confidence), and
**charters** (short missions for testing sessions). It finds bugs on the way, but its main output is a plan you can trust.

**What it does not do:** test cases (`dester-cases`), client documents and visuals (`dester-docs`), deep lens
reviews (`dester-lens`), code-first analysis (`dester-repo`), security checks (`dester-secure`), bug and final
reports (`dester-report`), automation (`dester-check`).

## Quick start (what the user says, what happens)

| User says | Do |
|---|---|
| "/dester-explore" or "explore this system" | Phase 0 intake, then Phase 1 |
| "continue" | Read `STATE.md` in the project folder, resume at RESUME HERE |
| "make charters" | Phase 4 from the existing map |
| "update the spec" | Phase 3, mark changed rows |

## Project folder

Create `qa-<system-slug>/` in the current directory (ask the user to confirm the location):

```
STATE.md              status, assumptions, RESUME HERE (update after every phase)
00_SCOPE.md           what, where, who signs in, out of bounds, cleanup plan
01_MAP.md             modules, roles, flows, data (see references/map-template.md)
02_DERIVED_SPEC.md    rules seen in the system, with confidence (see references/derived-spec-template.md)
03_CHARTERS.md        sessions to run (see references/charters.md)
04_SESSIONS/          one note per session: S01.md, S02.md
evidence/             screenshots, responses, files
questions.md          open questions for the owner or developer
```

## Phase 0: Intake and gate (one group at a time, with defaults)

If the client filled a Discovery Pack (`00_DISCOVERY_PACK.md`, from `dester-discover`), read it first and skip the
questions it already answers. If no pack exists and the client can answer questions, offer `dester-discover`. Do not
wait for it: start with what is available and list the gaps in `questions.md`.
Client answers are claims. Do the **blind recon (Phase 1) before** comparing with the pack, so the pack does not
narrow what you look at; then record every mismatch as an Observation.

Ask in plain language. Skip what is already known. Offer a default each time.

1. **The system:** What is it, in one or two sentences? Who uses it? What would hurt most if it broke (money, data,
   trust)? *Default: "I don't know, find out from the app".*
2. **Where:** URL, and is it a test or staging copy, not production? *Default: ask me to confirm it is safe.*
3. **Who signs in:** Which roles do you have accounts for (admin, merchant, employee, ...)? The human signs in;
   never ask for or type a password. *Default: start with one role, add others later.*
4. **Access mode:** What do you have to give me: just a link (public), a link with accounts, a link with a repo,
   or only screenshots or videos? See the table below. Any old docs, tickets or a chat with the dev?
   *Default: link only, or link with accounts.*
5. **Limits:** Anything that must not be touched (real payments, real emails or SMS, real customers)? How long do
   you have? *Default: 2 hours, nothing destructive.*
6. **Experience:** First time doing QA? If yes, switch on newbie mode (see core rules) and explain words from
   `references/glossary.md` as they come up.

Then state the **gate** from core rules (system, sign-in, what will be created, cleanup, out of bounds) and wait
for a yes. Write `00_SCOPE.md`.

### Access mode (pick one in Phase 0; the repo is optional, a link is enough)

| Mode | What the user gives | How to explore | Limits to state out loud |
|---|---|---|---|
| **A. Public link** | URL only, no sign-in | Browser or Playwright on public pages only: landing, sign-up, public forms, error pages, responsive, accessibility | Cannot see anything behind login. Map only covers what is public. |
| **B. Link + accounts** | URL, plus test accounts per role (the human signs in) | Live click-through per role, role comparison, data flows | Cannot confirm why (no code). Rules are Seen or Unclear, rarely Hypothesis. Roles you have no account for stay `not seen`. |
| **C. Link + repo** | URL, accounts, and a repo (read only) | Mode B, plus code read for routes, roles, validations, formulas | Code may differ from what is deployed. Code findings are Hypothesis until seen in the app. |
| **D. No live access** | Screenshots, recordings, a repo, or a demo video only | Build map and spec from what is shown; list what needs live checking | Everything is `(observed only)` or Hypothesis. No Pass can be claimed. |

Default: ask which one fits; if the user is unsure, start with **A or B** (whatever they have) and add more later.
Public site and no permission to test? Stay read-only and passive: look, do not submit forms, do not probe.

Tool choice (use what is available; say which you used):
- Browser MCP or Claude in Chrome for live click-through and screenshots.
- Playwright for repeatable or many-page sweeps. The helpers live in the `dester-check` skill
  (`~/.claude/skills/dester-check/scripts/`): `login.mjs` (the human signs in; the session is saved outside the
  project and never printed) and `recon.mjs` (read-only crawl: navigates only, never clicks or submits, skips
  logout and delete links). Use them for Phase 1 instead of writing new scripts. Run them from a checks folder that
  has Playwright installed (see dester-check Setup), and check the landing path after login.
- Before concluding anything about dates ("past", "overdue", "upcoming"), check today's date in the system and on the
  machine.
- Repo read for routes, roles, validations (read only, never edit it), only in mode C.
- If the user has no browser tool, ask them to share screenshots or screen recordings and work from those (mode D).

## Phase 1: Recon (the surface, quickly)

Goal: a first map in 15 to 30 minutes. Do not test deeply yet.
1. Sign-in screen and landing page for each role (the human signs in). Note the menu, tabs, top bar, profile menu.
2. List every module, menu item and sub-page per role. Click through; do not submit anything yet.
3. Note: what looks like create, edit, delete, approve, export, import, report, setting, search, filter?
4. Mode C only: read the router, role or permission files, models or schema, API routes. Add
   `(from code, hypothesis)` to anything not yet seen in the running app.
5. Fill `01_MAP.md` (modules x roles table first). Mark each cell: seen, denied, not seen, or unknown.

## Phase 2: Learn the flows and the data

1. Find the **core business flow(s)**, the ones that move money or important records. For an ERP: order to cash,
   procure to pay, hire to payroll. For a tipping app: customer tips, merchant receives, employee gets a share,
   payout. Draw each as numbered steps with the role that does each step.
2. For each flow, walk the happy path once with fictional data (named `QA ...`) and record what each step created
   or changed, and where else it shows up (lists, totals, reports, notifications).
3. Note **data objects** (user, merchant, order, invoice, payout, ...), their statuses, and the status changes seen.
4. Write what you create into `00_SCOPE.md` cleanup list.

## Phase 3: Derived spec

For every rule you observed, write one row in `02_DERIVED_SPEC.md`:
`ID | Rule (plain words) | Where seen | Role | Confidence | Evidence`.
- Confidence: **Seen** (observed, with evidence), **Hypothesis** (from code or guess), **Unclear** (looks wrong or
  inconsistent, goes to `questions.md`), **Confirmed (client)** (the owner said so, from a Discovery Pack or an
  answer; still checked against the system).
- Never invent limits, formulas, messages or thresholds. If the screen does not say it, mark Unclear.
- The expected result of a future test comes from this spec or from the owner, **never only from what the app
  did** (otherwise a bug becomes the expected behavior). Mark rows where that is the case `(observed only)`.
- Things that look like bugs while mapping go to a short "Found while exploring" list with evidence. Do not stop to
  investigate them; `dester-report` handles them later.

## Phase 4: Charters

Turn risk into sessions. Use `references/charters.md` (format, risk scoring, heuristics, tours).
1. Score every module and flow: **Impact** (money, data, many users) x **Likelihood** (new, complex, many rules,
   many roles, integration, little visible validation). Highest first.
2. Write 6 to 12 charters: `Explore <area> with <resource or role> to discover <risk>`; 45 to 90 minutes each;
   with starting heuristics. Always include: one per role boundary (what can each role NOT do), one for data
   accuracy (calculations, totals, reports vs source), one for negative and edge input, one for cross-module
   consistency.
3. Show the user the charter list with a recommended order and ask which to run first.

## Phase 5: Run a session (when the user picks a charter)

1. Restate the charter and timebox. Confirm writes and cleanup (gate still holds).
2. Explore with the charter's heuristics. After each meaningful action, note: action, observed, evidence,
   label (core rules rule 7). Anything odd goes in the note immediately.
3. At the end write `04_SESSIONS/Sxx.md`: what was covered, what was not, bugs and suspicions (with evidence),
   new questions, spec rows added or changed, and what the next charter should be. Debrief the user in 5 lines.
4. Update `02_DERIVED_SPEC.md`, `01_MAP.md`, `STATE.md`.

## Referee self-check (before every handover)

- Every Seen row has evidence that exists on disk (`test -s`). Nothing claimed that was not run.
- Every result carries one of the labels. A "bug" is only confirmed if it repeats twice and is not a setup issue.
- Hypotheses from code are not presented as facts. Numbers recounted.
- Test data created is listed for cleanup, and nothing was posted, sent or changed outside the test area.
- No secrets, tokens or real personal data in files.

## Hand-off

End each phase with: what was done, what is unsure (first), what needs the user's yes, and the next step.
Suggest the next skill: `dester-cases` to turn the spec into test cases, `dester-docs` for a client-ready overview
with diagrams, `dester-lens` to review one area through a role or UX lens, `dester-secure` for access
control checks (only with written permission), `dester-report` to turn findings into reports.
