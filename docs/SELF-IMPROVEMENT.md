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

### [2026-05-23] [COVERAGE] Ensure GitHub Actions marketplace attacks are caught same-day
- **Origin:** Prompt A
- **Description:** The actions-cool/issues-helper GitHub Action compromise occurred on May 18,
  2026 and was publicly disclosed on May 19, yet it was not captured in the May 20 KB update.
  The Radar prompt's Area 1 does mention "GitHub Actions marketplace compromises" but only as
  a bullet among many. Given that TeamPCP has now attacked the GitHub Actions marketplace
  directly (not just npm/PyPI), this attack surface deserves its own dedicated daily search
  query. Recommend adding "GitHub Actions compromised action tag redirect" and
  "GitHub Action imposter commit" as explicit daily search terms in Area 1, and checking
  StepSecurity's blog directly as a daily source (they were first to disclose this incident).
- **Impact:** High
- **Effort:** Low

### [2026-05-23] [PROMPT] Add StepSecurity blog as a named daily source in Area 1
- **Origin:** Prompt A
- **Description:** StepSecurity was first to detect and disclose both the actions-cool attack
  (May 18) and the Mini Shai-Hulud worm (May 11). They also maintain the harden-runner tool
  and GitHub Actions security monitoring. The Radar prompt does not name them as a source.
  Recommend adding "stepsecurity.io/blog" as an explicit daily check in Area 1 alongside the
  existing source references, similar to how we reference Socket.dev and Wiz.io for npm/PyPI.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-23] [KB] Add "CISA Deadline" field to CVE entries that have KEV deadlines
- **Origin:** Prompt A
- **Description:** Today we have two CISA KEV deadlines (June 3 for Defender, June 4 for
  Langflow/Apex One). The KB entries don't have a dedicated "CISA Deadline" field, which means
  these deadlines are buried in the Action taken text and easy to miss. Adding a top-level
  "CISA Deadline" field to CVE entries would make them visually scannable and easier to
  prioritize. The Copy Fail deadline (May 15) already passed and was only noted in the Status
  field. A dedicated field would prevent future misses.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-24] [COVERAGE] Add PHP/Packagist ecosystem to daily supply chain search scope
- **Origin:** Prompt A
- **Description:** The Laravel-Lang Packagist attack (May 22–23, THREAT-2026-0038) used a novel
  GitHub tag→fork exploit to compromise 700+ PHP package versions with a cross-platform credential
  stealer. The Radar prompt's Area 1 covers npm, PyPI, crates.io, Docker Hub, and GitHub Actions —
  but does NOT explicitly include Packagist (PHP/Composer) or RubyGems. Given that the Mini
  Shai-Hulud technique has now spread to PHP, these registries should be added to the daily search
  scope. Recommend adding "Packagist supply chain attack" and "Composer package compromise" as
  explicit daily search terms alongside the existing npm/PyPI searches.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-24] [PROMPT] Add "GitHub tag-to-fork exploit" as explicit supply chain search term
- **Origin:** Prompt A
- **Description:** The Laravel-Lang attack and the actions-cool attack both used the same technique:
  GitHub allows version tags to point to commits from a fork. This is now a confirmed exploit
  technique used by at least two separate campaigns. The Radar prompt doesn't explicitly search for
  this pattern. Adding "GitHub tag fork redirect supply chain" or "malicious git tag fork" as a
  search term in Area 1 would catch incidents using this vector earlier — it's distinct from
  "hacked maintainer accounts" or "dependency confusion" which are the current supply chain terms.
- **Impact:** High
- **Effort:** Low

### [2026-05-24] [COVERAGE] Add "AI agent prompt injection via issue/PR metadata" to Area 2
- **Origin:** Prompt A
- **Description:** "Comment and Control" (THREAT-2026-0035) was disclosed mid-April 2026 but was
  missed until today's scan — 5+ weeks late. The Radar prompt's Area 2 covers "Prompt injection in
  development contexts" but does not specifically mention GitHub PR/issue metadata as an injection
  vector for CI/CD AI agents. This attack class (untrusted GitHub data flowing into AI agents
  holding secrets) is architecturally different from TrustFall (cloned repo config files) and
  deserves its own explicit search term: "AI agent GitHub comment prompt injection" or
  "CI/CD AI agent credential theft." The 5-week gap confirms this search term is missing.
