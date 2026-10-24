---
name: dester-docs
description: "Create client-ready documentation and visual aids for a system that had none: system overview, module map, role and permission matrix, flow diagrams, data and status diagrams, test coverage summary, and a QA summary. Uses Mermaid diagrams, tables and annotated screenshots; can export to a Doc, HTML page, slides or PDF through the tools available. Use when the user says /dester-docs, 'make documentation', 'diagram this', 'visual for the client', 'system overview', 'flowchart', or after dester-explore or dester-cases."
metadata:
  author: Destine April
  version: 0.1.0
  license: TBD (placeholder, MIT planned)
  suite: dester
---

# dester-docs v0.1.0

Author: Destine April. Read `references/core-rules.md` first; those rules win.

**What it does:** turns the project folder (map, derived spec, cases, session notes) into documents and visuals that
a client, boss or teammate can read without knowing QA.

Nothing is sent or shared without a yes for that exact action. Everything is a **DRAFT** until the user approves.

## Inputs (ask, with defaults)

1. **Who reads it?** Client owner, developers, end users, your own team. *Default: client owner, non-technical.*
2. **Which deliverables?** Pick any (default: 1, 2, 3, 4):
   1. System overview (what it is, modules, roles, in plain words)
   2. Role and permission matrix (who can do what)
   3. Flow diagrams (the main business flows, step by step, by role)
   4. Data and status diagrams (objects and how their status changes)
   5. Test coverage summary (what was tested, what was not, results)
   6. QA summary with findings and a recommendation (needs `dester-report` data)
   7. Quick user guide with annotated screenshots
3. **Format:** Markdown (default), an editable Doc, an HTML page, slides, or PDF/Word through whichever skill or
   connector is available. Say which was used.
4. **Tone:** plain and short; or formal for a contract deliverable.

## Sources and honesty

- Use `01_MAP.md`, `02_DERIVED_SPEC.md`, `05_TEST_CASES.md`, `04_SESSIONS/`, and evidence. If missing, offer
  `dester-explore` or `dester-cases` first.
- Every statement keeps its confidence from the spec. In client documents show it plainly as a legend:
  **Confirmed**, **Observed** (seen working, not yet confirmed by you), **Unclear** (needs your answer). Never turn a
  Hypothesis or Observed rule into a statement of fact.
- Unknowns go in a "Questions for you" section, not into guesses.
- Test results: counts come from the run log; recount before writing. Never claim a check that was not run.

## Visuals (Mermaid first; it renders in GitHub, most docs tools and HTML)

Use the templates in `references/diagram-templates.md`:
- **Flow:** `flowchart` with swimlanes per role (`subgraph`), one flow per diagram, max about 12 steps.
- **Roles matrix:** a table with colored words (`Allowed`, `View only`, `Denied`, `Not tested`), never color alone.
- **Status lifecycle:** `stateDiagram-v2` per data object.
- **Module map:** `flowchart LR` showing how data moves between modules.
- **Sequence:** `sequenceDiagram` for a flow that crosses systems (payment, email, SMS).
- **Coverage:** a table (area, cases, run, pass, bug, blocked), plus a simple bar if the format supports charts.
Each diagram has a one-line caption saying what to notice. Keep text labels short; check that the diagram has no
step that was never seen (unseen steps are drawn dashed and labelled `unconfirmed`).

If the user wants a polished page, build it with the artifact or doc tools available, following their design
guidance. A screenshot with boxes and numbers (annotated) is better than a long description: only use screenshots
that are redacted (see below).

## Client-safe checklist (before anything leaves the project folder)

- No passwords, tokens, API keys, session data. No real personal data (names, emails, phone numbers, faces).
- Screenshots show only fictional or masked data; staging URLs are fine to show only if the client agrees.
- Internal notes, guesses and raw bug drafts are not included. Security findings are never put in a
  general client document; they go to the owner only, through `dester-secure` and `dester-report`.
- No em dashes, plain language, consistent names for modules and roles (same as in the map).

## Files

```
06_DOCS/overview.md
06_DOCS/roles-matrix.md
06_DOCS/flows.md            (Mermaid blocks)
06_DOCS/data-status.md
06_DOCS/coverage.md
06_DOCS/user-guide.md       (if chosen)
06_DOCS/exports/            (HTML, PDF, DOCX when produced)
```

## Self-check before handing over

- Every diagram step and matrix cell traces to a spec row or session note; unconfirmed ones are marked.
- Names match the map. Numbers recounted. Legend present. Client-safe checklist passed (list what you checked).
- The file exists and is non-empty (`test -s`) for every file you claim.

## Hand-off

Show what was produced, what is unconfirmed (first), and the questions for the owner. Ask for approval before any
export or share. Exporting to a Doc, Drive, email or chat is a separate yes.
