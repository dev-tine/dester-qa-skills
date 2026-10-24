# 02_DERIVED_SPEC.md template

Author: Destine April | dester-explore v0.1.0 | Status: DRAFT (a description, not the truth)

This is what the system *seems* to do. It becomes a real spec only after the owner or developer confirms it.

| ID | Rule (plain words) | Where seen | Role | Confidence | Evidence |
|---|---|---|---|---|---|
| R-001 | Tip amounts below 1.00 are rejected with "Minimum is 1.00" | Tip form | Customer | Seen | evidence/R-001.png |
| R-002 | Employee share is split equally among active employees | Payout page | Merchant | Hypothesis (from code) | src/payout.ts |
| R-003 | Total on dashboard and on payout report differ by 0.02 | Dashboard, Reports | Merchant | Unclear (see Q-004) | evidence/R-003.png |

Confidence: **Seen**, **Hypothesis**, **Unclear**. Add `(observed only)` when the only source of the rule is the
app's own behavior.

## Found while exploring (not yet reported)

| # | What | Where | Evidence | Label |
|---|---|---|---|---|

## Questions for the owner (copy to questions.md)

| Q | Question | Why it matters | Asked? | Answer |
|---|---|---|---|---|
