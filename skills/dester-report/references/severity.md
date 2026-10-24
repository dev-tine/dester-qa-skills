# Severity and priority

Author: Destine April | dester-report v0.1.0

**Severity** is how bad the problem is for users or the business. **Priority** is how soon to fix it. They can differ
(a typo on the home page: Low severity, maybe high priority before a launch).

| Severity | Meaning | Examples |
|---|---|---|
| Critical | Data loss or leak, money wrong, system unusable, core flow blocked with no workaround, security hole | Wrong payout amounts; a user can see another user's data |
| High | Major feature broken, workaround is hard or costly | Cannot create an order for one role |
| Medium | Important feature affected but a workaround exists | Export gives the wrong column order |
| Low | Cosmetic or minor, little user impact | Typo, small misalignment |

| Priority | Meaning |
|---|---|
| P0 | Drop everything (live money or data at risk) |
| P1 | Fix before release |
| P2 | Fix in the next cycle |
| P3 | Schedule later |

How to recommend: start from severity, then raise priority for number of users affected, nearness of a release,
legal or money exposure, and lower it when a safe workaround exists. Always give the one-line reason. The human
makes the final call.

Security bugs: label them, keep them out of general lists, share with the owner only.
