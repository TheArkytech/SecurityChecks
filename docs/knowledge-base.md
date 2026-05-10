# Security Knowledge Base — 2026

## Index
- Threat Registry
- Accumulated IOCs
- Dependencies Under Surveillance
- Security Decisions
- Audit History (Prompt B)

---

## Threat Registry

<!-- Format per entry: -->
<!-- Each threat has a unique ID for deduplication -->

### [THREAT-2026-0001] Axios npm supply chain compromise
- **Date detected:** 2026-04-01
- **Status:** 🔴 Active
- **Category:** Supply Chain > npm
- **Affects us:** Potentially
- **Summary:** Main maintainer account compromised, versions 1.14.1 and
  0.30.4 published with cross-platform RAT via plain-crypto-js. Attributed
  to UNC1069/Sapphire Sleet (North Korean actor). Malicious versions live
  for ~3 hours. Described as "most operationally sophisticated supply chain
  attack" against a major npm package. Multiple vendor advisories published
  (Google, Microsoft, Unit42, Elastic, CSA Singapore).
- **Affected versions:** axios@1.14.1, axios@0.30.4
- **Safe version:** axios@1.14.0 or earlier
- **IOCs:** sfrclak[.]com, 142.11.206.73
- **Action taken:** Pending verification of whether we use axios in any project
- **Last updated:** 2026-04-05
- **Sources:** [Google Cloud Blog](https://cloud.google.com/blog/topics/threat-intelligence/north-korea-threat-actor-targets-axios-npm-package), [Microsoft Security Blog](https://www.microsoft.com/en-us/security/blog/2026/04/01/mitigating-the-axios-npm-supply-chain-compromise/), [Unit42](https://unit42.paloaltonetworks.com/axios-supply-chain-attack/)

### [THREAT-2026-0002] LiteLLM PyPI supply chain compromise (TeamPCP)
- **Date detected:** 2026-03-27
- **Status:** 🔴 Active
- **Category:** Supply Chain > PyPI
- **Affects us:** Potentially (if using LiteLLM or AI middleware)
- **Summary:** LiteLLM versions 1.82.7 and 1.82.8 compromised with multi-stage
  credential stealer. 40K+ downloads. Exfiltrates SSL/SSH keys, cloud credentials,
  Kubernetes configs, API keys. Attributed to TeamPCP (possible LAPSUS$ link).
  First confirmed victim: Mercor (AI startup, 4TB exfiltrated).
- **Affected versions:** litellm@1.82.7, litellm@1.82.8
- **Safe version:** litellm@1.82.6 or earlier
- **IOCs:** models.litellm[.]cloud
- **Action taken:** Monitor; verify no projects depend on litellm
- **Last updated:** 2026-04-05
- **Sources:** [Sonatype](https://www.sonatype.com/blog/compromised-litellm-pypi-package-delivers-multi-stage-credential-stealer), [Endor Labs](https://www.endorlabs.com/learn/teampcp-isnt-done)

### [THREAT-2026-0003] Claude Code source leak + prompt injection bypass
- **Date detected:** 2026-04-03
- **Status:** 🟠 Monitoring
- **Category:** AI Dev > Claude Code
- **Affects us:** Yes (we use Claude Code)
- **Summary:** On March 31, Anthropic accidentally published sourcemap for
  Claude Code v2.1.88 to npm (512K lines, 1,900 files). Exposed: permission
  systems, tool orchestration, memory architecture, 44 unreleased features,
  internal model codenames. No customer data/API credentials/model weights
  exposed. Researchers found prompt injection bypass: >50 security subcommands
  causes default-allow. CVE-2026-21852 (API key exfiltration via malicious
  settings, CVSS 5.3) was fixed in v2.0.65. Leak now weaponized as social
  engineering lure (see THREAT-2026-0008).
- **Affected versions:** Claude Code < 2.1.89 (prompt injection), < 2.0.65 (CVE-2026-21852)
- **Safe version:** Latest Claude Code release
- **IOCs:** N/A
- **Action taken:** Verify Claude Code is up to date; audit cloned repos for malicious config files
- **Last updated:** 2026-04-05
- **Sources:** [SecurityWeek](https://www.securityweek.com/critical-vulnerability-in-claude-code-emerges-days-after-source-leak/), [Check Point Research](https://research.checkpoint.com/2026/rce-and-api-token-exfiltration-through-claude-code-project-files-cve-2025-59536/)

### [THREAT-2026-0004] TeamPCP multi-ecosystem supply chain campaign
- **Date detected:** 2026-04-03
- **Status:** 🔴 Actively escalating — now 6-ecosystem worm with AI agent infection
- **Category:** Threat Actor > Supply Chain
- **Affects us:** Yes (Claude Code configs now targeted as propagation vector)
- **Summary:** Month-long cascading campaign crossing 6 ecosystems: GitHub
  Actions, Docker Hub, npm, OpenVSX, PyPI, PHP (Packagist). Now formally
  designated UNC6780 by Google TIG (also: PCPcat, ShellForge, DeadCatx3).
  Started from single incompletely-rotated GitHub PAT. Compromised: Trivy
  (GitHub Actions + Docker Hub images v0.69.5/v0.69.6/latest), Checkmarx AST
  (GitHub Actions), LiteLLM (PyPI), Telnyx (PyPI), 66+ npm packages, 2 VS Code
  extensions. European Commission breached via Trivy (340GB stolen). Partnering
  with Vect ransomware group. Assigned CVE-2026-33634 (CVSS 9.4).
  **[2026-04-29/30 UPDATE — "Mini Shai-Hulud" wave]:** New victims:
  SAP CAP npm packages (mbt@1.2.48, @cap-js/db-service@2.10.1,
  @cap-js/postgres@2.2.2, @cap-js/sqlite@2.2.2, ~572K weekly downloads);
  PyTorch Lightning (lightning@2.6.2, 2.6.3, ~700K downloads, malicious for
  42 min); intercom-client@7.0.4 (~10M monthly downloads). Over 1,800
  developers' credentials stolen; 1,200+ GitHub repos infected. NEW TACTIC:
  Payload injects .claude/settings.json (abuses Claude Code SessionStart hook)
  and .vscode/tasks.json (runOn:folderOpen) into every accessible repo as a
  self-propagating worm — first confirmed supply chain attack to weaponize AI
  coding agent configuration files.
- **Affected tools (cumulative):** Trivy, Checkmarx AST/KICS, LiteLLM, Telnyx,
  66+ npm packages, 2 VS Code extensions, mbt, @cap-js/db-service,
  @cap-js/postgres, @cap-js/sqlite, lightning (PyTorch Lightning),
  intercom-client, intercom-php@5.0.2
- **Safe versions:** mbt@1.2.47, @cap-js/db-service@2.10.0,
  @cap-js/postgres@2.2.1, @cap-js/sqlite@2.2.1, lightning@2.6.1,
  intercom-client@7.0.3
- **IOCs:** models.litellm[.]cloud (see also THREAT-2026-0002)
- **Action taken:** Audit GitHub Actions for SHA pinning; verify no use of
  compromised tools; check all repos for unexpected .claude/settings.json commits
- **Last updated:** 2026-05-10
- **Sources:** [Unit42](https://unit42.paloaltonetworks.com/teampcp-supply-chain-attacks/), [StepSecurity](https://www.stepsecurity.io/blog/a-mini-shai-hulud-has-appeared), [Wiz](https://www.wiz.io/blog/mini-shai-hulud-supply-chain-sap-npm), [Semgrep](https://semgrep.dev/blog/2026/malicious-dependency-in-pytorch-lightning-used-for-ai-training/), [The Hacker News](https://thehackernews.com/2026/04/pytorch-lightning-compromised-in-pypi.html)

### [THREAT-2026-0005] MCP security crisis — 30+ CVEs in 60 days
- **Date detected:** 2026-04-03
- **Status:** 🔴 Escalating
- **Category:** AI Dev > MCP
- **Affects us:** Yes (we use MCP servers)
- **Summary:** 30+ CVEs filed against MCP servers/clients in Jan-Feb 2026.
  Key CVEs: CVE-2026-32211 (Azure MCP Server, CVSS 9.1, no patch yet),
  CVE-2026-5322 (mcp-data-vis SQL injection, April 2), CVE-2026-21518
  (VS Code mcp.json RCE — patched), CVE-2026-5323 (a11y-mcp SSRF, fixed
  in 1.0.6). Survey of 2,614 MCP implementations: 82% vulnerable to path
  traversal, 66% have code injection risk.
- **Action taken:** Review all connected MCP servers; rotate tokens; update VS Code
- **Last updated:** 2026-04-05
- **Sources:** [Dark Reading](https://www.darkreading.com/application-security/microsoft-anthropic-mcp-servers-risk-takeovers), [Systemtek](https://www.systemtek.co.uk/2026/04/microsoft-visual-studio-code-mcp-json-command-injection-remote-code-execution-vulnerability-cve-2026-21518/)

### [THREAT-2026-0006] CVE-2026-23864 — React/Next.js DoS via memory exhaustion
- **Date detected:** 2026-04-03
- **Status:** 🟠 Monitoring
- **Category:** CVE > React/Next.js
- **Affects us:** Potentially (if using React Server Components)
- **Summary:** DoS vulnerability (CVSS 7.5) in React Server Components allows
  memory exhaustion via crafted requests. Follows critical RCE pair from
  Dec 2025 (CVE-2025-55182/CVE-2025-66478, CVSS 10.0).
- **Safe version:** Latest React and Next.js
- **Action taken:** Verify patched versions in all projects
- **Last updated:** 2026-04-05
- **Sources:** [Akamai](https://www.akamai.com/blog/security-research/cve-2026-23864-react-nextjs-denial-of-service)

### [THREAT-2026-0007] CVE-2026-5281 — Chrome Dawn WebGPU zero-day (CISA KEV)
- **Date detected:** 2026-04-03
- **Status:** 🟡 Past CISA deadline — verify compliance
- **Category:** CVE > Browser
- **Affects us:** General (all Chrome users)
- **Summary:** Critical use-after-free in Chrome Dawn WebGPU. Added to CISA
  KEV on April 1. Active exploitation. Sandbox escape possible.
  CISA remediation deadline April 15, 2026 has passed.
- **Action taken:** Verify Chrome 134+ on all dev machines (`google-chrome --version`)
- **Last updated:** 2026-05-10
- **Sources:** [CISA](https://www.cisa.gov/news-events/alerts/2026/04/01/cisa-adds-one-known-exploited-vulnerability-catalog)

### [THREAT-2026-0008] Claude Code lure malware — Vidar + GhostSocks via GitHub
- **Date detected:** 2026-04-05
- **Status:** 🔴 Active
- **Category:** AI Dev > Social Engineering
- **Affects us:** Yes (we use Claude Code, team could be targeted)
- **Summary:** Within 24h of Claude Code source leak, attackers created GitHub
  repos impersonating "leaked Claude Code downloads" with trojanized 7z archives.
  Delivers Vidar (infostealer: credentials, credit cards, browser history)
  and GhostSocks (network proxy). Part of broader campaign impersonating 25+
  software brands since February 2026. Repos rank highly in Google search.
- **IOCs:** GitHub user idbzoomh (initial repo), trojanized 7z archives
- **Action taken:** Warn team; only install Claude Code via official channels
- **Last updated:** 2026-04-05
- **Sources:** [The Register](https://www.theregister.com/2026/04/02/trojanized_claude_code_leak_github/), [Trend Micro](https://www.trendmicro.com/en_us/research/26/d/weaponizing-trust-signals-claude-code-lures-and-github-release-payloads.html), [BleepingComputer](https://www.bleepingcomputer.com/news/security/claude-code-leak-used-to-push-infostealer-malware-on-github/)

### [THREAT-2026-0009] CVE-2026-21518 — VS Code mcp.json command injection RCE
- **Date detected:** 2026-04-05
- **Status:** 🔴 Actively exploited in the wild
- **Category:** AI Dev > IDE
- **Affects us:** Yes (we use VS Code + MCP + Claude Code)
- **Summary:** Malicious mcp.json files in repositories can execute arbitrary
  system commands when opened in VS Code. Lack of input validation on user-
  supplied strings. Microsoft has issued a patch. **[2026-05-10 UPDATE]:**
  Mini Shai-Hulud (TeamPCP/UNC6780) confirmed active exploitation in the wild,
  extending the attack pattern to also abuse .claude/settings.json (Claude Code
  SessionStart hook) for persistence and worm propagation. The attack surface
  now spans: mcp.json, .claude/settings.json, .vscode/tasks.json, and
  .cursorrules.
- **Action taken:** Update VS Code to latest version; audit all AI tool config
  files in cloned repos before opening
- **Last updated:** 2026-05-10
- **Sources:** [Systemtek](https://www.systemtek.co.uk/2026/04/microsoft-visual-studio-code-mcp-json-command-injection-remote-code-execution-vulnerability-cve-2026-21518/), [StepSecurity](https://www.stepsecurity.io/blog/a-mini-shai-hulud-has-appeared)

### [THREAT-2026-0010] CVE-2026-35616 — FortiClient EMS zero-day (CVSS 9.1)
- **Date detected:** 2026-04-05
- **Status:** 🔴 Active exploitation
- **Category:** CVE > Infrastructure
- **Affects us:** General informational (relevant if using Fortinet)
- **Summary:** Improper access control in FortiClient EMS 7.4.5-7.4.6.
  Unauthenticated RCE via crafted requests. Active exploitation confirmed
  April 4. Emergency hotfixes available. Fix in upcoming 7.4.7.
- **Action taken:** Check if any infrastructure uses Fortinet; apply hotfix if so
- **Last updated:** 2026-04-05
- **Sources:** [Help Net Security](https://www.helpnetsecurity.com/2026/04/04/forticlient-ems-zero-day-cve-2026-35616/)

### [THREAT-2026-0012] TrustFall — One-click RCE in Claude Code, Cursor, Gemini CLI, Copilot via folder trust dialog
- **Date detected:** 2026-05-07
- **Status:** 🔴 Active (no patch from Anthropic; by design)
- **Category:** AI Dev > AI Coding Agents
- **Affects us:** Yes (we use Claude Code and Cursor daily)
- **Summary:** Disclosed by Adversa AI on May 7, 2026. All four major agentic
  CLIs (Claude Code, Gemini CLI, Cursor CLI, GitHub Copilot CLI) auto-execute
  project-defined MCP servers immediately after the user accepts the folder
  trust dialog, and all four default to "Yes/Trust." A cloned repo containing
  .mcp.json + .claude/settings.json can route execution to an attacker-
  controlled MCP server with a single Enter keypress. Anthropic reviewed and
  declined it as outside their threat model ("trust = full consent"). No CVE
  assigned. Attack is already weaponized in Mini Shai-Hulud (THREAT-2026-0004).
  Related to but distinct from CVE-2026-21518 and CVE-2026-21852.
- **IOCs:** N/A — relies on repo-level config files
- **Action taken:** Warn team; manually inspect .mcp.json and .claude/settings.json
  before accepting any trust dialog in Claude Code or Cursor
- **Last updated:** 2026-05-10
- **Sources:** [Adversa AI](https://adversa.ai/blog/trustfall-coding-agent-security-flaw-rce-claude-cursor-gemini-cli-copilot/), [Help Net Security](https://www.helpnetsecurity.com/2026/05/07/trustfall-ai-coding-cli-vulnerability-research/), [Dark Reading](https://www.darkreading.com/application-security/trustfall-exposes-claude-code-execution-risk)

### [THREAT-2026-0013] CVE-2026-31431 "Copy Fail" — Linux kernel LPE, CISA KEV, all kernels since 2017
- **Date detected:** 2026-04-29
- **Status:** 🔴 Active exploitation, CISA KEV (deadline May 15)
- **Category:** CVE > Infrastructure > Linux
- **Affects us:** Yes (host OS is Linux 6.18.5, below patched 6.18.22)
- **Summary:** 9-year-old logic bug in the Linux kernel's algif_aead module
  (AF_ALG socket interface, authencesn cryptographic template). Allows
  unprivileged local user to perform a controlled 4-byte write into the kernel
  page cache of any readable file via splice() abuse, achieving reliable root
  escalation. CVSS 7.8. A 732-byte Python PoC achieves root on Ubuntu, Amazon
  Linux, RHEL, and SUSE. All kernels from 2017 until patched are affected.
  Introduced during an in-place optimization in 2017. Fixed in 6.18.22, 6.19.12,
  7.0. Added to CISA KEV May 1, 2026. FCEB patch deadline: May 15, 2026.
- **Affected versions:** Linux kernel 4.x – 6.18.21, 6.19.x < 6.19.12
- **Safe version:** Kernel 6.18.22+, 6.19.12+, or 7.0+
- **IOCs:** N/A
- **Action taken:** Verify and patch all Linux servers/CI runners; apply
  algif_aead modprobe blacklist as temporary mitigation (non-RHEL only)
- **Last updated:** 2026-05-10
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/cisa-adds-actively-exploited-linux-root.html), [Xint](https://xint.io/blog/copy-fail-linux-distributions), [Ubuntu](https://ubuntu.com/blog/copy-fail-vulnerability-fixes-available), [CERT-EU](https://cert.europa.eu/publications/security-advisories/2026-005/), [Microsoft](https://www.microsoft.com/en-us/security/blog/2026/05/01/cve-2026-31431-copy-fail-vulnerability-enables-linux-root-privilege-escalation/)

### [THREAT-2026-0014] Vercel breach — OAuth supply chain attack via Context.ai; developer env vars exposed
- **Date detected:** 2026-04-19
- **Status:** 🟠 Monitoring (Vercel contained; downstream impact ongoing)
- **Category:** Infrastructure > Platform
- **Affects us:** Potentially (if any project hosted on Vercel)
- **Summary:** Disclosed April 19-20, 2026. Attack chain: Lumma infostealer
  compromised a Context.ai employee (February 2026) → attacker used stolen
  Context.ai OAuth app credentials to silently access a Vercel employee's
  Google Workspace (OAuth tokens bypass MFA) → lateral movement into Vercel
  internal systems → enumeration of environment variables not marked "sensitive"
  for a limited subset of customers. Stolen data includes API keys, database
  credentials, signing keys, and other secrets stored in plaintext Vercel env
  vars. ShinyHunters claimed responsibility and offered data for sale on
  underground forums. Vercel confirmed and notified affected customers.
- **IOCs:** ShinyHunters group; Lumma infostealer
- **Action taken:** Rotate all non-sensitive-flagged Vercel env vars; audit and
  revoke unnecessary OAuth app integrations for dev accounts
- **Last updated:** 2026-05-10
- **Sources:** [Vercel KB](https://vercel.com/kb/bulletin/vercel-april-2026-security-incident), [Trend Micro](https://www.trendmicro.com/en_us/research/26/d/vercel-breach-oauth-supply-chain.html), [Help Net Security](https://www.helpnetsecurity.com/2026/04/20/vercel-breached/)

### [THREAT-2026-0011] Slopsquatting — AI hallucinated packages weaponized at scale
- **Date detected:** 2026-04-05
- **Status:** 🟠 Monitoring
- **Category:** Supply Chain > AI/Vibe Coding
- **Affects us:** Yes (we use AI coding tools)
- **Summary:** Attackers register package names AI models frequently hallucinate.
  Research: ~20% of packages recommended by LLMs are fake. One hallucinated
  npm package (react-codeshift) propagated to 237 repos before being caught.
  Our pre-install dependency guard hook and PROMPT-C vetting mitigate this.
- **Action taken:** Pre-install hook already blocks; ensure team adoption
- **Last updated:** 2026-04-05
- **Sources:** [Aikido](https://www.aikido.dev/blog/slopsquatting-ai-package-hallucination-attacks), [Snyk](https://snyk.io/articles/slopsquatting-mitigation-strategies/)

---

## Accumulated IOCs

| Date | Threat ID | Type | Indicator | Context |
|------|-----------|------|-----------|---------|
| 2026-04-01 | THREAT-2026-0001 | Domain | sfrclak[.]com | Axios C2 |
| 2026-04-01 | THREAT-2026-0001 | IP | 142.11.206.73 | Axios C2 |
| 2026-03-27 | THREAT-2026-0002 | Domain | models.litellm[.]cloud | TeamPCP/LiteLLM C2 |
| 2026-04-05 | THREAT-2026-0008 | GitHub user | idbzoomh | Claude Code lure malware |
| 2026-04-19 | THREAT-2026-0014 | Malware | Lumma infostealer | Initial vector in Vercel breach via Context.ai |
| 2026-04-19 | THREAT-2026-0014 | Threat group | ShinyHunters | Claimed responsibility for Vercel breach |
| 2026-04-29 | THREAT-2026-0004 | File | .claude/settings.json (injected) | Mini Shai-Hulud worm persistence payload |
| 2026-04-29 | THREAT-2026-0004 | File | .vscode/tasks.json (runOn:folderOpen injected) | Mini Shai-Hulud worm persistence payload |

---

## Dependencies Under Surveillance

<!-- Packages we use or might use that have had issues -->

| Package | Registry | Reason | Since | Status |
|---------|----------|--------|-------|--------|
| axios | npm | Compromised 2026-03-31 | 2026-04-01 | Watch |
| crypto-js | npm | Typosquat target | 2026-04-01 | Caution |
| litellm | PyPI | Compromised 2026-03 (TeamPCP) | 2026-04-03 | Watch |
| telnyx | PyPI | Compromised by TeamPCP | 2026-04-03 | Watch |
| trivy-action | GitHub Actions | Compromised by TeamPCP (CVE-2026-33634) | 2026-04-03 | Watch |
| react-codeshift | npm | Slopsquatting — AI hallucinated name | 2026-04-05 | Caution |
| mbt | npm | Mini Shai-Hulud (TeamPCP) — v1.2.48 compromised | 2026-05-10 | Watch (safe: 1.2.47) |
| @cap-js/db-service | npm | Mini Shai-Hulud (TeamPCP) — v2.10.1 compromised | 2026-05-10 | Watch (safe: 2.10.0) |
| @cap-js/postgres | npm | Mini Shai-Hulud (TeamPCP) — v2.2.2 compromised | 2026-05-10 | Watch (safe: 2.2.1) |
| @cap-js/sqlite | npm | Mini Shai-Hulud (TeamPCP) — v2.2.2 compromised | 2026-05-10 | Watch (safe: 2.2.1) |
| lightning (pytorch-lightning) | PyPI | Mini Shai-Hulud (TeamPCP) — v2.6.2/2.6.3 compromised | 2026-05-10 | Watch (safe: 2.6.1) |
| intercom-client | npm | Mini Shai-Hulud (TeamPCP) — v7.0.4 compromised | 2026-05-10 | Watch (safe: 7.0.3) |

---

## Security Decisions

<!-- Record of what we decided and why -->

| Date | Decision | Context | Decided by |
|------|----------|---------|------------|
| 2026-04-01 | Enable ignore-scripts in .npmrc | Post-axios | Guillermo |
| 2026-04-01 | Implement Security System v2 | Proactive protection | Guillermo |
| 2026-04-03 | Add pre-install dependency guard hook | Automated vetting enforcement | Guillermo |

---

## Audit History (Prompt B)

| Date | Project | Scorecard | Critical findings | Issues created |
|------|---------|-----------|-------------------|----------------|
| | | | | |
