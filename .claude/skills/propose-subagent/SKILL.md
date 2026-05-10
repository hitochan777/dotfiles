---
name: propose-subagent
description: Analyzes the current session conversation and proposes one or more Claude Code subagent definitions (ready-to-save .claude/agents/ markdown files) that would accelerate future sessions. Use this skill whenever: the user explicitly asks for subagent or agent proposals; you notice a multi-step workflow repeating itself in the conversation; domain knowledge or constraints had to be re-established; the user says something like "I keep doing this" or "every time I work on X"; a long session is wrapping up; or the user wants to capture a pattern from the current session as a reusable agent. Trigger proactively at natural session endings or when you spot recurring patterns — don't wait to be asked.
---

## What you're doing

You're a session analyst and agent designer. Review the conversation history, extract patterns worth encoding, and produce complete Claude Code agent definitions — so future sessions don't have to rebuild context from scratch.

## Step 1: Analyze the conversation for patterns

Look back through the session and look for:

**High-signal patterns (strong candidates for a subagent):**
- A multi-step workflow that appeared more than once
- Domain knowledge that had to be explained or re-established (project conventions, constraints, architecture)
- Preferences the user expressed — things to always do or never do
- A specialized task with clear inputs and outputs (e.g., writing ADRs, reviewing PRs by a specific rubric, processing a file in a consistent way)
- Tools or commands used repeatedly in the same sequence

**Lower-signal patterns (probably not worth a subagent):**
- A one-off task unlikely to recur
- Something too general — a specialized agent wouldn't improve on the default Claude
- A session too short to reveal a pattern

If no strong patterns emerge, say so briefly. Don't propose an agent just to propose one.

## Step 2: Design each subagent

The goal is to produce agents that are **useful across many projects**, not just the one in this session. The session reveals a *pattern* worth capturing — but the agent should encode the workflow and how to discover project-specific context, not hardcode the specific values from this one project.

**The key principle: encode discovery, not data.**

If the session showed the user re-establishing that their project uses a custom error type, don't write an agent with that type hardcoded. Instead, write an agent that *reads the project's source* at the start of each session to find whatever error type this project uses. The session taught you *what to look for*, not *what to put in*.

Good questions to ask for each potential hardcoded detail:
- "Would this be different in another project?" → if yes, make the agent discover it, not assume it
- "Could I find this by reading the project files?" → if yes, have the agent read those files
- "Is this a universal practice or project-specific?" → universal → encode it; project-specific → discover it

For each pattern worth capturing, design an agent:

**Name**: Short, lowercase, hyphenated. Generic enough to work across projects (e.g., `adr-writer`, `rust-debugger`) — not project-namespaced (not `space-adr-writer`, `myapp-rust-debugger`).

**Description field**: This is the primary trigger — it's what Claude reads to decide whether to invoke this agent in future sessions. Write it to be:
- Specific about the domain and task
- Clear about *when* to use it (including edge cases and proactive triggers)
- Slightly "pushy" — lean toward over-triggering rather than under-triggering

**Tools field** (optional): Restrict only when it genuinely makes sense. A read-only research agent might be restricted to `[Read, Bash, WebSearch]`; a code agent probably shouldn't be restricted. Omit entirely if unrestricted is appropriate.

**System prompt**: Encode the *workflow* and *what to discover*, not the project's specific values. Include:
- What to read at the start to discover this project's conventions (file paths, config, existing examples)
- Workflow steps the agent should follow in order
- Universal best practices and anti-patterns the session revealed
- The *why* behind each step — so the agent can adapt when the project doesn't fit the exact pattern

## Step 3: Present and optionally save

For each proposed agent:
1. Show the full draft markdown file (ready to copy)
2. Give a one-sentence explanation of *why* you're proposing it — what pattern you saw
3. Note the suggested save path: `.claude/agents/<name>.md`

Then ask: "Would you like me to save any of these to `.claude/agents/`?"

If yes, write the file. If the user wants to edit first, help them refine it, then save.

---

## Agent file format

```
---
name: <agent-name>
description: <when-to-use and what-it-does — specific and slightly pushy about triggering>
tools: [Tool1, Tool2]  # optional — omit to give all tools
---

<system prompt>
```

Available tools: `Bash`, `Read`, `Edit`, `Write`, `WebSearch`, `WebFetch`, `Agent`

---

## What makes a good system prompt

- **Start with discovery steps**: Tell the agent what to read first to learn this project's conventions (e.g., "Read existing ADRs to find the format and storage path", "Check Cargo.toml and src/error.rs to find the project's error type")
- **Encode the workflow, not the values**: "find the custom error type and use it" beats "use SpaceError"
- **Explain the why**: Constraints the session revealed should come with their reason — this lets the agent adapt to similar-but-not-identical situations
- **Keep it project-agnostic**: A future user of this agent may be working on a completely different codebase. Don't hardcode project names, type names, file paths, or architecture details from the current session
- **Capture universal practices**: Things the session revealed that apply broadly (e.g., "always verify compilation before running tests") are worth encoding even if they're obvious — they were clearly worth making explicit

---

## Example

If the conversation showed the user writing Architecture Decision Records with a consistent structure, and having to correct Claude on the status values:

---
**Proposed: `adr-writer`**
*Pattern observed: You wrote 3 ADRs this session using a consistent structure, and had to correct Claude on valid status values. This workflow and the correction are worth encoding — but the format and paths should be discovered from the project, not hardcoded.*

Save to: `.claude/agents/adr-writer.md`

```markdown
---
name: adr-writer
description: Creates and maintains Architecture Decision Records (ADRs) following the project's established format. Use whenever the user wants to document a technical decision, draft a new ADR, or review an existing one. Trigger proactively when the conversation involves choosing between technical approaches, design tradeoffs, or when the user says "we decided to..." or "let's write this up".
---

You write Architecture Decision Records (ADRs) for the current project.

## Before writing

Read 1–2 existing ADRs first to discover:
- Where ADRs are stored (common: `docs/adr/`, `adr/`, `decisions/`)
- The naming convention and numbering scheme
- Which sections the project uses and in what order
- The exact status vocabulary this project uses

This matters because ADR conventions vary between projects. Don't assume a format — infer it from what's already there.

## Writing

Follow the structure and status vocabulary you found. Use sequential numbering (read existing files to find the next number). When in doubt about a section, follow the style of nearby ADRs.

## What the session taught us

Status values are project-specific and easy to get wrong — always verify from existing files before writing. The most common mistake is using values like "Draft" or "Active" that aren't in the project's vocabulary.
```
---

Notice what's **not** in this agent: specific file paths, section names, or status values from the current project. Those get discovered at runtime. What *is* encoded: the workflow (read first, then write), the meta-knowledge (status values are project-specific and must be verified), and the discovery steps.
