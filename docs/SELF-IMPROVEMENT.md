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

### [2026-05-13] [CHECK] Add TrustFall pre-flight check to all repo onboarding procedures
- **Origin:** Prompt A
- **Description:** TrustFall (THREAT-2026-0013) showed that .mcp.json and .claude/settings.json
  in cloned repos can achieve one-click RCE via Claude Code's trust dialog. Anthropic declined
  to patch. Prompt B (auditor) should add an explicit check for the presence of these files
  in any project being audited, and flag any that contain `enableAllProjectMcpServers` or
  remote MCP server URLs. Consider adding this as a git pre-commit hook check to AGENTS.md.
- **Impact:** High
- **Effort:** Low

### [2026-05-13] [COVERAGE] Track SLSA provenance integrity separately from package integrity
- **Origin:** Prompt A
- **Description:** Mini Shai-Hulud (THREAT-2026-0012) achieved the first documented bypass of
  valid SLSA Sigstore provenance by hijacking the legitimate build pipeline. The KB and Prompt
  B currently treat SLSA provenance as a reliable integrity signal. We need a new section or
  check that recognizes provenance as "build pipeline was trusted" not "package content is
  safe" — and recommends runtime behavioral analysis (e.g., socket.dev, Socket CLI) in addition
  to provenance checks, especially for CI/CD dependencies.
- **Impact:** High
- **Effort:** Medium

### [2026-05-13] [PROMPT] Add Linux kernel version check to Radar's infrastructure area
- **Origin:** Prompt A
- **Description:** CVE-2026-31431 "Copy Fail" with a CISA KEV May 15 deadline was caught in
  today's scan, but the Radar prompt's Infrastructure area doesn't explicitly mention Linux
  kernel CVEs as a daily check. The prompt mentions "Zero-days in Node.js, Python, browsers,
  operating systems" — this should be strengthened to explicitly name Linux kernel LPEs given
  their high frequency and impact on CI/CD runners and dev machines.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-13] [KB] Add "Campaign timeline" field to Threat Actor entries
- **Origin:** Prompt A
- **Description:** THREAT-2026-0004 (TeamPCP) now spans 5 distinct phases over 2+ months.
  The current KB format makes it hard to track campaign phases chronologically. Adding a
  "Campaign timeline" table within threat actor entries (date, phase name, targets, outcome)
  would make phase tracking clearer and avoid overloading the Summary field.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-16] [COVERAGE] Track Chrome extension security separately from IDE/tool security
- **Origin:** Prompt A
- **Description:** ClaudeBleed (THREAT-2026-0018) revealed that the Claude Chrome extension
  is a distinct attack surface from Claude Code CLI. The Radar prompt groups "AI coding tools"
  but doesn't explicitly include browser extensions in its search scope. Browser extensions for
  AI tools (Claude, Cursor web, Copilot Chat) should be an explicit daily check area — they
  have different permission models and attack vectors (cross-extension injection vs. MCP/config
  file injection). Consider adding "AI tool browser extensions" as a sub-bullet in Area 2.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-16] [KB] Add "Vendor response" field to AI Dev threats
- **Origin:** Prompt A
- **Description:** TrustFall (Anthropic declined), ClaudeBleed (incomplete patch), CVE-2026-26268
  (Cursor patched promptly), MCPoison (Check Point research, no CVE) show very different vendor
  response patterns. The KB doesn't currently capture vendor response posture, which is critical
  for deciding how urgently we need compensating controls. A "Vendor response" field (Patched /
  Patched (incomplete) / Declined / Acknowledged/pending) would make prioritization easier.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-16] [PROMPT] Add "OAuth token hygiene" to Infrastructure search area
- **Origin:** Prompt A
- **Description:** The Vercel breach (THREAT-2026-0022) used OAuth tokens that bypassed MFA
  entirely — a pattern also seen in the Trivy/Context.ai chain. The Radar's Infrastructure
  area searches for platform vulnerabilities but doesn't explicitly search for OAuth supply
  chain attacks or SSO bypass patterns. Adding "OAuth supply chain attacks" and "MFA bypass
  via token reuse" as explicit search terms in Area 3 would catch these incidents earlier.
- **Impact:** High
- **Effort:** Low

### [2026-05-17] [COVERAGE] Add retrospective Q1 2026 threat gap scan to KB initialization
- **Origin:** Prompt A
- **Description:** The Cline CLI "Clinejection" attack (February 17, 2026) established the
  canonical AI-agent supply chain attack pattern (prompt injection → GitHub Actions → registry
  publish) that TeamPCP later industrialized. This was not in our KB because it predates our
  monitoring start (~April 1, 2026). A one-time retrospective scan of Q1 2026 (Jan–Mar) threats
  should be performed to identify any other foundational incidents we missed. The Shai-Hulud
  worm, Clinejection, and the Cline attack all form a clear evolutionary chain — missing the
  first link means missing the pattern context. Consider adding a "Historical context" section
  to the KB or running Prompt A in retrospective mode for Q1 2026.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-17] [COVERAGE] Track Linux kernel LPE clusters as campaign-level threats
