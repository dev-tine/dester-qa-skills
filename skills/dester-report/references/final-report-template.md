# Final report template

Author: Destine April | dester-report v0.1.0

```
# QA Report: <system>

Author: <tester> | Skill: dester-report v0.1.0 | Date: <date>
Status: DRAFT (waiting for human approval)
Environment: <URL, build or date> | Access mode: <A/B/C/D> | Roles tested: <list>

## Summary
<2 to 4 sentences: overall quality and QA recommendation, with the reason>
QA recommendation: Ready | Ready with conditions | Not ready | Cannot judge   (owner decides)

## Totals (recounted from records)
Planned: N | Executed: N | Pass: N | Bug: N | Blocked: N | Flaky: N | Not run: N
Executed = Pass + Bug + Blocked + Flaky  ->  N = N + N + N + N

## Bugs
| Severity | Open | Fixed |
|---|---|---|
| Critical | | |
| High | | |
| Medium | | |
| Low | | |

## Key bugs
| ID | Title | Severity | Priority | Status |
|---|---|---|---|---|

## What passed (core flows)
<list, each with the case IDs and evidence>

## Not tested and why
| Area / role / case | Reason (blocked, out of scope, no time, no access) | What is needed |
|---|---|---|

## Risks and open questions
<what could still go wrong; questions for the owner>

## Test data and cleanup
<records created, status>

## Appendix
<links: spec, cases, coverage, bug files, evidence>
```

Client summary (under 150 words, draft only):
```
Tested: <what, in plain words>. Recommendation: <ready / ready with conditions / not ready>, because <reason>.
Top issues: 1) ... 2) ... Not covered: <...>. We need from you: <...>.
```