- **Impact:** High
- **Effort:** Low

### [2026-05-24] [CHECK] Add nginx version check to Prompt B infrastructure audit
- **Origin:** Prompt A
- **Description:** CVE-2026-42945 "NGINX Rift" is a CVSS 9.2 actively exploited vulnerability
  in all nginx versions since 2008. Nginx is ubiquitous in web infrastructure. Prompt B's audit
  checklist doesn't currently include nginx version checking. Given the 18-year exposure window
  and active exploitation, any project audit should include `nginx -v` verification and comparison
  against the safe threshold (≥1.30.1). This should be added to Prompt B's Infrastructure section
  alongside the existing Node.js/Python version checks.
- **Impact:** High
- **Effort:** Low

### [2026-05-23] [COVERAGE] Track extortion-focused threat actors (CoinbaseCartel, LAPSUS$ offshoots) separately
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

### [2026-05-25] [CHECK] Add zero-width Unicode character scan to AI config file pre-flight checklist
- **Origin:** Prompt A
- **Description:** TrapDoor (THREAT-2026-0041) uses hidden zero-width Unicode characters (U+200B, U+200C,
  U+200D, U+FEFF, U+2060) in `.cursorrules` and `CLAUDE.md` files to inject attacker instructions that
  are invisible to human reviewers but parsed and executed by AI coding assistants (Claude Code, Cursor).
  The existing TrustFall pre-flight check (THREAT-2026-0013) only inspects for file existence and suspicious
  URLs. It must be extended with a Unicode character scan:
  `grep -rP '[\x{200b}\x{200c}\x{200d}\x{feff}\x{2060}]' . --include="CLAUDE.md" --include=".cursorrules"`
  This should be added to AGENTS.md as a mandatory pre-flight step and as a git pre-commit hook in the
  .pre-commit-config.yaml template.
- **Impact:** High
- **Effort:** Low

### [2026-05-25] [COVERAGE] Add Crates.io (Rust) to daily supply chain search scope
- **Origin:** Prompt A
- **Description:** TrapDoor (THREAT-2026-0041) included 6 malicious Crates.io packages that abuse `build.rs`
  (executes automatically during Rust compilation) — a dangerous default behavior. The Radar prompt's Area 1
  lists Crates.io but it has never been the subject of an active campaign in our KB until today. Searches for
  Crates.io supply chain attacks should be added as an explicit daily query alongside npm/PyPI, and the
  `build.rs` execution vector should be documented in AGENTS.md as a known risk vector for any Rust project.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-25] [PROMPT] Add "AI agent skills marketplace" to Area 2 (AI/Vibe Coding) search scope
- **Origin:** Prompt A
- **Description:** ToxicSkills (THREAT-2026-0043) found 36% of AI agent skills containing prompt injection
  and 1,467 malicious payloads across ClawHub and skills.sh — a significant threat surface not currently
  covered by the Radar prompt. Area 2 covers AI coding tools and MCP servers but does not mention AI agent
  skill marketplaces (ClawHub, skills.sh, OpenClaw, etc.). These should be added as an explicit daily search
  target: "AI agent skill supply chain attack OR malicious ClawHub skill." The OWASP Agentic Skills Top 10
  launch should also be bookmarked as a standing reference source.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-25] [KB] Add "ISC SANS Update number" field to TeamPCP/UNC6780 entry for easier phase tracking
- **Origin:** Prompt A
- **Description:** ISC SANS now publishes weekly W-series updates AND numbered "Update NNN" reports on the
  TeamPCP campaign. THREAT-2026-0004 captures phase numbers but not the ISC SANS update numbers. This means
  ISC SANS Update 008 (April 27) introduced phases (Checkmarx KICS, xinference, CanisterSprawl) that were
  not in the KB for 28 days. Cross-referencing the ISC SANS update number in the KB status field would
  immediately flag gaps: "Last ISC SANS update incorporated: 007" makes it obvious 008 is missing.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-27] [COVERAGE] Add "mass GitHub repo backdooring via forged CI commits" to Area 1 search scope
