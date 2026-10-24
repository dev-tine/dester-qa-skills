---
name: dester-secure
description: "Authorized-only security testing of a web system the user owns or has WRITTEN permission to test: sign-in and session checks, access control (roles, IDOR, privilege escalation), input handling, exposed secrets and keys, headers and CORS, and database rules for vibe-coded apps (Supabase, Firebase). Non-destructive, minimal proof, no attacks on third parties. It refuses to start without a recorded authorization. Use when the user says /dester-secure, 'security test', 'check access control', 'pentest this', 'check for IDOR', 'is it secure', and has permission."
metadata:
  author: Destine April
  version: 0.1.0
  license: TBD (placeholder, MIT planned)
  suite: dester
---

# dester-secure v0.1.0

Author: Destine April. Read `references/core-rules.md` first; those rules win. Then `references/authorization.md`.

**What it does:** finds common security weaknesses (OWASP-style) in a system the user owns or is explicitly allowed to
test, proves each with the smallest safe evidence, and reports to the owner only.

## HARD GATE (nothing runs before this passes)

Do **all** of these, in order. If any fails, stop and say why. Do not "just look around".

1. **Written authorization exists.** One of: Part C of the client's Discovery Pack, or a signed or written message
   from the owner that names the system, the exact link or area, the dates, and what is excluded. Use the form in
   `references/authorization.md`. A verbal yes, or the user's own belief, is not enough for a client system. For a
   system the user personally owns, the user confirms in this chat: "I own this and I allow security testing of
   <link>".
2. **Scope is written down** in `00_SCOPE.md`: target link, roles and accounts, dates, exclusions, a contact for
   emergencies.
3. **Environment is test or staging with fictional data.** Not production real data. If it is production, stop
   unless the owner's authorization explicitly says so, and even then only passive checks.
4. **Safe-handling plan:** what accounts are used, what will be created, how it is cleaned up.
5. The user says go for this specific run.

## Hard rules (always)

- Only the authorized target. **No third parties** (payment providers, Google, hosting, email services, CDNs): do not
  scan or test them. If the target redirects off-scope, stop at the boundary.
- **No denial of service, no load tests, no brute force, no credential stuffing, no password guessing**, no mass
  requests (a handful of requests per check).
- **No social engineering, no persistence, no pivoting, no malware, no evasion of monitoring.**
- **Minimal proof:** show access with the smallest evidence (one record id, redacted). Do not download, copy or keep
  real personal data. If real data is exposed, stop that check, note it, tell the user at once.
- Never type passwords or secrets; the human signs in. Never print tokens or keys; refer to them as `<redacted>`.
- Non-destructive payloads only (harmless markers like `qa-xss-test`), no data deletion or modification beyond own
  test records.
- Stop at the first sign of an unexpected impact (errors storm, real data, the system slowing) and tell the user.
- Findings are for the **owner only**. Never put them in general client documents, public tickets or chats, and never
  post or send them without the user's yes.

## Quick start

| User says | Do |
|---|---|
| "/dester-secure" | HARD GATE, then Step 1 |
| "check access control" | Gate, then Step 3 |
| "check for exposed keys" | Gate, then Step 5 |

## Steps (checklists in `references/owasp-checklist.md`)

1. **Plan:** pick checks that fit the stack and access mode (live, with two accounts, or with repo). Show the list and the
   number of requests per check; get the user's go.
2. **Authentication and session:** sign-in behavior (generic errors, lockout presence seen without brute forcing),
   password reset flow, session expiry, logout really ends the session, cookie flags, sign-in required for private
   pages.
3. **Access control (highest value):** with two accounts of the same role and one of a lower role:
   - Vertical: can a lower role open an admin URL, or call an admin API, directly?
   - Horizontal (IDOR): change an id in the URL or request to read or change another user's record.
   - Hidden-in-UI is not protected: try hidden buttons' actions by direct request.
   - Unauthenticated access to private pages, files and API.
   - Multi-tenant leaks: lists, search, exports, reports showing other tenants.
4. **Input handling:** harmless probes for reflected or stored XSS markers, SQL or injection error behavior (single
   quote), file upload type and size checks, open redirects, mass assignment (extra fields in a request).
5. **Secrets and exposure:** public JavaScript bundles and source maps (keys, service tokens, internal URLs),
   `.env` or backup files reachable, debug pages, directory listing, verbose errors, API docs exposed.
6. **Configuration:** security headers (CSP, HSTS, X-Frame-Options, X-Content-Type-Options), CORS rules, cookie
   attributes, HTTPS only, cache of private pages.
7. **Vibe-coded app specifics:** Supabase or Firebase: are row-level security or rules enabled on every table and
   bucket? Can the public anon key read or write tables or files it should not? Are service keys in the frontend?
   Are storage buckets public?
8. **Repo mode (read only, with `dester-repo`):** missing authorization checks, secrets committed, vulnerable
   dependencies (read the lockfile or run an audit only with the user's yes), unsafe query building.

## Findings

For each finding use the bug template from `dester-report`, plus:
- **Class** (for example Broken access control, Exposed secret) and where.
- **Impact in plain words** and **who is affected.**
- **Minimal reproduction** (steps with redacted values), repeated twice.
- **Severity** by impact and ease: Critical (any user reads or changes others' data, or a secret grants broad
  access), High, Medium, Low, Info. Recommendation, with a one-line reason; the owner decides.
- Fix suggestion in plain language. Label `Hypothesis` for anything from code only.
- Mark **CONFIDENTIAL: owner only** at the top.

File: `10_SECURITY/FINDINGS.md` (separate from `07_BUGS/`). Not tested and why is required.

## Self-check before handover

- Authorization recorded and in scope for every request made. Nothing outside scope touched.
- No secrets or real personal data stored in any file. Evidence redacted. Findings repeat twice.
- Request counts stayed small. Cleanup list updated.

## Hand-off

Tell the user the findings in order of severity, privately, and that sharing them is their decision. Suggest the
owner fix and rotate any exposed key first, then retest the same checks (`dester-check` can keep them as
repeatable access-control checks).
