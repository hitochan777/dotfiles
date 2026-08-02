---
name: session-mistake-report
description: Scans recent Claude Code session transcripts to find mistakes Claude made — wrong assumptions, semantic copy-paste errors, workflow violations, dangerous operations, hallucinations, implementation bugs — and produces a report with prevention suggestions. Trigger when the user says things like "what mistakes did you make", "review your errors", "what went wrong in our sessions", or at the end of a long session as a retrospective. Default window is the past day; the user can specify a different range (e.g. "past week").
---

# Session Mistake Report

Reads recent session transcripts, identifies mistakes Claude made, and reports them with prevention suggestions.

## Time window

Default: sessions modified in the **past 24 hours**.
If the user specifies a different window (e.g. "past 3 days", "past week"), adjust the `mtime` accordingly:
```bash
# Past day (default)
find ~/.claude/projects -name "*.jsonl" -mtime -1 -type f 2>/dev/null

# Past N days
find ~/.claude/projects -name "*.jsonl" -mtime -N -type f 2>/dev/null
```

## Reading sessions

Each line is a JSON object. Extract conversation turns:
```bash
jq -r 'select(.type == "user" or .type == "assistant") | (.type + ": ") + (.message.content | if type == "string" then . else (map(select(.type == "text") | .text) | join(" ")) end)' <file>.jsonl 2>/dev/null
```

Focus on the **sequence** of turns, not just individual messages — mistakes often only become visible when you see the correction that follows.

## Mistake categories

Look for these specific patterns:

### Wrong assumption
Claude misread or misidentified the problem before attempting a solution.
Signal: user says "no, that's not what I meant", "you misunderstood", redirects the entire approach early in the task.

### Semantic copy-paste
Claude applied a code pattern, variable, or structure from one context where it made sense to another where it didn't, without checking whether the semantics still held.
Signal: user points out that something "looks right but is wrong for this reason", or explains why a variable/value is conceptually wrong.

### Workflow violation
Claude broke an established rule or preference (e.g. pushing directly to main, committing without being asked, deleting files without confirmation).
Signal: user says "you should always...", "I told you before...", or corrects a process step.

### Dangerous operation
Claude performed or attempted a destructive/irreversible action — deleting secrets, force-pushing, dropping data, clearing credentials, overwriting uncommitted work — without sufficient caution or confirmation.
Signal: explicit correction, revert action, or user expressing alarm. Also scan for tool calls involving `rm -rf`, secret deletion, `--force`, `DROP`, credential overwrites.

### Hallucination
Claude stated something confidently that was factually wrong — a file path, API name, behavior, library version, or claimed capability that doesn't exist.
Signal: user says "that doesn't exist", "that's wrong", "where did you get that from".

### Incomplete fix
Claude's fix addressed a symptom but not the underlying cause, requiring a follow-up correction.
Signal: the same issue recurs, or user says "but that doesn't fix the real problem".

### Implementation bug
Code Claude wrote had a correctness error — logic bug, off-by-one, wrong condition, type mismatch — that required correction.
Signal: test failure, user pointing out the bug, or a subsequent edit fixing the logic.

## Detection signals (what to scan for)

User-side signals:
- "no", "wrong", "that's not right", "you misunderstood", "I told you"
- "so your brain was not working", "you didn't think", expressions of frustration
- Explicit corrections to facts, code, or approach
- Requests to revert something

Action-side signals (in assistant tool calls):
- A revert commit immediately following a feature commit
- Secret/credential manipulation in git or env
- `rm`, `drop`, `--force`, `--no-verify` flags
- Multiple iterations fixing the same file

## Report format

Output the report inline in the conversation. Use this structure:

---
## Mistake Report — [date range]
**Sessions reviewed:** N  
**Mistakes found:** M

---

### [#] [Category] — [one-line summary]
**What happened:** Brief description of what Claude did wrong.  
**Correction:** What the user had to say or do to fix it.  
**Prevention:** What prompt phrasing, explicit context, or upfront constraint would have avoided this. Be specific — e.g. *"Stating 'there are 200 posts to push, not pull' at the start"* or *"Adding a rule: always check whether a pattern's semantics match before reusing it from a different context."*

---

(repeat for each mistake)

**Patterns across mistakes:** If multiple mistakes share a common root (e.g. "not reading the problem carefully before coding", "applying patterns without semantic verification"), call it out here. This is the most useful part — individual mistakes are less actionable than a pattern.

---

## Tone

Be direct and specific. Vague entries like "Claude misunderstood the task" are not useful. Good entries name the exact wrong claim, the exact correction, and a concrete prevention strategy. The goal is actionable insight, not a confession log.

If no mistakes are found, say so plainly — that's a valid outcome.