- **Origin:** Prompt A
- **Description:** Megalodon (THREAT-2026-0045, May 18) was a fundamentally different attack class from
  package-registry compromise: it targeted GitHub repositories directly with forged automated commits
  injecting malicious CI/CD workflows. This attack hit 5,561 repos in 6 hours and was NOT captured in
  either the May 20 or May 25 KB updates — a 9-day gap. The Radar prompt's Area 1 covers "GitHub Actions
  marketplace compromises" but not "mass forged commit campaigns against individual repos." Recommend adding
  "GitHub malicious workflow commit campaign OR backdoor CI" as an explicit daily search term in Area 1.
  Also add OX Security (ox.security/blog) as a named daily source alongside StepSecurity and Socket.dev.
- **Impact:** High
- **Effort:** Low

### [2026-05-27] [COVERAGE] Add CMS/backend framework CVEs (Drupal, WordPress) to Area 5 search scope
- **Origin:** Prompt A
- **Description:** CVE-2026-9082 (Drupal PostgreSQL SQL injection, CISA KEV) had a federal remediation
  deadline TODAY (May 27) and was not in the KB until this scan. The Radar prompt's Area 5 (CVEs) explicitly
  lists "Node.js, React, Next.js, Python, Three.js, popular web framework, Linux, macOS, Windows" but does
  not mention CMS platforms (Drupal, WordPress, Joomla) or backend frameworks (Laravel, Django, Rails).
  Drupal is widely used in enterprise and government contexts, and appears in CISA KEV frequently. Recommend
  adding "Drupal CVE" and "WordPress CVE actively exploited" as explicit search terms in Area 5.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-29] [COVERAGE] Add AI workflow builders (Flowise, n8n, Langchain server) as explicit Area 2 search targets
- **Origin:** Prompt A
- **Description:** Flowise CVE-2025-59528 (CVSS 10.0, actively exploited, 12K–15K exposed instances) was missed for
  ~6 weeks because the Radar prompt's Area 2 covers "AI coding tools" and "MCP servers" but not "AI workflow builders"
  or "LLM orchestration platforms." Flowise, n8n, LangChain server, Dify, and similar tools are widely deployed in
  developer environments and hold LLM API keys + cloud credentials. They should be explicit daily search targets:
  "Flowise vulnerability", "n8n security CVE", "AI workflow builder exploit" should be added to Area 2.
- **Impact:** High
- **Effort:** Low

### [2026-05-29] [COVERAGE] Add AI coding agent CVEs as an explicit Area 2 search target
- **Origin:** Prompt A
- **Description:** OpenCode CVE-2026-22812/22813 (220K exposed instances, dual RCE) was published January 2026 but
  was not captured until today — a 4+ month gap. "OpenCode" is not named in the Radar prompt's Area 2, which focuses
  on the tools our team specifically uses (Claude Code, Cursor, Antigravity, Copilot, Windsurf). However, AI coding
  agents are proliferating rapidly and developers frequently evaluate/install new ones. Recommend adding "AI coding
  agent CVE site:nvd.nist.gov" and "open source AI coding tool vulnerability" as daily search terms in Area 2 to
  catch CVEs in tools like OpenCode, Aider, Continue.dev, etc. before they proliferate to 220K exposed instances.
- **Impact:** High
- **Effort:** Low

### [2026-05-29] [PROMPT] Add hosting control panel CVEs (cPanel, Plesk, DirectAdmin) to Area 5 search scope
- **Origin:** Prompt A
- **Description:** CVE-2026-41940 (cPanel/WHM CVSS 9.8 auth bypass) was exploited since February 2026, affected
  ~1.5M servers, and was not in the KB until today — approximately 3 months late. The Radar prompt's Area 5 CVE
  list explicitly covers Node.js, React, Next.js, Python, Three.js, popular web frameworks, Linux, macOS, Windows —
  but not hosting control panels. cPanel/WHM is ubiquitous in web hosting environments used by development teams.
  Recommend adding "cPanel CVE" and "Plesk vulnerability" as explicit daily search terms in Area 5.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-30] [COVERAGE] Add Python notebook tools as explicit Area 2/5 search targets
