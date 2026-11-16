---
name: dester-init
description: "Set up a Test Cases repo for a product: one folder per module, a module index with status, a product sheet (links, environments, roles, sources of truth), case and CSV templates, and a README any QA can follow. The repo is the clean, shareable blueprint for manual and automated testing, kept apart from the messy QA project folder. Creates the folder and a local git repo only; making a remote (GitHub, Azure, GitLab) needs a yes. Use when the user says /dester-init, 'make a test cases repo', 'set up the repo for my product', 'new product', 'where do I save the cases', or before dester-modules and dester-cases on a new product."
metadata:
  author: Destine April
  version: 0.1.0
  license: MIT
  suite: dester
---

# dester-init v0.1.0

Author: Destine April. Part of the dester QA suite. Read `references/core-rules.md` first; those rules win.

**What it does:** creates the home for a product's test cases, so every module's cases land in the same place, in
the same format, and any QA (or a Playwright suite later) can pick them up.

**What it does not do:** list the modules (`dester-modules`), write cases (`dester-cases`), automate
(`dester-check`). It never pushes, never creates a remote, and never makes a repo public without a yes for that
exact action.

## Quick start

| User says | Do |
|---|---|
| `/dester-init <product> [link] [folder]` | Use the arguments, ask only what is missing, then Step 2 |
| "/dester-init" or "make a test cases repo" | Step 1 questions, then Step 2 |
| "use my existing repo at <path>" | Step 4 (adopt): add only what is missing, never overwrite |
| "push it to GitHub" | Step 5, only after a yes for the exact remote, name and visibility |

Arguments: `<product>` is the product name in quotes if it has spaces (`"Acme Shop"`). `[link]` is the app URL
(staging or test copy). `[folder]` is where to create the repo. Anything after that is free text context.

## Two folders, two jobs (explain this to the user once)

| | QA project folder `qa-<system>/` | Test Cases repo `<product>-test-cases/` |
|---|---|---|
| Made by | `dester-explore`, `dester-discover` | `dester-init` (this skill) |
| Holds | scope, map, derived spec, session notes, evidence, questions | approved-quality cases per module, CSV, coverage, module index |
| Audience | you, while working | other QAs, the client, automation |
| Can be shared | no (evidence and notes may hold client data) | yes, once reviewed |

If the user only wants one folder, put the repo inside the project folder as `qa-<system>/test-cases/` and say so.

## Step 1: Ask (one group, with defaults; skip what the arguments answered)

1. **Product name** and a short product code (2 to 4 letters). The product code only labels the repo and
   `PRODUCT.md`; case IDs use module codes from `MODULES.md` (`TC-INV-001`). *Default: from the name.*
2. **Link** to the app, and is it staging or a test copy? *Default: none yet, fill in later.* Never production
   without the user saying it is safe and read only.
3. **Where:** folder path. *Default: `./<product-slug>-test-cases/` in the current folder.*
4. **Code repo** of the product (optional, read only, used by `dester-repo` and `dester-cases`). *Default: none.*
5. **Test tool** the cases will be imported into (Testiny, TestRail, Jira Xray, Qase, Excel, none). *Default: none,
   CSV stays generic.*
6. **Who will read it:** just me, my QA team, the client, public. *Default: QA team, so private.*

## Step 2: Create

Run the scaffold script (it never overwrites an existing file and prints what it created or skipped):

```bash
bash ~/.claude/skills/dester-init/scripts/init-cases-repo.sh \
  --product "<Product Name>" --code <CODE> --dir "<folder>" [--link "<url>"] [--repo "<code repo url>"] [--tool "<test tool>"]
```

It creates the layout in `references/repo-layout.md` and runs `git init` (local only, no remote). If `git` is
missing, it still creates the files and says so.

## Step 3: Fill the product sheet

Open `PRODUCT.md` and fill what is known from the user, a Discovery Pack (`00_DISCOVERY_PACK.md`) or an
exploration map (`01_MAP.md`), with a Basis label on each line (`Confirmed`, `Confirmed (client)`, `Observed`,
`Hypothesis`). Leave unknowns as `TBD` and list them under Open questions. Never write passwords, tokens or real
customer data; for access, write the method only ("test accounts from the dev team, per role").

## Step 4: Adopt an existing repo

If the folder already exists (or the user has a cases repo already):
1. List what is there. Read the case format they use.
2. Run the script with the same `--dir`; it only adds missing files. Never rename, move or rewrite their files.
3. If their case format differs from dester's, say so in 2 lines and ask: keep theirs (dester-cases will follow it)
   or use dester's for new modules only. *Default: keep theirs.* Record the choice in `README.md` under
   "Case format".

## Step 5: Remote (only with a yes for the exact action)

Show the exact command and wait for a yes that names the host, owner, repo name and visibility. Default
visibility: **private**. Example for GitHub:

```bash
gh repo create <owner>/<product-slug>-test-cases --private --source "<folder>" --remote origin
```

Before the first push, scan for secrets, real emails, real names and client data, and show the result. Push only
after a second yes.

## Self-check before handing over

- `ls` the new folder: README.md, PRODUCT.md, MODULES.md, STATE.md, templates/, modules/ exist.
- `PRODUCT.md` has no secrets and no real personal data; unknowns are `TBD`.
- Nothing was pushed and no remote was made without a yes.

## Hand-off

Say: where the repo is, what is still `TBD` in `PRODUCT.md`, and the next step: `/dester-modules` to fill the
module index (from the link, the code, or an existing map), then `/dester-cases <module>` per module.
