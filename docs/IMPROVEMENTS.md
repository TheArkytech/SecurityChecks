# Security Improvements — Roadmap

Improvements ordered by impact/effort. Check off each one when completed.

---

## Immediate (this week)

- [x] **1. `.npmrc` in all projects**
  ```ini
  ignore-scripts=true
  package-lock=true
  audit=true
  audit-level=high
  ```
  Base file included in this repo. Copy to each project.

- [ ] **2. GitHub: Enable free security features**
  - **Dependabot alerts** → Enable in Settings > Security
  - **Secret scanning** → Detects accidentally committed API keys
  - **Push protection** → Blocks push if it contains a detected secret
  - **Branch protection** on main → Require PR reviews

- [x] **3. Pre-commit hook for secrets**
  ```bash
  # Install gitleaks
  brew install gitleaks  # macOS
  ```
  `.pre-commit-config.yaml` file included in this repo. Activate with `pre-commit install`.

- [ ] **4. npm audit in CI**
  ```yaml
  # In GitHub Actions, add step:
  - name: Security audit
    run: npm audit --audit-level=high
  ```

---

## Short term (this month)

- [ ] **5. Socket.dev (free for open source)**
  Monitors your dependencies and alerts you about compromised packages
  in real time. Has a GitHub App that comments on PRs.

- [ ] **6. Pin GitHub Actions by SHA**
  ```yaml
  # Insecure (mutable tag, can be hijacked)
  - uses: actions/checkout@v4

  # Secure (immutable SHA)
  - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
  ```
  Tool to automate: StepSecurity `secure-repo`

- [ ] **7. Lockfile enforcement in CI**
  ```yaml
  # Use npm ci instead of npm install in CI
  - name: Install dependencies
    run: npm ci --ignore-scripts
  ```

- [ ] **8. SBOM generation**
  ```bash
  npx @cyclonedx/cyclonedx-npm --output-file sbom.json
  ```

---

## Medium term (next 2-3 months)

- [ ] **9. Leaked credentials monitoring**
  - Set up HaveIBeenPwned alerts for team emails
  - GitHub secret scanning partner program

- [ ] **10. Network-level protections**
  - Block known C2 domains at DNS level (IOCs from the Knowledge Base)
  - Consider Cloudflare Gateway or similar for the team

- [ ] **11. MCP Server security**
  For each connected MCP server, periodically review:
  - What permissions each one has
  - Whether any have had security incidents
  - Whether connection tokens are rotated

- [ ] **12. Review Cursor / Claude Code configuration**
  - Verify that .cursorrules and AI tool configs in repos are legitimate
  - Don't automatically accept rules files from cloned repos
  - Review what context is sent to AI providers
