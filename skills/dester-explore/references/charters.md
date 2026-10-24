# Charters, risk scoring and heuristics

Author: Destine April | dester-explore v0.1.0

## Charter format

```
S01 | <area> | Role: <role> | Time: 60 min | Risk: High
Mission: Explore <area> with <role / data> to discover <risk>.
Start with: <2 to 4 heuristics from below>
Setup: <accounts, fictional data, anything to create>
Out of bounds: <what not to touch>
Done when: <what must be covered, or time is up>
```

Example: `Explore the tip payout screen as a merchant with 3 employees and uneven tips to discover wrong totals or
wrong splits.`

## Risk score

Impact (1 to 3): 3 = money, personal or legal data, many users. 1 = cosmetic or rarely used.
Likelihood (1 to 3): add one for each: new or recently changed, many rules or calculations, many roles,
connects to other modules or outside services, little visible validation. 3 = two or more.
Score = Impact x Likelihood. 7 to 9 first, 4 to 6 next, 1 to 3 only if time is left.

## Heuristics (rules of thumb; say them in plain words to newbies)

| Name | Ask yourself |
|---|---|
| Roles | What can each role see, do and NOT do? Does the menu, a button, the URL and the data agree? |
| Money and numbers | Do totals add up? Rounding? Currency, tax, fees, percentages? Same number on every screen and report? |
| Boundaries | 0, 1, max, max+1, negative, empty, very long, special characters, emoji, duplicate. |
| Sequence | Do steps in the wrong order, twice, back button, refresh, two tabs, work or break things? |
| Status | Every status change: who can do it, can it be undone, what happens to the related records? |
| Delete and edit | What happens to history, reports and related data when something is edited or deleted? |
| Search, filter, sort, pagination | Right results? Empty result? Many pages? Export matches the screen? |
| Time | Dates, time zones, past or future dates, cut-off times, month end. |
| Interruption | Session expires, network drops, double click on submit, close tab mid-way. |
| Consistency | Same thing named the same way, behaves the same way everywhere? Does it match common sense and similar products? |
| Integration | Something created in module A: does it show correctly in B, C and the reports? |
| Messages | Are errors clear and correct? Success message when it did not actually save? |

## Tours (quick ways to cover ground)

- **Money tour:** follow one amount from entry to report.
- **Role tour:** repeat the same task as each role.
- **Lazy user tour:** skip optional fields, accept defaults, click the first option.
- **Saboteur tour:** wrong input, wrong order, repeat, cancel midway.
- **Report tour:** compare every report and dashboard number to its source records.
- **Back-office tour:** every admin setting, then check what each one changes elsewhere.

## Must-have charters for any system

1. One per role boundary (what can each role NOT do).
2. One for data accuracy (calculations, totals, reports vs source).
3. One for negative and edge input on the most-used form.
4. One for cross-module or cross-role consistency.
5. One for the first-time user (sign up or onboarding, empty states).