- **Origin:** Prompt A
- **Description:** CVE-2026-39987 (Marimo pre-auth RCE, CVSS 9.3, CISA KEV April 23) was missed for 37 days — exploited in the wild within 10 hours of disclosure. The Radar prompt's Area 2 covers AI coding tools (Claude Code, Cursor, Copilot) and Area 5 covers Python, but neither explicitly includes "Python notebook tools" or "reactive notebook RCE." Marimo, Jupyter, and similar interactive Python environments are widely used by AI/ML developers, bind to local network ports by default, and routinely hold environment variables and cloud credentials. Recommend adding "Marimo CVE", "Jupyter vulnerability", "Python notebook RCE" as explicit daily search terms in Area 2 or Area 5.
- **Impact:** High
- **Effort:** Low

### [2026-05-30] [COVERAGE] Track non-TeamPCP developer-targeting botnets (GlassWorm, similar actors)
- **Origin:** Prompt A
- **Description:** GlassWorm was a separate developer-targeting botnet (Russian attribution, since 2025) that poisoned OpenVSX extensions, npm/PyPI packages, and GitHub repos — entirely distinct from TeamPCP. The Radar prompt's Area 1 searches for supply chain attacks but doesn't explicitly search for developer-targeting botnets or non-TeamPCP supply chain campaigns. GlassWorm used novel C2 channels (Solana blockchain, BitTorrent DHT, Google Calendar) that would not be caught by standard IoC-based detection. Recommend adding "developer botnet" and "developer targeting malware" as explicit search terms in Area 4 (Threat Actors) or Area 1 (Supply Chain). Also: awareness that TeamPCP is not the only developer-targeting threat actor active in 2026.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-30] [COVERAGE] Add AI orchestration frameworks (Semantic Kernel, LangChain, LlamaIndex) to Area 2 search scope
- **Origin:** Prompt A
- **Description:** CVE-2026-26030 (Semantic Kernel CVSS 9.8 eval() RCE) was disclosed May 7 but missed until today (May 30) — a 23-day gap. Semantic Kernel is Microsoft's production AI agent orchestration SDK, directly relevant to teams building AI agents. The Radar prompt's Area 2 covers AI coding tools and MCP servers but not "AI agent orchestration frameworks" like Semantic Kernel, LangChain, LlamaIndex, or Haystack. These frameworks sit in the AI agent execution path, often run with elevated permissions, and are now confirmed exploit targets via their own output channel (LLM-controlled eval()). Recommend adding "Semantic Kernel vulnerability", "LangChain CVE", "AI agent framework RCE" as explicit daily search terms in Area 2.
- **Impact:** High
- **Effort:** Low

### [2026-05-30] [PROMPT] Add "blockchain C2 / living-off-trusted-services C2" to Threat Actor search area
- **Origin:** Prompt A
- **Description:** GlassWorm's use of Solana blockchain, BitTorrent DHT, and Google Calendar as C2 dead-drops is a pattern specifically designed to evade domain/IP-based detection. The Radar prompt's Area 4 searches for threat actor activity but doesn't include detection of adversaries using legitimate services for C2 — a growing pattern also seen with GitHub (TeamPCP exfiltration repos), Google Docs (various APTs), and now the blockchain. Adding "blockchain C2" and "living off trusted services supply chain" as Area 4 search terms would surface these novel evasion techniques.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-30] [KB] Add "days since last KB update" field to CISA KEV threats that have passed deadlines
- **Origin:** Prompt A
- **Description:** THREAT-2026-0046 (Drupal) CISA deadline passed on May 27 (today is May 30 — 3 days overdue). THREAT-2026-0034 (Langflow) deadline is June 4 (5 days). THREAT-2026-0032 (Defender) deadline is June 3 (4 days). The current KB structure makes it hard to quickly identify which deadlines are approaching vs. already passed. Adding a dedicated "Days to deadline / Days overdue" computed field (or at minimum updating Status to include explicit countdown) would make time-sensitive items visually prominent in a quick scan. The THREAT-2026-0046 entry says "CISA deadline TODAY (May 27)" in the detected date section — but after the date passes, this becomes misleading rather than actionable.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-30] [CHECK] Add Gitea/Forgejo container registry to infrastructure audit checklist in Prompt B
- **Origin:** Prompt A
- **Description:** CVE-2026-27771 (Gitea container registry auth bypass, 4-year exposure, 30K instances) affects self-hosted Gitea and Forgejo deployments. Gitea is commonly used by teams running self-hosted code hosting as a GitHub alternative — particularly relevant for teams with on-prem CI/CD. Prompt B currently checks GitHub Actions but not self-hosted code hosting alternatives. A Gitea/Forgejo version check should be added to the infrastructure section of Prompt B.
- **Impact:** Low
- **Effort:** Low

