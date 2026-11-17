# dester guide: from a link to test cases, step by step

One page. Follow it top to bottom. At every step there is **what you type** and **what you get**.
You do not need to know QA words; the skills explain them as they come up.

## Before you start (5 minutes)

You need:
- **Claude Code** (desktop app, terminal, or IDE extension).
- **The link** to the app you will test. Use a **staging or test copy**, never the live site with real customers.
- **Test accounts** per role (admin, staff, ...) if the app has a sign-in. **You** sign in. Never give the AI a password.
- Optional: the **code repo** link of the app (read only). It makes the cases sharper.

Install once:

```bash
git clone https://github.com/dev-tine/dester-qa-skills.git
cd dester-qa-skills
./install.sh
```

Open a **new** Claude Code session after installing. In the examples below, replace `Acme Shop` and the link with yours.

## The easy way: let the AI guide you

Paste this as your first message, then just follow what it tells you:

```
I want to make test cases for "Acme Shop" (https://staging.acme.example).
Use the dester skills in this order: dester-init, then dester-modules, then dester-cases
for one module at a time, riskiest first. Do one step at a time. After each step, tell me what you made, what you need from me,
and the exact line I should type next.
```

## The steps (if you want to drive it yourself)

| # | Type this | What happens | You are done when |
|---|---|---|---|
| 0 | `/dester-discover` *(optional)* | Makes a short form for the client: what the system does, roles, access, what must not be touched. | The client sent answers back, or you skipped it. |
| 1 | `/dester-init "Acme Shop" https://staging.acme.example` | Creates `acme-shop-test-cases/`: one folder per module, a module list, a product sheet, templates. Local only, nothing is uploaded. | The folder exists. |
| 2 | `/dester-modules "Acme Shop" https://staging.acme.example` | You sign in. It reads the menus (look only, no clicks that save), and the code if you gave a repo. Lists every module with a risk score and picks the riskiest one first. | `MODULES.md` has a row per module and a "next module". |
| 3 | `/dester-cases Orders "Acme Shop" https://staging.acme.example` | Opens the Orders screens, reads the code if given, shows you the rules it found. You add or remove rules. Then it writes cases: happy path, positive, negative, edge, boundary. | `modules/orders/` has `cases.md`, `cases.csv`, `coverage.md`, `questions.md`. |
| 4 | Read `questions.md`, then type the answers: `answers for Orders: 1. no, hide the total 2. yes ...` | Cases waiting on the owner get a real expected result. Anything still unsure stays marked. | No `TBD, ask owner` left, or you know who to ask. |
| 5 | `mark Orders as reviewed` | Updates `MODULES.md`. | Status says Cases reviewed. |
| 6 | `next module` | Picks the next riskiest module and runs step 3 for it. | Repeat 3 to 6 until every module you care about has cases. |

Add a code repo to step 2 or 3 by putting its link at the end:
`/dester-cases Orders "Acme Shop" https://staging.acme.example https://github.com/acme/shop`

## After the cases (pick what you need)

| You want to | Type this |
|---|---|
| Write user stories and acceptance criteria (before UAT) | `/dester-stories Orders "Acme Shop" https://staging.acme.example` |
| Build UAT scenarios from the agreed stories | `/dester-stories uat "Acme Shop"` |
| Run some cases now, together | `run TC-ORD-001 to TC-ORD-005 with me and record results with evidence` |
| Make repeatable automated checks (Playwright) | `/dester-check automate the P1 cases of Orders` |
| Look at one area through a lens (UX, accessibility, numbers, a role) | `/dester-lens check the numbers in Orders` |
| Write up a bug you found | `/dester-report write the bug report for TC-ORD-014` |
| Make a client summary or diagrams | `/dester-docs module map and test coverage for Acme Shop` |
| Check security (only with written permission) | `/dester-secure` |

## Stopping and coming back

Every skill saves to files and keeps a `STATE.md` with **RESUME HERE**. In a new session, type:
`continue Acme Shop from STATE.md`

## What the labels mean

- **Confirmed**: the owner, a developer or a document said so. Safe to use as the expected result.
- **Observed**: the app did it, nobody confirmed it yet. It could be a bug, so it goes to `questions.md`.
- **Hypothesis**: read from code or guessed, not yet seen working.
- **Standard**: normal behavior everyone expects (a required field cannot be empty).
- Priority: **P1** money, data loss, security, main flow. **P2** common features. **P3** cosmetic or rare.

## Rules the skills always follow

- **You decide.** Nothing is posted, uploaded, pushed or changed in a real system without your yes for that exact action.
- **You sign in.** The AI never types or stores passwords.
- **Only systems you are allowed to test**, on staging or a test copy.
- **Fake test data only** (`QA Test Customer 01`), and the skills list what they created so you can clean it up.
- **No evidence, no pass.** A case is Pass only when the result was seen and saved.

## If something goes wrong

| Problem | Say this |
|---|---|
| It found almost no modules | `the menu has more pages, read it again as <role>` or give it the code repo |
| Cases feel generic | `use the real labels and limits from the screen and code, list the rules first` |
| It is going too fast | `one step at a time, wait for my yes` |
| You are new to QA | `I'm new to QA, explain as you go` |
