# Security checklist (OWASP-style, non-destructive)

Author: Destine April | dester-secure v0.1.0

Each item: what to check, safe way, what a problem looks like. Keep requests few. Use `<redacted>` in notes.

## A. Access control (do first)

| Check | Safe way | Problem looks like |
|---|---|---|
| Private pages without sign-in | Open private URLs in a fresh private window | Page or data shown |
| Admin pages as a lower role | Sign in as the lower role, open admin URLs directly | Page loads or API returns data |
| Hidden button, working action | Find the request an admin button sends; send it as a lower role (own test records only) | Request succeeds |
| IDOR | Two same-role accounts, A and B. As A, request B's record by id | A can read or change B's record |
| Guessable ids | Compare ids (sequential numbers vs random) | Sequential ids plus IDOR |
| Tenant leaks | Search, export, report, notifications as tenant A | Rows of tenant B |
| Direct file access | Open a private file link in a private window | File opens without sign-in |
| Mass assignment | Add an extra field (role, is_admin) to own profile update | Field accepted |

## B. Authentication and sessions

- Wrong password gives a generic message (not "user does not exist"). Lockout or delay present (observe over a few
  tries only; never brute force).
- Password reset: link expires, single use, does not reveal whether an email exists.
- Logout ends the session (back button, reuse of old page, second tab).
- Cookies: `Secure`, `HttpOnly`, `SameSite` where expected. Session ends after a reasonable time.
- Sign-in over HTTPS only; HTTP redirects to HTTPS.
- Invite-only systems: sign-up truly disabled (try the API, not only the page).

## C. Input handling

- Reflected and stored XSS: harmless marker such as `qa-xss-test<b>x</b>` in text fields; see whether it renders as
  HTML or script context. Do not use payloads that steal data.
- Injection: a single quote or similar in inputs and search; look for database error text or odd behavior.
- File upload: wrong type renamed, oversize, empty, odd name; files served from a safe type and domain.
- Open redirect: redirect parameters pointing to another domain.
- Server-side validation: send values the form would block (use the browser's network tool on own records).

## D. Secrets and exposure

- Public JavaScript and source maps: search for keys, tokens, service credentials, internal URLs, admin emails.
- Common exposed paths on the target only: `.env`, `.git`, backups, `/admin`, `/api/docs`, debug pages, directory
  listing. A few requests, not a scan of the internet.
- Error pages and API errors: stack traces, file paths, SQL text.
- Any key found: record only where and what kind (never the value); tell the owner to rotate it.

## E. Configuration

- Headers: Content-Security-Policy, Strict-Transport-Security, X-Frame-Options or frame-ancestors,
  X-Content-Type-Options, Referrer-Policy. Missing ones are Low or Info unless exploited.
- CORS: does a random origin get `Access-Control-Allow-Origin` with credentials?
- Cache: private pages not cached publicly.
- Cookies and tokens not placed in URLs.

## F. Vibe-coded app specifics

- **Supabase:** row-level security enabled on every table? With only the public anon key, can you select, insert,
  update or delete rows you should not? Storage buckets public? Service-role key anywhere in the frontend?
- **Firebase:** security rules not open (`allow read, write: if true`)? Storage rules?
- **Lovable or similar builders:** roles stored only in client-side state or editable user metadata? Admin checks done
  only in the interface?
- **Serverless or edge functions:** do they check the caller's identity and role?
- **Webhooks:** signatures verified?

## G. Repo mode (read only)

- Authorization checks present on every route and function that changes data.
- Secrets committed (history too, `git log -p -S` on key-like strings; report location only).
- Dependency risk: read manifest and lockfile; run an audit tool only with the user's yes.
- Query building with string concatenation; unsafe HTML rendering; disabled certificate or auth checks.

## Severity quick guide

| Severity | Example |
|---|---|
| Critical | Any user can read or change other users' data; a secret gives broad access; anonymous write to the database |
| High | Lower role can use admin functions; stored XSS in a shared page; missing authentication on private data |
| Medium | Weak session handling, missing rate limiting on sign-in (observed), exposed internal detail with limited use |
| Low | Missing headers without exploit, verbose errors |
| Info | Hardening advice |
