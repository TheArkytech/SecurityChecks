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
- **Status:** 🔴 Phase 7b+ active — actions-cool attack ongoing; ISC SANS Update 008 (Apr 27) confirmed previously-uncaptured Phase 4b: Checkmarx KICS Docker Hub + xinference PyPI + CanisterSprawl cross-registry worm
- **Category:** Threat Actor > Supply Chain
- **Affects us:** Yes (GitHub Actions, npm, PyPI, Claude Code hooks in our stack)
- **Summary:** Sustained cascading campaign, now crossing 8+ ecosystems. Formally
  designated **UNC6780** by Google Threat Intelligence Group. Started from single
  incompletely-rotated GitHub PAT. Compromised: Trivy (GitHub Actions + Docker Hub),
  Checkmarx AST (GH Actions), LiteLLM (PyPI), Telnyx (PyPI), 66+ npm packages,
  2 VS Code extensions. European Commission breached (340GB). CVE-2026-33634
  (CVSS 9.4). **Phase 4 (Apr 22):** Bitwarden CLI (see THREAT-2026-0016). **Phase 5
  (May 9–11):** Checkmarx Jenkins AST Plugin + Mini Shai-Hulud worm (172 packages,
  CVE-2026-45321 CVSS 9.6, see THREAT-2026-0012). **Phase 5b (Apr 29):** SAP CAP/MBT
  npm packages compromised — 4 packages with preinstall credential stealer + Claude Code
  SessionStart hook abuse (first documented supply chain attack to target AI coding
  agent configs as a persistence vector). **Phase 6 (May 12):** Full Shai-Hulud source
  code open-sourced + BreachForums $1K contest (see THREAT-2026-0023). **Phase 7
  (May 19):** (a) @antv/* ecosystem — 300+ malicious versions, 323 packages, ~16M
  weekly downloads, 22-minute burst; (b) Microsoft durabletask PyPI SDK — versions
  1.4.1/1.4.2/1.4.3, 400K monthly downloads; Claude Code SessionStart hook / VS Code
  tasks weaponized as persistence (survives package removal); (c) TeamPCP claimed
  breach of ~4,000 GitHub internal repositories via malicious VS Code extension
  (Nx Console v18.95.0, confirmed — see THREAT-2026-0029). **Phase 7b (May 18):**
  actions-cool/issues-helper and actions-cool/maintain-one-comment GitHub Actions
  compromised via imposter commit tag redirect — all tags moved to credential-stealing
  Bun payload; exfiltration via t.m-kosche[.]com (same infra as Phase 7 npm burst —
  see THREAT-2026-0031). **Confirmed long-tail victim (May 24 update):** Credentials from
  the March 2026 Trivy breach were used to clone 300+ internal Cisco GitHub repositories,
  including source for Cisco AI Assistant, AI Defense, unreleased products, and repos belonging
  to bank/government customers. ISC SANS tracks this as TeamPCP Update 007. Mini Shai-Hulud has
  also spread to Packagist/PHP via a malicious Intercom PHP Composer plugin (see THREAT-2026-0038).
  **ISC SANS Update 008 (Apr 27 — previously uncaptured phases):** Following a ~26-day operational pause,
  TeamPCP simultaneously hit Checkmarx KICS Docker Hub (Apr 22), xinference PyPI (Apr 22), and deployed
  "CanisterSprawl" — a self-propagating npm worm that harvests 40 credential categories and auto-propagates
  to PyPI if a PyPI publish token is discovered. ISC SANS now publishes weekly W-series analysis (W18, W19…).
  GitHub/npm began major countermeasures: mandatory 2FA, classic token sunset, 90-day granular token caps,
  staged publishing with 2FA gate. These phases fall between Phase 4 (Bitwarden Apr 22) and Phase 5 (May 9).
- **Affected tools:** Trivy, Checkmarx AST (GH Actions), Checkmarx Jenkins AST plugin
  v2026.5.09, LiteLLM (PyPI), Telnyx (PyPI), 66+ npm packages, @bitwarden/cli,
  @tanstack/* (84 packages), @mistralai/mistralai, guardrails-ai, UiPath packages,
  SAP CAP/MBT npm packages (April 29), @antv/* (May 19), durabletask PyPI 1.4.1–1.4.3,
  Nx Console VS Code extension v18.95.0 (May 18), actions-cool/issues-helper + actions-cool/maintain-one-comment (May 18),
  Cisco internal repos (300+, long-tail victim via Trivy creds), laravel-lang Packagist packages (May 22–23)
- **IOCs:** models.litellm[.]cloud; gh-token-monitor daemon (macOS LaunchAgent / Linux
  systemd); public GitHub repos under victim accounts for credential exfiltration;
  unexpected entries in ~/.claude/settings.json hooks section; Claude Code SessionStart
  hook pointing to external script; t.m-kosche[.]com (Phase 7/7b exfiltration endpoint)
- **Action taken:** Audit GitHub Actions for SHA pinning; verify no use of compromised
  tools; rotate CI/CD credentials; update Checkmarx Jenkins plugin; CHECK CLAUDE CODE
  HOOKS on all developer machines; verify @antv/* and durabletask versions; audit for
  actions-cool usage; add t.m-kosche[.]com to network blocklist
- **Last updated:** 2026-05-25
- **Sources:** [Unit42](https://unit42.paloaltonetworks.com/teampcp-supply-chain-attacks/), [Sysdig](https://www.sysdig.com/blog/teampcp-expands-supply-chain-compromise-spreads-from-trivy-to-checkmarx-github-actions), [Wiz AntV](https://www.wiz.io/blog/mini-shai-hulud-teampcp-hits-antv-supply-chain), [Wiz durabletask](https://www.wiz.io/blog/durabletask-teampcp-supply-chain-attack), [StepSecurity](https://www.stepsecurity.io/blog/microsofts-durabletask-pypi-package-compromised-in-supply-chain-attack), [StepSecurity actions-cool](https://www.stepsecurity.io/blog/actions-cool-issues-helper-github-action-compromised-all-tags-point-to-imposter-commit-that-exfiltrates-ci-cd-credentials), [Incident Timeline](https://ramimac.me/teampcp/), [ISC SANS Update 007](https://isc.sans.edu/diary/TeamPCP+Supply+Chain+Campaign+Update+007+Cisco+Source+Code+Stolen+via+TrivyLinked+Breach+Google+GTIG+Tracks+TeamPCP+as+UNC6780+and+CISA+KEV+Deadline+Arrives+with+No+Standalone+Advisory/32880), [ISC SANS Update 008](https://isc.sans.edu/diary/32926), [BleepingComputer Cisco](https://www.bleepingcomputer.com/news/security/cisco-source-code-stolen-in-trivy-linked-dev-environment-breach/)

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
- **Action taken:** Review all connected MCP servers; rotate tokens; update VS Code; avoid
  running public MCP servers without explicit sandboxing; upgrade Splunk MCP Server to ≥1.0.3
- **Last updated:** 2026-05-16
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
- **Status:** 🔴 Active — CVE-2026-45321 (CVSS 9.6); Claude Code hook persistence confirmed; OpenAI devices confirmed compromised
- **Category:** Supply Chain > npm/PyPI
- **Affects us:** Yes (ecosystem-level threat; Claude Code hooks weaponized)
- **Summary:** On May 11, 2026, TeamPCP's "Mini Shai-Hulud" worm exploited a chained GitHub
  Actions attack (pull_request_target + cache poisoning + OIDC token memory extraction from
  `/proc/<pid>/mem`) to publish 403 malicious versions across 172 npm and PyPI packages —
  including @tanstack/react-router (12M weekly downloads/week), @mistralai/mistralai, UiPath
  packages, and guardrails-ai. Historic milestone: first documented supply chain worm to carry
  VALID SLSA Sigstore provenance, defeating this integrity control. Malware steals GitHub/npm/
  SSH/cloud credentials and installs a persistent `gh-token-monitor` daemon that runs
  `rm -rf ~/` if the stolen token is later revoked. True worm: enumerates and infects all other
  packages the victim maintainer controls. CVE-2026-45321 (CVSS 9.6). Geofenced destructive
  payload: 1-in-6 probability of `rm -rf /` for Israel/Iran systems. NHS England CC-4781.
  @squawk/* (87 packages) confirmed affected. **May 13–14:** OpenAI confirmed two employee
  devices compromised via @tanstack packages; code-signing certificates for ChatGPT Desktop,
  Codex App, Codex CLI, and Atlas stolen. macOS users of these apps MUST update before
  **June 12, 2026** (certificate revocation deadline). No user data affected. **May 19 update:**
  Later Phase 7 malware now modifies Claude Code's SessionStart hook and VS Code tasks as a
  persistence mechanism — survives package removal; see THREAT-2026-0028.
- **Affected versions:** @tanstack/* published 19:20–19:26 UTC May 11, 2026;
  @mistralai/mistralai, guardrails-ai, UiPath packages, @squawk/* in same window
- **Safe version:** Any @tanstack/* version NOT from that 6-minute window
- **IOCs:** gh-token-monitor daemon (macOS LaunchAgent / Linux systemd); public GitHub repos
  under victim accounts for exfiltration; unexpected Claude Code hooks in ~/.claude/settings.json
- **Action taken:** Run `npm audit` and verify @tanstack versions; check for gh-token-monitor
  process/service; verify Claude Code hooks; macOS OpenAI apps must update before June 12
- **Last updated:** 2026-05-20
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

### [THREAT-2026-0020] CVE-2026-42897 — Microsoft Exchange XSS/spoofing zero-day (CISA KEV, deadline May 29)
- **Date detected:** 2026-05-16 (disclosed 2026-05-14; added to CISA KEV 2026-05-15)
- **Status:** 🔴 Active exploitation — No patch yet; EM Service mitigation available; CISA FCEB deadline May 29, 2026 (3 days)
- **Category:** CVE > Infrastructure > Email
- **Affects us:** Low risk (only if running on-prem Exchange 2016/2019/SE)
- **Summary:** CVSS 8.1 XSS/spoofing vulnerability in Microsoft Exchange OWA. Attacker sends
  a crafted email; if victim opens it in Outlook Web Access, arbitrary JavaScript executes in
  the browser context. Affects Exchange 2016, 2019, and SE; does NOT affect Exchange Online.
  Added to CISA KEV May 15. **Update 2026-05-26:** CISA federal remediation deadline confirmed as
  May 29, 2026 (per BOD 22-01). Microsoft deployed a temporary fix via EEMS (URL rewrite config,
  enabled by default); permanent patch still in development. Active exploitation confirmed.
- **Affected versions:** Exchange Server 2016, 2019, Subscription Edition (all current versions)
- **Safe version:** Patch not yet available — apply EM Service mitigation immediately; await full patch
- **IOCs:** N/A
- **Action taken:** Verify EM Service (EEMS) is enabled and active on on-prem Exchange; confirm URL rewrite
  mitigation is applied; CISA deadline is May 29 — verify TODAY if using on-prem Exchange
- **Last updated:** 2026-05-26
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

### [THREAT-2026-0024] Next.js May 2026 security release — 13 CVEs including SSRF + auth bypass
- **Date detected:** 2026-05-17 (SSRF published 2026-05-11; full 13-CVE release 2026-05-15)
- **Status:** 🟠 Active — Safe versions updated to 15.5.18 / 16.2.6; previous 15.5.16/16.2.5 insufficient
- **Category:** CVE > React/Next.js
- **Affects us:** Potentially (if any project self-hosts Next.js with middleware for auth)
- **Summary:** The original CVE-2026-44578 (CVSS 8.6, WebSocket SSRF, ~79K exposed hosts,
  public exploit scanner live) has been superseded by the May 2026 security release shipping
  13 CVEs. Key additions beyond the SSRF: **4 middleware / auth bypass vulnerabilities**
  (including CVE-2026-45109) where crafted `.rsc` and segment-prefetch URLs bypass
  middleware.ts authorization — making any app using middleware for RBAC or auth fully
  compromised on unpatched versions. Also: DoS via React Server Components (CVE-2026-23870),
  XSS via CSP nonces, cache poisoning. Vercel-hosted apps NOT affected by SSRF; self-hosted
  apps affected by all 13 CVEs. The 4 auth bypass CVEs are the most dangerous for
  applications using Next.js middleware as an access control gate.
- **Affected versions:** Next.js 13.4.13+, 14.x, 15.x < 15.5.18, 16.0.0 < 16.2.6 (self-hosted)
- **Safe version:** Next.js ≥ 15.5.18 or ≥ 16.2.6 (upgraded from previous 15.5.16 / 16.2.5)
- **Action taken:** Run `npm list next` across all projects; upgrade to 15.5.18 or 16.2.6;
  WAF rules are NOT sufficient — full upgrade required
- **Last updated:** 2026-05-20
- **Sources:** [Vercel changelog](https://vercel.com/changelog/next-js-may-2026-security-release), [Netlify](https://www.netlify.com/changelog/2026-05-08-react-nextjs-security-vulnerabilities/), [Hadrian](https://hadrian.io/blog/next-js-websocket-ssrf-unauthenticated-access-to-internal-resources-cve-2026-44578-2), [SentinelOne CVE-2026-45109](https://www.sentinelone.com/vulnerability-database/cve-2026-45109/), [DevOps Daily](https://devops-daily.com/posts/nextjs-16-2-6-15-5-18-security-release)

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

### [THREAT-2026-0028] TeamPCP Phase 7 — AntV npm + Microsoft durabletask PyPI + Claude Code hook persistence
- **Date detected:** 2026-05-20 (attack occurred 2026-05-19)
- **Status:** 🔴 Active — Attacks from yesterday; Claude Code hook persistence requires immediate inspection
- **Category:** Supply Chain > npm/PyPI | Threat Actor
- **Affects us:** Yes (Claude Code users; npm/PyPI ecosystem)
- **Summary:** On May 19, 2026, TeamPCP published 300+ malicious npm package versions across
  the @antv/* Alibaba data visualization ecosystem (323 packages, ~16 million combined weekly
  downloads) in a 22-minute automated burst via a compromised maintainer account. Simultaneously,
  three malicious versions of Microsoft's official durabletask Python SDK (1.4.1, 1.4.2, 1.4.3
  — 400,000 monthly downloads) appeared on PyPI within 35 minutes. The 28 KB credential-stealing
  payload targets AWS, Azure, GCP, Kubernetes, password managers, and 90+ developer tool
  configs. **Critical new TTP:** malware modifies Claude Code's `SessionStart` hook in
  `~/.claude/settings.json` and injects VS Code tasks — enabling malware reinstallation with
  full LLM privileges even after the infected npm/PyPI package is removed. Malware also injects
  itself into every GitHub repository accessible to the compromised developer. Geofenced rm-rf
  logic (Israel/Iran) present.
- **Affected versions:** @antv/* packages published May 19, 2026 in ~22-minute window;
  durabletask==1.4.1, 1.4.2, 1.4.3
- **Safe version:** @antv/* any version NOT from May 19 burst; durabletask ≤ 1.4.0
- **IOCs:** Unexpected entries in `~/.claude/settings.json` hooks section pointing to external
  scripts; unexpected VS Code tasks in `.vscode/tasks.json`; gh-token-monitor daemon (inherited)
- **Action taken:** (1) Inspect ~/.claude/settings.json for unexpected hooks; (2) Check
  durabletask version in all Python environments; (3) Check @antv/* npm packages installed today;
  (4) Rotate all cloud credentials if either package was present
- **Last updated:** 2026-05-20
- **Sources:** [Wiz Blog @antv](https://www.wiz.io/blog/mini-shai-hulud-teampcp-hits-antv-supply-chain), [Wiz Blog durabletask](https://www.wiz.io/blog/durabletask-teampcp-supply-chain-attack), [StepSecurity](https://www.stepsecurity.io/blog/microsofts-durabletask-pypi-package-compromised-in-supply-chain-attack), [Snyk](https://snyk.io/blog/mini-shai-hulud-antv-npm-supply-chain-attack/), [The Hacker News](https://thehackernews.com/2026/05/mini-shai-hulud-pushes-malicious-antv.html), [Cybernews](https://cybernews.com/security/shai-hulud-strikes-again-massive-npm-compromise/)

### [THREAT-2026-0029] GitHub internal repository breach — TeamPCP via malicious VS Code extension
- **Date detected:** 2026-05-20 (ongoing investigation)
- **Status:** 🔴 Active — VS Code extension identified (Nx Console v18.95.0); stolen data listed for sale at $50K; zero-days from stolen source code remain a watch item
- **Category:** Breach > Infrastructure > GitHub | Threat Actor
- **Affects us:** Yes (we host code on GitHub; potential zero-days from stolen source)
- **Summary:** TeamPCP (UNC6780) posted ~3,800 GitHub internal repositories for sale on a
  cybercrime forum (~$50,000 USD). GitHub confirmed unauthorized access via a GitHub employee
  installing a trojanized VS Code extension: **Nx Console (nrwl.angular-console) v18.95.0**,
  published to the VS Code Marketplace on May 18, 2026 and live for roughly 11 minutes before
  removal. The extension yielded access to internal GitHub secrets and from there to internal
  repositories. GitHub isolated the compromised endpoint, rotated high-impact internal secrets,
  and confirmed no impact to customer repositories, enterprises, or user data. Attacker
  continues to taunt GitHub publicly. If internal GitHub source is in attacker hands,
  researchers may surface new GitHub platform zero-days in coming weeks.
- **Affected scope:** GitHub internal repositories only (not customer repos); ~3,800 repos
- **IOCs:** nrwl.angular-console v18.95.0 (malicious VS Code extension, now removed); GitHub audit log anomalies
- **Action taken:** Rotate GitHub PATs; audit VS Code extensions for nrwl.angular-console and
  any other low-install-count extensions; watch GitHub security advisories this week;
  DO NOT install Nx Console unless from the official Nx publisher page and verified
- **Last updated:** 2026-05-23
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/github-investigating-teampcp-claimed.html), [Help Net Security](https://www.helpnetsecurity.com/2026/05/20/github-breached-teampcp/), [StepSecurity](https://www.stepsecurity.io/blog/actions-cool-issues-helper-github-action-compromised-all-tags-point-to-imposter-commit-that-exfiltrates-ci-cd-credentials), [The Next Web](https://thenextweb.com/news/github-confirms-hackers-stole-thousands-of-internal-code-repositories-after-employee-installed-a-poisoned-vs-code-extension)

### [THREAT-2026-0030] Grafana Labs codebase stolen — CoinbaseCartel Pwn Request (May 16–18)
- **Date detected:** 2026-05-20 (disclosed 2026-05-16; reported 2026-05-18)
- **Status:** 🟠 Contained — Codebase stolen; extortion rejected; no customer data affected
- **Category:** Breach > Supply Chain > GitHub Actions
- **Affects us:** 🟠 Could affect us (Grafana is widely used OSS; attack TTP identical to
  TeamPCP; demonstrates Pwn Request attacks proliferating beyond TeamPCP to new actors)
- **Summary:** On May 16, 2026, Grafana Labs disclosed that an unauthorized actor obtained a
  GitHub Actions token by exploiting a pull_request_target "Pwn Request" misconfiguration —
  the same technique used by TeamPCP at scale. The attacker forked a Grafana repository,
  injected malicious code via a curl command, dumped CI environment variables encrypted with
  a private key, deleted the fork to cover tracks, then used the stolen GitHub token to clone
  Grafana's entire private codebase across multiple repositories. Grafana's canary token system
  triggered the alert. The attacker demanded ransom; Grafana refused (per FBI guidance). No
  customer data or operational systems affected. Attribution: **CoinbaseCartel**, an extortion
  crew that emerged September 2025, assessed as an offshoot of the ShinyHunters / Scattered
  Spider / LAPSUS$ ecosystem. Significance: The Pwn Request TTP is now confirmed being used
  by multiple independent threat actors. Grafana is the second major OSS infrastructure tool
  breached this month (after TeamPCP Phase 5–7).
- **IOCs:** CoinbaseCartel infrastructure (see Halcyon threat-intel feed)
- **Action taken:** Audit all repos for pull_request_target workflows that checkout fork code;
  restrict secrets access to trusted contributors; revoke broad CI tokens
- **Last updated:** 2026-05-20
- **Sources:** [TechCrunch](https://techcrunch.com/2026/05/18/open-source-tool-maker-grafana-labs-says-hackers-stole-its-code-refuses-to-pay-ransom/), [Help Net Security](https://www.helpnetsecurity.com/2026/05/18/attackers-accessed-downloaded-code-from-grafana-labs-github/), [The Hacker News](https://thehackernews.com/2026/05/grafana-github-token-breach-led-to.html), [SecurityWeek](https://www.securityweek.com/grafana-confirms-breach-after-hackers-claim-they-stole-data/), [The Register](https://www.theregister.com/cyber-crime/2026/05/18/grafana-labs-admits-attackers-downloaded-its-codebase-from-github/5241686), [BleepingComputer](https://www.bleepingcomputer.com/news/security/grafana-says-stolen-github-token-let-hackers-steal-codebase/)

### [THREAT-2026-0031] actions-cool GitHub Actions marketplace supply chain attack (TeamPCP Phase 7b)
- **Date detected:** 2026-05-23 (attack occurred 2026-05-18; disclosed 2026-05-19)
- **Status:** 🔴 Active — All tags still affected unless explicitly re-pinned; any un-pinned workflow referencing these actions is compromised
- **Category:** Supply Chain > GitHub Actions
- **Affects us:** Yes (we use GitHub Actions)
- **Summary:** On May 18, 2026 between 19:10–19:13 UTC, all 53 tags of the widely-used GitHub
  Action `actions-cool/issues-helper` were force-moved to a single imposter commit created in a
  3-minute 16-second burst. `actions-cool/maintain-one-comment` had 15 tags compromised
  identically. The malicious commit downloads the Bun JavaScript runtime, reads the Runner.Worker
  process memory (which holds decrypted in-flight workflow secrets), and exfiltrates CI/CD
  credentials via HTTPS to t.m-kosche[.]com — the same domain used in TeamPCP's Phase 7 npm
  attack. This is the first confirmed Shai-Hulud attack directly targeting the GitHub Actions
  marketplace. Only workflows pinned to a known-good full commit SHA are safe. Attribution:
  TeamPCP (UNC6780) via shared infrastructure.
- **Affected tools:** actions-cool/issues-helper (all tags), actions-cool/maintain-one-comment (all tags)
- **IOCs:** t.m-kosche[.]com (exfiltration domain, shared with Phase 7 npm attack)
- **Action taken:** `grep -r "actions-cool/issues-helper\|actions-cool/maintain-one-comment" .github/workflows/`
  across all repos — if found: rotate CI secrets and replace with SHA-pinned reference immediately;
  block t.m-kosche[.]com at network perimeter
- **Last updated:** 2026-05-23
- **Sources:** [StepSecurity](https://www.stepsecurity.io/blog/actions-cool-issues-helper-github-action-compromised-all-tags-point-to-imposter-commit-that-exfiltrates-ci-cd-credentials), [The Hacker News](https://thehackernews.com/2026/05/github-actions-supply-chain-attack.html), [CybersecurityNews](https://cybersecuritynews.com/compromised-github-action-exfiltrates-workflow-credentials/)

### [THREAT-2026-0032] CVE-2026-41091 / CVE-2026-45498 — Microsoft Defender EoP + DoS zero-days (CISA KEV, deadline June 3)
- **Date detected:** 2026-05-23 (disclosed 2026-05-19; actively exploited as of 2026-05-21)
- **Status:** 🔴 Active exploitation — Patch released; CISA FCEB deadline June 3, 2026
- **Category:** CVE > Infrastructure > Windows
- **Affects us:** 🟠 Could affect us (all Windows dev machines and endpoints)
- **Summary:** Two Microsoft Defender vulnerabilities actively exploited in the wild as of May
  19–21, 2026. **CVE-2026-41091** (CVSS 7.8): "link following" EoP in Defender's scanning logic
  — an authenticated local user can trick Defender into following crafted junctions and gain
  SYSTEM-level privileges. **CVE-2026-45498** (DoS): crashes or impairs the Defender antimalware
  platform, creating a protection window for follow-on attacks. Threat actors named campaigns
  "RedSun" (CVE-2026-41091) and "UnDefend" (CVE-2026-45498). Microsoft patched both in engine
  version 1.1.26040.8 and platform 4.18.26040.7 (released May 22, 2026). CISA FCEB remediation
  deadline: June 3, 2026.
- **Affected versions:** Microsoft Malware Protection Engine ≤ 1.1.26030.3008; Defender Platform < 4.18.26040.7
- **Safe version:** Engine ≥ 1.1.26040.8; Platform ≥ 4.18.26040.7
- **IOCs:** N/A
- **Action taken:** Run `Get-MpComputerStatus` on Windows machines; verify `AMEngineVersion` ≥ 1.1.26040.8
  and `AMProductVersion` ≥ 4.18.26040.7; force update with `Update-MpSignature` if needed
- **Last updated:** 2026-05-23
- **Sources:** [CybersecurityNews](https://cybersecuritynews.com/microsoft-defender-0-days-exploited/), [SecurityWeek](https://www.securityweek.com/recent-microsoft-defender-vulnerability-exploited-as-zero-day/), [Winbuzzer](https://winbuzzer.com/2026/05/22/microsoft-patches-exploited-defender-zero-days-as-cisa-acts-xcxwbn/)

### [THREAT-2026-0033] CVE-2026-46333 "ssh-keysign-pwn" — Linux kernel ptrace fd-theft (4th in LPE cluster)
- **Date detected:** 2026-05-23 (patch committed 2026-05-14; Qualys disclosure 2026-05-20)
- **Status:** 🔴 Active — PoC viable (100–2,000 attempts); patches available; this environment (6.18.5) confirmed vulnerable
- **Category:** CVE > Infrastructure > Linux Kernel
- **Affects us:** Yes (all Linux dev machines, CI/CD runners, and this session environment)
- **Summary:** A 6-year race condition in `__ptrace_may_access()` (Qualys research, disclosed
  May 20). During the narrow window between a task's memory descriptor being detached and its
  file descriptor table being closed, an unprivileged local user can invoke `pidfd_getfd(2)`
  (available since Linux 5.6) to clone file descriptors from exiting SUID binaries. Primary
  targets: `ssh-keysign` (reads SSH host private keys) and `chage` (reads the shadow password
  database). Not a full root privilege escalation but enables credential theft for lateral
  movement. Exploit succeeds within 100–2,000 attempts (practical on real systems). This is
  the **FOURTH** Linux kernel credential disclosure/LPE in the current cluster (after Copy Fail
  CVE-2026-31431, Dirty Frag CVE-2026-43284/43500, Fragnesia CVE-2026-46300). Patch committed
  publicly May 14, 2026.
- **Affected versions:** Linux kernels with pidfd_getfd (≥5.6, unpatched)
- **Safe version:** ≥7.0.8, ≥6.18.31, ≥6.12.89, ≥6.6.139, ≥6.1.173, ≥5.15.207, ≥5.10.256
- **IOCs:** N/A
- **Action taken:** Apply distro CVE-2026-46333 kernel update; check `uname -r` (must show ≥6.18.31
  on this kernel branch); interim: apply AppArmor/SELinux confinement on ssh-keysign; restrict
  pidfd_getfd via seccomp policy
- **Last updated:** 2026-05-23
- **Sources:** [Qualys Blog](https://blog.qualys.com/vulnerabilities-threat-research/2026/05/20/cve-2026-46333-local-root-privilege-escalation-and-credential-disclosure-in-the-linux-kernel-ptrace-path), [CloudLinux](https://blog.cloudlinux.com/ptrace-exit-race-cve-2026-46333-mitigation-and-kernel-update), [CybersecurityNews](https://cybersecuritynews.com/linux-kernel-vulnerability-ssh-keysign-pwn/)

### [THREAT-2026-0035] "Comment and Control" — Prompt injection via GitHub comments → credential theft (Claude Code, Gemini CLI, Copilot)
- **Date detected:** 2026-05-24 (disclosed 2026-04-15; missed in initial scan)
- **Status:** 🔴 Active — No CVE assigned; no patch from any vendor; Anthropic downgraded severity to "None" after paying $100 bounty
- **Category:** AI Dev > Claude Code / Prompt Injection
- **Affects us:** Yes (we use Claude Code with GitHub Actions; PR review agents)
- **Summary:** Disclosed publicly ~April 15, 2026 by Aonan Guan (Wyze Labs) + Zhengyu Liu + Gavin Zhong
  (Johns Hopkins). Three AI coding agents — Anthropic's Claude Code Security Review, Google's Gemini
  CLI Action, and GitHub Copilot Agent — are vulnerable to prompt injection via ordinary GitHub PR
  titles, issue bodies, and HTML-hidden issue comments. The attack is **proactive**: GitHub Actions
  workflows auto-trigger on `pull_request`, `issues`, and `issue_comment` events, so an attacker
  simply opens a PR or files an issue to activate the agent with no victim interaction. The AI reads
  untrusted metadata as trusted context, executes attacker-supplied instructions, and exfiltrates
  CI/CD secrets (ANTHROPIC_API_KEY, GEMINI_API_KEY, GITHUB_TOKEN) back through PR comments, issue
  comments, or git commits — the entire loop stays within GitHub. No CVE assigned by any vendor.
  Anthropic rated CVSS 9.4 internally, paid $100 bounty, then re-classified severity as "None."
  GitHub marked Copilot variant as "architectural limitation." No public advisories published.
- **Affected scope:** Any repo using Claude Code Security Review, Gemini CLI Action, or Copilot Agent
  workflows triggered by untrusted GitHub events
- **IOCs:** Unexpected PR comments or commits containing encoded credential strings
- **Action taken:** Audit all GitHub Actions workflows — if any AI agent runs on pull_request/issues/
  issue_comment events with access to secrets, add explicit input sanitization or switch to
  pull_request_target with secret isolation; never pass raw PR metadata to an AI agent holding secrets
- **Last updated:** 2026-05-24
- **Sources:** [SecurityWeek](https://www.securityweek.com/claude-code-gemini-cli-github-copilot-agents-vulnerable-to-prompt-injection-via-github-comments/), [CybersecurityNews](https://cybersecuritynews.com/prompt-injection-via-github-comments/), [Original Research](https://oddguan.com/blog/comment-and-control-prompt-injection-credential-theft-claude-code-gemini-cli-github-copilot/), [Repello AI](https://repello.ai/blog/comment-and-control-claude-code-gemini-copilot-prompt-injection)

### [THREAT-2026-0036] CVE-2026-42945 "NGINX Rift" — 18-year-old unauthenticated RCE in rewrite module (actively exploited)
- **Date detected:** 2026-05-24 (disclosed 2026-05-13; exploitation confirmed 2026-05-16)
- **Status:** 🔴 Active exploitation — CISA KEV inclusion expected; patch available since May 13
- **Category:** CVE > Infrastructure > Web Server
- **Affects us:** 🟠 Could affect us (if any project or CI/CD infra runs nginx with rewrite rules)
- **Summary:** A heap buffer overflow in NGINX's `ngx_http_rewrite_module` (`ngx_http_script.c`),
  present since NGINX 0.6.27 shipped in 2008 — 18 years ago. Discovered by depthfirst's autonomous
  vulnerability analysis system; disclosed jointly by F5 and depthfirst on May 13, 2026. An
  unauthenticated attacker sends a single crafted HTTP request with extensive repeating patterns
  that trigger a heap overflow when processed by `rewrite`, `if`, or `set` directives using unnamed
  capture groups ($1, $2). Reliable DoS; RCE potential under specific configurations. CVSS 9.2.
  Affects NGINX OSS 0.6.27–1.30.0, NGINX Plus R32–R36, and all downstreams compiling
  `ngx_http_script.c` (including Ingress NGINX Controller ≤1.15.1). Public PoC available on GitHub.
  Active exploitation observed by VulnCheck canaries from May 16. CISA KEV inclusion likely given
  confirmed in-the-wild exploitation.
- **Affected versions:** NGINX OSS 0.6.27–1.30.0; NGINX Plus R32–R36; Ingress NGINX ≤1.15.1
- **Safe version:** NGINX OSS ≥1.30.1 (stable) or ≥1.31.0 (mainline); NGINX Plus R32 P6 / R35 P2 / R36 P4
- **IOCs:** N/A
- **Action taken:** Run `nginx -v` on all systems; upgrade to 1.30.1 or 1.31.0; restart nginx workers;
  for NGINX Plus apply F5 advisory K000161019; for Ingress NGINX upgrade controller
- **Last updated:** 2026-05-24
- **Sources:** [Akamai](https://www.akamai.com/blog/security-research/nginx-critical-heap-buffer-overflow-cve-2026-42945), [The Hacker News](https://thehackernews.com/2026/05/18-year-old-nginx-rewrite-module-flaw.html), [Help Net Security](https://www.helpnetsecurity.com/2026/05/18/ngnix-vulnerability-exploited-cve-2026-42945/), [HeroDevs](https://www.herodevs.com/blog-posts/cve-2026-42945-nginx-rift-heap-buffer-overflow-hits-ingress-nginx), [Picus Security](https://www.picussecurity.com/resource/blog/nginx-rift-cve-2026-42945-critical-heap-buffer-overflow-vulnerability-explained)

### [THREAT-2026-0037] vm2 Node.js sandbox escape cluster — 13 critical CVEs (CVSS up to 10.0)
- **Date detected:** 2026-05-24 (CVEs published across Jan–May 2026; latest batch disclosed May 2026)
- **Status:** 🔴 Active — Multiple public PoCs; fix in vm2 3.11.2
- **Category:** CVE > Node.js > Sandboxing
- **Affects us:** 🟠 Could affect us (if using vm2 for code sandboxing, expression evaluation, or
  AI-generated code execution — common in n8n, low-code tools, and custom script runners)
- **Summary:** A cluster of 13 critical vulnerabilities in the widely-used `vm2` Node.js sandbox
  library that collectively allow sandboxed code to escape isolation and execute arbitrary commands
  on the host. Key CVEs: **CVE-2026-22709** (CVSS 9.8) — bypasses Promise callback sanitization;
  **CVE-2026-26956** (CVSS 9.8) — WebAssembly exception handling intercepts errors below vm2's
  JS-level defenses via V8 (Symbol-to-string conversion trick); **CVE-2026-43997** (CVSS 10.0)
  — code injection obtains the host Object directly. Additional CVEs (CVE-2026-24118,
  -24120, -24781, -43999) all CVSS 9.8+. Public PoC code published on GitHub for CVE-2026-26956,
  -24118, -24781, -22709. Any application using vm2 to sandbox untrusted user input or AI-generated
  code is at risk of full host compromise.
- **Affected versions:** vm2 < 3.11.2
- **Safe version:** vm2 ≥ 3.11.2
- **IOCs:** N/A
- **Action taken:** Run `npm list vm2` across all projects; if present, upgrade to ≥3.11.2 immediately;
  if using vm2 for AI-generated code execution, consider migrating to Deno or isolated-vm which
  use native V8 isolates rather than JS-level sandboxing
- **Last updated:** 2026-05-24
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/vm2-nodejs-library-vulnerabilities.html), [Endor Labs](https://www.endorlabs.com/learn/cve-2026-22709-critical-sandbox-escape-in-vm2-enables-arbitrary-code-execution), [Qualys ThreatPROTECT](https://threatprotect.qualys.com/2026/05/07/vm2-sandbox-escape-vulnerability-allows-attackers-to-execute-code-cve-2026-26956/)

### [THREAT-2026-0038] Laravel-Lang Packagist supply chain attack — 700+ malicious tags (May 22–23)
- **Date detected:** 2026-05-24 (attack occurred 2026-05-22–23; disclosed 2026-05-23)
- **Status:** 🟠 Contained — Malicious versions removed from Packagist; tags cleaned; rotate credentials if installed
- **Category:** Supply Chain > Packagist / PHP
- **Affects us:** 🟡 Low direct impact (PHP/Laravel ecosystem, not our primary stack) but technique is novel
- **Summary:** On May 22–23, 2026, attackers exploited a GitHub feature allowing version tags to
  point to commits in a fork — not the original repo. By controlling a malicious fork, they
  published 700+ compromised historical version tags across four community-maintained
  laravel-lang packages (laravel-lang/lang, /attributes, /http-statuses, /actions) on Packagist.
  The malicious `src/helpers.php` was auto-loaded via Composer's `autoload.files` directive —
  no user action beyond `composer install` needed. Payload: cross-platform credential stealer
  targeting cloud keys (AWS/GCP/Azure), Kubernetes/Vault secrets, CI/CD tokens, SSH material,
  browser data, crypto wallets. Cross-ecosystem placement (hidden in package.json lifecycle hooks)
  evades PHP-only dependency scans. Packagist removed malicious versions within hours.
  Technique is significant: the GitHub tag→fork exploit bypasses direct repo commit access and
  is identical in mechanism to the actions-cool GitHub Action attack (THREAT-2026-0031).
- **Affected versions:** laravel-lang/lang, laravel-lang/attributes, laravel-lang/http-statuses,
  laravel-lang/actions — any version published as a tag May 22–23, 2026
- **IOCs:** N/A (malicious versions removed)
- **Action taken:** Run `composer show laravel-lang/*` on all PHP projects; if any laravel-lang
  package was installed between May 22–24, rotate all cloud credentials, CI/CD tokens, and SSH keys
  accessible from that environment
- **Last updated:** 2026-05-24
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/laravel-lang-php-packages-compromised.html), [Aikido Security](https://www.aikido.dev/blog/supply-chain-attack-targets-laravel-lang-packages-with-credential-stealer), [StepSecurity](https://www.stepsecurity.io/blog/laravel-lang-supply-chain-attack), [CybersecurityNews](https://cybersecuritynews.com/laravel-lang-packages-compromised/)

### [THREAT-2026-0039] CISA AWS GovCloud credentials publicly exposed on GitHub (844 MB leak)
- **Date detected:** 2026-05-24 (exposed since ~Nov 2025; discovered 2026-05-14; remediated 2026-05-15)
- **Status:** ⚪ Remediated — Repo taken down; no confirmed attacker exfiltration; context/irony significant
- **Category:** Breach > Government > Credentials
- **Affects us:** ⚪ General informational (not our systems, but validates secrets hygiene urgency)
- **Summary:** On May 14, 2026, GitGuardian researcher Guillaume Valadon found a public GitHub
  repository named "Private-CISA" containing 844 MB of plaintext credentials belonging to CISA —
  the US agency responsible for cybersecurity guidance. Exposed since approximately November 2025.
  Contents: AWS GovCloud administrative credentials (file literally named "importantAWStokens"),
  plaintext usernames/passwords for dozens of internal CISA systems (file: "AWS-Workspace-Firefox-
  Passwords.csv"), IAM identities, service accounts, internal endpoint URLs, Entra ID SAML
  certificates, and secret-management paths. CISA had disabled GitHub's default secret-blocking
  setting. Described by Valadon as "the worst leak I've witnessed." Repo taken offline within 26
  hours after KrebsOnSecurity reported it. US lawmakers have demanded answers.
- **IOCs:** N/A
- **Action taken:** No action needed for our systems. Key lesson: verify GitHub secret scanning is
  enabled on all org repos (`git push` protection + secret scanning); never disable default protections
- **Last updated:** 2026-05-24
- **Sources:** [KrebsOnSecurity](https://krebsonsecurity.com/2026/05/cisa-admin-leaked-aws-govcloud-keys-on-github/), [GitGuardian](https://blog.gitguardian.com/how-we-got-a-cisa-github-leak-taken-down-in-26-hours/), [The Register](https://www.theregister.com/security/2026/05/19/americas-top-cyber-defense-agency-left-a-github-repo-open-with-passwords-keys-tokens-and-incredibly-obvious-filenames/5242915), [CyberNews](https://cybernews.com/security/cisa-844-mb-plaintext-passwords-aws-tokens-github/)

### [THREAT-2026-0040] CVE-2026-20223 — Cisco Secure Workload REST API auth bypass (CVSS 10.0)
- **Date detected:** 2026-05-24 (patched 2026-05-21; no known active exploitation)
- **Status:** 🟡 Patched — No active exploitation confirmed; apply patch
- **Category:** CVE > Infrastructure > Network
- **Affects us:** 🟡 Low direct risk (only if using Cisco Secure Workload SaaS or on-prem)
- **Summary:** CVSS 10.0 authentication bypass in Cisco Secure Workload (formerly Tetration).
  Insufficient validation in REST API endpoints allows an unauthenticated remote attacker to send
  crafted HTTP requests, instantly gaining Site Admin privileges. Enables reading sensitive
  information and making configuration changes across isolated tenant boundaries — full data center
  and cloud infrastructure reconfiguration possible without any credentials. Affects SaaS and on-prem
  deployments regardless of configuration. No workarounds; patch only. Cisco PSIRT states no known
  public exploitation at time of disclosure. Patched May 21, 2026. This is the second CVSS 10.0
  Cisco vulnerability this year (after SD-WAN CVE-2026-20182).
- **Affected versions:** Cisco Secure Workload 3.9.x (all), 3.10.x < 3.10.8.3, 4.0.x < 4.0.3.17
- **Safe version:** 3.10.8.3 or 4.0.3.17; versions 3.9.x must migrate to newer release
- **IOCs:** N/A
- **Action taken:** If using Cisco Secure Workload, upgrade to 4.0.3.17 (or 3.10.8.3 for 3.10.x
  branch) per Cisco advisory cisco-sa-csw-pnbsa-g8WEnuy
- **Last updated:** 2026-05-24
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/cisco-patches-cvss-100-secure-workload.html), [SecurityWeek](https://www.securityweek.com/cisco-patches-critical-vulnerability-in-secure-workload/), [Cisco Advisory](https://sec.cloudapps.cisco.com/security/center/content/CiscoSecurityAdvisory/cisco-sa-csw-pnbsa-g8WEnuy)

### [THREAT-2026-0041] TrapDoor — Cross-Registry Supply Chain Attack + CLAUDE.md/.cursorrules AI Prompt Injection (May 22–24)
- **Date detected:** 2026-05-25 (attack began 2026-05-22)
- **Status:** 🔴 Active — malicious packages removed from registries; PR campaign ongoing against popular OSS repos
- **Category:** Supply Chain > npm/PyPI/Crates.io | AI Dev > Prompt Injection
- **Affects us:** 🔴 YES — we use Claude Code and Cursor; CLAUDE.md and .cursorrules files are directly weaponized
- **Summary:** "TrapDoor" is a coordinated cross-registry supply chain attack discovered May 22–24, 2026 by Socket.dev.
  34 malicious packages across npm (21), PyPI (7), and Crates.io (6) target cryptocurrency/DeFi, AI, and security
  developers. Earliest package: `eth-security-auditor@0.1.0` (PyPI, May 22 20:20 UTC). Crates.io packages abuse
  `build.rs` (executes automatically during Rust compilation). Steals: SSH keys, Sui/Solana/Aptos wallet keystores,
  AWS/GCP/Azure credentials, GitHub tokens, browser databases, crypto wallet extensions. **Critical novel TTP
  directly affecting our toolchain:** TrapDoor embeds attacker instructions inside `.cursorrules` and `CLAUDE.md`
  files using **hidden zero-width Unicode characters** (U+200B, U+200C, U+200D, U+FEFF, U+2060) — invisible
  in most editors and diff views but parsed as instructions by Claude Code and Cursor, silently executing
  "security scan" commands that exfiltrate secrets. **Second novel TTP:** PR campaign against popular GitHub
  OSS repos (langchain-ai/langchain, langflow-ai/langflow, run-llama/llama_index, FoundationAgents/MetaGPT,
  OpenHands/OpenHands) submitting PRs with innocuous titles ("docs: add .cursorrules with dev standards") to
  inject malicious AI config files. Detection time: Socket detected packages in avg 5m 56s.
- **IOCs:** `eth-security-auditor` PyPI; zero-width Unicode chars in `.cursorrules` / `CLAUDE.md`;
  GitHub Gist exfiltration (XOR-encoded with key `cargo-build-helper-2026`)
- **Action taken:**
  1. Inspect all CLAUDE.md and .cursorrules in repos: `grep -rP '[\x{200b}\x{200c}\x{200d}\x{feff}\x{2060}]' . --include="CLAUDE.md" --include=".cursorrules"`
  2. Add zero-width Unicode check to repo onboarding pre-flight (add to TrustFall procedure from THREAT-2026-0013)
  3. Check for any TrapDoor packages: `npm audit` + verify against Socket.dev indicator list
  4. Inspect any open PRs to repos we own for suspicious .cursorrules or CLAUDE.md additions
- **Last updated:** 2026-05-25
- **Sources:** [Socket.dev](https://socket.dev/blog/trapdoor-crypto-stealer-npm-pypi-crates), [Cyberpress](https://cyberpress.org/supply-chain-attack-compromises-34-packages/), [Cyberkendra](https://www.cyberkendra.com/2026/05/malicious-packages-on-npm-pypi-and.html)

### [THREAT-2026-0042] Instructure Canvas LMS Breach — ShinyHunters, 275M Users, Largest Educational Breach on Record
- **Date detected:** 2026-05-25 (incident 2026-05-01; re-attack 2026-05-07; ransom resolution ~2026-05-22)
- **Status:** 🟡 Resolved — Ransom reportedly paid ($10M); data purportedly destroyed; ShinyHunters active
- **Category:** Breach > Education Platform | Threat Actor > ShinyHunters
- **Affects us:** 🟡 Low direct risk (we are not in education); ShinyHunters/CoinbaseCartel activity tracking
- **Summary:** ShinyHunters breached Instructure's Canvas LMS affecting 275 million users at 8,809 universities
  and institutions worldwide — the largest educational breach on record. Initial incident May 1, 2026.
  Instructure claimed containment May 6; re-attacked May 7 with login page replaced by ransomware message.
  Attack vector: exploitation of the Free-For-Teacher account program to gain platform access. Data stolen:
  names, email addresses, student IDs, private messages between students and teachers (3.65 TB total).
  Disruption occurred during final exam periods at multiple universities. Instructure reportedly paid ~$10M
  (unconfirmed terms; FBI guidance recommends against). ShinyHunters is assessed as part of the same
  CoinbaseCartel/Scattered Spider/LAPSUS$ offshoot ecosystem seen in the Grafana breach (THREAT-2026-0030).
- **IOCs:** N/A (ShinyHunters infrastructure — see Halcyon threat-intel feed)
- **Action taken:** No direct action for our team. Monitors ShinyHunters as an active actor targeting
  developer/platform infrastructure (Grafana, Canvas). If team uses Canvas or any Instructure product,
  rotate credentials and enable MFA immediately.
- **Last updated:** 2026-05-25
- **Sources:** [Bitdefender](https://businessinsights.bitdefender.com/technical-advisory-shinyhunters-breach-instructure-canvas-lms), [Rescana](https://www.rescana.com/post/shinyhunters-launches-second-major-attack-on-instructure-canvas-lms-via-free-for-teacher-accounts-may-2026-breach-analys), [Halcyon](https://www.halcyon.ai/ransomware-alerts/education-sector-in-the-crosshairs-shinyhunters-extortion-campaign-against-instructure), [Wikipedia](https://en.wikipedia.org/wiki/2026_Canvas_security_incident)

### [THREAT-2026-0043] ToxicSkills — AI Agent Skills Supply Chain Crisis (Snyk Research)
- **Date detected:** 2026-05-25 (research published ~2026-05-20)
- **Status:** 🟠 Active — 8+ malicious skills confirmed still live on ClawHub at time of publication
- **Category:** AI Dev > Agent Skills > Supply Chain
- **Affects us:** 🟡 Low direct risk unless team uses ClawHub/skills.sh AI skill marketplaces
- **Summary:** Snyk published "ToxicSkills," the first comprehensive security audit of the AI Agent Skills
  ecosystem (3,984 skills across ClawHub and skills.sh, scanned February 2026). Key findings: 36% of
  tested skills contain prompt injection payloads; 13.4% (534 skills) contain critical-level security
  issues; 1,467 distinct malicious payloads identified; 76 confirmed active malicious skills with verified
  credential theft, backdoor installation, and data exfiltration capabilities. Attack patterns: skills
  inject malicious instructions into the agent's system prompt; skills silently exfiltrate env vars on
  trigger; skills harvest API keys from the developer shell. 91% of verified malware combines language
  jailbreaks with executable payloads. Skills publishing grew 10x (from ~50/day in Jan 2026 to 500+/day
  by Feb 2026). An OWASP "Agentic Skills Top 10" project was launched as a response.
- **IOCs:** Malicious skills on ClawHub/skills.sh (see Snyk report for hash list)
- **Action taken:** Do NOT install AI agent skills from ClawHub or skills.sh without manually reviewing
  the skill source; prefer skills from vetted providers with source code available; treat AI skills as
  code — apply the same vetting (PROMPT-C) as for npm packages
- **Last updated:** 2026-05-25
- **Sources:** [Snyk](https://snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub/), [Agensi.io](https://www.agensi.io/learn/toxicskills-clawhavoc-agent-skills-security-crisis-2026), [OWASP Agentic Skills Top 10](https://owasp.org/www-project-agentic-skills-top-10/)

### [THREAT-2026-0044] Patch Tuesday May 2026 — CVE-2026-41096 (Windows DNS RCE, CVSS 9.8) + CVE-2026-41089 (Netlogon Wormable RCE, CVSS 9.8) + Hyper-V Escape
- **Date detected:** 2026-05-25 (Patch Tuesday 2026-05-13)
- **Status:** 🟠 Patched — No zero-days; apply Windows Update immediately; no CISA KEV additions for this batch
- **Category:** CVE > Infrastructure > Windows
- **Affects us:** 🟠 Could affect us (all Windows dev machines; critical for DC operators)
- **Summary:** Microsoft's May 13, 2026 Patch Tuesday addressed 138 CVEs (30 Critical, no zero-days — first
  zero-day-free Patch Tuesday since June 2024). Critical highlights:
  **CVE-2026-41096** (CVSS 9.8): Heap overflow in Windows DNS Client triggered by a malicious DNS response.
  Unauthenticated, no user interaction — attacker with MitM position or rogue DNS server achieves RCE on
  Windows 11, Server 2022/2025. Potentially wormable.
  **CVE-2026-41089** (CVSS 9.8): Stack overflow in Windows Netlogon — unauthenticated remote attacker sends
  crafted network request to domain controller for full DC compromise. Wormable. Affects Windows Server
  2012–2025. Highest priority fix for any environment with domain controllers.
  **CVE-2026-40402** (CVSS 9.3): Hyper-V guest-to-host VM escape.
  **CVE-2026-42826** (Azure DevOps, CVSS 10.0): Information disclosure — already fully mitigated by Microsoft
  in cloud infrastructure; no customer action required.
  Note: Defender zero-days (CVE-2026-41091/45498, THREAT-2026-0032) were patched in engine 1.1.26040.8 separately.
- **Affected versions:** Windows 11, Server 2012–2025 (DNS + Netlogon); Hyper-V hosts
- **Safe version:** Apply May 2026 Cumulative Update via Windows Update
- **Action taken:** Apply May 2026 Patch Tuesday update on all Windows machines; prioritize domain controllers
  for CVE-2026-41089 (Netlogon); verify `winver` shows latest update
- **Last updated:** 2026-05-25
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/microsoft-patches-138-vulnerabilities.html), [Rapid7](https://www.rapid7.com/blog/post/em-patch-tuesday-may-2026/), [Tenable](https://www.tenable.com/blog/microsofts-may-2026-patch-tuesday-addresses-118-cves-cve-2026-41103), [ZDI](https://www.zerodayinitiative.com/blog/2026/5/12/the-may-2026-security-update-review)

### [THREAT-2026-0034] Langflow CVE-2025-34291 + CVE-2026-42048 — CISA KEV, active MuddyWater exploitation (deadline June 4)
- **Date detected:** 2026-05-23 (CISA KEV addition 2026-05-21; active exploitation confirmed)
- **Status:** 🔴 Active exploitation — CISA KEV; federal deadline June 4, 2026; MuddyWater using for initial access
- **Category:** CVE > AI Dev Tool > Workflow Automation
- **Affects us:** 🟠 Could affect us (if team uses Langflow for AI agent/workflow automation)
- **Summary:** CISA added CVE-2025-34291 (CVSS 9.4) in Langflow ≤1.6.9 to the KEV catalog on
  May 21, 2026, with a federal remediation deadline of June 4. The flaw chains overly-permissive
  CORS + a SameSite=None refresh token cookie to enable unauthenticated RCE and full account
  takeover — exposing ALL API keys and tokens stored in the Langflow workspace. Active
  exploitation linked to **MuddyWater** (Iranian state-sponsored group) using this for initial
  network access. Additionally, CVE-2026-42048 (CVSS 9.6, path traversal in Langflow <1.9.0)
  allows reading arbitrary files. Both fixed in Langflow ≥1.9.0. CISA simultaneously added
  Trend Micro Apex One CVE-2026-34926 (CVSS 6.7, directory traversal in on-prem endpoint agent,
  allows injecting malicious code distributed to all connected agents) with the same June 4 deadline.
- **Affected versions:** Langflow ≤1.6.9 (CVE-2025-34291); Langflow <1.9.0 (CVE-2026-42048);
  Trend Micro Apex One on-premise (CVE-2026-34926)
- **Safe version:** Langflow ≥1.9.0; Trend Micro Apex One with CVE-2026-34926 patch applied
- **IOCs:** N/A
- **Action taken:** Patch Langflow to ≥1.9.0 (fixes both CVEs); if previously running ≤1.6.9,
  rotate ALL API keys/tokens stored in Langflow workspaces immediately; for Trend Micro Apex One
  on-prem: apply CVE-2026-34926 patch before June 4
- **Last updated:** 2026-05-23
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/cisa-adds-exploited-langflow-and-trend.html), [Obsidian Security](https://www.obsidiansecurity.com/blog/cve-2025-34291-critical-account-takeover-and-rce-vulnerability-in-the-langflow-ai-agent-workflow-platform), [CISA KEV](https://www.cisa.gov/known-exploited-vulnerabilities-catalog)

### [THREAT-2026-0045] node-ipc npm supply chain — expired domain maintainer takeover, DNS TXT exfiltration
- **Date detected:** 2026-05-26 (attack occurred 2026-05-14; missed in previous scans)
- **Status:** 🟠 Contained — malicious versions removed; rotate credentials if installed; no worm propagation
- **Category:** Supply Chain > npm
- **Affects us:** 🟠 Could affect us (node-ipc is a transitive dependency in many Node.js projects; 10M+ weekly downloads)
- **Summary:** On May 14, 2026, three malicious versions of `node-ipc` (9.1.6, 9.2.3, 12.0.1) were simultaneously
  published to npm via a compromised inactive maintainer account (`atiertant`). Attack vector: the maintainer's email
  domain `atlantis-software.net` expired January 10, 2025 and was re-registered by the attacker on May 7, 2026 — a
  classic expired-domain maintainer account takeover. The malicious payload (80 KB obfuscated IIFE appended to
  `node-ipc.cjs`) fires unconditionally on every `require('node-ipc')`, silently harvesting 90+ credential categories
  (AWS, Azure, GCP, SSH keys, GitHub CLI, **Claude AI and Kiro IDE settings**, Terraform state, Kubernetes tokens,
  database passwords, shell history). **Novel exfiltration technique:** data is compressed and exfiltrated via DNS TXT
  queries to `bt.node.js.<attacker-domain>` masquerading as Azure infrastructure — bypassing standard HTTP egress
  monitoring. Not a self-propagating worm (unlike Shai-Hulud), but high impact given download volume.
- **Affected versions:** node-ipc 9.1.6, 9.2.3, 12.0.1
- **Safe version:** Any version OTHER than the three above (9.1.5, 9.2.2, 11.x are clean)
- **IOCs:** `atiertant` npm account; DNS exfiltration to `azurestaticprovider.net`; `bt.node.js.*` DNS TXT patterns
- **Action taken:** Run `npm list node-ipc` across all projects (check transitive deps); if 9.1.6, 9.2.3, or 12.0.1
  found, rotate ALL credentials — cloud keys, SSH keys, GitHub tokens, Claude AI API keys; monitor DNS logs for
  `azurestaticprovider.net` queries
- **Last updated:** 2026-05-26
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/stealer-backdoor-found-in-3-node-ipc.html), [StepSecurity](https://www.stepsecurity.io/blog/node-ipc-npm-supply-chain-attack), [BleepingComputer](https://www.bleepingcomputer.com/news/security/popular-node-ipc-npm-package-compromised-to-steal-credentials/), [Snyk](https://snyk.io/blog/malicious-node-ipc-versions-published-npm/), [Datadog Security Labs](https://securitylabs.datadoghq.com/articles/node-ipc-npm-malware-analysis/), [Socket.dev](https://socket.dev/blog/node-ipc-package-compromised)

### [THREAT-2026-0046] CVE-2026-45585 "YellowKey" — Windows BitLocker bypass via WinRE physical access
- **Date detected:** 2026-05-26 (disclosed publicly 2026-05-22; Microsoft mitigation 2026-05-20)
- **Status:** 🟡 No patch yet — Microsoft mitigation available (TPM+PIN); no confirmed in-the-wild exploitation
- **Category:** CVE > Infrastructure > Windows
- **Affects us:** 🟡 Low-to-medium risk (affects physical security of dev laptops/workstations; relevant if machines are unattended)
- **Summary:** CVE-2026-45585 (CVSS 6.8) is a BitLocker security feature bypass disclosed by researcher Chaotic Eclipse
  (Nightmare-Eclipse) on May 22, 2026. An attacker with **brief physical access** can place specially crafted FsTx files
  on a USB drive or EFI partition, reboot the target Windows 11 / Server 2025 machine into Windows Recovery Environment
  (WinRE), and trigger an unrestricted shell via Ctrl key hold — bypassing BitLocker encryption and gaining read access to
  encrypted storage. No specialized hardware tools required — attack uses only native Windows functionality and leaves no
  persistent artifacts. Microsoft acknowledged the flaw on May 20 and published mitigations (no full patch released).
  **Mitigation:** Switch BitLocker from "TPM-only" to "TPM+PIN" mode — this requires the PIN at decryption and blocks
  YellowKey. Affects Windows 11 (24H2, 25H2, 26H1) and Windows Server 2025.
- **Affected versions:** Windows 11 versions 24H2/25H2/26H1 (x64); Windows Server 2025 (including Server Core)
- **Safe config:** BitLocker with "TPM+PIN" protector mode (not TPM-only)
- **IOCs:** N/A (physical attack; no network IOCs)
- **Action taken:** On all dev laptops/workstations with BitLocker: run `manage-bde -protectors -get C:` and verify
  "TPM And PIN" is listed; if only "TPM", run `manage-bde -protectors -add C: -TPMAndPIN` and set a PIN
- **Last updated:** 2026-05-26
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/microsoft-releases-mitigation-for.html), [Help Net Security](https://www.helpnetsecurity.com/2026/05/20/yellowkey-bitlocker-mitigation-cve-2026-45585/), [Eclypsium](https://eclypsium.com/blog/yellowkey-bitlocker-bypass-windows-recovery-environment/), [SOCPrime](https://socprime.com/blog/cve-2026-45585-yellowkey-bitlocker-bypass/)

### [THREAT-2026-0047] Claude Code SOCKS5 sandbox bypass — 5.5-month silent exposure, no CVE published
- **Date detected:** 2026-05-26 (publicly disclosed ~2026-05-20; silently patched 2026-04-01 in v2.1.90)
- **Status:** 🟠 Patched — upgrade to ≥ v2.1.90; audit credentials if ran wildcard sandbox allowlists pre-patch
- **Category:** AI Dev > Claude Code
- **Affects us:** 🔴 Yes — we use Claude Code; the vulnerability was present for 5.5 months without disclosure
- **Summary:** A SOCKS5 hostname null-byte injection vulnerability affected every Claude Code release from v2.0.24
  (sandbox GA, October 20, 2025) through v2.1.89 — approximately 130 published versions over 5.5 months. The flaw
  allowed an attacker to inject a null byte into a SOCKS5 hostname to bypass the sandbox network allowlist: given an
  allowlist like `*.google.com`, the attacker sends `attacker-host.com\x00.google.com` — the allowlist filter approves
  the trailing `.google.com` but the OS truncates at `\x00` and dials `attacker-host.com`. When paired with prompt
  injection, this allowed Claude to read hidden instructions then exfiltrate environment variables, API keys, and source
  code via raw SOCKS5 (bypassing standard HTTP egress logs). Anthropic silently patched the issue in v2.1.90 on April 1,
  2026 with no mention in release notes and no CVE assignment (CVE-2025-66479 exists for the sandbox runtime, not Claude
  Code itself). This is **distinct** from THREAT-2026-0003 (sourcemap leak and command-padding bypass). Disclosed
  publicly around May 20 by researcher Aonan Guan (same researcher as "Comment and Control" — THREAT-2026-0035).
- **Affected versions:** Claude Code v2.0.24 through v2.1.89
- **Safe version:** Claude Code ≥ v2.1.90
- **IOCs:** Outbound SOCKS5 traffic to unexpected hosts (bypasses HTTP egress monitors); null bytes in SOCKS5 hostnames
- **Action taken:** Verify Claude Code is ≥ v2.1.90 on all machines (`claude --version`); if ran wildcard network
  allowlists between Oct 20, 2025 and April 1, 2026, audit SOCKS5-level egress logs and rotate all credentials reachable
  from Claude Code sessions
- **Last updated:** 2026-05-26
- **Sources:** [The Register](https://www.theregister.com/security/2026/05/20/even-claude-agrees-hole-in-its-sandbox-was-real-and-dangerous/5243662), [SecurityWeek](https://www.securityweek.com/anthropic-silently-patches-claude-code-sandbox-bypass/), [CybersecurityNews](https://cybersecuritynews.com/claude-codes-network-sandbox-vulnerability/), [Aonan Guan research](https://oddguan.com/blog/second-time-same-sandbox-anthropic-claude-code-network-allowlist-bypass-data-exfiltration/)

### [THREAT-2026-0048] CVE-2026-6973 — Ivanti EPMM authenticated RCE (CISA KEV, deadline May 10 — PASSED)
- **Date detected:** 2026-05-26 (disclosed 2026-05-07; CISA KEV deadline 2026-05-10 — missed in previous scans)
- **Status:** 🟡 Post-deadline — patch available; federal deadline passed; apply immediately if using Ivanti EPMM
- **Category:** CVE > Infrastructure > MDM
- **Affects us:** 🟡 Low direct risk (only if using Ivanti Endpoint Manager Mobile on-prem)
- **Summary:** CVE-2026-6973 (CVSS 7.2) is an improper input validation vulnerability in Ivanti Endpoint Manager
  Mobile (EPMM) that allows a remotely authenticated administrator to achieve remote code execution. Ivanti confirmed
  limited in-the-wild exploitation at time of disclosure (May 7, 2026). CISA added to KEV with a 3-day federal
  remediation deadline of May 10, 2026 (now passed). As of disclosure date, Shadowserver tracked 800+ internet-exposed
  EPMM instances. Four additional CVEs were patched alongside it: CVE-2026-5786, CVE-2026-5787, CVE-2026-5788
  (privilege escalation, certificate exposure, method invocation), CVE-2026-7821 (information disclosure).
  Only affects on-prem EPMM; Ivanti Neurons for MDM (cloud) and Ivanti EPM are not affected.
- **Affected versions:** Ivanti EPMM ≤ 12.8.0.0 (all versions before patch)
- **Safe version:** EPMM 12.6.1.1, 12.7.0.1, or 12.8.0.1
- **IOCs:** N/A
- **Action taken:** If using Ivanti EPMM on-prem, upgrade to 12.6.1.1 / 12.7.0.1 / 12.8.0.1 immediately; rotate
  EPMM admin credentials and any privileged integration credentials; if previously exploited via CVE-2026-1281/CVE-2026-1340
  and credentials were already rotated, risk is reduced
- **Last updated:** 2026-05-26
- **Sources:** [The Hacker News](https://thehackernews.com/2026/05/ivanti-epmm-cve-2026-6973-rce-under.html), [SecurityWeek](https://www.securityweek.com/ivanti-patches-epmm-zero-day-exploited-in-targeted-attacks/), [SOCRadar](https://socradar.io/blog/cve-2026-6973-rce-ivanti-epmm-cisa-kev/), [Help Net Security](https://www.helpnetsecurity.com/2026/05/08/ivanti-epmm-zero-day-cve-2026-6973/)

### [THREAT-2026-0049] CVE-2026-26980 — Ghost CMS SQL injection → large-scale ClickFix campaign (700+ sites)
- **Date detected:** 2026-05-26 (exploitation campaign confirmed 2026-05-24–25)
- **Status:** 🔴 Active exploitation — 700+ sites compromised including Harvard, Oxford, DuckDuckGo; upgrade Ghost immediately
- **Category:** CVE > Web Platform / Threat Actor
- **Affects us:** 🟠 Could affect us if any project uses Ghost CMS; also affects developer awareness (fake Cloudflare prompts targeting any user browsing compromised sites)
- **Summary:** CVE-2026-26980 is a critical SQL injection vulnerability in Ghost CMS (versions 3.24.0–6.19.0) discovered
  and documented by XLab (Qianxin). The flaw is in the slug filter ordering functionality, where user-supplied slug
  values were concatenated directly into SQL CASE statements (no parameterized queries). An unauthenticated attacker can
  read arbitrary data from the site database — including **admin API keys**. Once admin access is obtained, attackers
  inject malicious JavaScript into Ghost articles; the JS fingerprints visitors and serves a fake Cloudflare CAPTCHA
  (ClickFix lure) instructing them to paste a command in their Windows CMD, which drops malware (DLL loaders, JS
  droppers, `UtilifySetup.exe` Electron malware). Over 700 domains confirmed compromised, including university portals
  (Harvard, Oxford, Auburn), AI/SaaS companies, media outlets, fintech firms, and security sites. Payloads observed:
  DLL loaders and Electron-based malware. **Developer awareness note:** Any developer browsing news/documentation on
  affected Ghost sites could be exposed to ClickFix lures.
- **Affected versions:** Ghost 3.24.0 through 6.19.0
- **Safe version:** Ghost ≥ 6.19.1
- **IOCs:** Fake Cloudflare verification iframes injected into pages; `UtilifySetup.exe` Electron payload
- **Action taken:** (1) If any project uses Ghost CMS: upgrade to ≥ 6.19.1 immediately; (2) Warn team: if you see a
  Cloudflare "verify you are human" prompt asking you to paste a command in CMD/Terminal on ANY site — DO NOT execute
  it, this is a ClickFix attack; (3) Check admin API keys if running Ghost < 6.19.1 — assume compromised
- **Last updated:** 2026-05-26
- **Sources:** [BleepingComputer](https://www.bleepingcomputer.com/news/security/ghost-cms-sql-injection-flaw-exploited-in-large-scale-clickfix-campaign/), [The Hacker News](https://thehackernews.com/2026/05/ghost-cms-cve-2026-26980-exploited-to.html), [TechTimes](https://www.techtimes.com/articles/317134/20260525/ghost-cms-sql-injection-hits-700-sites-harvard-duckduckgo-serve-fake-cloudflare-malware.htm)

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
| 2026-05-19 | THREAT-2026-0028 | npm packages | @antv/* (May 19 burst, ~22 min window) | TeamPCP Phase 7 — 300+ malicious versions, 16M weekly downloads |
| 2026-05-19 | THREAT-2026-0028 | PyPI package | durabletask==1.4.1, 1.4.2, 1.4.3 | TeamPCP Phase 7 — Microsoft Azure Python SDK; 400K monthly downloads |
| 2026-05-19 | THREAT-2026-0028 | Config file | ~/.claude/settings.json hooks section | TeamPCP Phase 7 persistence — unexpected hooks entries reinstall malware |
| 2026-05-20 | THREAT-2026-0029 | GitHub repos | ~4,000 GitHub internal repos (claimed by UNC6780) | TeamPCP GitHub internal breach — investigation ongoing |
| 2026-05-18 | THREAT-2026-0029 | VS Code extension | nrwl.angular-console@18.95.0 (Nx Console) | TeamPCP GitHub breach entry vector — trojanized VS Code extension; removed from Marketplace ~11 min after publish |
| 2026-05-18 | THREAT-2026-0031 | Domain | t.m-kosche[.]com | TeamPCP Phase 7/7b exfiltration endpoint — actions-cool GitHub Action + npm/PyPI Shai-Hulud shared C2 |
| 2026-05-18 | THREAT-2026-0031 | GitHub Action | actions-cool/issues-helper (all tags) | All tags redirected to imposter credential-stealing commit; exfil via t.m-kosche[.]com |
| 2026-05-18 | THREAT-2026-0031 | GitHub Action | actions-cool/maintain-one-comment (all tags) | 15 tags redirected; same imposter commit and exfil domain as issues-helper |
| 2026-05-22 | THREAT-2026-0038 | Packagist packages | laravel-lang/lang, laravel-lang/attributes, laravel-lang/http-statuses, laravel-lang/actions | 700+ malicious tags via GitHub fork exploit; cross-platform credential stealer |
| 2026-05-22 | THREAT-2026-0041 | PyPI package | eth-security-auditor@0.1.0 | TrapDoor — earliest observed package; crypto/AI developer targeting |
| 2026-05-22 | THREAT-2026-0041 | Config file vector | .cursorrules / CLAUDE.md (zero-width Unicode U+200B/C/D/FEFF/2060) | TrapDoor — hidden prompt injection in AI coding assistant config files |
| 2026-05-22 | THREAT-2026-0041 | Exfil channel | GitHub Gist (XOR key: cargo-build-helper-2026) | TrapDoor — Crates.io payload keystore exfiltration |
| 2026-04-22 | THREAT-2026-0004 | npm worm | CanisterSprawl | TeamPCP Update 008 — cross-registry self-propagating worm; jumps npm→PyPI if token found |
| 2026-05-14 | THREAT-2026-0045 | npm packages | node-ipc@9.1.6, 9.2.3, 12.0.1 | Expired domain maintainer takeover; 90+ credential categories; DNS TXT exfiltration |
| 2026-05-14 | THREAT-2026-0045 | Domain | azurestaticprovider.net | node-ipc malware C2 — DNS TXT queries for credential exfiltration |
| 2026-05-14 | THREAT-2026-0045 | npm account | atiertant (atlantis-software.net) | Expired domain re-registered May 7 to hijack node-ipc maintainer account |

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
| next | npm | 13 CVEs: SSRF + 4 auth bypass + DoS + XSS + cache poisoning (May 2026 release) | 2026-05-17 | Safe if ≥ 15.5.18 or ≥ 16.2.6 (self-hosted only) — UPDATED |
| linux-kernel | System | Dirty Frag (CVE-2026-43284/-43500) + Fragnesia (CVE-2026-46300) LPE cluster | 2026-05-17 | Patch per distro advisory; interim: blacklist esp4 esp6 rxrpc |
| cline | npm | Clinejection (Feb 2026) — prompt injection supply chain attack | 2026-05-17 | Safe if ≠ 2.3.0 (clean version 2.4.0+) |
| @antv/* | npm | TeamPCP Phase 7 — entire ecosystem compromised May 19 | 2026-05-20 | Avoid any @antv/* version published May 19, 2026 |
| durabletask | PyPI | TeamPCP Phase 7 — Microsoft Azure Python SDK; 3 malicious versions | 2026-05-20 | Safe if ≤ 1.4.0; do NOT install 1.4.1/1.4.2/1.4.3 |
| ~/.claude/settings.json | Config | TeamPCP Phase 7 persistence target — hooks used to reinstall malware | 2026-05-20 | Inspect hooks section after any npm/pip install |
| actions-cool/issues-helper | GitHub Actions | TeamPCP Phase 7b — all tags redirected to imposter commit; exfil via t.m-kosche[.]com | 2026-05-23 | Do NOT use tag-based reference; pin to known-good SHA only |
| actions-cool/maintain-one-comment | GitHub Actions | TeamPCP Phase 7b — same imposter commit attack as issues-helper | 2026-05-23 | Do NOT use tag-based reference; pin to known-good SHA only |
| langflow | PyPI | CVE-2025-34291 (CVSS 9.4, RCE) + CVE-2026-42048 (CVSS 9.6, path traversal); CISA KEV; MuddyWater exploiting | 2026-05-23 | Safe if ≥ 1.9.0; if was ≤ 1.6.9: rotate all stored API keys |
| linux-kernel (ptrace) | System | CVE-2026-46333 ssh-keysign-pwn — 4th Linux LPE in cluster; reads SSH host keys + shadow | 2026-05-23 | Safe if ≥ 6.18.31 (or ≥ 7.0.8, ≥ 6.12.89, ≥ 6.6.139); this environment (6.18.5) vulnerable |
| nginx | System/Infra | CVE-2026-42945 "NGINX Rift" — 18-year-old heap buffer overflow in rewrite module; unauthenticated RCE; actively exploited | 2026-05-24 | Safe if OSS ≥ 1.30.1 or ≥ 1.31.0; Plus ≥ R36 P4; Ingress NGINX controller update required |
| vm2 | npm | 13 critical sandbox escape CVEs (CVSS up to 10.0); public PoCs available | 2026-05-24 | Safe if ≥ 3.11.2 |
| laravel-lang/* | Packagist | Supply chain attack May 22–23; 700+ malicious tags via fork exploit; malicious versions removed | 2026-05-24 | Rotate credentials if installed May 22–24; safe on current Packagist versions |
| CLAUDE.md / .cursorrules | Config files | TrapDoor — TTP: hidden zero-width Unicode chars used to inject malicious instructions into Claude Code and Cursor | 2026-05-25 | Inspect ALL repos: `grep -rP '[\x{200b}\x{200c}\x{200d}\x{feff}\x{2060}]' . --include="CLAUDE.md" --include=".cursorrules"` |
| xinference | PyPI | TeamPCP Update 008 (Apr 22) — compromised simultaneous with Checkmarx KICS Docker Hub | 2026-05-25 | Verify version not from Apr 22 batch |
| checkmarx-kics | Docker Hub | TeamPCP Update 008 (Apr 22) — Docker Hub image compromised | 2026-05-25 | Avoid images from Apr 22; use SHA-pinned digest |
| AI agent skills (ClawHub/skills.sh) | Skills marketplace | ToxicSkills: 36% contain prompt injection; 13.4% critical issues; 76 confirmed malicious skills | 2026-05-25 | Treat as untrusted code; apply PROMPT-C vetting before installing any skill |
| Windows (DNS Client / Netlogon) | System | CVE-2026-41096 (CVSS 9.8 DNS RCE) + CVE-2026-41089 (CVSS 9.8 Netlogon wormable DC RCE) — Patch Tuesday May 2026 | 2026-05-25 | Apply May 2026 Cumulative Update; DCs are highest risk for CVE-2026-41089 |
| node-ipc | npm | Expired-domain maintainer takeover May 14; versions 9.1.6, 9.2.3, 12.0.1 malicious; DNS TXT exfiltration | 2026-05-26 | Safe if NOT one of the 3 compromised versions; run `npm list node-ipc` to check transitives |
| ghost | npm / Self-hosted | CVE-2026-26980 — SQL injection → admin API key theft → ClickFix malware injection; 700+ sites compromised | 2026-05-26 | Safe if ≥ 6.19.1; if was 3.24.0–6.19.0: rotate admin API keys immediately |
| Exchange Server (on-prem) | System | CVE-2026-42897 — OWA XSS zero-day; CISA FCEB deadline May 29, 2026; EEMS mitigation enabled by default | 2026-05-26 | Apply EEMS URL rewrite mitigation NOW; full patch pending; deadline in 3 days |

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