### [2026-05-29] [COVERAGE] Track NSA/CISA government security advisories for AI/ML tooling as a standing check
- **Origin:** Prompt A
- **Description:** The NSA published the first official US government MCP security advisory (U/OO/6030316-26,
  May 20, 2026) — a significant signal that MCP security is now a government-level concern. The Radar prompt
  doesn't include a standing check for government advisories specifically targeting AI development tooling
  (NSA AISC, CISA AI guidance, NCSC AI advisories). These are low-frequency but high-signal events. Recommend
  adding "NSA CISA advisory AI MCP 2026" and "NCSC AI security guidance" as weekly (not daily) checks in Area 7
  (Trends & Tools).
- **Impact:** Medium
- **Effort:** Low

### [2026-05-27] [PROMPT] Add OX Security blog as a named daily source in Area 1
- **Origin:** Prompt A
- **Description:** OX Security was the primary source for Megalodon discovery and published the comprehensive
  MCP Supply Chain Advisory. They were also first to disclose systemic MCP STDIO vulnerabilities affecting
  200K+ servers. The Radar prompt does not name them as a daily source, which contributed to the 9-day gap
  on Megalodon. Recommend adding "ox.security/blog" as an explicit daily check in Area 1 alongside
  stepsecurity.io/blog, socket.dev/blog, and wiz.io/blog.
- **Impact:** High
- **Effort:** Low

### [2026-05-27] [KB] Add "CISA Deadline" as a top-level field to CVE entries with KEV deadlines
- **Origin:** Prompt A
- **Description:** CVE-2026-9082 had a CISA deadline of TODAY (May 27) but was not in the KB — making it
  impossible to track proactively. The previous suggestion ([2026-05-23]) to add a "CISA Deadline" field
  remains unimplemented (still pending). This second occurrence of the same gap in 4 days reinforces that
  this is a high-priority KB structural improvement. The current format buries deadline dates in the
  "Action taken" field, making them invisible in a quick scan. A dedicated "- **CISA Deadline:** YYYY-MM-DD"
  field (used by THREAT-2026-0046 today as a pilot) would make these immediately scannable.
- **Impact:** High
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

### [2026-05-31] [COVERAGE] Add VPN/network access control CVEs to Area 3 (Infrastructure) search scope
- **Origin:** Prompt A
- **Description:** CVE-2026-0257 (Palo Alto GlobalProtect, CVSS 9.1, actively exploited since May 18, CISA KEV May 29)
  was not in the KB until today — a 13-day gap from first exploitation to KB entry. The Radar prompt's Area 3
  (Infrastructure) covers "Vulnerabilities in Vercel, AWS, GitHub, Cloudflare" and "Attacks on DNS, CDNs" but does not
  explicitly mention VPN appliances (Palo Alto, Fortinet, Cisco, Pulse Secure). These are critical network perimeter
  controls used by virtually all development teams for remote access, and they are consistently targeted by nation-state
  actors. Recommend adding "Palo Alto PAN-OS CVE", "Fortinet VPN vulnerability", "Pulse Secure Ivanti exploit" as
  explicit daily search terms in Area 3.
- **Impact:** High
- **Effort:** Low

### [2026-05-31] [COVERAGE] Add SEO poisoning of developer tools as an explicit Area 2 search target
- **Origin:** Prompt A
- **Description:** THREAT-2026-0058 (SEO Poisoning — Fake Gemini CLI & Claude Code installers) was active since March
  2026 but not in the KB until today — a 3-month gap. The Radar prompt's Area 2 covers social engineering via "malicious
  repositories or configuration files" and "AI-generated code as a vector," but does not explicitly search for SEO
  poisoning campaigns targeting AI coding tool installs. This is now a confirmed and ongoing attack class. Recommend
  adding "SEO poisoning AI coding tool installer" and "fake Claude Code download" as explicit daily search terms in
  Area 2. Also consider adding EclecticIQ blog (blog.eclecticiq.com) as a named daily source alongside Socket.dev
  and StepSecurity.
