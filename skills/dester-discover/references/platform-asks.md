# Platform-specific asks

Author: Destine April | dester-discover v0.1.0

Add only the blocks that match what the client said they use. Always ask for the **test or staging** version, and
**read-only** access. Never ask for passwords, keys or tokens.

## Lovable (AI app builder)
- Link to the published app and to the preview link. Which one is the test copy?
- The original brief or the first prompts, and the project's plan or knowledge files if any.
- Backend: Supabase or other. Read-only invite to the project, or an export of the table list and the row-level
  security (RLS) policies. Which tables hold user, money and role data?
- Sign-up and roles: how are roles assigned (a roles table, metadata)? Is email confirmation on?
- Is the repo synced to GitHub? Link (read-only).

## GoHighLevel (GHL)
- Sub-account name and a user with the lowest role that can see everything we test (not the agency owner).
- List or screenshots of: pipelines and stages, workflows (triggers, actions, wait steps), forms and funnels,
  calendars and booking widgets, custom fields and tags.
- Which workflows send SMS or email to contacts? A test contact (our own phone and email) to use.
- Integrations: payment, Zapier, webhooks, Google, Facebook.
- Is there a sandbox or a duplicate sub-account? We never run workflows against real contacts.

## Azure
- Environment names (dev, test, prod) and which one we may test. URLs for each.
- A **Reader** role on the test resource group only (or a diagram or list of resources: App Service, Static Web
  App, Functions, SQL, Storage, Service Bus).
- Entra ID (login) roles and groups: which map to app roles.
- Azure DevOps or GitHub pipelines: where builds and releases are, and how to tell which build is deployed.
- Never Key Vault values or connection strings.

## GitHub repository
- Read-only access (or a ZIP of the default branch). Branch deployed to the test environment.
- README, CLAUDE.md, AGENTS.md, docs folder, `.env.example` (never `.env`), migrations or schema, OpenAPI or route
  list, test folder, CI workflow files.
- Recent pull requests or commits that changed the area to test, and any open issues.
- How to run it locally, if we may.

## Claude Code or Codex built
- The project's CLAUDE.md or AGENTS.md, plan or spec files, TODO list, and any prompt or chat summary that
  describes the intended behavior.
- Which parts were generated and never reviewed by a person? Which parts the builder is unsure about?
- Test commands that exist (and whether they pass).

## Other (Bubble, WordPress, no-code, custom)
- Admin read-only role or a staff role per user type, the plugin or integration list, and an export of settings,
  roles and workflows.

## Reading the answers

For each block, put the answers into: access and limits (`00_SCOPE.md`), rules and roles (`02_DERIVED_SPEC.md`),
flows and risk (`01_MAP.md`, `03_CHARTERS.md`), gaps (`questions.md`). A repo that arrives means mode C of
`dester-explore`; read-only, and code findings stay Hypothesis until seen in the running system.
