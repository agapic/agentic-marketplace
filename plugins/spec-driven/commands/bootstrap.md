---
description: Scaffold a new or existing repo for spec-driven agent workflow
---

# Bootstrap

Detect the project's stack and scaffold the spec-driven workflow. Run once on a new repo, or on an existing repo to fill gaps.

## Process

### 1. Detect Stack

Scan the repository root for:

| File | Stack |
|------|-------|
| `package.json` | Node.js / JavaScript / TypeScript |
| `Cargo.toml` | Rust |
| `pyproject.toml` or `setup.py` | Python |
| `go.mod` | Go |
| `Makefile` | Generic (check targets) |
| `Dockerfile` | Containerized |
| `vercel.json` or `netlify.toml` or `fly.toml` | Deploy platform |

Also detect:
- Monorepo structure (multiple package.json, workspaces)
- Existing `CLAUDE.md` or `AGENTS.md`
- Existing `specs/` directory
- Existing test/lint/typecheck commands
- Framework: Next.js, Django, Rails, etc.

### 2. Ask One Question

```
I've detected: [stack summary]

What does this project do? (one sentence for CLAUDE.md)
```

Wait for the answer.

### 3. Scaffold

Create only what's missing — never overwrite existing files.

**`CLAUDE.md`** (if it doesn't exist):
```markdown
# [Project Name] — Project Context

[User's one-sentence description]

## Source of Truth
1. This file (CLAUDE.md) — repo-wide rules
2. specs/<feature>/spec.md — feature intent
3. specs/<feature>/acceptance.md — exit criteria
4. Verification artifacts — machine proof
5. Chat history — ephemeral, never authoritative

## Working Rules
- Restate requirements before implementation for non-trivial work
- Prefer the smallest change that satisfies the spec
- For browser/runtime bugs: inspect console, network, headers before patching code

## Verification
[detected verify command, e.g., "cd prototype && pnpm verify"]

## RTK
Prefix all shell commands with `rtk`. Full reference: RTK.md
```

**`specs/_templates/`** (if missing): copy all four templates (spec.md, tasks.md, acceptance.md, handoff.md).

**`NOW.md`** (if missing):
```markdown
# NOW

Feature: (none active)
Blocker: none
Next: /plan to start new work
```

**Verification script** (if missing):
- For `package.json` without `scripts.verify`: add `"verify": "<typecheck> && <lint> && <build>"` using detected commands
- For `Makefile` without `check:` target: add a check target
- If verification already exists, skip

**`.cursor/rules/verification.mdc`** (if missing):
```
---
description: Post-edit verification for [detected stack]
globs:
alwaysApply: true
---
After editing code files, run: [detected fast check command]
If it fails, fix before reporting done.
```

### 4. Audit and Report

```
## Agent Readiness: Level [N]

Created:
- [list of files created]

Already existed (kept as-is):
- [list of files that were already present]

Missing for next level:
- [what's needed to advance]
```

**Maturity levels:**

| Level | Name | Requirements |
|---|---|---|
| 1 | Guided | CLAUDE.md + specs/ + /plan available |
| 2 | Verified | Level 1 + /verify works + acceptance.md for active features + post-edit rule |
| 3 | Enforced | Level 2 + CI gate for verify + spec presence on PRs |

### 5. Suggest Next Steps

Based on what was scaffolded:
- "Run `/plan` to start your first feature spec"
- "Add acceptance.md for active work to reach Level 2"
- "Add CI verification gate to reach Level 3"

## Guidelines

- **Never overwrite** — if CLAUDE.md exists, suggest additions instead of replacing
- **Detect, don't assume** — scan for actual project structure
- **Minimal scaffolding** — only create what's genuinely missing
- **Respect existing conventions** — if the project uses Makefile, add Make targets, not npm scripts
