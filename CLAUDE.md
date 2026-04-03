# SecurityChecks — Claude Instructions

This is a meta-repository containing security prompts, documentation, and
hardening templates for development teams. It is NOT an application.

## What this repo contains

- **Prompts** (A/B/C): Automated security scanning prompts for Claude agents
- **Knowledge Base**: `docs/knowledge-base.md` — live threat intel and decisions
- **Hardening templates**: `.npmrc`, `.pre-commit-config.yaml` — copy to projects
- **Roadmap**: `docs/IMPROVEMENTS.md` — prioritized security improvements

## Automated enforcement

- **Dependency guard hook** (`.claude/hooks/dependency-guard.sh`): Blocks any
  `npm install <pkg>`, `pnpm add`, `pip install <pkg>`, etc. before execution.
  Claude must run the PROMPT-C-VETTING.md vetting process before installing
  any new dependency. Configured in `.claude/settings.json`.

## Rules for working in this repo

1. **Read `AGENTS.md` before any action.** It defines supply chain security rules.
2. **Never add npm dependencies to this repo.** It has no `package.json` by design.
3. **Keep documentation in English.** All docs are maintained in English.
4. **Update the roadmap** (`docs/IMPROVEMENTS.md`) when completing security items.
5. **Update the KB** (`docs/knowledge-base.md`) when discovering new threats or IOCs.
6. **Follow the self-improvement loop** in `docs/SELF-IMPROVEMENT.md`.
