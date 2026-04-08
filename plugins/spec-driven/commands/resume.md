---
description: Resume work from spec artifacts and handoff documents
---

# Resume

Restore context from spec folder artifacts and validate current state before continuing work.

## Context Resolution

1. If an argument was provided (slug or path), use it
2. If `NOW.md` exists at repo root, read the current feature slug from it
3. If neither, list `specs/` directories and ask which to resume

## Process

### 1. Read Artifacts in Priority Order

Read these files completely (skip any that don't exist):

1. `NOW.md` — current state overview
2. `specs/<slug>/spec.md` — feature intent and constraints
3. `specs/<slug>/tasks.md` — phased plan with completion status
4. `specs/<slug>/acceptance.md` — exit criteria
5. `specs/<slug>/verification.md` — last verification results
6. `specs/<slug>/handoff.md` — session transition context
7. `specs/<slug>/research.md` — investigation findings

### 2. Validate Current State

Never assume the handoff matches reality. Verify:

```bash
git branch --show-current
git status --short
git log --oneline -5
git stash list
```

Check:
- Is the branch what the handoff says?
- Are there uncommitted changes?
- Have other commits landed since the handoff?
- Do referenced files still exist?

### 3. Spawn Verification (if needed)

If the handoff mentions recent changes or in-progress work:
- Use **codebase-locator** to verify referenced files exist
- Use **codebase-analyzer** to confirm partial implementations match the plan
- Run quick verification (detect from project) to check build/test state

### 4. Present Findings

```
Resuming <slug> from handoff on [date].

**Status:** [from handoff]

**Tasks:**
- Phase 1: DONE (checked off)
- Phase 2: DONE (checked off)
- Phase 3: IN PROGRESS — [detail from handoff]

**Last Verification:** [from verification.md if exists]

**Current Git State:**
- Branch: [actual]
- Uncommitted changes: [yes/no]
- Divergence from handoff: [any differences found]

**Open Issues:** [from handoff]

**Recommended Next Action:**
[Most logical next step based on all artifacts]

Shall I proceed with [action], or would you like to adjust?
```

### 5. Get Confirmation

Wait for the user to confirm or redirect before writing any code.

### 6. Begin Work

After confirmation:
- Create a todo list from the remaining tasks
- Reference learnings from the handoff throughout
- Apply patterns and approaches documented in research.md
- Update `NOW.md` with the active session

## Handling Edge Cases

**No handoff found:**
- Read `NOW.md` and any spec artifacts that exist
- Present what you found and propose starting from the spec

**Stale handoff (significant time passed):**
- Note the age
- Run full verification to assess current state
- Re-evaluate whether the original approach still applies
- Present findings and ask before proceeding

**Diverged codebase (changes since handoff):**
- Note what changed (new commits, modified files)
- Reconcile differences
- Adapt the plan based on current state

## Guidelines

- **Never assume** — always verify state before acting
- **Read everything** — all spec artifacts, not just the handoff
- **Be interactive** — present findings and get confirmation before coding
- **Capture continuity** — reference the handoff in your first commit message
