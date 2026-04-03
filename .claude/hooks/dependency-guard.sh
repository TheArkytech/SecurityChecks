#!/bin/bash
# dependency-guard.sh — Pre-install gate for Claude Code
# Blocks package install commands and requires vetting (PROMPT-C-VETTING.md) first.
# Works without jq — parses JSON with pure bash.

INPUT=$(cat)

# Extract the command from tool_input.command in the JSON
# Handles: "command": "npm install lodash"
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/^"command"[[:space:]]*:[[:space:]]*"//;s/"$//')

# If we couldn't extract a command, allow through
if [ -z "$COMMAND" ]; then
  exit 0
fi

# --- ALLOW: non-package-manager commands (fast path) ---
# Only check commands that start with a package manager keyword
if ! echo "$COMMAND" | grep -qE '^\s*(npm|npx|pnpm|yarn|pip3?|pipenv|cargo|go)\s'; then
  exit 0
fi

# --- ALLOW: read-only / safe commands ---
# npm/pnpm/yarn: audit, list, outdated, view, info, why, ls, pack, test, run, start, build
if echo "$COMMAND" | grep -qE '^\s*(npm|pnpm|yarn)\s+(audit|list|ls|outdated|view|info|why|pack|test|run|start|build|init|login|whoami|version|config|cache|help)\b'; then
  exit 0
fi

# pip: list, show, freeze, check
if echo "$COMMAND" | grep -qE '^\s*pip3?\s+(list|show|freeze|check|--version)\b'; then
  exit 0
fi

# cargo: build, test, run, check, clippy, fmt, bench, doc
if echo "$COMMAND" | grep -qE '^\s*cargo\s+(build|test|run|check|clippy|fmt|bench|doc)\b'; then
  exit 0
fi

# go: build, test, run, vet, fmt
if echo "$COMMAND" | grep -qE '^\s*go\s+(build|test|run|vet|fmt|mod tidy)\b'; then
  exit 0
fi

# --- ALLOW: lockfile restore (no new packages) ---
# npm ci (always a lockfile restore)
if echo "$COMMAND" | grep -qE '^\s*npm\s+ci\b'; then
  exit 0
fi

# pip install -r requirements.txt (lockfile restore)
if echo "$COMMAND" | grep -qE '^\s*pip3?\s+install\s+(-r|--requirement)\s'; then
  exit 0
fi

# --- BLOCK: package install commands ---

# npm install/i/add — block if it contains a package name (non-flag argument after install)
# Strip the "npm install/i/add" prefix, then check if any non-flag token remains
if echo "$COMMAND" | grep -qE '^\s*npm\s+(install|i|add)\b'; then
  # Extract everything after "npm install/i/add"
  ARGS=$(echo "$COMMAND" | sed -E 's/^\s*npm\s+(install|i|add)\s*//')
  # Remove all flag tokens (words starting with -)
  PKG_TOKENS=$(echo "$ARGS" | tr ' ' '\n' | grep -v '^\s*$' | grep -v '^-')
  # If any non-flag token remains, it's a package name — block
  if [ -n "$PKG_TOKENS" ]; then
    cat >&2 <<'EOF'
BLOCKED: New dependency installation detected.

Before installing any package, you MUST run the vetting process:

1. Read and follow docs/PROMPT-C-VETTING.md in this repo
2. Verify the package exists on the official registry
3. Check for known CVEs and supply chain compromises
4. Check docs/knowledge-base.md for prior evaluations
5. Only after vetting passes, install with: npm install --ignore-scripts <pkg>@<exact-version>

This is enforced by AGENTS.md rule #1: "Never install packages without vetting."
EOF
    exit 2
  fi
  # No package name — lockfile restore, allow through
  exit 0
fi

# pnpm add, yarn add
if echo "$COMMAND" | grep -qE '^\s*(pnpm|yarn)\s+add\s'; then
  cat >&2 <<'EOF'
BLOCKED: New dependency installation detected.

Before installing any package, you MUST run the vetting process:

1. Read and follow docs/PROMPT-C-VETTING.md in this repo
2. Verify the package exists on the official registry
3. Check for known CVEs and supply chain compromises
4. Check docs/knowledge-base.md for prior evaluations
5. Only after vetting passes, install with --ignore-scripts and pin an exact version

This is enforced by AGENTS.md rule #1: "Never install packages without vetting."
EOF
  exit 2
fi

# pip install <pkg> (not -r)
if echo "$COMMAND" | grep -qE '^\s*pip3?\s+install\s+[^-]'; then
  cat >&2 <<'EOF'
BLOCKED: New Python dependency installation detected.

Before installing any package, you MUST run the vetting process:

1. Read and follow docs/PROMPT-C-VETTING.md in this repo
2. Verify the package exists on pypi.org
3. Check for known CVEs and supply chain compromises
4. Check docs/knowledge-base.md for prior evaluations
5. Only after vetting passes, install with an exact pinned version

This is enforced by AGENTS.md rule #1: "Never install packages without vetting."
EOF
  exit 2
fi

# cargo add
if echo "$COMMAND" | grep -qE '^\s*cargo\s+add\s'; then
  cat >&2 <<'EOF'
BLOCKED: New Rust dependency installation detected.

Before installing any package, you MUST run the vetting process:
1. Read and follow docs/PROMPT-C-VETTING.md in this repo
2. Only after vetting passes, add with an exact pinned version

This is enforced by AGENTS.md rule #1: "Never install packages without vetting."
EOF
  exit 2
fi

# go get (adding dependencies)
if echo "$COMMAND" | grep -qE '^\s*go\s+get\s'; then
  cat >&2 <<'EOF'
BLOCKED: New Go dependency installation detected.

Before installing any package, you MUST run the vetting process:
1. Read and follow docs/PROMPT-C-VETTING.md in this repo
2. Only after vetting passes, add with an exact pinned version

This is enforced by AGENTS.md rule #1: "Never install packages without vetting."
EOF
  exit 2
fi

# --- DEFAULT: allow everything else ---
exit 0
