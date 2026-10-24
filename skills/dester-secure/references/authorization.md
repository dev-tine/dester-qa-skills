# Authorization (written permission) for security testing

Author: Destine April | dester-secure v0.1.0

Without this, `dester-secure` does not run. Keep a copy in the project folder as `10_SECURITY/AUTHORIZATION.md`.
This is a plain-language form, not legal advice; for big clients let their legal contact review it.

```
Security testing authorization

System owner (person and company): ______
Tester: ______ (Destine April)
Target (exact link(s) or areas): ______
Environment: test / staging / production (circle). Fictional data only: yes / no
Dates and hours allowed: from ______ to ______
Accounts provided (roles only, no passwords here): ______

Allowed: authentication and session checks, access control checks (roles, IDOR), harmless input probes, exposed
secrets and configuration checks, review of the code provided read-only.
Not allowed: denial of service or load tests, brute force or password guessing, social engineering, testing of
third-party services, touching live customer data, anything outside the target above.
Excluded areas: ______
Who receives findings (owner only): ______
Emergency contact if something goes wrong: ______

I confirm that I own this system or am authorized to allow the testing described above.
Name: ______  Role: ______  Date: ______  (typed name in an email or a signature)
```

## How the skill checks it

- The target in the form matches the link being tested, and today is inside the dates.
- Every request target is on the list. Anything else stops the run.
- The user confirms in chat that the form is real and current. If the user cannot show it, the run does not start.
