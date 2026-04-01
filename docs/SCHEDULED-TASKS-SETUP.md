# Scheduled Tasks Setup in Claude Code

> Scheduled tasks are configured in the **Claude Code web interface**,
> not in these .md files. The prompt files are reference only.

---

## How it works

Claude Code allows creating **scheduled agents** that run automatically
on a defined schedule. Each execution is an isolated remote session that:

1. Clones the specified repository
2. Executes the prompt with the allowed tools
3. Can commit results back to the repo
4. Shuts down when finished

Frequency is controlled from the web interface, not from the .md files.

---

## Active scheduled tasks

| Task | Prompt | Model | Schedule | Repo |
|---|---|---|---|---|
| Security Radar | [PROMPT-A-RADAR.md](PROMPT-A-RADAR.md) | Sonnet 4.6 | Daily 08:00 Europe/Paris | TheArkytech/SecurityChecks |

---

## How to create or modify scheduled tasks

### From Claude Code CLI

Use the `/schedule` command inside Claude Code to create, list, or
run scheduled tasks.

### From the web interface

1. Go to https://claude.ai/code/scheduled
2. Create a new task or edit an existing one
3. Configure: name, cron expression, model, repo, prompt, tools

### Radar configuration (reference)

```
Name: Arkytech Security Radar (Prompt A)
Cron: 0 6 * * * (6:00 UTC = 8:00 Europe/Paris in summer)
Model: claude-sonnet-4-6
Repo: https://github.com/TheArkytech/SecurityChecks
Tools: Bash, Read, Write, Edit, Glob, Grep, WebSearch, WebFetch
```

---

## Future tasks to consider

| Task | Prompt | Model | Suggested schedule |
|---|---|---|---|
| Weekly Code Auditor | PROMPT-B-AUDITOR.md | Opus 4.6 | Monday 09:00 Europe/Paris |

> **Note on Prompt B:** Currently run manually because it requires
> interaction (scoping questions). Could be automated with a prompt
> that defines a default scope (e.g., audit ArkyHub every Monday).

> **Note on Prompt C:** It's on-demand by nature. Not scheduled.
