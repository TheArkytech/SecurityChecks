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
- **Status:** 🔴 Escalating
- **Category:** Threat Actor > Supply Chain
- **Affects us:** Potentially (GitHub Actions, npm, PyPI in our stack)
- **Summary:** Month-long cascading campaign crossing 5 ecosystems: GitHub
  Actions, Docker Hub, npm, OpenVSX, PyPI. Started from single incompletely-
  rotated GitHub PAT. Compromised: Trivy (GitHub Actions + Docker Hub images
  v0.69.5/v0.69.6/latest), Checkmarx AST (GitHub Actions), LiteLLM (PyPI),
  Telnyx (PyPI), 66+ npm packages, 2 VS Code extensions. European Commission
  breached via Trivy (340GB stolen). Now partnering with Vect ransomware group.
  Assigned CVE-2026-33634 (CVSS 9.4).
  **April 29-30 update ("Mini Shai-Hulud"):** Compromised four SAP npm packages
  (@cap-js/sqlite v2.2.2, @cap-js/postgres v2.2.2, @cap-js/db-service v2.10.1,
  mbt v1.2.48) via preinstall hook loading a Bun runtime payload. Also hit
  PyTorch Lightning (v2.6.2-2.6.3, ~42 min live) and intercom-client. Exfiltration
  novel: stolen secrets written to public GitHub repos created on *victim's own
  account* to bypass egress blocks.
  **PCPJacked:** SentinelOne reports a rival cloud worm evicted TeamPCP from
  compromised hosts and is harvesting the same credentials — supply chain
  attacker-on-attacker activity confirmed.
- **Affected tools:** Trivy (GitHub Actions + Docker Hub), Checkmarx AST
  (GitHub Actions), LiteLLM (PyPI), Telnyx (PyPI), 66+ npm packages,
  @cap-js/sqlite, @cap-js/postgres, @cap-js/db-service, mbt (npm),
  PyTorch Lightning (PyPI), intercom-client (npm)
