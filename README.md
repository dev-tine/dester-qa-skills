# dester QA skills

Author: Destine April | Version: 0.1.0 | License: TBD (placeholder, MIT planned)

A suite of Claude Code skills for QA on systems with no documentation. Built for QA analysts and for vibe coders
who build fast with AI and want to check their work without learning QA jargon.

## The suite

| Skill | Purpose |
|---|---|
| `dester-discover` | Step 0. Client Discovery Pack (fillable, tiered, platform-specific asks for Lovable, GHL, Azure, GitHub, Claude Code), then reads the answers and shows the gaps |
| `dester-explore` | Map an undocumented system, write a derived spec and charters, run exploratory sessions |
| `dester-cases` | Test cases (happy, positive, negative, edge, boundary) with traceability; Markdown and import-ready CSV |
| `dester-lens` | Review one area through a lens: senior QA, end user per role, UX, accessibility, process, data accuracy, negative and edge |
| `dester-repo` | Read-only code review: risk map, code to spec rows and cases, PR or diff review |
| `dester-secure` | Authorized-only OWASP-style checks; refuses to run without written permission |
| `dester-check` | Playwright checks for what you want to repeat, plus the login helper (human signs in) and read-only recon crawler |
| `dester-report` | Referee check, bug reports, severity and priority, final report and ship recommendation |
| `dester-docs` | Client-ready documentation and visuals: overview, roles matrix, flow and status diagrams, coverage |

## How they connect

```
dester-discover  ->  dester-explore  ->  dester-cases  ->  dester-lens / dester-check
   (client facts)     (map, spec,          (what to test)     (test it, repeat it)
                       charters)                  \                 |
 dester-repo (code, read only) feeds explore,      ->  dester-report  ->  dester-docs
 cases and secure                                       (bugs, verdict)    (client deliverables)
 dester-secure (written permission only) -> findings go to the owner only
```

You do not need all of them. Common starts:
- **Client with no docs, has access:** discover, explore, cases, lens, report.
- **Just a link:** explore (mode A or B), then cases and report. Expect lower confidence.
- **Repo given:** repo, then explore (mode C), then cases.
- **A PR to check:** repo (Job C), then check.

## Install

```bash
./install.sh            # copies shared rules in, symlinks every skill into ~/.claude/skills/
./install.sh --uninstall
```

Then open a new Claude Code session. Type `/dester-discover`, `/dester-explore`, and so on. Re-run `install.sh`
after you edit `shared/`.

For browser work you need Node and Google Chrome (or run `npx playwright install chromium`). See `dester-check`.

## Rules (all skills)

See `shared/core-rules.md`: the skill recommends and you decide; you sign in, never the skill; authorized systems
only; fictional data only; no evidence, no pass; findings from code are hypotheses; security findings go to the
owner only.
