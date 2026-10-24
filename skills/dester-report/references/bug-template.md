# Bug report template

Author: Destine April | dester-report v0.1.0

```
# BUG-001: <what is wrong, where, under what condition>

Author: <tester> | Skill: dester-report v0.1.0 | Date: <date>
Status: DRAFT (waiting for human approval)

Severity: Critical | High | Medium | Low   (reason: <one line>)
Priority: P0 | P1 | P2 | P3                (reason: <one line>)
Label: Bug | Reproducibility: 3 of 3
Environment: <URL, build or date, browser and version, screen size>
Role / account: <role, not the login details>
Related: <TC IDs, spec rows R-xxx, other bugs>
Duplicate check: <where I searched, result>

## Steps to reproduce
1. Sign in as <role>.
2. ...

## Expected
<what should happen> (source: <spec row / owner / standard>)

## Actual
<what happened; exact message text and numbers>

## Evidence
<evidence/redacted/bug-001.png, video, response, file>

## Impact
<who is affected and how; workaround if any>

## Cause (optional)
Hypothesis (code read, not executed): <...>

## Test data used
<fictional records created, cleanup status>
```

Good title: "Merchant payout total ignores the service fee when tip is under 1.00".
Bad title: "TC-014 failed", "Payout broken".
