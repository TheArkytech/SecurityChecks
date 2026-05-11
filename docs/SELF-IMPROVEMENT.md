# Security System Auto-Improvement

> This file is a living log of suggestions to improve the security system
> itself (prompts, KB, checks, coverage). Prompts A and B write suggestions
> here. Guillermo reviews and approves them on Fridays.

---

## How it works

1. **Prompt A (Radar)** — After each daily scan, evaluates if the security
   system has gaps and logs suggestions here
2. **Prompt B (Auditor)** — After each audit, evaluates if the audit
   checklists need improvements and logs suggestions here
3. **Friday** — Guillermo reviews suggestions, approves the ones that make
   sense, and implements them (or asks Claude to implement them)

---

## Suggestion categories

- **PROMPT** — Improvements to the prompts (new research areas, better format, etc.)
- **KB** — New sections or fields for the Knowledge Base
- **CHECK** — New checks to add to Prompt B (auditor)
- **COVERAGE** — Security areas not currently covered
- **PROCESS** — Process or cadence improvements
- **TOOLING** — Tools or integrations to consider

---

## Pending suggestions

<!-- Format:
### [YYYY-MM-DD] [CATEGORY] Short title
- **Origin:** Prompt A / Prompt B / Manual
- **Description:** What to improve and why
- **Impact:** High / Medium / Low
- **Effort:** High / Medium / Low
-->

### [2026-04-03] [CHECK] Add MCP server security audit to Prompt B
- **Origin:** Prompt A
- **Description:** The MCP ecosystem has 30+ CVEs in 60 days, with 82% of implementations vulnerable to path traversal. Prompt B's audit checklist (AGENTS.md rule #11) only says "review periodically." We should add a concrete MCP audit section to Prompt B that checks: server versions against CVE database, token scopes, whether servers use HTTPS, and input validation patterns.
- **Impact:** High
- **Effort:** Low

### [2026-04-03] [PROMPT] Add Claude Code configuration audit to Prompt A
- **Origin:** Prompt A
- **Description:** The Claude Code source leak revealed configuration injection attacks (CVE-2026-21852) via malicious `.claude/` and `.claudecode/` files in repos. Prompt A should include a check for newly disclosed Claude Code / AI tool CVEs and advise on configuration file hygiene.
- **Impact:** Medium
- **Effort:** Low

### [2026-04-03] [COVERAGE] Track GitHub Actions SHA pinning status
- **Origin:** Prompt A
- **Description:** TeamPCP's campaign exploited mutable GitHub Action tags to inject malicious code. We should track which of our projects have SHA-pinned Actions vs mutable tags, and flag any regressions. This could be a new section in the KB or a check in Prompt B.
- **Impact:** High
- **Effort:** Medium

### [2026-04-05] [CHECK] Add mcp.json and config file audit to Prompt B
- **Origin:** Prompt A
- **Description:** CVE-2026-21518 shows that malicious mcp.json files in repos can achieve RCE via VS Code. Combined with CVE-2026-21852 (Claude Code settings injection), we need Prompt B to explicitly check for malicious configuration files: mcp.json, .claude/, .claudecode/, .cursorrules, .cursor/ in any audited project. These files are a new attack surface that the current checklist doesn't cover.
- **Impact:** High
- **Effort:** Low

### [2026-04-05] [COVERAGE] Add slopsquatting check to PROMPT-C vetting
- **Origin:** Prompt A
- **Description:** With ~20% of AI-recommended packages being hallucinated names, PROMPT-C's step 1 ("Does it actually exist?") should be strengthened. Add explicit checks: cross-reference the package name against known AI hallucination patterns, verify the package existed BEFORE the AI suggested it (check publish date), and flag packages with very low download counts that match common naming patterns.
- **Impact:** High
- **Effort:** Low

### [2026-05-11] [CHECK] Add TrustFall CI workflow audit to Prompt B
- **Origin:** Prompt A
- **Description:** TrustFall (THREAT-2026-0012) shows that GitHub Actions workflows using the Anthropic claude-code action are exploitable via external contributor PRs with no user interaction. Prompt B should audit all CI/CD workflow files for: (1) use of claude-code action without fork PR gating, (2) presence of .mcp.json or .claude/settings.json in repo roots that could be malicious, (3) workflows that auto-trust external PRs. Specific check: grep for `anthropic/claude-code-action` and verify a maintainer approval gate (e.g., `if: contains(github.event.pull_request.labels.*.name, 'safe to run')`) exists.
- **Impact:** High
- **Effort:** Low

### [2026-05-11] [PROMPT] Add 36-day gap detection to Prompt A cadence check
- **Origin:** Prompt A
- **Description:** Today's report covered a 36-day gap (last KB update 2026-04-05, today 2026-05-11). Several threats had significant developments (TeamPCP "Mini Shai-Hulud," TrustFall, Vercel breach, Linux kernel KEV) during the gap. Prompt A should detect when the last KB update was more than 7 days ago and explicitly flag the gap at the top of the report, noting which time windows may have been missed. This increases user awareness of coverage gaps and encourages more frequent scans.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-11] [COVERAGE] Monitor GitHub service account repos for TeamPCP-style exfil pattern
- **Origin:** Prompt A
- **Description:** TeamPCP's "Mini Shai-Hulud" exfiltrates stolen secrets to *public repos created on the victim's own account* (named "A Mini Shai-Hulud has Appeared") to evade egress-based detection. Prompt B and the KB should include a check: enumerate public repos created by any CI/CD service account or bot in the last 30 days and flag any unexpected ones. This is a one-call GitHub API check (`GET /user/repos?type=public&sort=created`) that can be added to Prompt B's CI/CD audit section.
- **Impact:** High
- **Effort:** Low

### [2026-05-11] [KB] Add "Alert History" section tracking alert level trend over time
- **Origin:** Prompt A
- **Description:** The KB tracks individual threats well but has no time-series view of overall alert level. Adding a short "Alert History" table (date, level, dominant threat driver) would let Guillermo see whether the threat landscape is improving or worsening at a glance without reading every entry. Today's radar would log: 2026-05-11 | ORANGE | TrustFall + CVE-2026-31431 KEV deadline.
- **Impact:** Medium
- **Effort:** Low

---

## Implemented suggestions

<!-- Move approved and implemented suggestions here -->

| Date implemented | Category | Description | Origin |
|---|---|---|---|
| | | | |

---

## Instructions for prompts

### For Prompt A (add at the end of each execution):
After completing the daily report, reflect briefly:
- Was there any security area you couldn't cover well? Why?
- Was the report format adequate or could something improve?
- Are there information sources you should check but aren't in your instructions?
- Does the Knowledge Base have the right structure for what you found today?

If you identify something, add an entry to the "Pending suggestions" section
of `docs/SELF-IMPROVEMENT.md`.

### For Prompt B (add at the end of each execution):
After completing the audit, reflect briefly:
- Were there vulnerabilities you looked for but your checklist didn't cover?
- Is any checklist category outdated or incomplete?
- Does the scorecard accurately reflect the project's security posture?
- Do you need access to tools or data you don't have?

If you identify something, add an entry to the "Pending suggestions" section
of `docs/SELF-IMPROVEMENT.md`.
