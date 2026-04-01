# Prompt C — Dependency Vetting (Pre-Install)

> **Model:** Claude Sonnet 4.6
> **Frequency:** ALWAYS before installing something new
> **Especially critical when the dependency was suggested by an AI**

---

## How to use this prompt

1. **Before** running `npm install`, `pip install`, or similar
2. Open Claude Code (model **Sonnet 4.6**)
3. Paste the prompt below, filling in the 4 bracketed fields
4. Especially important if the dependency was suggested by Claude Code, Cursor, or any AI

---

## Prompt

````markdown
I'm about to install a new dependency.

**Package:** [NAME]
**Registry:** [npm / PyPI / cargo / other]
**Target project:** [which]
**Who suggested it?:** [Me / Claude Code / Cursor / Antigravity / Copilot]

---

Check the Knowledge Base (`docs/knowledge-base.md` in the SecurityChecks
repo) to see if this package has already been evaluated or is under
surveillance.

Then search the web and evaluate:

### 1. Does it actually exist?
- Verify on the official registry (npmjs.com / pypi.org)
- If an AI suggested it: could it be a hallucination (slopsquat)?
- Is the name exactly correct? Are there typosquats?

### 2. Is it trustworthy?
- Maintainer(s): who? how many? company or individual?
- Activity: last release, last commit, open issues
- Does it use trusted publishing (OIDC) or classic tokens?
- Weekly downloads and trend

### 3. Is it safe?
- Historical CVEs
- Has it been compromised before?
- GitHub Advisory Database
- Socket.dev score if available
- Does it have postinstall scripts? What do they do?
- Number of transitive dependencies

### 4. Is it necessary?
- Is there a native alternative or one already included in our framework?
- Is there an option with fewer dependencies?
- Can we write the functionality ourselves (~50 lines)?

### 5. Verdict

- **INSTALL** — Safe, trustworthy, necessary
- **INSTALL WITH CAUTION** — [what precautions]
- **FIND ALTERNATIVE** — [why and which ones]
- **DO NOT INSTALL** — [concrete reason]

If approved → Command with exact pinned version.
Record the evaluation in the Knowledge Base.
````
