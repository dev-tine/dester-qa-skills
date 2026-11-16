#!/usr/bin/env bash
# dester-init: scaffold a Test Cases repo. Never overwrites an existing file. Local git init only, no remote.
# Usage: init-cases-repo.sh --product "Name" [--code ABC] [--dir path] [--link url] [--repo url] [--tool name]
set -euo pipefail

PRODUCT="" CODE="" DIR="" LINK="" REPO="" TOOL=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --product) PRODUCT="${2:-}"; shift 2 ;;
    --code) CODE="${2:-}"; shift 2 ;;
    --dir) DIR="${2:-}"; shift 2 ;;
    --link) LINK="${2:-}"; shift 2 ;;
    --repo) REPO="${2:-}"; shift 2 ;;
    --tool) TOOL="${2:-}"; shift 2 ;;
    -h|--help) sed -n 2,3p "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done
[[ -n "$PRODUCT" ]] || { echo "Missing --product" >&2; exit 1; }

SLUG="$(printf '%s' "$PRODUCT" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
[[ -n "$SLUG" ]] || SLUG="product"
if [[ -z "$CODE" ]]; then
  CODE="$(printf '%s' "$PRODUCT" | tr -cd '[:alnum:] ' | awk '{ if (NF>1) { for (i=1;i<=NF&&i<=4;i++) printf substr($i,1,1) } else printf substr($1,1,3) }' | tr '[:lower:]' '[:upper:]')"
fi
DIR="${DIR:-./$SLUG-test-cases}"
LINK="${LINK:-TBD}" REPO="${REPO:-none}" TOOL="${TOOL:-none (generic CSV)}"
TODAY="$(date +%Y-%m-%d)"

mkdir -p "$DIR/templates" "$DIR/modules" "$DIR/automation"
created=0 skipped=0
put() { # put <relative path>  (content on stdin)
  local f="$DIR/$1"
  if [[ -e "$f" ]]; then echo "skip    $1 (exists)"; skipped=$((skipped+1)); cat >/dev/null
  else cat >"$f"; echo "create  $1"; created=$((created+1)); fi
}

put .dester-cases-repo <<EOF
product=$PRODUCT
code=$CODE
slug=$SLUG
created=$TODAY
EOF

put README.md <<EOF
# $PRODUCT test cases

Test cases for **$PRODUCT**, one folder per module. They are the blueprint for manual testing and for automated
checks. Made with the dester QA skills (MIT).

## How to read this repo

- \`PRODUCT.md\`: what the product is, links, environments, roles, where expected results come from.
- \`MODULES.md\`: every module, its risk, status and case count. Start here to pick what to test.
- \`modules/<module>/cases.md\`: the cases. \`cases.csv\` is the same list, ready to import into a test tool.
- \`modules/<module>/coverage.md\`: which requirement each case checks, and what has no case yet.
- \`modules/<module>/questions.md\`: expected results waiting for the owner to confirm.

## Case format

See \`templates/case-template.md\`. Every case has a Source (where the expected result comes from) and a Basis:

| Basis | Means |
|---|---|
| Confirmed | the owner, a developer or a real document said so |
| Observed | seen in the app, not yet confirmed by the owner (could be a bug) |
| Hypothesis | read from code or guessed, not yet seen working |
| Standard | common behavior (required fields cannot be empty, passwords are hidden) |

Case IDs: \`TC-<MODULE>-<nnn>\`. Never reuse an ID; mark old cases \`Retired\`.
Priority: P1 money, data loss, security, core flow. P2 common features. P3 cosmetic or rare.

## Adding cases

With Claude Code and the dester skills: \`/dester-cases <module> "$PRODUCT" <link>\`.
By hand: copy \`templates/case-template.md\`, keep the ID rules, add the row to \`cases.csv\` and update
\`MODULES.md\`.

## Never commit

Passwords, tokens, \`.env\` files, browser session files, real customer data, screenshots with real data.
EOF

put PRODUCT.md <<EOF
# $PRODUCT

Status: DRAFT | Updated: $TODAY | Code: $CODE

Every line carries a Basis: Confirmed, Confirmed (client), Observed, Hypothesis, or TBD.

## What it is
TBD: one or two sentences, who uses it, what would hurt most if it broke.

## Links and environments
| Environment | URL | Safe to create test data? | Basis |
|---|---|---|---|
| Staging or test | $LINK | TBD | TBD |
| Production | TBD | No (read only, only if allowed) | TBD |

Code repo (read only): $REPO
Test tool for import: $TOOL

## Roles
| Role | What they do | Test account available? (method only, never the password) |
|---|---|---|
| TBD | | |

## Sources of truth for expected results
| Source | Where | Trust |
|---|---|---|
| TBD (BRD, tickets, owner answers, help pages) | | |

## Out of bounds
TBD (real payments, real emails or SMS, real customers)

## Open questions
- TBD
EOF

put MODULES.md <<EOF
# $PRODUCT modules

Updated: $TODAY | Filled by dester-modules. Status words: Not started, Mapped, Cases drafted, Cases reviewed,
Automated (partial), Automated, Out of scope.

| # | Code | Module | Sub-pages or screens | Roles | Risk (I x L) | Found from | Status | Cases | Folder |
|---|---|---|---|---|---|---|---|---|---|

Found from: Seen (opened in the app), Code (hypothesis), Client (said by the owner), Docs.
EOF

put STATE.md <<EOF
# STATE

Updated: $TODAY

## RESUME HERE
Repo created. Next: run /dester-modules to fill MODULES.md, then /dester-cases <module>.

## Open items
- PRODUCT.md has TBD lines.
EOF

put templates/case-template.md <<'EOF'
TC-<MODULE>-<nnn> | <title: action and condition> | P1/P2/P3 | Happy path / Positive / Negative / Edge / Boundary
Source: <spec row, requirement, ticket or "Standard"> | Basis: Confirmed / Observed / Hypothesis / Standard
Preconditions: <role, data, state>
Steps:
1. <one action, exact on-screen label in quotes: Click the "Save" button>
Expected: <specific, checkable result: a message, a number, a visible state>
Data: <fictional values, for example "QA Test Customer 01">
Status: Not run | Pass | Bug | Blocked | Flaky
Evidence: <path or "-">
EOF

put templates/cases-template.csv <<'EOF'
ID,Module,Title,Priority,Category,Source,Basis,Preconditions,Steps,Expected,Data,Status
EOF

put automation/README.md <<'EOF'
# Automation

Playwright checks made from the cases (dester-check). One spec per case or per small group, named after the case
ID. Sign-in is done by a human; session files stay outside this repo.
EOF

put .gitignore <<'EOF'
.DS_Store
node_modules/
evidence/
.dester-sessions/
storage-state*.json
state.json
.env
.env.*
test-results/
playwright-report/
EOF

touch "$DIR/modules/.gitkeep"

if command -v git >/dev/null 2>&1; then
  if [[ -d "$DIR/.git" ]] || git -C "$DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "git     already a repo (left as is)"
  else
    git -C "$DIR" init -q && echo "git     initialized (local only, no remote)"
  fi
else
  echo "git     not found: files created, no repo initialized"
fi

echo "Done: $created created, $skipped skipped | product=$PRODUCT code=$CODE dir=$DIR"
