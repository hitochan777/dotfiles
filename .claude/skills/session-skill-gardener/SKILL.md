---
name: session-skill-gardener
description: Reviews Claude Code session transcripts from the past day to find skill friction (corrections, repeated misunderstandings) and recurring unscaffolded workflows, then proposes updates to personal skills or creates new ones. Use this at the end of a work session, or when the user says things like "we should save this pattern", "I keep doing this", or "that skill didn't help much". Also trigger if a long session just finished and patterns are fresh in context. Personal skills only — never touch repo skills.
---

# Session Skill Gardener

Scans recent session transcripts, finds what's worth improving or capturing, and updates personal skills accordingly.

## Paths

- **Sessions**: `~/.claude/projects/**/*.jsonl` — one file per conversation
- **Personal skills**: `~/.claude/skills/<name>/SKILL.md` — global, not project-scoped
- **Never touch**: `.claude/skills/` inside any project directory

Find sessions from the past 24 hours:
```bash
find ~/.claude/projects -name "*.jsonl" -mtime -1 -type f 2>/dev/null
```

## Reading sessions

Each line in a `.jsonl` file is a JSON object. The ones that matter have `"type":"user"` or `"type":"assistant"` — these contain the conversation. Extract the `message.content` field (which may be a string or array of content blocks). Skip `file-history-snapshot`, `mode`, and other metadata lines.

A quick way to pull just the text:
```bash
jq -r 'select(.type == "user" or .type == "assistant") | .message.content | if type == "string" then . else (map(select(.type == "text") | .text) | join(" ")) end' <file>.jsonl 2>/dev/null
```

## What to look for

### Skill friction (reason to update an existing skill)
- User corrected the skill's output or approach multiple times in one session
- A preference or constraint had to be re-established that the skill should already know
- The skill completed but left extra cleanup work
- User said things like "no not like that", "stop doing X", "I told you this before"

### New skill candidates (reason to create a skill)
- A multi-step workflow appeared in 2+ sessions and took significant back-and-forth to set up
- The user said "we should save this", "I keep doing this", "remember this for next time"
- Domain knowledge or project context had to be re-established from scratch
- A long predictable sequence of tool calls with no existing skill covering it

## Bar for acting

Apply a **high bar**. A single correction or one-off issue is not enough — look for repeated evidence. The goal is to save real future effort, not to over-engineer a skill for every edge case. If in doubt, don't.

## Process

1. Find all JSONL session files modified in the past 24 hours
2. Read and analyze each one for the signals above
3. List what you found — friction points and/or new patterns
4. Propose specific changes: for each, say which skill it affects, what the issue was, and exactly what you'd add or change
5. **Wait for user confirmation before writing anything**
6. Apply only the agreed changes, to personal skills only

## Output format

Be concise. Structure your report as:

- Sessions reviewed: N
- **Proposed updates** (if any): one bullet per change — skill name, issue, proposed fix
- **Proposed new skills** (if any): one bullet per — name, what it does, why it's warranted
- If nothing warrants a change, say so plainly — that's a valid and common outcome
