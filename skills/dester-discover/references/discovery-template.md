# Discovery Pack: <System name>

Prepared by: Destine April (QA) | Skill: dester-discover v0.1.0 | Date: <date>
Status: DRAFT

Thank you for helping us test <System name>. The more we know, the fewer assumptions we make and the more useful the
results are. Answer what you can. "Not sure" is a fine answer. **Please do not write passwords, API keys, tokens or
.env files in this document.** We will tell you how to share access safely.

Part A takes about 10 minutes. Part B is optional but makes the testing much deeper.

## Part A: Essentials

### A1. About the system
1. In one or two sentences, what does the system do and for whom?
   *Why: so we test what matters to your business.*
2. Who uses it? List each type of user (for example admin, merchant, employee, customer).
   *Why: each type needs its own tests, and "what each can NOT do" is where many bugs hide.*
3. What are the 3 to 5 things that must never break?
   *Why: we test these first and hardest.*
4. What would hurt most if it failed (money wrong, data lost, customers locked out, embarrassment)?

### A2. Where and how we test
5. Test link (URL): ______  Is it a test or staging copy, not the live system? Yes / No / Not sure
   *Why: we do not test on live data unless you tell us it is safe.*
6. Is there a live (production) system? We will not touch it unless you say so in writing.
7. How can we get in? Tick all that apply:
   - [ ] You create a test account for each user type (we sign in ourselves)
   - [ ] You invite our email address to each role
   - [ ] Public, no sign-in needed
   - [ ] Other: ______
   *Why: we never need your password. Test accounts are best.*
8. Which user types will we get an account for? ______
9. Anything we must NOT touch or do? (real payments, real emails or SMS, deleting data, inviting users, a specific
   customer's data) ______
10. Does the system send emails, SMS, calendar invites or payments? To whom? Can we use our own test addresses?

### A3. How it should behave
11. Is there anything written about how it should work (a brief, notes, a Notion page, a chat with the developer,
    videos, screenshots, a list of requirements)? Please attach or link it: ______
12. Any rules we cannot guess? (limits, fees, percentages, who can approve what, cut-off times) ______
13. Anything you already know is broken or unfinished? (so we do not report it as new) ______

### A4. Practicalities
14. Who can answer our questions, and how fast? Name: ______ Contact: ______
15. Deadline or release date: ______ How much testing time is available? ______
16. What do you want at the end? (a bug list, a full report, a ship / do not ship opinion, test cases, documentation
    with diagrams) ______

### A5. Permission
17. I confirm I own this system or am authorized to allow testing of it, on the link in A2, during: ______ (dates).
    Name: ______  Date: ______

## Part B: Deep (optional)

### B1. Build and code
18. What was it built with? (Lovable, GoHighLevel, Azure, Bubble, WordPress, custom code, other) ______
19. Is there a code repository? We only need read access. Link: ______ (see "How to share access safely" below)
20. Files that explain the system (README, CLAUDE.md, AGENTS.md, a PRD or plan document, prompts or chat history used
    to build it): ______

### B2. Data and logic
21. Main records in the system (for example orders, invoices, tips, payouts) and their statuses: ______
22. Calculations we should check (totals, splits, fees, taxes, commissions): give one worked example with the answer.
23. Test data: is there fake data we can use, or should we create our own? ______

### B3. Connections
24. Outside services used (payment, email, SMS, calendar, analytics, CRM, automation): ______
25. Automations or workflows that run by themselves (triggers, schedules, webhooks): ______

### B4. History
26. What changed recently? Where did bugs show up before? ______
27. Who built it and who maintains it? ______

## Part C: Security testing (only if you want it)

Security checks try to break in. Only a written yes allows them.
28. We have the owner's written permission to run security checks on: ______ (exact link or area), from ______ to
    ______. Anything excluded: ______  Contact if something goes wrong: ______
29. Is it a test copy with fake data? Yes / No. (We will not run security checks on live data.)
30. Should findings be shared only with: ______ (security reports are never put in general documents.)

## How to share access safely

- Do **not** send passwords or keys in this document, email or chat.
- Best: create a test user per role and share the email; we sign in ourselves and you can reset the password.
- For code: invite our account as **read-only** on the repository.
- For cloud: a **Reader** role only, on the test environment only.
- If a secret was pasted anywhere by mistake, rotate it (change it) right away.

## Our promise

We use fictional test data, we do not touch the live system, we list every record we create so it can be cleaned up,
and nothing is sent or published without your approval.
