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
- **Status:** 🔴 Escalating — Phase 6 + ecosystem fragmentation; PCPJack rival worm now active; copycat attacks ongoing
- **Category:** Threat Actor > Supply Chain
- **Affects us:** Potentially (GitHub Actions, npm, PyPI in our stack)
- **Summary:** Month-long cascading campaign crossing 5 ecosystems: GitHub
  Actions, Docker Hub, npm, OpenVSX, PyPI. Started from single incompletely-
  rotated GitHub PAT. Compromised: Trivy (GitHub Actions + Docker Hub images
  v0.69.5/v0.69.6/latest), Checkmarx AST (GitHub Actions), LiteLLM (PyPI),
  Telnyx (PyPI), 66+ npm packages, 2 VS Code extensions. European Commission
  breached via Trivy (340GB stolen). Now partnering with Vect ransomware group.
  Assigned CVE-2026-33634 (CVSS 9.4). **Phase 4 (April 22):** Bitwarden CLI npm
  compromise (see THREAT-2026-0016). **Phase 5 (May 9–11):** (a) Checkmarx Jenkins
  AST Plugin compromised May 9–10 using credentials stolen in March Trivy breach;
  (b) Mini Shai-Hulud worm May 11 — 172 packages, 403 malicious versions, first-ever
  SLSA provenance bypass, now CVE-2026-45321 (CVSS 9.6) (see THREAT-2026-0012).
  Phase 5 malware includes geofenced destructive payload — 1-in-6 chance of
  `rm -rf /` (not just `~/`) when infected system appears to be in Israel or Iran.
  **Phase 6 (May 12):** TeamPCP published full Shai-Hulud source code to GitHub
  and launched $1,000 XMR BreachForums contest ("biggest supply chain attack").
  Full TypeScript/Bun attack framework now publicly available — dramatically lowering
  the barrier for copycat attacks. See THREAT-2026-0023 for Phase 6 details.
  Most sustained and technically sophisticated open-source supply chain campaign
  on record; now also the most democratized.
