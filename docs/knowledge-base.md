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
- **Status:** 🔴 Escalating — Phase 5 active (May 11, 2026)
- **Category:** Threat Actor > Supply Chain
- **Affects us:** Potentially (GitHub Actions, npm, PyPI in our stack)
- **Summary:** Month-long cascading campaign crossing 5 ecosystems: GitHub
  Actions, Docker Hub, npm, OpenVSX, PyPI. Started from single incompletely-
  rotated GitHub PAT. Compromised: Trivy (GitHub Actions + Docker Hub images
  v0.69.5/v0.69.6/latest), Checkmarx AST (GitHub Actions), LiteLLM (PyPI),
  Telnyx (PyPI), 66+ npm packages, 2 VS Code extensions. European Commission
  breached via Trivy (340GB stolen). Now partnering with Vect ransomware group.
  Assigned CVE-2026-33634 (CVSS 9.4). **Phase 4 (April 22):** Bitwarden CLI npm
  compromise (see THREAT-2026-0016). **Phase 5 (May 11):** Mini Shai-Hulud worm —
  172 packages, 403 malicious versions, first-ever SLSA provenance bypass
  (see THREAT-2026-0012). Most sustained and technically sophisticated open-source
  supply chain campaign on record.
- **Affected tools:** Trivy, Checkmarx AST, LiteLLM (PyPI), Telnyx (PyPI), 66+ npm
  packages, @bitwarden/cli, @tanstack/* (84 packages), @mistralai/mistralai, guardrails-ai
- **IOCs:** models.litellm[.]cloud; gh-token-monitor daemon (THREAT-2026-0012)
- **Action taken:** Audit GitHub Actions for SHA pinning; verify no use of compromised tools;
  rotate CI/CD credentials if any pipeline ran on May 11
- **Last updated:** 2026-05-13
- **Sources:** [Unit42](https://unit42.paloaltonetworks.com/teampcp-supply-chain-attacks/), [Sysdig](https://www.sysdig.com/blog/teampcp-expands-supply-chain-compromise-spreads-from-trivy-to-checkmarx-github-actions), [GitGuardian](https://blog.gitguardian.com/trivys-march-supply-chain-attack-shows-where-secret-exposure-hurts-most/), [StepSecurity](https://www.stepsecurity.io/blog/mini-shai-hulud-is-back-a-self-spreading-supply-chain-attack-hits-the-npm-ecosystem)

### [THREAT-2026-0005] MCP security crisis — 50+ CVEs in 5 months
- **Date detected:** 2026-04-03
- **Status:** 🔴 Escalating — Architectural design risk confirmed
- **Category:** AI Dev > MCP
- **Affects us:** Yes (we use MCP servers)
- **Summary:** CVE count now exceeds 50 since January. Key CVEs: CVE-2026-32211 (Azure MCP
  Server, CVSS 9.1), CVE-2026-5322 (mcp-data-vis SQL injection), CVE-2026-21518 (VS Code
  mcp.json RCE — patched), CVE-2026-5323 (a11y-mcp SSRF — fixed), CVE-2026-33032 (nginx-ui
  MCP endpoint, CVSS 9.8, unauthenticated full takeover). OX Security disclosed a systemic
  architectural flaw (April 2026): all official Anthropic MCP SDKs (Python, TypeScript, Java,
  Rust) expose STDIO in a way that permits arbitrary OS command execution without sandboxing.
  Estimated 200K vulnerable instances; 7,000+ publicly accessible servers. The vulnerablemcp.info
  database now tracks known-vulnerable implementations.
- **Action taken:** Review all connected MCP servers; rotate tokens; update VS Code; avoid
  running public MCP servers without explicit sandboxing
- **Last updated:** 2026-05-13
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
- **Status:** 🔴 Active
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
  enumerates and infects all other packages the victim maintainer controls.
- **Affected versions:** @tanstack/* versions published 19:20–19:26 UTC on May 11, 2026;
  @mistralai/mistralai, guardrails-ai, and UiPath packages in same window
- **Safe version:** Any @tanstack/* version NOT published in that 6-minute window
- **IOCs:** gh-token-monitor daemon (macOS LaunchAgent / Linux systemd); public GitHub repos
  created under victim accounts for credential exfiltration
- **Action taken:** Run `npm audit` and verify @tanstack versions across all projects
- **Last updated:** 2026-05-13
- **Sources:** [Wiz Blog](https://www.wiz.io/blog/mini-shai-hulud-strikes-again-tanstack-more-npm-packages-compromised), [The Hacker News](https://thehackernews.com/2026/05/mini-shai-hulud-worm-compromises.html), [StepSecurity](https://www.stepsecurity.io/blog/mini-shai-hulud-is-back-a-self-spreading-supply-chain-attack-hits-the-npm-ecosystem), [Aikido](https://www.aikido.dev/blog/mini-shai-hulud-is-back-tanstack-compromised), [Socket.dev](https://socket.dev/blog/tanstack-npm-packages-compromised-mini-shai-hulud-supply-chain-attack)

### [THREAT-2026-0013] TrustFall — one-click RCE via MCP trust prompt in Claude Code, Cursor, Gemini CLI, Copilot
- **Date detected:** 2026-05-13 (disclosed 2026-05-07)
- **Status:** 🔴 Active — No vendor patch; Anthropic declined to fix
- **Category:** AI Dev > Claude Code / MCP
- **Affects us:** Yes (we use Claude Code daily)
- **Summary:** Disclosed May 7, 2026 by Adversa AI. Any cloned repository can embed
  `.mcp.json` + `.claude/settings.json` with `enableAllProjectMcpServers=true` pointing to
  an attacker-controlled MCP server. When the user presses Enter on Claude Code's folder trust
  dialog, all project-defined MCP servers auto-spawn as unsandboxed OS processes with the
  developer's full user privileges. Claude Code v2.1+ removed the prior explicit warning about
  MCP servers in cloned repos. Anthropic reviewed and declined to patch, considering folder
  trust as consent to all project MCP definitions. Affects Claude Code, Cursor CLI, Gemini
  CLI, and GitHub Copilot CLI. CVE not yet assigned.
- **Action taken:** Team warned; pre-flight check procedure established (inspect for .mcp.json
  before accepting trust prompt)
- **Last updated:** 2026-05-13
- **Sources:** [Adversa AI](https://adversa.ai/blog/trustfall-coding-agent-security-flaw-rce-claude-cursor-gemini-cli-copilot/), [Help Net Security](https://www.helpnetsecurity.com/2026/05/07/trustfall-ai-coding-cli-vulnerability-research/), [Dark Reading](https://www.darkreading.com/application-security/trustfall-exposes-claude-code-execution-risk), [The Register](https://www.theregister.com/security/2026/05/07/claude-code-trust-prompt-can-trigger-one-click-rce/5235319)

### [THREAT-2026-0014] CVE-2026-31431 "Copy Fail" — Linux kernel local privilege escalation (CISA KEV)
- **Date detected:** 2026-05-13 (added to CISA KEV 2026-05-01)
- **Status:** 🔴 Active exploitation — CISA deadline May 15, 2026
- **Category:** CVE > Infrastructure
- **Affects us:** Yes (all Linux dev machines, CI/CD runners, servers)
- **Summary:** Logic bug in the Linux kernel's `authencesn` cryptographic template (AF_ALG
  socket family) allows an unprivileged local user to perform a controlled 4-byte write into
  the page cache of any readable file — enabling replacement of in-memory setuid binary code
  and reliable root escalation. A 732-byte Python PoC is publicly available; no races or
  timing windows needed. CVSS 7.8. Affects all Linux distributions running kernels from 2017
  onward. Container breakout and multi-tenant compromise are realistic escalation paths.
  CISA KEV deadline: May 15, 2026.
- **Affected versions:** Linux kernels 2017–present (unpatched)
- **Safe version:** Kernel ≥ 6.18.22, ≥ 6.19.12, or ≥ 7.0
- **Action taken:** Patch immediately on all systems
- **Last updated:** 2026-05-13
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