- **IOCs:** models.litellm[.]cloud (see also THREAT-2026-0002)
- **Action taken:** Audit GitHub Actions for SHA pinning; verify no use of compromised tools
- **Last updated:** 2026-05-11
- **Sources:** [Unit42](https://unit42.paloaltonetworks.com/teampcp-supply-chain-attacks/), [Wiz](https://www.wiz.io/blog/mini-shai-hulud-supply-chain-sap-npm), [The Hacker News](https://thehackernews.com/2026/04/sap-npm-packages-compromised-by-mini.html), [SentinelOne](https://www.sentinelone.com/labs/cloud-worm-evicts-teampcp-and-steals-credentials-at-scale/)

### [THREAT-2026-0005] MCP security crisis — 30+ CVEs in 60 days
- **Date detected:** 2026-04-03
- **Status:** 🔴 Critical (escalated)
- **Category:** AI Dev > MCP
- **Affects us:** Yes (we use MCP servers)
- **Summary:** 30+ CVEs filed against MCP servers/clients in Jan-Feb 2026.
  Key CVEs: CVE-2026-32211 (Azure MCP Server, CVSS 9.1, no patch yet),
  CVE-2026-5322 (mcp-data-vis SQL injection, April 2), CVE-2026-21518
  (VS Code mcp.json RCE — patched), CVE-2026-5323 (a11y-mcp SSRF, fixed
  in 1.0.6). Survey of 2,614 MCP implementations: 82% vulnerable to path
  traversal, 66% have code injection risk.
  **April-May 2026 update:** CVE-2026-7812 (code-mcp git_operation command
  injection) has a public PoC — treat as Priority 1. CVE-2026-35228 (Oracle
  MCP Server Helper unauthenticated SQL injection). A systemic architectural
  flaw in all official Anthropic MCP SDKs now tracked as THREAT-2026-0016.
- **Action taken:** Review all connected MCP servers; rotate tokens; update VS Code;
  audit for CVE-2026-7812 (public PoC available)
- **Last updated:** 2026-05-11
- **Sources:** [Dark Reading](https://www.darkreading.com/application-security/microsoft-anthropic-mcp-servers-risk-takeovers), [Systemtek](https://www.systemtek.co.uk/2026/04/microsoft-visual-studio-code-mcp-json-command-injection-remote-code-execution-vulnerability-cve-2026-21518/), [RedPacket](https://www.redpacketsecurity.com/cve-alert-cve-2026-7812-54yyyu-code-mcp/)

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
- **Status:** 🟡 Informational
- **Category:** CVE > Browser
- **Affects us:** General (all Chrome users)
- **Summary:** Critical use-after-free in Chrome Dawn WebGPU. Added to CISA
  KEV on April 1. Active exploitation. Sandbox escape possible.
  Remediation deadline: April 15.
- **Action taken:** Ensure Chrome auto-updates on all dev machines
- **Last updated:** 2026-04-05
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
- **Status:** 🔴 Active
- **Category:** AI Dev > IDE
- **Affects us:** Yes (we use VS Code + MCP)
- **Summary:** Malicious mcp.json files in repositories can execute arbitrary
  system commands when opened in VS Code. Lack of input validation on user-
  supplied strings. Microsoft has issued a patch.
- **Action taken:** Update VS Code to latest version; audit mcp.json in cloned repos
- **Last updated:** 2026-04-05
- **Sources:** [Systemtek](https://www.systemtek.co.uk/2026/04/microsoft-visual-studio-code-mcp-json-command-injection-remote-code-execution-vulnerability-cve-2026-21518/)

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

### [THREAT-2026-0011] Slopsquatting — AI hallucinated packages weaponized at scale
- **Date detected:** 2026-04-05
- **Status:** 🟠 Escalating
- **Category:** Supply Chain > AI/Vibe Coding
- **Affects us:** Yes (we use AI coding tools)
- **Summary:** Attackers register package names AI models frequently hallucinate.
  Research: ~20% of packages recommended by LLMs are fake. One hallucinated
  npm package (react-codeshift) propagated to 237 repos before being caught.
  Our pre-install dependency guard hook and PROMPT-C vetting mitigate this.
  As of May 2026, Stanford AI Index classifies slopsquatting as a top-3 supply
  chain threat. Attackers now actively monitor LLM outputs and register
  hallucinated names within hours of new model releases. AI coding agents
  (Claude Code, Cursor) are the primary target — not just human developers.
- **Action taken:** Pre-install hook already blocks; ensure team adoption
- **Last updated:** 2026-05-11
- **Sources:** [Aikido](https://www.aikido.dev/blog/slopsquatting-ai-package-hallucination-attacks), [Snyk](https://snyk.io/articles/slopsquatting-mitigation-strategies/), [CSO Online](https://www.csoonline.com/article/4167465/supply-chain-attacks-take-aim-at-your-ai-coding-agents.html)

### [THREAT-2026-0012] TrustFall — one-click RCE in Claude Code, Cursor, Gemini CLI, GitHub Copilot CLI
- **Date detected:** 2026-05-07
- **Status:** 🔴 Active — no vendor patch (Anthropic declined)
- **Category:** AI Dev > Coding Agents
- **Affects us:** Yes (we use Claude Code)
- **Summary:** Disclosed May 7 by Adversa AI. A malicious repository containing
  .mcp.json + .claude/settings.json auto-executes an attacker-controlled MCP
  server when a user accepts the "trust this folder?" prompt. All four tools
  default to "Yes/Trust." In CI/headless mode (Anthropic's official claude-code
  GitHub Action) the trust dialog is skipped entirely — a PR from an external
  contributor triggers RCE with no user interaction, exposing runner credentials.
  Anthropic declined to fix, calling it "by design."
- **Affected tools:** Claude Code (all versions), Cursor CLI, Gemini CLI, Copilot CLI
- **Action taken:** Team notification pending; CI workflow audit required
- **Last updated:** 2026-05-11
- **Sources:** [Adversa AI](https://adversa.ai/blog/trustfall-coding-agent-security-flaw-rce-claude-cursor-gemini-cli-copilot/), [Help Net Security](https://www.helpnetsecurity.com/2026/05/07/trustfall-ai-coding-cli-vulnerability-research/), [The Register](https://www.theregister.com/security/2026/05/07/claude-code-trust-prompt-can-trigger-one-click-rce/5235319), [Dark Reading](https://www.darkreading.com/application-security/trustfall-exposes-claude-code-execution-risk)

### [THREAT-2026-0013] Vercel April 2026 breach — OAuth/Context.ai supply chain
- **Date detected:** 2026-04-19
- **Status:** 🟠 Resolved (Vercel) — residual risk for teams that haven't rotated
- **Category:** Infra > SaaS Platform Breach
- **Affects us:** Potentially (if any project hosted on Vercel)
- **Summary:** Lumma Stealer infected a Context.ai employee (~February 2026),
  stole Google Workspace OAuth tokens. Attacker pivoted via OAuth into a Vercel
  employee account (MFA bypassed — OAuth tokens bypass MFA re-auth), then
  enumerated and decrypted environment variables from a limited subset of
  customer projects. Exposed variables included AWS keys, DB credentials, GitHub
  tokens, and third-party API keys stored without the "sensitive" flag.
  Vercel confirmed no npm packages tampered. A small number of customer accounts
  also compromised. Root cause: AI productivity tool granted overly broad OAuth
  to enterprise Google Workspace.
- **IOCs:** Lumma Stealer (initial malware), Context.ai OAuth tokens (pivot)
- **Action taken:** Rotate all Vercel env var secrets; audit OAuth app permissions
- **Last updated:** 2026-05-11
- **Sources:** [Vercel KB](https://vercel.com/kb/bulletin/vercel-april-2026-security-incident), [Trend Micro](https://www.trendmicro.com/en_us/research/26/d/vercel-breach-oauth-supply-chain.html), [The Hacker News](https://thehackernews.com/2026/04/vercel-breach-tied-to-context-ai-hack.html)

### [THREAT-2026-0014] QLNX / Quasar Linux RAT — developer credential stealer
- **Date detected:** 2026-05-01
- **Status:** 🟠 Monitoring
- **Category:** Threat Actor > Malware
- **Affects us:** Potentially (targets Linux/macOS dev environments)
- **Summary:** New fileless RAT with dual rootkit stealth attributed to the "QLNX"
  threat actor. Specifically targets developer and DevOps workstations to harvest
  credentials used in supply chain attacks. Steals: .npmrc, .pypirc,
  .git-credentials, .aws/credentials, .kube/config, .docker/config.json,
  .vault-token, Terraform credentials, GitHub CLI tokens, and .env files.
  No confirmed npm/PyPI incident attributed solely to QLNX yet, but credential
  theft enables downstream supply chain compromise.
- **Action taken:** Monitor; advise team to rotate publish tokens
- **Last updated:** 2026-05-11
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/quasar-linux-rat-steals-developer.html), [Rankiteo](https://blog.rankiteo.com/pypnpm1778070456-pypi-npm-cyber-attack-may-2026/)

### [THREAT-2026-0015] CVE-2026-31431 — Linux kernel "Copy Fail" privilege escalation (CISA KEV)
- **Date detected:** 2026-05-01
- **Status:** 🔴 Active exploitation — CISA KEV deadline May 15
- **Category:** CVE > Linux Kernel
- **Affects us:** Yes (CI runners, Docker hosts, Kubernetes nodes)
- **Summary:** CVSS 7.8. Logic bug in algif_aead module of the AF_ALG cryptographic
  subsystem. Unprivileged local user can escalate to root using a 732-byte Python
  PoC — no kernel modules, no network access, no root privileges inside containers
  required. Particularly dangerous in containerized CI environments (Docker, K8s).
  Added to CISA KEV May 1; federal mandatory remediation deadline May 15, 2026.
- **Affected versions:** Linux kernel < 6.18.22, < 6.19.12, < 7.0
- **Safe version:** Linux kernel ≥ 6.18.22, 6.19.12, or 7.0
- **Note:** Dev host is on 6.18.5 — VULNERABLE.
- **Action taken:** Patch CI runners; check all Docker/K8s hosts
- **Last updated:** 2026-05-11
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/cisa-adds-actively-exploited-linux-root.html), [CybersecurityNews](https://cybersecuritynews.com/linux-kernel-0-day-vulnerability-exploited/)

### [THREAT-2026-0016] MCP "By Design" STDIO RCE — systemic architectural flaw
- **Date detected:** 2026-04-16
- **Status:** 🔴 Active — Anthropic confirmed "by design"; no protocol fix coming
- **Category:** AI Dev > MCP / Architecture
- **Affects us:** Yes (we use MCP servers)
- **Summary:** OX Security disclosed April 16 that Anthropic's official MCP SDKs
  (Python, TypeScript, Java, Rust) pass user-supplied strings to OS shell via the
  STDIO transport without sanitization. Confirmed "by design" by Anthropic.
  Affects 7,000+ publicly accessible servers and up to 200,000 total vulnerable
  instances representing 150M+ downloads. CVE-2026-30623 (LiteLLM MCP command
  injection) and CVE-2026-7812 (code-mcp git_operation injection, public PoC
  available) are concrete exploits in this class. Distinct from the individual
  CVEs tracked in THREAT-2026-0005 — this is an architectural systemic issue.
- **Action taken:** Audit all MCP servers for unsanitized input handling; run with
  least-privileged OS user
- **Last updated:** 2026-05-11
- **Sources:** [OX Security](https://www.ox.security/blog/the-mother-of-all-ai-supply-chains-critical-systemic-vulnerability-at-the-core-of-the-mcp/), [Computing.co.uk](https://www.computing.co.uk/news/2026/security/flaw-in-anthropic-s-mcp-putting-200k-servers-at-risk), [SecurityWeek](https://www.securityweek.com/by-design-flaw-in-mcp-could-enable-widespread-ai-supply-chain-attacks/)

### [THREAT-2026-0017] 16-Billion Credential Mega-Leak (infostealer aggregation)
- **Date detected:** 2026-05-08
- **Status:** 🟡 Informational
- **Category:** Breach > Credential Leak
- **Affects us:** General (all developer accounts at risk)
- **Summary:** ~16 billion records from multiple infostealer log compilations
  published, covering Google, Apple, Facebook, GitHub, and government portals.
  Largest credential dump on record. Confirmed NOT a single new breach — an
  aggregation of infostealer malware logs spanning recent years. Includes live
  session tokens and authentication cookies, making records immediately exploitable
  beyond just password reuse attacks.
- **Action taken:** Advise team to check HaveIBeenPwned; encourage passkey adoption
- **Last updated:** 2026-05-11
- **Sources:** [Cybernews](https://cybernews.com/security/billions-credentials-exposed-infostealers-data-leak/), [BleepingComputer](https://www.bleepingcomputer.com/news/security/no-the-16-billion-credentials-leak-is-not-a-new-data-breach/)

### [THREAT-2026-0018] BlueNoroff — fileless PowerShell campaign via AI-generated Zoom/Calendly lures
- **Date detected:** 2026-05-01
- **Status:** 🟡 Monitoring (not directly targeting us currently)
- **Category:** Threat Actor > APT / Social Engineering
- **Affects us:** General informational (expanding to developer environments)
- **Summary:** Ongoing since at least January 2026. BlueNoroff delivers
  unsolicited Calendly invites with typosquatted Zoom links. Fake Zoom UI
  exfiltrates victim camera feed while deploying ClickFix-style clipboard
  injection (fileless PowerShell). Primary targets: Web3/crypto founders (45%
  of victims), CEOs, and developers with cloud/wallet access. Same actor as
  axios npm maintainer account compromise (THREAT-2026-0001). Now expanding
  focus to developer environments and cloud infrastructure.
- **Action taken:** Team awareness; verify Zoom/Calendly invites from unknown contacts
- **Last updated:** 2026-05-11
- **Sources:** [Infosecurity Magazine](https://www.infosecurity-magazine.com/news/bluenoroff-dprk-hackers-target/), [CybersecurityNews](https://cybersecuritynews.com/new-bluenoroff-campaign-uses-fileless-powershell/)

---

## Accumulated IOCs

| Date | Threat ID | Type | Indicator | Context |
|------|-----------|------|-----------|----------|
| 2026-04-01 | THREAT-2026-0001 | Domain | sfrclak[.]com | Axios C2 |
| 2026-04-01 | THREAT-2026-0001 | IP | 142.11.206.73 | Axios C2 |
| 2026-03-27 | THREAT-2026-0002 | Domain | models.litellm[.]cloud | TeamPCP/LiteLLM C2 |
| 2026-04-05 | THREAT-2026-0008 | GitHub user | idbzoomh | Claude Code lure malware |
| 2026-04-19 | THREAT-2026-0013 | Malware | Lumma Stealer | Vercel breach initial vector (Context.ai infection) |
| 2026-04-29 | THREAT-2026-0004 | GitHub repo pattern | "A Mini Shai-Hulud has Appeared" | TeamPCP exfil staging repos on victim accounts |

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
| @cap-js/sqlite | npm | Compromised by TeamPCP "Mini Shai-Hulud" (v2.2.2) | 2026-04-29 | Watch — avoid v2.2.2 |
| @cap-js/postgres | npm | Compromised by TeamPCP "Mini Shai-Hulud" (v2.2.2) | 2026-04-29 | Watch — avoid v2.2.2 |
| @cap-js/db-service | npm | Compromised by TeamPCP "Mini Shai-Hulud" (v2.10.1) | 2026-04-29 | Watch — avoid v2.10.1 |
| mbt | npm | Compromised by TeamPCP "Mini Shai-Hulud" (v1.2.48) | 2026-04-29 | Watch — avoid v1.2.48 |
| pytorch-lightning | PyPI | Compromised by TeamPCP (v2.6.2-2.6.3, ~42 min live) | 2026-04-30 | Watch |
| intercom-client | npm | Compromised by TeamPCP April 2026 | 2026-04-30 | Watch |

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
