---
name: opencode-research
description: >
  Run a code research or exploration task using opencode LLM CLI.
  Use when the user wants to explore a codebase, investigate how something works,
  trace logic, or answer a code question using opencode as the AI agent.
  Trigger: "use opencode to research X", "ask opencode about Y", "explore Z with opencode",
  or invokes /opencode-research.
---

## Purpose

Delegate code research/exploration tasks to `opencode run` CLI. Useful when the user wants a second AI agent to investigate code, trace logic, or answer questions about the codebase with full tool access.

## How to Execute

Run the task via shell:

```bash
opencode run "<research prompt>" 2>&1
```

Key flags:
- `-m <provider/model>` — override model if user specifies one (e.g. `anthropic/claude-sonnet-4-5`)
- `--dir <path>` — run in specific directory (default: current working dir)
- `--title "<short title>"` — give session a meaningful name

## When to Use

- User wants opencode to explore or investigate any part of the codebase
- Research question benefits from opencode's agent loop (multi-step tool use)
- User asks to "research with opencode", "explore using opencode", or similar

## Workflow

1. Extract the research question/task from user message
2. Craft a clear, self-contained prompt for opencode (include file paths, function names, specific questions)
3. Run `opencode run "<prompt>"` via Bash tool
4. Stream output — it may take 30–120 seconds
5. Summarize findings back to user in caveman style

## Prompt Crafting Tips

- Be specific: include file paths, symbol names, what question to answer
- State the expected output format: "List all callers of X", "Explain the flow from A to B"
- Scope it: "only look in `sync_core/`" avoids unnecessary exploration

## Example Invocations

User: "use opencode to research how auth middleware works"

```bash
opencode run \
  "Explore the auth middleware in this codebase. Trace the request flow, explain how tokens are validated, and list the key types and functions involved." \
  --dir /path/to/project \
  --title "auth middleware research"
```

User: "ask opencode to explain the database migration setup"

```bash
opencode run \
  "Explain how database migrations are set up in this project. What tools are used, where are migrations stored, and how are they applied?" \
  --dir /path/to/project \
  --title "db migration exploration"
```
