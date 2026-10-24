---
name: dester-report
description: "Turn QA findings into reports: a bug report per defect (steps, expected vs actual, severity, priority, evidence, hypothesis), a bug list, and a final QA report with totals, a ship recommendation and an honest 'not tested' section. Includes a referee check that classifies every failure (bug, blocked, flaky, setup, excluded) before anything is written. Newbie-friendly. Use when the user says /dester-report, 'write the bug report', 'report this bug', 'QA summary', 'final report', 'is it ready to ship', or after testing with dester-explore, dester-cases or dester-lens."
metadata:
  author: Destine April
  version: 0.1.0
  license: TBD (placeholder, MIT planned)
  suite: dester
---

# dester-report v0.1.0

Author: Destine April. Read `references/core-rules.md` first; those rules win.

**What it does:** checks that a finding is real, writes it clearly, ranks it, and rolls everything up into a final
report with a recommendation. **The skill recommends, the human decides.** Severity, priority, verdict and ship
recommendation are drafts until the user says yes. Nothing is posted, filed or sent without a yes for that exact
action.

## Quick start

| User says | Do |
|---|---|
| "report this bug" + what they saw | Step 1 (referee), then Step 2 for that one finding |
| "report all findings" | Collect from the project folder (Step 0), referee all, write bugs, show the list |
| "final report" / "can we ship?" | Step 4 |
| "client summary" | Step 5 |

## Step 0: Collect (ask only what is missing, with defaults)

Sources, in order: the user's description, `04_SESSIONS/`, "Found while exploring" in `02_DERIVED_SPEC.md`,
`05_TEST_CASES.md` rows with Status Bug, evidence files. Create the project folder files if missing:

```
07_BUGS/BUG-001.md ...      one file per bug (template: references/bug-template.md)
07_BUGS/INDEX.md            list: ID, title, severity, priority, status
08_REPORT/FINAL_REPORT.md   (template: references/final-report-template.md)
08_REPORT/CLIENT_SUMMARY.md
evidence/redacted/          copies safe to share
```

Ask: Who reads the reports (owner, client, developer)? Where do bugs go (files only, GitHub, Linear, Jira)?
*Default: files only, non-technical reader.* Newbie mode: explain Severity vs Priority in one line each.

## Step 1: Referee (before writing any bug)

For every red result:
1. **Repeat it** at least twice, same steps. Note the result of each try.
2. **Check it is not me:** wrong role, wrong data, stale page, slow system, unclear spec, a setting I changed.
3. **Check it against a trusted source:** the spec row, the owner's answer, or standard behavior. If the only
   source is "the app did something different yesterday", it is an Observation, not a bug.
4. **Label it:**

| Label | Meaning | What happens |
|---|---|---|
| Bug | Repeats, not my setup, contradicts a trusted source | Gets a bug report |
| Blocked | I could not test it (no access, no data, feature missing) | Listed under Not tested, with what is needed |
| Flaky | Sometimes fails, sometimes passes | Written as Flaky with the pass/fail counts, lower confidence |
| Setup | My data, role or environment was wrong | Fixed and rerun, not reported |
| Excluded | Out of scope or known issue | Listed under Not tested, with the reason |
| Observation | Odd, but no trusted source says it is wrong | Goes to a questions list for the owner |

Nothing stays unlabelled. Search the existing bug list or tracker for a duplicate before calling it new
(read only).

## Step 2: Write each bug (template: references/bug-template.md)

- **Title says what is wrong, where, and when**, not which test failed. "Tip total ignores the service fee when
  tip is under 1.00" and not "TC-014 failed".
- **Steps** a newbie can follow, starting from sign-in role and data. Fictional data only.
- **Expected** quotes its source (spec row, owner, standard). **Actual** gives exact text and numbers.
- **Evidence:** at least one screenshot, response, file or video that exists on disk (`test -s`). Redacted copy is
  the one linked. A bug without evidence is Observation.
- **Cause (optional):** only as `Hypothesis (code read, not executed)` or `Hypothesis (guessed)`. Never as a verdict.
- **Severity** (impact) and **Priority** (urgency) as a recommendation with a one-line reason, from
  `references/severity.md`. Security-related bugs: say so and keep the report out of general lists (owner only).
- **Reproducibility** like "3 of 3" or "2 of 3".

## Step 3: Bug list for approval

Show a table ordered by severity: ID, title, severity, priority, reason, evidence. Ask for approval of the
wording, severity and priority. Apply changes, re-show only what changed. Filing in a tracker is a separate yes,
one bug at a time.

## Step 4: Final report (template: references/final-report-template.md)

1. **Recount from the records**, never from memory: Planned, Executed (Pass + Bug + Blocked + Flaky), Not run.
   Show the math. Executed must equal the parts. If it does not add up, fix the records first.
2. **Verdict (draft):**
   - `Ready` (no open Critical or High, core flows pass, gaps are small and listed)
   - `Ready with conditions` (open Medium or known gaps the owner accepts, listed)
   - `Not ready` (open Critical or High, or a core flow was not tested)
   - `Cannot judge` (too much Blocked or Not run to say)
   Give the reason in two sentences. The owner decides; the report says "QA recommends".
3. **Not tested and why** is required. Every area, role or case not run, with the reason. Honest gaps build trust.
4. Add the risks that remain, and the questions still open for the owner.

## Step 5: Client summary (under 150 words)

Plain language: what was tested, the recommendation, the top two or three issues, what is not covered, and what you
need from them. Draft only.

## Definition of Done (report is complete when all hold)

1. Every bug is Bug-labelled, repeated, has evidence, severity and priority with a reason.
2. Every other red result has a label; none is left uncategorized.
3. Totals recounted and consistent across the report, the bug index and the coverage file.
4. Expected results state their source; Observed and Hypothesis items are marked.
5. "Not tested and why" present. Data created during testing is listed with its cleanup status.
6. Redaction checklist passed (no secrets, no real personal data, no unrelated tabs, redacted evidence linked).
7. The user approved the content; nothing was sent or filed without a separate yes.

## Self-check before handing over

List in one line what you checked (counts, evidence files exist, links resolve, labels present, no em dashes).
State anything you could not check. Never claim a file that was not written.