- **Origin:** Prompt A
- **Description:** Three Linux kernel LPEs dropped in two weeks (Copy Fail, Dirty Frag,
  Fragnesia). This is a known pattern: when a page-cache corruption primitive is published,
  security researchers find sibling variants in related subsystems within days. The current
  KB tracks each LPE as a separate THREAT ID with no cross-linkage. We should add a
  "Related vulnerabilities" or "LPE cluster" field to kernel CVE entries so that when Copy Fail
  was added, the KB would flag "watch for variants in related crypto/networking subsystems."
  Prompt A's search terms should also explicitly include "Linux kernel LPE variant" and the
  names of related kernel subsystems (XFRM, RxRPC, AF_ALG) when a kernel LPE drops.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-17] [PROMPT] Add "open-sourced malware / BreachForums contests" to Threat Actor area
- **Origin:** Prompt A
- **Description:** The Shai-Hulud open-source release + BreachForums contest is a new attack
  democratization pattern that the Radar prompt's Threat Actor area doesn't explicitly search
  for. The prompt asks about "campaigns" and "activities" but not about malware being
  open-sourced or crowdsourced. A search for "malware open source GitHub" or "supply chain
  contest BreachForums" would have surfaced this a day earlier. Recommend adding "open-sourced
  malware / threat actor contest" as an explicit search sub-bullet in Area 4.
- **Impact:** High
- **Effort:** Low

### [2026-05-17] [CHECK] Add "AI triage bot scope" to Prompt B workflow audit
- **Origin:** Prompt A
- **Description:** The Clinejection attack (THREAT-2026-0027) shows that AI triage bots reading
  untrusted input (GitHub issue titles, PR descriptions) in workflows that share cache scope
  with publish workflows are a concrete supply chain risk. Prompt B should add a check: do any
  GitHub Actions workflows that read untrusted external input (issues, PRs, comments) share
  cache scope or secrets with release/publish workflows? This is distinct from the existing
  SHA-pinning check and TrustFall check, and applies to any repo using AI automation in CI/CD.
- **Impact:** High
- **Effort:** Low

### [2026-05-20] [COVERAGE] Add Claude Code hooks and VS Code tasks as explicit daily audit targets
- **Origin:** Prompt A
- **Description:** TeamPCP Phase 7 (THREAT-2026-0028) established that ~/.claude/settings.json
  hooks and VS Code tasks are now active malware persistence targets. The Radar prompt's Area 2
  (AI/Vibe Coding) doesn't explicitly mention checking local AI tool configuration files for
  tampering as a daily hygiene item. The prompt should add: "Check for unexpected modifications
  to ~/.claude/settings.json (hooks section) and .vscode/tasks.json — these are now confirmed
  malware persistence vectors that survive package removal." This should also be added as a
  machine hygiene check separate from the repo-level TrustFall check.
- **Impact:** High
- **Effort:** Low

### [2026-05-20] [COVERAGE] Track "Pwn Request proliferation" as a separate threat category
- **Origin:** Prompt A
- **Description:** Both TeamPCP and CoinbaseCartel used the pull_request_target "Pwn Request"
  technique this week (Grafana Labs breach via CoinbaseCartel is the clearest example). The
  Radar prompt currently searches for "GitHub Actions marketplace compromises" but not
  specifically for the pull_request_target misconfiguration pattern. This pattern is now being
  exploited by at least two independent threat actor families. Recommend adding
  "pull_request_target Pwn Request" and "GitHub Actions external fork secrets" as explicit
  daily search terms in Area 1 (Supply Chain). Also consider adding a standing weekly check:
  any new pull_request_target exploit disclosures or CVEs.
- **Impact:** High
- **Effort:** Low

### [2026-05-20] [PROMPT] Add "threat actor Google TI / MITRE designation updates" to Area 4
- **Origin:** Prompt A
- **Description:** TeamPCP was formally designated UNC6780 by Google Threat Intelligence Group
  this week. This kind of formal designation is a signal that a threat actor has crossed a
  threshold of attribution confidence, which changes how organizations should respond (e.g.,
  more likely to receive government advisories, more likely to be tracked by IR vendors). The
  Radar's Area 4 (Threat Actors) searches for activity but not for new formal designations
  or attribution changes. Adding "threat actor designation OR attribution OR UNC OR APT
  [current month]" as a search term would catch these signals earlier.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-20] [CHECK] Add "check VS Code extension list" to Prompt B baseline hygiene
- **Origin:** Prompt A
- **Description:** The GitHub internal breach (THREAT-2026-0029) used a malicious VS Code
  extension as its entry vector. This is the second time a VS Code extension has been the
  attack vector in a major incident (after CVE-2026-21518). Prompt B's audit checklist should
  add: for every project being audited, review the list of VS Code extensions used by
  contributors — flag any with low download counts, recent publication dates, or unusual
  permissions (filesystem access, network access). A simple `code --list-extensions` combined
  with a lookup against the Open VSX or Marketplace abuse database would surface this.
