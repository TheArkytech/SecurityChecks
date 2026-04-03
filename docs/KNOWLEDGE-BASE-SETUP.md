# Knowledge Base Setup

> The Knowledge Base lives in this repo as `docs/knowledge-base.md`.
> All three prompts (A, B, C) read it before executing and update it after.
> Accessible to the whole team via GitHub, with version history via git.

---

## Location

```
docs/knowledge-base.md
```

This file is the brain of the system. It contains live data that gets
updated with each prompt execution.

---

## Data Flow

```
Prompt A (Daily Radar)
  → Reads the KB before investigating
  → Writes: new threats, IOCs, status updates
  → Commits changes

Prompt B (Weekly Auditor)
  → Reads the KB to know what to verify
  → Writes: audit results, scorecard, issues created

Prompt C (On-demand Vetting)
  → Reads the KB to check if the package was already evaluated
  → Writes: package evaluation result
```

---

## KB Structure

The `knowledge-base.md` file has these sections:

### Threat Registry
Each threat has a unique ID (`THREAT-2026-XXXX`) for deduplication.
Fields per entry:
- Date detected, status, category
- Whether it affects us
- Summary, affected versions, safe version
- IOCs, action taken, sources

### Accumulated IOCs
Table with: Date, Threat ID, Type (Domain/IP/Hash), Indicator, Context.

### Dependencies Under Surveillance
Packages we use or might use that have had issues.
Table with: Package, Registry, Reason, Since, Status.

### Security Decisions
Record of what we decided and why.
Table with: Date, Decision, Context, Decided by.

### Audit History
Results from Prompt B.
Table with: Date, Project, Scorecard, Critical findings, Issues created.

---

## Maintenance

- **Daily:** Prompt A (Radar) automatically updates with new threats
- **Friday:** Guillermo does cleanup — mark resolved threats, remove obsolete IOCs, review self-improvement suggestions
- **After audit:** Prompt B records results in the Audit History section
