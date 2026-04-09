---
description: Create structured session handoff for transferring work context
---

# Handoff

Write a structured handoff document so a future session can resume your work without losing context.

## Context Resolution

1. If an argument was provided, use it as the spec slug
2. If `NOW.md` exists at repo root, read the current feature slug from it
3. If working on a specific feature, write to `specs/<slug>/handoff.md`
4. If cross-cutting (no single feature), write expanded context to `NOW.md`

## Process

### 1. Gather State

Collect current context automatically:

```bash
git branch --show-current
git log --oneline -5
git status --short
git stash list
```

### 2. Write Handoff

If a spec folder exists, write to `specs/<slug>/handoff.md`:

```markdown
# Handoff: <slug>

## Status
<one-line summary of current state>

## Tasks
<what was being worked on, status of each>
- [task]: completed / in progress / planned
- If following a plan: which phase, what's checked off

## Last Verified
- <check>: PASS/FAIL
- <check>: PASS/FAIL

## Recent Changes
<files changed in this session, with file:line references>

## Learnings
<important discoveries — patterns, root causes, gotchas>
<prefer file:line references over code snippets>

## Open Issues
<blockers, unknowns, risks>

## Next Action
<what the next session should do first>

## Git State
- Branch: <branch>
- Last commit: <hash> <message>
- Uncommitted changes: <yes/no — what>
- Stashes: <any>
```

If no spec folder (cross-cutting work), update `NOW.md` with expanded context:

```markdown
# NOW

Feature: <what you were working on>
Status: <one-line>
Blocker: <if any>
Next: <specific next action>

## Context
<2-3 sentences of what the next session needs to know>
```

### 3. Quality Checks

Before finishing:
- Include file:line references, not large code blocks
- Cover both what was done and what remains
- Be precise about next steps — not "continue work" but "run /verify on specs/foo then fix the failing typecheck"
- Mention any uncommitted changes or stashes

### 4. Report

```
Handoff written to specs/<slug>/handoff.md

Resume in a new session with:
  /resume <slug>
```

## Guidelines

- **More context, not less** — the template is a minimum, add more if needed
- **Be precise** — file:line references over vague descriptions
- **Avoid code dumps** — prefer references the next agent can follow
- **Capture learnings** — patterns discovered, dead ends tried, gotchas found