- **Impact:** High
- **Effort:** Low

### [2026-05-20] [KB] Add "macOS app update deadlines" field to supply chain threats affecting end-user software
- **Origin:** Prompt A
- **Description:** The OpenAI certificate revocation deadline (June 12, 2026) is a time-bounded
  action that could break macOS apps for team members. The KB currently has no field for
  "deadline" or "user action expiry" on supply chain threats. Adding a "Deadline" field to
  relevant KB entries (especially where certificate revocations, forced updates, or CISA
  deadlines are involved) would make these time-sensitive actions more visible. The existing
  THREAT-2026-0014 (CISA Copy Fail deadline May 15) already passed unnoticed in the KB status.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-21] [COVERAGE] Add VS Code Marketplace as a daily monitoring source
- **Origin:** Prompt A
- **Description:** The Nx Console v18.95.0 supply chain attack (THREAT-2026-0029) — which
  caused the GitHub internal breach — was live for only ~11 minutes on the Marketplace.
  The Radar prompt's Area 2 (AI/Vibe Coding) and Area 1 (Supply Chain) both cover supply
  chain attacks but don't explicitly include the VS Code Marketplace as a daily search
  target. Given that the Marketplace has now been used as an attack vector in two
  major incidents (CVE-2026-21518 mcp.json and Nx Console), it should be an explicit
  daily search area: "VS Code Marketplace compromised extension [current date]".
  Tools like Open VSX or the Extension Marketplace abuse tracker could be integrated.
- **Impact:** High
- **Effort:** Low

### [2026-05-21] [KB] Add "Asking price / threat actor monetization" field to breach entries
- **Origin:** Prompt A
- **Description:** TeamPCP is selling the GitHub breach data for $95,000+. CoinbaseCartel
  demanded ransom from Grafana. These monetization signals are useful for threat
  prioritization (a threat actor actively selling data is more likely to dump it or use
  it for follow-on attacks than one who exfiltrated silently). The KB currently has no
  field for this. Adding an optional "Monetization" or "Threat actor asking price" field
  to Breach-category entries would allow faster escalation decisions when stolen data
  is actively for sale vs. silently held.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-21] [PROMPT] Add ClickFix / clipboard injection as explicit daily search in AI Dev area
- **Origin:** Prompt A
- **Description:** The BlueNoroff ClickFix campaign (THREAT-2026-0035) uses clipboard
  injection as its primary social engineering vector — the "paste this to fix it" trick.
  This technique is increasingly common and is now being used by multiple threat actor
  families (not just North Korea). The Radar prompt's Area 2 (AI/Vibe Coding) covers
  prompt injection but not ClickFix / clipboard injection targeting developers. Adding
  "ClickFix clipboard injection developer" as an explicit daily search term in Area 4
  (Threat Actors) or Area 2 would catch these campaigns earlier.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-21] [COVERAGE] Track "stolen source code → new CVEs" as a distinct post-breach risk
- **Origin:** Prompt A
- **Description:** The GitHub internal breach creates a unique follow-on risk: TeamPCP
  now has ~3,800 internal GitHub repositories that may contain vulnerability information,
  internal security research, and implementation details that could enable new
  platform-level zero-days. This "stolen source code → new CVEs" post-breach risk
  pattern exists for any major platform breach (GitHub, GitLab, etc.) but the Radar
  currently has no standing search to monitor for CVEs or disclosures that cite stolen
  source code as their discovery vector. Recommend adding a weekly check: are any new
  GitHub CVEs being attributed to knowledge derived from the May 2026 breach?
- **Impact:** High
- **Effort:** Low

### [2026-05-20] [COVERAGE] Track extortion-focused threat actors (CoinbaseCartel, LAPSUS$ offshoots) separately
- **Origin:** Prompt A
- **Description:** CoinbaseCartel (THREAT-2026-0030) represents a distinct threat actor class:
  data-theft extortion gangs targeting developer infrastructure (GitHub codebase theft,
  ransom demand). These actors don't deploy ransomware but steal code and threaten public
  disclosure. The KB currently tracks ransomware groups and supply chain actors but has no
  standing entry for CoinbaseCartel / ShinyHunters / Scattered Spider ecosystem activity.
  Given their increasing focus on dev tooling (Grafana this week), recommend adding a KB entry
  for this actor cluster and monitoring their BreachForums DLS for new developer-targeted
  victims weekly.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-16] [CHECK] Add "AI tool privileged/autonomous mode audit" to Prompt B
- **Origin:** Prompt A
- **Description:** ClaudeBleed and TrustFall both show that "Act without asking" / autonomous
  mode in AI tools removes the last human approval layer and dramatically widens the attack
  surface. Prompt B should add an explicit check: for each project, are any AI tools configured
  with autonomous/privileged mode enabled? This includes Claude extension settings, Cursor
  agent mode, and any MCP server configs with auto-approve flags. Should be a Prompt B
  security hygiene question.
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