- **Affected tools:** Trivy, Checkmarx AST (GH Actions), Checkmarx Jenkins AST plugin
  v2026.5.09, LiteLLM (PyPI), Telnyx (PyPI), 66+ npm packages, @bitwarden/cli,
  @tanstack/* (84 packages), @mistralai/mistralai, guardrails-ai, UiPath packages
- **IOCs:** models.litellm[.]cloud; gh-token-monitor daemon (THREAT-2026-0012); public
  GitHub repos created under victim accounts for credential exfiltration
- **Action taken:** Audit GitHub Actions for SHA pinning; verify no use of compromised tools;
  rotate CI/CD credentials if any pipeline ran May 9–11; update Checkmarx Jenkins plugin
- **Last updated:** 2026-05-19
- **Sources:** [Unit42](https://unit42.paloaltonetworks.com/teampcp-supply-chain-attacks/), [Sysdig](https://www.sysdig.com/blog/teampcp-expands-supply-chain-compromise-spreads-from-trivy-to-checkmarx-github-actions), [GitGuardian](https://blog.gitguardian.com/trivys-march-supply-chain-attack-shows-where-secret-exposure-hurts-most/), [StepSecurity](https://www.stepsecurity.io/blog/mini-shai-hulud-is-back-a-self-spreading-supply-chain-attack-hits-the-npm-ecosystem), [SecurityWeek Phase 6](https://www.securityweek.com/teampcp-ups-the-game-releases-shai-hulud-worms-source-code/)

### [THREAT-2026-0005] MCP security crisis — 50+ CVEs in 5 months
- **Date detected:** 2026-04-03
- **Status:** 🔴 Escalating — Vendor refusal to patch emerging as new pattern
- **Category:** AI Dev > MCP
- **Affects us:** Yes (we use MCP servers)
- **Summary:** CVE count now exceeds 50 since January. Key CVEs: CVE-2026-32211 (Azure MCP
  Server, CVSS 9.1), CVE-2026-5322 (mcp-data-vis SQL injection), CVE-2026-21518 (VS Code
  mcp.json RCE — patched), CVE-2026-5323 (a11y-mcp SSRF — fixed), CVE-2026-33032 (nginx-ui
  MCP endpoint, CVSS 9.8, unauthenticated full takeover). OX Security disclosed a systemic
  architectural flaw (April 2026): all official Anthropic MCP SDKs (Python, TypeScript, Java,
  Rust) expose STDIO in a way that permits arbitrary OS command execution without sandboxing.
  Estimated 200K vulnerable instances; 7,000+ publicly accessible servers. **May 2026 update:**
  Three new database-tier MCP server flaws: (1) Apache Doris MCP — unintended SQL execution;
  (2) Alibaba RDS MCP — sensitive metadata exfiltration (Alibaba DECLINED to patch); (3) Apache
  Pinot MCP — potential full takeover of internet-exposed instances. Also: CVE-2026-20205
  (Splunk MCP Server < 1.0.3) exposes session and authorization tokens in cleartext logs.
  Adversa AI published "Top MCP Security Resources — May 2026" tracking digest.
  **May 19 2026 update:** CVE-2026-26118 (Azure MCP Server SSRF, CVSS 8.8) not previously
  logged. Distinct from CVE-2026-32211. Allows low-privileged attacker to exfiltrate Azure
  managed identity tokens via SSRF to the Azure metadata service (169.254.169.254). Patched
  in March 2026 Patch Tuesday. Total known MCP CVEs now exceeds 52.
- **Action taken:** Review all connected MCP servers; rotate tokens; update VS Code; avoid
  running public MCP servers without explicit sandboxing; upgrade Splunk MCP Server to ≥1.0.3;
  verify Azure MCP Server has March 2026 Patch Tuesday applied (CVE-2026-26118)
- **Last updated:** 2026-05-19
- **Sources:** [Dark Reading](https://www.darkreading.com/application-security/microsoft-anthropic-mcp-servers-risk-takeovers), [OX Security](https://www.ox.security/blog/the-mother-of-all-ai-supply-chains-critical-systemic-vulnerability-at-the-core-of-the-mcp/), [The Register](https://www.theregister.com/2026/04/16/anthropic_mcp_design_flaw/), [vulnerablemcp.info](https://vulnerablemcp.info/)

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
- **Status:** ⚪ Resolved — CISA deadline (April 15) has passed; verify Chrome auto-updates
- **Category:** CVE > Browser
- **Affects us:** General (all Chrome users)
- **Summary:** Critical use-after-free in Chrome Dawn WebGPU. Added to CISA
  KEV on April 1. Active exploitation. Sandbox escape possible.
  Remediation deadline: April 15 (passed).
- **Action taken:** Ensure Chrome auto-updates on all dev machines; status updated to resolved
- **Last updated:** 2026-05-13
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

### [THREAT-2026-0012] Mini Shai-Hulud — npm/PyPI self-propagating supply chain worm (TeamPCP Phase 5)
- **Date detected:** 2026-05-13 (attack occurred 2026-05-11)
- **Status:** 🔴 Active — CVE-2026-45321 (CVSS 9.6) assigned; worm source code now PUBLIC; copycat attacks imminent
- **Category:** Supply Chain > npm/PyPI
- **Affects us:** Potentially (ecosystem-level threat; verify @tanstack usage)
- **Summary:** On May 11, 2026, TeamPCP's "Mini Shai-Hulud" worm exploited a chained GitHub
  Actions attack (pull_request_target + cache poisoning + OIDC token memory extraction from
  `/proc/<pid>/mem`) to publish 403 malicious versions across 172 npm and PyPI packages —
  including @tanstack/react-router (12M weekly downloads/week), @mistralai/mistralai, UiPath
  packages, and guardrails-ai. Historic milestone: first documented supply chain worm to carry
  VALID SLSA Sigstore provenance, defeating this integrity control. Malware steals GitHub/npm/
  SSH/cloud credentials and installs a persistent `gh-token-monitor` daemon that runs
  `rm -rf ~/` if the stolen token is later revoked. True worm: after stealing credentials,
  enumerates and infects all other packages the victim maintainer controls. **May 2026 update:**
  CVE-2026-45321 formally assigned (CVSS 9.6). Geofenced destructive payload confirmed: 1-in-6
  probability of running `rm -rf /` (full filesystem) when infected system appears to be in
  Israel or Iran — TeamPCP's first use of geofenced destructive logic. NHS England Digital
  issued advisory CC-4781. @squawk/* (87 packages) confirmed affected in addition to previously
  known namespaces.
- **Affected versions:** @tanstack/* versions published 19:20–19:26 UTC on May 11, 2026;
  @mistralai/mistralai, guardrails-ai, UiPath packages, @squawk/* in same window
- **Safe version:** Any @tanstack/* version NOT published in that 6-minute window
- **IOCs:** gh-token-monitor daemon (macOS LaunchAgent / Linux systemd); public GitHub repos
  created under victim accounts for credential exfiltration
- **Action taken:** Run `npm audit` and verify @tanstack versions across all projects; check for gh-token-monitor process/service
- **Last updated:** 2026-05-19
- **Notes (May 19):** opensearch-project/opensearch-js (1.3M weekly npm downloads) confirmed
  additionally compromised in May 11 wave. OpenAI two employee devices + code-signing certs
  compromised as downstream victims (see THREAT-2026-0030). Total cumulative downloads across
  affected packages: 518M+. Malicious versions removed from registries; cleanup confirmed.
- **Sources:** [Wiz Blog](https://www.wiz.io/blog/mini-shai-hulud-strikes-again-tanstack-more-npm-packages-compromised), [The Hacker News](https://thehackernews.com/2026/05/mini-shai-hulud-worm-compromises.html), [StepSecurity](https://www.stepsecurity.io/blog/mini-shai-hulud-is-back-a-self-spreading-supply-chain-attack-hits-the-npm-ecosystem), [Aikido](https://www.aikido.dev/blog/mini-shai-hulud-is-back-tanstack-compromised), [Socket.dev](https://socket.dev/blog/tanstack-npm-packages-compromised-mini-shai-hulud-supply-chain-attack)

### [THREAT-2026-0013] TrustFall — one-click RCE via MCP trust prompt in Claude Code, Cursor, Gemini CLI, Copilot
- **Date detected:** 2026-05-13 (disclosed 2026-05-07)
- **Status:** 🔴 Active — No CVE; no vendor patch; Anthropic and others declined to fix
- **Category:** AI Dev > Claude Code / MCP
- **Affects us:** Yes (we use Claude Code daily)
- **Summary:** Disclosed May 7, 2026 by Adversa AI. Any cloned repository can embed
  `.mcp.json` + `.claude/settings.json` with `enableAllProjectMcpServers=true` pointing to
  an attacker-controlled MCP server. When the user presses Enter on Claude Code's folder trust
  dialog, all project-defined MCP servers auto-spawn as unsandboxed OS processes with the
  developer's full user privileges. Claude Code v2.1+ removed the prior explicit warning about
  MCP servers in cloned repos. Anthropic reviewed and declined to patch, considering folder
  trust as consent to all project MCP definitions. Affects Claude Code, Cursor CLI, Gemini
  CLI, and GitHub Copilot CLI. CVE not yet assigned. **May 2026 update:** Check Point Research
  documented "MCPoison" — a Cursor-specific variant where malicious repositories include
  `.cursor/mcp.json` that spawns attacker-controlled MCP servers when the Cursor workspace
  loads. OX Security published a broader MCP Supply Chain Advisory covering all coding agents.
  Cursor has separately been documented as persistent across workspace sessions.
- **Action taken:** Team warned; pre-flight check procedure established (inspect for .mcp.json,
  .cursor/mcp.json, and .claude/settings.json before accepting any trust prompt in any IDE)
- **Last updated:** 2026-05-16
- **Sources:** [Adversa AI](https://adversa.ai/blog/trustfall-coding-agent-security-flaw-rce-claude-cursor-gemini-cli-copilot/), [Help Net Security](https://www.helpnetsecurity.com/2026/05/07/trustfall-ai-coding-cli-vulnerability-research/), [Dark Reading](https://www.darkreading.com/application-security/trustfall-exposes-claude-code-execution-risk), [The Register](https://www.theregister.com/security/2026/05/07/claude-code-trust-prompt-can-trigger-one-click-rce/5235319)

### [THREAT-2026-0014] CVE-2026-31431 "Copy Fail" — Linux kernel local privilege escalation (CISA KEV)
- **Date detected:** 2026-05-13 (added to CISA KEV 2026-05-01)
- **Status:** 🔴 Post-deadline — CISA deadline May 15 PASSED; active exploitation confirmed; co-active with Dirty Frag + Fragnesia
- **Category:** CVE > Infrastructure
- **Affects us:** Yes (all Linux dev machines, CI/CD runners, servers)
- **Summary:** Logic bug in the Linux kernel's `authencesn` cryptographic template (AF_ALG
  socket family) allows an unprivileged local user to perform a controlled 4-byte write into
  the page cache of any readable file — enabling replacement of in-memory setuid binary code
  and reliable root escalation. A 732-byte Python PoC is publicly available; no races or
  timing windows needed. CVSS 7.8. Affects all Linux distributions running kernels from 2017
  onward. Container breakout and multi-tenant compromise are realistic escalation paths.
  CISA KEV deadline was May 15, 2026 (now passed). Exploitation confirmed against US think
  tanks, European manufacturers, and cloud service providers. CloudLinux published a live-patch
  (kpatch/livepatch) approach for patching without rebooting. IMPORTANT: Current session
  environment is running Linux 6.18.5 — BELOW safe threshold of 6.18.22.
- **Affected versions:** Linux kernels 2017–present (unpatched)
- **Safe version:** Kernel ≥ 6.18.22, ≥ 6.19.12, or ≥ 7.0
- **Action taken:** CISA deadline passed — verify kernel version on all systems NOW; apply live-patch if reboot not possible; note three Linux LPEs now co-active: also patch for Dirty Frag (THREAT-2026-0025) and Fragnesia (THREAT-2026-0026)
- **Last updated:** 2026-05-17
- **Sources:** [Microsoft Security Blog](https://www.microsoft.com/en-us/security/blog/2026/05/01/cve-2026-31431-copy-fail-vulnerability-enables-linux-root-privilege-escalation/), [Unit42](https://unit42.paloaltonetworks.com/cve-2026-31431-copy-fail/), [Ubuntu](https://ubuntu.com/blog/copy-fail-vulnerability-fixes-available), [Tenable](https://www.tenable.com/blog/copy-fail-cve-2026-31431-frequently-asked-questions-about-linux-kernel-privilege-escalation)

### [THREAT-2026-0015] CVE-2026-3854 — GitHub.com/GHES RCE via git push (CVSS 8.7)
- **Date detected:** 2026-05-13 (disclosed 2026-04-28; discovered/patched on github.com 2026-03-04)
- **Status:** 🟡 Resolved on github.com; GHES users must patch manually
- **Category:** CVE > Infrastructure > GitHub
- **Affects us:** Low risk (github.com users are protected; relevant if self-hosting GHES)
- **Summary:** Injection flaw in GitHub's internal git push pipeline — user-supplied push
  options were not sanitized before inclusion in the internal X-Stat header (semicolon
  delimiter). Any authenticated user could execute arbitrary commands on GitHub backend
  servers and read other users' private repositories. CVSS 8.7. Discovered by Wiz Research
  on March 4, 2026; github.com patched within 2 hours with no confirmed exploitation. GHES
  patch requires manual upgrade. Publicly disclosed April 28, 2026.
- **Affected versions:** GitHub Enterprise Server < 3.14.25 / 3.15.20 / 3.16.16 / 3.17.13 /
  3.18.8 / 3.19.4
- **Safe version:** GHES ≥ 3.19.4 (or any of the above patched minor versions)
- **Action taken:** Verify GHES version if self-hosted
- **Last updated:** 2026-05-13
- **Sources:** [Wiz Blog](https://www.wiz.io/blog/github-rce-vulnerability-cve-2026-3854), [The Hacker News](https://thehackernews.com/2026/04/researchers-discover-critical-github.html), [GitHub Blog](https://github.blog/security/securing-the-git-push-pipeline-responding-to-a-critical-remote-code-execution-vulnerability/)

### [THREAT-2026-0017] CVE-2026-26268 — Cursor AI IDE zero-click RCE via hidden Git hooks
- **Date detected:** 2026-05-16
- **Status:** 🔴 Active — Patched in Cursor 2.5; verify all team installs
- **Category:** AI Dev > Cursor IDE / CVE
- **Affects us:** Yes (we use Cursor AI daily)
- **Summary:** CVSS 8.1 flaw in all Cursor IDE versions prior to 2.5. An attacker embeds a
  bare repository with a malicious pre-commit hook inside a legitimate-looking repository.
  The moment Cursor's AI agent performs any Git operation (bootstrap flow is sufficient), the
  hook executes with the developer's full user privileges — no prompt injection, no user click,
  zero interaction required. This is a Git-level exploit (not MCP-level), distinct from
  TrustFall. Sensitive data at risk: access tokens, SSH keys, source code, credentials.
- **Affected versions:** Cursor < 2.5
- **Safe version:** Cursor ≥ 2.5
- **IOCs:** Malicious bare repos with hidden pre-commit hooks embedded in legitimate repos
- **Action taken:** Team must update Cursor to ≥2.5 immediately; do not clone untrusted repos in Cursor until verified
- **Last updated:** 2026-05-16
- **Sources:** [Novee Security](https://novee.security/blog/cursor-ide-cve-2026-26268-git-hook-arbitrary-code-execution/), [CybersecurityNews](https://cybersecuritynews.com/cursor-ai-coding-agent-vulnerability/), [SentinelOne](https://www.sentinelone.com/vulnerability-database/cve-2026-26268/)

### [THREAT-2026-0018] ClaudeBleed — Claude Chrome extension incomplete patch
- **Date detected:** 2026-05-16 (disclosed 2026-04-27; partial patch 2026-05-06)
- **Status:** 🔴 Active — Partial patch released; privileged mode still exploitable
- **Category:** AI Dev > Claude / Browser Extension
- **Affects us:** Yes (team uses Claude Code and Claude browser extension)
- **Summary:** Any Chrome extension — even one with zero declared permissions — can send
  arbitrary prompts to the Claude Chrome extension by exploiting a message handler that trusts
  the claude.ai origin without verifying the sender. Enables: silent exfiltration of Gmail,
  Google Drive, and GitHub data; approve looping (auto-confirming actions); DOM manipulation
  to disguise dangerous actions. Anthropic released v1.0.70 on May 6 adding approval flows,
  but the underlying externally_connectable handler is unfixed. In "Act without asking"
  (privileged) mode, the vulnerability remains fully exploitable even post-patch.
- **Affected versions:** Claude Chrome Extension < 1.0.70 (fully); ≥ 1.0.70 in privileged mode
- **IOCs:** N/A
- **Action taken:** Ensure extension ≥1.0.70; DISABLE "Act without asking" mode on all team machines; audit and remove unnecessary Chrome extensions
- **Last updated:** 2026-05-16
- **Sources:** [LayerX Security](https://layerxsecurity.com/blog/a-flaw-in-claudes-browser-extension-allows-any-extension-to-hijack-it/), [SecurityWeek](https://www.securityweek.com/vulnerability-in-claude-extension-for-chrome-exposes-ai-agent-to-takeover/), [The Hacker News](https://thehackernews.com/2026/03/claude-extension-flaw-enabled-zero.html)

### [THREAT-2026-0019] PyTorch Lightning PyPI supply chain compromise
- **Date detected:** 2026-05-16 (attack occurred 2026-04-30)
- **Status:** 🟠 Contained (malicious versions removed; 42-minute exposure window)
- **Category:** Supply Chain > PyPI / AI/ML
- **Affects us:** Potentially (Python-using ML workloads)
- **Summary:** On April 30, 2026, versions 2.6.2 and 2.6.3 of PyTorch Lightning were published
  to PyPI with malicious Bun-based credential stealers. Attacker obtained PyPI credentials and
  bypassed source control entirely (source code on GitHub was never compromised). Payload runs
  automatically on import — no user interaction beyond installation. Targets: env files, API
  keys, GitHub tokens, browser credentials (Chrome, Firefox, Brave). PyTorch Lightning receives
  millions of downloads/month, making this a high-impact window despite the 42-minute
  containment. Attributed to "Shai-Hulud themed malware" (possible TeamPCP adjacency).
- **Affected versions:** pytorch-lightning 2.6.2, 2.6.3
- **Safe version:** pytorch-lightning ≤ 2.6.1
- **IOCs:** Malicious _runtime/ directory inside package; Bun-based JavaScript payload
- **Action taken:** Verify no 2.6.2/2.6.3 in any environment; rotate credentials if installed
- **Last updated:** 2026-05-16
- **Sources:** [The Hacker News](https://thehackernews.com/2026/04/pytorch-lightning-compromised-in-pypi.html), [Snyk](https://snyk.io/blog/lightning-pypi-compromise-bun-based-credential-stealer/), [Socket.dev](https://socket.dev/blog/lightning-pypi-package-compromised)

### [THREAT-2026-0020] CVE-2026-42897 — Microsoft Exchange XSS/spoofing zero-day (CISA KEV)
- **Date detected:** 2026-05-16 (disclosed 2026-05-14; added to CISA KEV 2026-05-15)
- **Status:** 🔴 Active exploitation — No patch yet; EM Service mitigation available
- **Category:** CVE > Infrastructure > Email
- **Affects us:** Low risk (only if running on-prem Exchange 2016/2019/SE)
- **Summary:** CVSS 8.1 XSS/spoofing vulnerability in Microsoft Exchange OWA. Attacker sends
  a crafted email; if victim opens it in Outlook Web Access, arbitrary JavaScript executes in
  the browser context. Affects Exchange 2016, 2019, and SE; does NOT affect Exchange Online.
  Added to CISA KEV May 15 (no remediation deadline yet). Microsoft confirmed active in-the-wild
  exploitation. No patch released; Microsoft issued Exchange Emergency Mitigation (EM) Service
  mitigation which is enabled by default.
- **Affected versions:** Exchange Server 2016, 2019, Subscription Edition (all current versions)
- **Safe version:** Patch not yet available — apply EM Service mitigation
- **IOCs:** N/A
- **Action taken:** Verify EM Service enabled if using on-prem Exchange; watch for patch
- **Last updated:** 2026-05-16
- **Sources:** [Help Net Security](https://www.helpnetsecurity.com/2026/05/15/exchange-server-cve-2026-42897-exploited/), [SecurityWeek](https://www.securityweek.com/microsoft-warns-of-exchange-server-zero-day-exploited-in-the-wild/), [The Hacker News](https://thehackernews.com/2026/05/on-prem-microsoft-exchange-server-cve.html)

### [THREAT-2026-0021] CVE-2026-20182 — Cisco Catalyst SD-WAN auth bypass (CVSS 10.0)
- **Date detected:** 2026-05-16 (patched 2026-05-15; CISA KEV deadline 2026-05-17)
- **Status:** 🔴 CISA deadline TODAY (May 17) — Patch available; apply NOW; attribution confirmed to UAT-8616
- **Category:** CVE > Infrastructure > Network
- **Affects us:** Low risk (only if using Cisco Catalyst SD-WAN)
- **Summary:** CVSS 10.0 authentication bypass in Cisco Catalyst SD-WAN Controller and Manager.
  Flaw in vdaemon service DTLS peering (UDP 12346): unauthenticated remote attacker can inject
  their SSH key into vmanage-admin and issue arbitrary NETCONF commands for full fabric
  reconfiguration. Exploited by "highly sophisticated cyber threat actor" (nation-state
  language). This is the 6th Cisco SD-WAN zero-day actively exploited in 2026. Patch released
  May 15 alongside disclosure. CISA deadline: May 17, 2026.
- **Affected versions:** Cisco Catalyst SD-WAN Controller and Manager (multiple versions)
- **Safe version:** Apply Cisco Security Advisory cisco-sa-sdwan-rpa2-v69WY2SW
- **IOCs:** N/A
- **Action taken:** CISA deadline TODAY — apply patch cisco-sa-sdwan-rpa2-v69WY2SW; block UDP 12346 at perimeter as interim measure; attribution to UAT-8616 (nation-state) confirmed
- **Last updated:** 2026-05-17
- **Sources:** [Help Net Security](https://www.helpnetsecurity.com/2026/05/15/cisco-sd-wan-zero-day-cve-2026-20182/), [Rapid7](https://www.rapid7.com/blog/post/ve-cve-2026-20182-critical-authentication-bypass-cisco-catalyst-sd-wan-controller-fixed/), [SecurityWeek](https://www.securityweek.com/cisco-patches-another-sd-wan-zero-day-the-sixth-exploited-in-2026/)

### [THREAT-2026-0022] Vercel April 2026 breach — OAuth supply chain, env var exposure
- **Date detected:** 2026-05-16 (incident 2026-04-19; disclosed 2026-04-20)
- **Status:** 🟠 Monitoring — Contained; credential rotation required
- **Category:** Breach > Infrastructure > Cloud Platform
- **Affects us:** Potentially (if any project deploys via Vercel)
- **Summary:** April 19, 2026. Attack chain: Lumma Stealer infected a Context.ai employee
  (Feb 2026) → stolen OAuth tokens accessed Vercel employee's Google Workspace (bypassing MFA
  entirely — OAuth tokens don't require re-auth) → attacker bulk-extracted environment variables
  from Vercel customer projects. Exposure window: February–April 2026. Credentials potentially
  exposed: AWS/Azure/GCP keys, database credentials, GitHub tokens, payment/third-party API
  keys. Vercel initially described exposure as "non-sensitive" variables; security researchers
  dispute scope. Vercel confirmed no npm packages compromised.
- **IOCs:** N/A (Lumma Stealer C2 infrastructure; see threat intel feeds)
- **Action taken:** Rotate ALL Vercel environment variables regardless of sensitivity; review GitHub token scopes; check cloud access logs Feb–April 2026
- **Last updated:** 2026-05-16
- **Sources:** [Vercel KB](https://vercel.com/kb/bulletin/vercel-april-2026-security-incident), [Trend Micro](https://www.trendmicro.com/en_us/research/26/d/vercel-breach-oauth-supply-chain.html), [The Hacker News](https://thehackernews.com/2026/04/vercel-breach-tied-to-context-ai-hack.html)

### [THREAT-2026-0023] TeamPCP Shai-Hulud worm open-sourced; BreachForums contest active
- **Date detected:** 2026-05-17 (open-sourced 2026-05-12; contest announced 2026-05-12)
- **Status:** 🔴 Escalating — Phase 6; worm source code public; copycat attacks expected imminently
- **Category:** Threat Actor > Supply Chain
- **Affects us:** Yes (npm/PyPI ecosystem; we use GitHub Actions)
- **Summary:** On May 12, TeamPCP published the full Shai-Hulud attack framework source code to
  GitHub under compromised accounts — a modular TypeScript/Bun toolkit covering credential
  harvesting, GitHub Actions cache-poisoning, OIDC token extraction from /proc/<pid>/mem, and
  encrypted exfiltration via attacker-controlled public repos. Simultaneously, TeamPCP partnered
  with BreachForums to launch a $1,000 XMR ("biggest supply chain attack") contest explicitly
  encouraging other actors to use the code. This is Phase 6 of the TeamPCP campaign and the
  most significant escalation to date: the attack surface expands from a single sophisticated
  group to any threat actor with basic TypeScript skills. The three-step attack chain (pull_request_target
  + cache poisoning + OIDC memory extraction) is now fully documented and weaponized.
- **IOCs:** GitHub repos published under compromised accounts containing the Shai-Hulud framework
- **Action taken:** Audit all GitHub Actions workflows for the three-step chain; run StepSecurity
  harden-runner; consider blocking external fork PRs from triggering release workflows
- **Last updated:** 2026-05-17
- **Sources:** [SecurityWeek](https://www.securityweek.com/teampcp-ups-the-game-releases-shai-hulud-worms-source-code/), [The Register](https://www.theregister.com/security/2026/05/13/malware-crew-teampcp-open-sources-its-shai-hulud-worm-on-github/5239319), [OX Security](https://www.ox.security/blog/shai-hulud-open-source-malware-github/), [Socket.dev](https://socket.dev/blog/teampcp-supply-chain-attack-contest)

### [THREAT-2026-0024] CVE-2026-44578 — Next.js WebSocket SSRF (CVSS 8.6)
- **Date detected:** 2026-05-17 (published 2026-05-11)
- **Status:** 🟠 Active — Patch available; public exploit scanner live; ~79K exposed hosts
- **Category:** CVE > React/Next.js
- **Affects us:** Potentially (if any project self-hosts Next.js)
- **Summary:** Unauthenticated attacker sends a crafted HTTP request with Upgrade: websocket
  headers and an absolute-form URL. Next.js's WebSocket upgrade handler proxies it to any host
  reachable on port 80, bypassing the routing safety checks enforced on regular HTTP requests.
  Enables access to AWS IMDSv1, GCP metadata, Azure IMDS, internal admin dashboards. Affects
  all self-hosted Next.js 13.4.13+, 14.x, 15.x < 15.5.16, 16.0.0 < 16.2.5. Vercel-hosted
  apps are NOT affected. ~79,000 hosts exposed on Shodan. Public exploit scanner (nextssrf)
  already available on GitHub. Framed as particularly dangerous for vibe-coded apps with
  default self-hosted configs (VibeAudits.com).
- **Affected versions:** Next.js 13.4.13+, 14.x, 15.x < 15.5.16, 16.0.0 < 16.2.5 (self-hosted)
- **Safe version:** Next.js ≥ 15.5.16 or ≥ 16.2.5
- **Action taken:** Run `npm list next` across all projects; upgrade immediately
- **Last updated:** 2026-05-17
- **Sources:** [Hadrian](https://hadrian.io/blog/next-js-websocket-ssrf-unauthenticated-access-to-internal-resources-cve-2026-44578-2), [Tenable](https://www.tenable.com/cve/CVE-2026-44578), [GitLab Advisory](https://advisories.gitlab.com/npm/next/CVE-2026-44578/)

### [THREAT-2026-0025] CVE-2026-43284 / CVE-2026-43500 — "Dirty Frag" Linux kernel LPE chain
- **Date detected:** 2026-05-17 (disclosed 2026-05-08; active exploitation confirmed 2026-05-11)
- **Status:** 🔴 Active exploitation — CVE-2026-43284 patched; CVE-2026-43500 patch pending
- **Category:** CVE > Infrastructure > Linux Kernel
- **Affects us:** Yes (all Linux dev machines, CI/CD runners — same scope as Copy Fail)
- **Summary:** Two-vulnerability chain in the Linux kernel's IPsec ESP subsystem (esp4/esp6,
  CVE-2026-43284, introduced Jan 2017) and RxRPC (CVE-2026-43500, introduced Jun 2023). Both
  use a page-cache write primitive enabling race-free escalation from unprivileged user to root.
  Exploits user/network namespaces (enabled by default) to acquire CAP_NET_ADMIN without host
  privileges. Microsoft Defender confirmed limited in-the-wild exploitation as of May 11, 2026.
  This is the SECOND Linux kernel LPE in two weeks after Copy Fail (CVE-2026-31431). Live-patches
  available from KernelCare and TuxCare. CVE-2026-43500 patch not yet published in NVD.
- **Affected versions:** Linux kernels containing esp4/esp6 (since 2017) and rxrpc (since 2023),
  unpatched as of 2026-05-08. This includes Linux 6.18.5 running in this environment.
- **Safe version:** Kernel with CVE-2026-43284 patch (released 2026-05-08); await CVE-2026-43500
- **IOCs:** Privilege escalation via `su` observed by Microsoft Defender
- **Action taken:** Apply kernel updates; interim: blacklist esp4, esp6, rxrpc modules
- **Last updated:** 2026-05-17
- **Sources:** [Microsoft Security Blog](https://www.microsoft.com/en-us/security/blog/2026/05/08/active-attack-dirty-frag-linux-vulnerability-expands-post-compromise-risk/), [Wiz Blog](https://www.wiz.io/blog/dirty-frag-linux-kernel-local-privilege-escalation-via-esp-and-rxrpc), [Help Net Security](https://www.helpnetsecurity.com/2026/05/08/dirty-frag-linux-vulnerability-cve-2026-43284-cve-2026-43500/), [TuxCare](https://tuxcare.com/blog/dirty-frag-cve-2026-43284-cve-2026-43500-kernelcare-live-patches-released/)

### [THREAT-2026-0026] CVE-2026-46300 — "Fragnesia" Linux kernel LPE (spawned by Dirty Frag patch)
- **Date detected:** 2026-05-17 (disclosed 2026-05-14)
- **Status:** 🟠 Active — PoC public; no confirmed in-the-wild exploitation; patches available
- **Category:** CVE > Infrastructure > Linux Kernel
- **Affects us:** Yes (all Linux systems — same scope as Copy Fail and Dirty Frag)
- **Summary:** The THIRD Linux kernel LPE in two weeks (discovered by William Bowling, V12
  Security). Fragnesia is a variant in the XFRM ESP-in-TCP subsystem introduced by an
  incomplete patch for Dirty Frag. Identical page-cache corruption primitive targets /usr/bin/su:
  attacker overwrites the cached in-memory copy so the next invocation of `su` executes
  attacker-controlled code as root. No race conditions required. Exploit uses user/network
  namespaces (default-enabled). Public PoC available. Patches issued by AlmaLinux, Amazon Linux,
  Debian, Red Hat, SUSE, Ubuntu. CVSS 7.8. Fragnesia may require a SEPARATE kernel update from
  Dirty Frag patches (check distro advisories). Linux 6.18.5 in this environment is affected.
- **Affected versions:** Linux kernels before 2026-05-13 patches (distro-specific)
- **Safe version:** Apply distro CVE-2026-46300 advisory kernel update
- **Action taken:** Apply latest kernel update addressing CVE-2026-46300; same module blacklist
  (esp4, esp6, rxrpc) applies as interim measure
- **Last updated:** 2026-05-17
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/new-fragnesia-linux-kernel-lpe-grants.html), [Help Net Security](https://www.helpnetsecurity.com/2026/05/14/fragnesia-cve-2026-46300-linux-lpe-vulnerability/), [Tenable](https://www.tenable.com/blog/fragnesia-cve-2026-46300-faq-about-new-linux-kernel-xfrm-esp-in-tcp-priv-esc), [BleepingComputer](https://www.bleepingcomputer.com/news/security/new-fragnesia-linux-flaw-lets-attackers-gain-root-privileges/)

### [THREAT-2026-0027] Cline CLI 2.3.0 "Clinejection" — prompt injection → GitHub Actions → npm publish
- **Date detected:** 2026-05-17 (attack occurred 2026-02-17; missed in initial KB setup)
- **Status:** ⚪ Resolved — Historical; establishes canonical AI-agent supply chain attack pattern
- **Category:** Supply Chain > npm > AI Dev Tool
- **Affects us:** Indirectly (attack pattern now replicated by TeamPCP at scale)
- **Summary:** On February 17, 2026, an attacker injected a malicious instruction into a GitHub
  issue title. Cline's AI triage bot read it, interpreted it as an instruction, and used shared
  GitHub Actions cache scope to exfiltrate NPM_RELEASE_TOKEN, VS Code Marketplace, and OpenVSX
  credentials. Published cline@2.3.0 with a postinstall installing openclaw (persistent C2 daemon
  with remote command capability). 4,000 developer machines compromised in 8 hours. This attack
  established the "prompt injection via issue title → GitHub Actions cache poisoning → registry
  publish" pattern that TeamPCP later industrialized in Mini Shai-Hulud. Clean version (2.4.0)
  published same day. Logging as historical context because the pattern is now being replicated.
- **Affected versions:** cline@2.3.0 only
- **IOCs:** openclaw npm package (global install); ~/.openclaw/ credentials directory
- **Action taken:** Confirmed historical; ensure AI bots in repos have read-only scopes and
  cannot trigger release workflows; ensure PR and release workflows have separate cache scopes
- **Last updated:** 2026-05-17
- **Sources:** [Cremit](https://www.cremit.io/blog/ai-supply-chain-attack-clinejection), [Snyk](https://snyk.io/blog/cline-supply-chain-attack-prompt-injection-github-actions/), [The Hacker News](https://thehackernews.com/2026/02/cline-cli-230-supply-chain-attack.html), [GitHub Advisory](https://github.com/cline/cline/security/advisories/GHSA-9ppg-jx86-fqw7)

### [THREAT-2026-0028] Grafana GitHub codebase breach — CoinbaseCartel "Pwn Request"
- **Date detected:** 2026-05-19 (incident 2026-05-16; disclosed 2026-05-16)
- **Status:** 🟠 Contained — codebase stolen; no customer data; extortion refused; same attack vector as Mini Shai-Hulud
- **Category:** Breach > Infrastructure > GitHub / Supply Chain
- **Affects us:** Potentially (identical attack vector — pull_request_target misconfiguration in GitHub Actions)
- **Summary:** On May 16, 2026, CoinbaseCartel (assessed as ShinyHunters/Scattered Spider/LAPSUS$ offshoot, active
  since Sept 2025) exploited a "Pwn Request" misconfiguration in a freshly-enabled Grafana GitHub Action. The
  workflow triggered on pull_request_target events, granting external fork PRs access to production secrets.
  Attacker forked a Grafana repo, injected malicious curl-based env-var exfiltration code, stole a privileged
  GitHub token, downloaded the full codebase from five private repos, then deleted the fork to cover tracks.
  Detected by Grafana's canary token network. Extortion demand refused. No customer data or systems affected.
  CRITICAL CONTEXT: pull_request_target misconfiguration is IDENTICAL to the GitHub Actions attack vector used
  in Mini Shai-Hulud (CVE-2026-45321). Two independent actor groups are actively exploiting this pattern
  simultaneously as of May 2026.
- **IOCs:** CoinbaseCartel extortion communications; canary token trigger as detection method
- **Action taken:** Audit all GitHub Actions for pull_request_target + secrets/write permissions; implement
  canary tokens in all repos
- **Last updated:** 2026-05-19
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/grafana-github-token-breach-led-to.html), [SecurityWeek](https://www.securityweek.com/grafana-confirms-breach-after-hackers-claim-they-stole-data/), [BleepingComputer](https://www.bleepingcomputer.com/news/security/grafana-says-stolen-github-token-let-hackers-steal-codebase/), [The Register](https://www.theregister.com/cyber-crime/2026/05/18/grafana-labs-admits-attackers-downloaded-its-codebase-from-github/5241686)

### [THREAT-2026-0029] PCPJack — cloud worm targeting Anthropic/OpenAI API keys, competing with TeamPCP
- **Date detected:** 2026-05-19 (discovered 2026-04-28 by SentinelLABS; published 2026-05-07)
- **Status:** 🔴 Active — worm-spreading across exposed cloud infrastructure; explicitly targets Anthropic API keys
- **Category:** Threat Actor > Cloud Worm / Credential Theft
- **Affects us:** Yes (explicitly targets Anthropic API keys, Claude integrations, cloud credentials, Slack tokens)
- **Summary:** Discovered April 28, 2026 by SentinelLABS via Kubernetes-focused VirusTotal hunting rule. PCPJack
  is a credential-theft worm that actively removes TeamPCP artifacts from compromised systems before deploying its
  own stealer — suggesting a rival actor or TeamPCP splinter operator with deep familiarity with the original 2025
  TTPs. Exploits 5 CVEs to spread worm-like across exposed cloud infrastructure (Docker, Kubernetes, misconfigured
  cloud management APIs). High-value credential targets: AWS/Azure/GCP keys, SSH keys, Slack tokens, Discord,
  **Anthropic API keys**, OpenAI API keys, database credentials, DigitalOcean tokens, WordPress configs, and
  cryptocurrency wallets. Exfiltrates to attacker-controlled Telegram channels encrypted with X25519 ECDH +
  ChaCha20-Poly1305, split into 2800-byte chunks. Attribution: possibly former TeamPCP operator who left before
  the 2026 high-visibility campaigns.
- **IOCs:** See SentinelOne IOC list; PCPJack persistence artifacts; Telegram channels for C2
- **Action taken:** Audit Anthropic API key usage logs; check cloud infra for unauthorized Docker containers;
  verify no API keys exposed in repo history; see SentinelOne lab report for YARA/detection rules
- **Last updated:** 2026-05-19
- **Sources:** [SentinelOne Labs](https://www.sentinelone.com/labs/cloud-worm-evicts-teampcp-and-steals-credentials-at-scale/), [SecurityWeek](https://www.securityweek.com/pcpjack-worm-removes-teampcp-infections-steals-credentials/), [BleepingComputer](https://www.bleepingcomputer.com/news/security/new-pcpjack-worm-steals-credentials-cleans-teampcp-infections/), [Dark Reading](https://www.darkreading.com/cloud-security/teampcp-malware-pcpjack-steals-cloud-secrets), [The Hacker News](https://thehackernews.com/2026/05/pcpjack-credential-stealer-exploits-5-cves-to-spread-worm-like-across-cloud-systems.html)

### [THREAT-2026-0030] OpenAI Mini Shai-Hulud exposure — code-signing certificates compromised
- **Date detected:** 2026-05-19 (confirmed 2026-05-18; incident 2026-05-11)
- **Status:** 🟡 Contained — certificate rotation underway; macOS users must update before 2026-06-12
- **Category:** Breach > AI Infrastructure / Supply Chain Downstream
- **Affects us:** Low (only if team uses OpenAI macOS desktop apps; establishes precedent for AI vendor cert risk)
- **Summary:** OpenAI confirmed that two employee devices were compromised as downstream victims of the Mini
  Shai-Hulud / TanStack supply chain attack (May 11). Attackers exfiltrated "limited credential material" from
  internal repositories accessible to the affected employees, including code-signing certificates used to validate
  OpenAI macOS desktop applications. OpenAI is rotating those certificates; macOS users must update all OpenAI
  apps before June 12, 2026 (certificates revoked after that date). No customer data, production systems, or
  intellectual property affected. Establishes a supply chain worm → employee dev machine → code-signing cert
  compromise → forced user-side update precedent for the AI tooling ecosystem.
- **Affected versions:** OpenAI macOS apps signed with pre-rotation certificates (all versions before June 12 update)
- **IOCs:** N/A
- **Action taken:** Update OpenAI macOS apps before June 12; monitor for similar cert revocations from other
  AI vendors (Anthropic, Mistral) whose employees may have been affected
- **Last updated:** 2026-05-19
- **Sources:** [OpenAI](https://openai.com/index/our-response-to-the-tanstack-npm-supply-chain-attack/), [The Hacker News](https://thehackernews.com/2026/05/tanstack-supply-chain-attack-hits-two.html), [BleepingComputer](https://www.bleepingcomputer.com/news/security/openai-confirms-security-breach-in-tanstack-supply-chain-attack/)

### [THREAT-2026-0016] Bitwarden CLI npm compromise — TeamPCP "Butlerian Jihad" phase
- **Date detected:** 2026-05-13 (attack occurred 2026-04-22)
- **Status:** 🟡 Contained (clean version 2026.4.1 published by Bitwarden same day)
- **Category:** Supply Chain > npm > Threat Actor
- **Affects us:** Potentially (if @bitwarden/cli used in CI/CD or scripts)
- **Summary:** On April 22, 2026 (17:57–19:30 ET), TeamPCP injected malicious code into
  @bitwarden/cli v2026.4.0 via a compromised GitHub Actions workflow in Bitwarden's CI/CD
  pipeline. Malware (`bw_setup.js` + `bw1.js`) collected npm tokens, GitHub tokens, SSH keys,
  and AWS/Azure/GCP credentials, then exfiltrated by creating public GitHub repos under the
  victim's account (novel exfiltration technique). Bitwarden contained within hours and
  published clean v2026.4.1. This is a separate phase from the March TeamPCP campaign (CVE-
  2026-33634) and precedes the Mini Shai-Hulud worm.
- **Affected versions:** @bitwarden/cli@2026.4.0 only
- **IOCs:** Public GitHub repos created under victim accounts containing AES-256-GCM-encrypted
  credential dumps
- **Action taken:** Verify @bitwarden/cli is not pinned to 2026.4.0; rotate credentials if exposed
- **Last updated:** 2026-05-13
- **Sources:** [BleepingComputer](https://www.bleepingcomputer.com/news/security/bitwarden-cli-npm-package-compromised-to-steal-developer-credentials/), [SOCRadar](https://socradar.io/blog/bitwarden-cli-hijacked-npm-supply-chain-teampcp/), [SecurityWeek](https://www.securityweek.com/bitwarden-npm-package-hit-in-supply-chain-attack/)

---

## Accumulated IOCs

| Date | Threat ID | Type | Indicator | Context |
|------|-----------|------|-----------|----------|
| 2026-04-01 | THREAT-2026-0001 | Domain | sfrclak[.]com | Axios C2 |
| 2026-04-01 | THREAT-2026-0001 | IP | 142.11.206.73 | Axios C2 |
| 2026-03-27 | THREAT-2026-0002 | Domain | models.litellm[.]cloud | TeamPCP/LiteLLM C2 |
| 2026-04-05 | THREAT-2026-0008 | GitHub user | idbzoomh | Claude Code lure malware |
| 2026-05-11 | THREAT-2026-0012 | Process/daemon | gh-token-monitor | Mini Shai-Hulud persistent daemon (macOS LaunchAgent / Linux systemd) |
| 2026-04-22 | THREAT-2026-0016 | npm package | @bitwarden/cli@2026.4.0 | TeamPCP Bitwarden CLI compromise; exfil via victim GitHub repos |
| 2026-04-30 | THREAT-2026-0019 | PyPI package | pytorch-lightning@2.6.2, 2.6.3 | Bun-based credential stealer; 42-min window |
| 2026-05-09 | THREAT-2026-0004 | Jenkins plugin | checkmarx-ast-scanner@2026.5.09 | TeamPCP Phase 5; stolen creds from March Trivy breach |
| 2026-05-11 | THREAT-2026-0012 | Process/daemon | gh-token-monitor | Mini Shai-Hulud persistent daemon (macOS LaunchAgent / Linux systemd); also triggers rm -rf / in Israel/Iran geo |
| 2026-05-11 | THREAT-2026-0012 | CVE | CVE-2026-45321 (CVSS 9.6) | Mini Shai-Hulud — GitHub Actions chain + SLSA provenance bypass |
| 2026-05-12 | THREAT-2026-0023 | GitHub repos | Shai-Hulud source on GitHub (compromised accounts) | TeamPCP open-sourced full attack framework; BreachForums $1K contest active |
| 2026-05-11 | THREAT-2026-0024 | CVE | CVE-2026-44578 (CVSS 8.6) | Next.js WebSocket SSRF; public exploit scanner live |
| 2026-05-08 | THREAT-2026-0025 | CVE | CVE-2026-43284 / CVE-2026-43500 | Dirty Frag Linux kernel LPE; limited in-wild exploitation; module blacklist: esp4 esp6 rxrpc |
| 2026-05-14 | THREAT-2026-0026 | CVE | CVE-2026-46300 (CVSS 7.8) | Fragnesia Linux kernel LPE; PoC public; XFRM ESP-in-TCP subsystem |
| 2026-02-17 | THREAT-2026-0027 | npm package | cline@2.3.0 | Clinejection — prompt injection → GitHub Actions → OpenClaw C2 daemon |
| 2026-05-16 | THREAT-2026-0028 | GitHub Actions misconfiguration | pull_request_target + write/secrets | Grafana "Pwn Request" breach (CoinbaseCartel); identical to Mini Shai-Hulud vector |
| 2026-05-19 | THREAT-2026-0029 | Worm/stealer | PCPJack artifacts (see SentinelOne IOC list) | Cloud worm targeting Anthropic/OpenAI API keys; X25519+ChaCha20 Telegram exfil |
| 2026-05-19 | THREAT-2026-0029 | API key target | Anthropic API keys / OpenAI API keys | PCPJack explicitly harvests these from dev environments |

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
| @tanstack/react-router | npm | Mini Shai-Hulud — 12M weekly downloads; SLSA bypass | 2026-05-13 | Caution — verify version |
| @mistralai/mistralai | npm | Mini Shai-Hulud — official Mistral TypeScript SDK | 2026-05-13 | Caution — verify version |
| guardrails-ai | PyPI | Mini Shai-Hulud — LLM guardrails library | 2026-05-13 | Caution — verify version |
| @bitwarden/cli | npm | TeamPCP Bitwarden compromise (2026-04-22) | 2026-05-13 | Safe if ≠ 2026.4.0 |
| pytorch-lightning | PyPI | Supply chain compromise 2026-04-30 (versions 2.6.2/2.6.3) | 2026-05-16 | Safe if ≤ 2.6.1 |
| checkmarx-ast-scanner | Jenkins Marketplace | TeamPCP Phase 5 compromise (2026-05-09) | 2026-05-16 | Upgrade to ≥ 2.0.13-848 |
| cursor (IDE) | Desktop app | CVE-2026-26268 zero-click RCE via Git hooks | 2026-05-16 | Safe if ≥ 2.5 |
| claude-chrome-extension | Chrome Web Store | ClaudeBleed — incomplete patch; privileged mode vulnerable | 2026-05-16 | Safe if ≥ 1.0.70 AND privileged mode disabled |
| next | npm | CVE-2026-44578 SSRF via WebSocket upgrade handler | 2026-05-17 | Safe if ≥ 15.5.16 or ≥ 16.2.5 (self-hosted only) |
| linux-kernel | System | Dirty Frag (CVE-2026-43284/-43500) + Fragnesia (CVE-2026-46300) LPE cluster | 2026-05-17 | Patch per distro advisory; interim: blacklist esp4 esp6 rxrpc |
| cline | npm | Clinejection (Feb 2026) — prompt injection supply chain attack | 2026-05-17 | Safe if ≠ 2.3.0 (clean version 2.4.0+) |
| opensearch-js | npm | Mini Shai-Hulud May 11 wave — 1.3M weekly downloads | 2026-05-19 | Caution — verify version not from May 11 window |
| GitHub Actions (pull_request_target) | GitHub | Pwn Request pattern — Grafana + TeamPCP both exploiting | 2026-05-19 | Audit all workflows immediately |

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
