# AGENTS.md — Security Rules for AI Agents

This file defines mandatory rules for any AI agent (Claude, Cursor, Copilot,
or similar) operating in Arkytech repositories.

---

## Supply Chain Security

1. **Never install packages without vetting.**
   Before running `npm install <pkg>`, `pnpm add <pkg>`, or any equivalent:
   - Check the package on npm: publication date, weekly downloads, maintainer count.
   - If the package has < 1,000 weekly downloads or was published < 30 days ago, STOP and ask the user.
   - Run the Vetting prompt (`docs/PROMPT-C-VETTING.md`) for any new dependency.

2. **Always use `--ignore-scripts` for installs.**
   ```bash
   npm install --ignore-scripts
   npm ci --ignore-scripts
   ```
   Post-install scripts are the #1 vector for supply chain attacks.

3. **Never widen dependency ranges.**
   - Use exact versions (`1.2.3`), never `^1.2.3` or `~1.2.3`.
   - If a `package.json` already has pinned versions, do not add `^` or `~`.

4. **Lockfile is sacred.**
   - Never delete `package-lock.json` or `pnpm-lock.yaml`.
   - Use `npm ci` (not `npm install`) in CI and when reproducing builds.
   - If the lockfile has conflicts, resolve them manually — never regenerate.

## Code Execution

5. **Never execute code from untrusted sources.**
   - Do not run `curl | sh`, `npx <unknown-pkg>`, or download-and-execute patterns.
   - Do not clone and run repos without user approval.
   - Do not eval() or execute dynamically constructed code from external input.

6. **Never disable security tooling.**
   - Do not remove or bypass pre-commit hooks.
   - Do not add `--no-verify` to git commands.
   - Do not modify `.npmrc` to set `ignore-scripts=false`.
   - Do not disable ESLint security rules or similar linters.

## Secrets

7. **Never hardcode secrets.**
   - API keys, tokens, passwords, and credentials go in `.env` files only.
   - `.env` files are gitignored and must never be committed.
   - If you find a hardcoded secret, flag it immediately — do not commit it.

8. **Never expose secrets in logs or output.**
   - Do not `console.log()` environment variables.
   - Do not include secrets in error messages, comments, or documentation.

## GitHub Actions & CI

9. **Pin all GitHub Actions by full SHA.**
   ```yaml
   # Correct
   - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2

   # Wrong — mutable tag, vulnerable to supply chain attack
   - uses: actions/checkout@v4
   ```

10. **Minimize CI permissions.**
    ```yaml
    permissions:
      contents: read
    ```
    Only grant the minimum permissions required for each workflow.

## MCP Servers & External Integrations

11. **Review MCP server permissions periodically.**
    - Each connected MCP server has access tokens.
    - Verify what scopes each token grants.
    - Rotate tokens if a server has a security incident.

12. **Do not auto-connect new MCP servers.**
    - Adding a new MCP integration requires explicit user approval.
    - Verify the server source and permissions before connecting.