- **Impact:** High
- **Effort:** Low

### [2026-05-31] [COVERAGE] Add ClickFix clipboard injection to Area 4 (Threat Actors) search scope
- **Origin:** Prompt A
- **Description:** BlueNoroff's ClickFix + Deepfake Zoom campaign (THREAT-2026-0059) was disclosed April 27, 2026, but
  was not in our KB until today — a 34-day gap. ClickFix is now a confirmed social engineering vector used by North
  Korean APTs (BlueNoroff), ransomware groups, and other threat actors. The Radar's Area 4 searches for "phishing
  targeting devs" but not specifically for "ClickFix" as an attack technique. Adding "ClickFix attack developer 2026"
  as an explicit daily search term would surface future ClickFix campaigns faster. Also: the deepfake AI pipeline for
  creating fake Zoom meeting participants is a significant new TTP that should be tracked as it proliferates to other
  threat actors.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-31] [KB] Add "Coverage gap discovery date" field to threats added after significant delay
- **Origin:** Prompt A
- **Description:** Today's scan added 4 threats (THREAT-2026-0056 through 0059) that were detected/disclosed between
  March and May 2026 but missed in earlier scans — gaps ranging from 13 days (PAN-OS CVE) to 3 months (SEO poisoning).
  The KB currently has no field distinguishing "first detected date" from "when it was actually publicly disclosed."
  Adding a "Gap discovered" note to threats that were missed would help track the health of our monitoring coverage
  and identify which search terms/sources need to be added. Example: "First public disclosure: 2026-04-27 | Detected:
  2026-05-31 | Gap: 34 days" — this would make coverage gaps measurable over time.
- **Impact:** Medium
- **Effort:** Low

### [2026-05-31] [PROMPT] Add "CISA KEV additions in last 48 hours" as an explicit daily search in Area 5
- **Origin:** Prompt A
- **Description:** CVE-2026-0257 was added to the CISA KEV on May 29 but not captured until today's May 31 scan — a
  2-day lag for a vulnerability with active exploitation. The Radar's Area 5 searches for critical CVEs and mentions
  "CISA KEV catalog" but doesn't explicitly make it the first query of the day. Making "CISA KEV additions last 48 hours
  site:cisa.gov" the very first search in Area 5 would ensure we catch actively-exploited vulnerabilities the day CISA
  confirms them, rather than 2+ days later. CISA's KEV catalog is arguably the highest-signal, highest-precision source
  for prioritizing vulnerabilities.
- **Impact:** High
- **Effort:** Low

### [2026-06-01] [COVERAGE] Add retaliatory/independent researcher zero-day campaigns to Area 4 search scope
- **Origin:** Prompt A
- **Description:** Nightmare-Eclipse (THREAT-2026-0060) is a solo security researcher who has released
  six working Windows zero-day exploits in six weeks and is actively promising more for specific
  dates (June 16 Patch Tuesday, July 14). This is a distinct threat model from nation-state actors
  (TeamPCP, BlueNoroff) and extortion groups (CoinbaseCartel). The Radar prompt's Area 4 searches
  for "campaigns" and "groups" but does not include "independent researcher zero-day dump" or
  "public exploit PoC release" as explicit search vectors. Adding "zero-day researcher github dump
  2026" and "unpatched Windows exploit public release" as daily search terms in Area 4 would catch
  these events faster. The specific date promises (June 16, July 14) should also be flagged as
  calendar-based threat intelligence milestones.
- **Impact:** Medium
- **Effort:** Low

### [2026-06-01] [COVERAGE] Add AI workflow automation platforms (n8n, Zapier, Make) to Area 2 search scope
- **Origin:** Prompt A
- **Description:** CVE-2026-21858 "Ni8mare" (CVSS 10.0, n8n, 100K+ exposed instances) was published
  January 8, 2026 and was not captured in the KB until June 1 — a 5-month gap. The self-improvement
  suggestion from 2026-05-29 recommended adding AI workflow builders, but that suggestion was not
  implemented in time to catch the n8n vulnerability. The pattern is consistent: AI/automation
  workflow platforms (n8n, Flowise, Langflow, Zapier, Make/Integromat) hold LLM API keys, database
  credentials, and cloud tokens — they are high-value targets. n8n had 100,000 exposed instances
  with a CVSS 10.0 vulnerability unpatched for months. Recommend adding "n8n vulnerability",
  "Zapier security CVE", "Make.com exploit" as explicit daily search terms in Area 2 alongside the
  already-added Flowise/Langflow terms.
