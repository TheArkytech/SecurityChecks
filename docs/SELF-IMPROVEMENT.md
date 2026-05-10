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

### [2026-05-10] [CHECK] Add repo config file pre-inspection ritual to team onboarding and AGENTS.md
- **Origin:** Prompt A
- **Description:** TrustFall and Mini Shai-Hulud together prove that .mcp.json,
  .claude/settings.json, .vscode/tasks.json, and .cursor/ files are now a primary
  attack vector for anyone who clones a repo. Anthropic has explicitly declined to
  patch TrustFall ("trust = consent"). The only defense is manual pre-inspection
  before accepting any trust dialog. This should be a named checklist step in
  AGENTS.md rule set and in Prompt B's audit checklist: "Before opening any
  cloned repo in Claude Code or Cursor, run:
  `grep -rn 'mcpServers\|SessionStart\|runOn' .mcp.json .claude/ .cursor/ .vscode/tasks.json 2>/dev/null`
  and review any output." Consider adding this as a git clone alias or shell
  function for the team.
- **Impact:** High
- **Effort:** Low

### [2026-05-10] [COVERAGE] Add Linux kernel version tracking to security checklist
- **Origin:** Prompt A
- **Description:** CVE-2026-31431 (Copy Fail) revealed that the current host
  OS (Linux 6.18.5) is below the patched kernel version (6.18.22). The Security
  Radar has no mechanism to track kernel versions of our dev/CI infrastructure
  and compare against CVE patch levels. Prompt B or a separate infrastructure
  check should capture kernel versions and flag when they fall below known-safe
  versions for active CVEs. Could be a simple `uname -r` in CI output compared
  against a tracked minimum.
- **Impact:** High
- **Effort:** Medium

### [2026-05-10] [PROMPT] Add OAuth third-party app compromise as a search area in Prompt A
- **Origin:** Prompt A
- **Description:** The Vercel breach originated from a compromised third-party
  AI tool (Context.ai) that had been granted Google Workspace OAuth access by a
  Vercel employee. This attack pattern (infostealer → OAuth token theft → MFA
  bypass → lateral movement) is not currently in Prompt A's research areas.
  Area 3 (Infrastructure) should explicitly include: "Attacks on SaaS platforms
  via compromised OAuth integrations or third-party AI productivity tools."
  Also worth tracking: which OAuth apps our team has authorized to access
  GitHub, Google Workspace, and Vercel.
- **Impact:** High
- **Effort:** Low

### [2026-05-10] [KB] Add "Attack Techniques" section to Knowledge Base
- **Origin:** Prompt A
- **Description:** Several findings today (TrustFall folder trust exploitation,
  Mini Shai-Hulud worm propagation via AI agent config injection, Vercel OAuth
  lateral movement via infostealer) represent reusable attack techniques rather
  than single-incident threats. The current KB structure (Threat Registry + IOCs)
  is good for tracking specific incidents but doesn't capture reusable TTPs.
  Consider adding an "Attack Techniques / TTPs" section in the KB that maps
  techniques to MITRE ATT&CK IDs and lists mitigations independently of
  specific threat actors.
- **Impact:** Medium
- **Effort:** Medium

### [2026-04-05] [COVERAGE] Add slopsquatting check to PROMPT-C vetting
- **Origin:** Prompt A
- **Description:** With ~20% of AI-recommended packages being hallucinated names, PROMPT-C's step 1 ("Does it actually exist?") should be strengthened. Add explicit checks: cross-reference the package name against known AI hallucination patterns, verify the package existed BEFORE the AI suggested it (check publish date), and flag packages with very low download counts that match common naming patterns.
- **Impact:** High
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
