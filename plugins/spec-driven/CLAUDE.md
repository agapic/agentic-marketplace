# Spec-Driven Workflow — Agent Rules

## Discipline

Before non-trivial changes:
- Restate what you're about to do and why
- If changing more than 3 files, list them first
- For spec-driven work, reference the spec slug and phase

"Done" means proven:
- Verification commands must pass (detect from project)
- When claiming "tests pass" — cite the command and exit code
- When claiming "deploy works" — cite the URL and HTTP status
- When claiming "bug is fixed" — cite reproduction steps and verification output
- When claiming a domain fact — cite the source file and line

Escalation:
- If stuck after 3 attempts, stop and report what you've tried
- Never delete user files without explicit permission
- Never skip verification steps
- If a spec exists for current work, read it before making changes

## Verification After Edit

After editing code files, find and run the project's fast verification:

Detection order:
1. `package.json` → `scripts.typecheck` or `scripts.verify`
2. `Makefile` → `check` target
3. `Cargo.toml` → `cargo check`
4. `go.mod` → `go vet`
5. `pyproject.toml` → `ruff check` or `mypy`

If verification fails, fix the issue before reporting done. Show the command and exit code.

## Context Rotation

If the session has been running for a long time and quality is degrading, suggest a handoff.
Always prefer writing findings to `specs/` over keeping them only in chat.

## Parallel Agent Discipline

When spawning parallel sub-agents:
- Each agent gets a fixed spec, a fixed set of files, and exit-code success criteria
- Do not run parallel agents on overlapping file sets
- Prefer narrow, bounded tasks over broad mandates

## Source of Truth

1. Project `CLAUDE.md` / `AGENTS.md` — repo-wide rules
2. `specs/<slug>/spec.md` — feature intent
3. `specs/<slug>/acceptance.md` — provable exit criteria
4. Verification artifacts — machine-written proof
5. `specs/<slug>/research.md` — optional context
6. Chat history — ephemeral, never authoritative