- **Impact:** High
- **Effort:** Low

### [2026-06-02] [COVERAGE] Add dedicated daily search for malicious AI tooling npm packages by alias/publisher
- **Origin:** Prompt A
- **Description:** codexui-android (THREAT-2026-0064) was active for 6 weeks before discovery — 27K-29K
  weekly downloads silently stealing OpenAI Codex refresh tokens. The exfil code was not in the GitHub repo,
  only in the published npm package — making it invisible to source-based audits. The Radar prompt's Area 1
  covers "compromised packages" in general but doesn't include targeted searches for malicious AI tool
  impostors (fake Codex UI, fake Claude CLI, fake Cursor packages). Recommend adding a daily query:
  "malicious npm package AI tool impostor Codex Cursor Claude 2026" in Area 2 (AI/Vibe Coding). Also:
  the "exfil code not in GitHub repo" pattern should be added to PROMPT-C vetting as a red flag —
  check that the published npm tarball matches the GitHub tag hash via `npm pack --dry-run` comparison.
- **Impact:** High
- **Effort:** Low

### [2026-06-02] [KB] Add calendar-date verification requirement for time-sensitive threat entries
- **Origin:** Prompt A
- **Description:** THREAT-2026-0060 (Nightmare-Eclipse) had "June 16 Patch Tuesday" recorded in its status
  field — but June 16 is NOT a Patch Tuesday in June 2026. The real June Patch Tuesday is June 9. This is a
  consequential error because the researcher promised new exploits timed to Patch Tuesday. The KB entry was
  created May 31 and the error persisted until today's scan (June 2). When recording specific calendar dates
  in threat status fields (especially "Patch Tuesday", "CISA deadline", or "certificate expiration"), the
  radar should verify the date against a calendar before recording it. Consider adding a simple check: for
  any entry that says "Patch Tuesday", verify it is actually the 2nd Tuesday of the stated month.
- **Impact:** Medium
- **Effort:** Low

### [2026-06-02] [COVERAGE] Track Shai-Hulud copycat actors separately from TeamPCP attribution
- **Origin:** Prompt A
- **Description:** The Miasma @redhat-cloud-services attack (THREAT-2026-0063) used Shai-Hulud TTPs but
  attribution is uncertain — TeamPCP open-sourced the full framework in May 2026. This creates a new
  monitoring challenge: any npm supply chain attack using Shai-Hulud-like TTPs may now be a copycat
  rather than TeamPCP directly. The current KB structure groups all Shai-Hulud variants under THREAT-2026-0004
  (TeamPCP). We should distinguish between "confirmed TeamPCP" and "Shai-Hulud-based (attribution uncertain)."
  Recommend adding a "Confirmed TeamPCP" vs "Shai-Hulud-derived (possible copycat)" flag to supply chain
  attack entries — this changes the threat model, since copycat actors may have different targets,
  escalation patterns, and exfiltration infrastructure.
- **Impact:** Medium
- **Effort:** Low

### [2026-06-01] [PROCESS] Add forward-looking "threat calendar" section to daily report
- **Origin:** Prompt A
- **Description:** Today's report identifies three time-bound milestones in the next 30 days:
  June 3 (Defender CISA deadline), June 4 (Langflow CISA deadline), June 12 (OpenAI macOS
  cert revocation), June 16 (Patch Tuesday — Nightmare-Eclipse "big surprise"), June 19
  (PAN-OS CISA deadline), June 26 (Secure Boot cert expiry), July 14 (Nightmare-Eclipse
  "bone-shattering" release). These forward-looking milestones are actionable and time-critical
  but are currently scattered across the report. Adding a small "Upcoming threat calendar"
  section to the daily report format (listing known dates in the next 30 days) would make these
  immediately scannable and easier to track week-over-week. Format example:
  "| 2026-06-03 | Defender CISA deadline | THREAT-2026-0032 |"
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
