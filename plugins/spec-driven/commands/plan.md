---
description: Create or iterate spec-driven implementation plans through interactive research
---

# Plan

Create, develop, or iterate a spec-driven implementation plan. Adapts depth based on what already exists.

## Context Resolution

1. If an argument was provided (slug, path, or description), use it
2. If `NOW.md` exists at repo root, read the current feature slug from it
3. If neither, ask: "What feature or task should I plan?"

Derive a kebab-case slug from the request (e.g., "add CSV export to recon" → `recon-csv-export`).

## Mode Detection

Check `specs/<slug>/` and adapt:

| Exists | Mode | What happens |
|--------|------|--------------|
| Nothing | **Scope + Plan** | Full creation: spec.md → research → tasks.md |
| `spec.md` only | **Plan** | Skip scoping, research and write tasks.md |
| `spec.md` + `tasks.md` | **Iterate** | Present current plan, ask what to change |

---

## Mode: Scope + Plan

### 1. Understand the Request

Read everything the user provided: ticket descriptions, file references, conversation context. Read all referenced files completely — no partial reads, no limit/offset.

### 2. Research

Spawn parallel sub-agents to gather codebase context:

- **codebase-locator**: find all files related to the request
- **codebase-analyzer**: understand how the current implementation works
- **codebase-pattern-finder**: find similar features to model after

Read all files the agents identify. Cross-reference with the request.

### 3. Create spec.md

Create `specs/<slug>/spec.md` using the IntentSpec schema:

```yaml
---
id: "<slug>"
objective: "One sentence"
outcomes:
  - "Observable result"
constraints:
  - "Hard requirement"
edgeCases:
  - scenario: "Edge case"
    expected: "Expected behavior"
healthMetrics:
  - "Existing behavior that must not degrade"
status: draft
owner: ""
created: YYYY-MM-DD
---

## Context
[Why this matters]

## Non-goals
[Explicitly out of scope]
```

### 4. Present Understanding

```
Based on the request and my research:

Objective: [restate in your own words]
Key constraints: [list]
Assumptions I'm making: [list — be explicit]

Questions (only what code research couldn't answer):
- [question]
```

If the request is too vague for provable success criteria, ask clarifying questions instead of guessing.

### 5. Write tasks.md

After alignment, create `specs/<slug>/tasks.md` with a phased plan.

Structure each phase with:
- **Overview**: what the phase accomplishes
- **Changes**: specific files and modifications (code snippets where helpful)
- **Success criteria** split into:
  - **Automated**: commands to run (detect from project — see Verification Detection below)
  - **Manual**: human verification steps

Include a "What We're NOT Doing" section if scope boundaries need reinforcement.

### 6. Optional: research.md

If the investigation produced substantial findings worth preserving (architecture analysis, design tradeoffs, pattern survey), write to `specs/<slug>/research.md`. Skip for straightforward work.

---

## Mode: Plan

Spec folder exists with `spec.md` but no `tasks.md`. Scoping is done — go straight to research + planning.

1. Read `spec.md` fully — understand objective, constraints, edge cases
2. Spawn research sub-agents as needed
3. Present your understanding and any questions
4. After alignment, write `tasks.md`
5. Optionally write `research.md`

---

## Mode: Iterate

Spec folder has both `spec.md` and `tasks.md`.

1. Read all existing spec artifacts (`spec.md`, `tasks.md`, and any `research.md`, `verification.md`, `acceptance.md`)
2. Present the current plan:
   ```
   Current plan: N phases. Phases 1-2 complete (checked off). Phase 3 pending.
   What would you like to change?
   ```
3. When the user provides feedback:
   - Spawn targeted research only if changes require new technical understanding
   - Confirm understanding before editing
   - Make surgical edits to `tasks.md` — preserve what works
   - Update `acceptance.md` if success criteria changed
4. If invoked without feedback, present the plan and wait

---

## Verification Detection

When writing success criteria, detect the project's verification commands:

| File | Look for |
|------|----------|
| `package.json` | `scripts.verify`, `scripts.test`, `scripts.typecheck`, `scripts.lint` |
| `Makefile` | `check`, `test`, `lint` targets |
| `Cargo.toml` | `cargo check`, `cargo test`, `cargo clippy` |
| `pyproject.toml` | pytest, ruff, mypy config |
| `go.mod` | `go vet`, `go test` |

Use whatever the project provides. Never hardcode verification commands.

---

## Guidelines

- **Read fully**: all mentioned files, completely. No partial reads.
- **Be skeptical**: question vague requirements. Don't assume — verify with code.
- **Be interactive**: get buy-in at each step. Don't write the full plan in one shot.
- **No open questions**: if you hit an unresolved question, stop and ask. The final plan must be complete and actionable.
- **Separate auto vs manual**: every phase must distinguish automated checks from human verification.
- **Include non-goals**: every spec should state what is out of scope.

## Completion

1. Update `NOW.md` at repo root: `Feature: <slug>`, current status, next action
2. Present the spec/plan location and ask for review
3. Do not write code — that's `/implement`
