---
description: Verify implementation against spec — run acceptance checks, cross-check completeness
---

# Verify

Verify that an implementation is correct and complete. Adapts depth based on what spec artifacts exist.

## Context Resolution

1. If an argument was provided, use it as the spec slug
2. If `NOW.md` exists at repo root, read the current feature slug from it
3. If neither, ask: "Which feature should I verify?"

## Mode Detection

| Exists | Mode | What happens |
|--------|------|--------------|
| `specs/<slug>/acceptance.md` | **Full** | Cross-check tasks.md + run acceptance checks + write verification.md |
| `specs/<slug>/` without `acceptance.md` | **Spec-aware** | Detect and run verification, compare against tasks.md |
| No spec folder | **Lightweight** | Detect verification commands, run, report in conversation |

---

## Verification Detection

Detect the project's verification commands:

| File | Look for |
|------|----------|
| `package.json` | `scripts.verify`, `scripts.test`, `scripts.typecheck`, `scripts.lint` |
| `Makefile` | `check`, `test`, `lint` targets |
| `Cargo.toml` | `cargo check`, `cargo test`, `cargo clippy` |
| `pyproject.toml` | pytest, ruff, mypy config |
| `go.mod` | `go vet`, `go test` |

If `scripts.verify` exists, prefer it. Otherwise compose from available scripts.

**Always prefix with `rtk`** — suppresses passing output, surfaces only failures:

```bash
rtk pnpm run verify      # preferred if scripts.verify exists
rtk tsc                  # TypeScript check
rtk lint                 # ESLint/Biome
rtk next build           # Next.js build
rtk cargo test           # Rust
rtk vitest run           # Vitest
```

---

## Mode: Full

### 1. Cross-Check Completeness

Read `specs/<slug>/tasks.md` and verify every phase was implemented:

- For each phase, spawn a research task to check the actual code matches:
  - **codebase-locator**: verify the files were changed as planned
  - **codebase-analyzer**: verify the changes match the described behavior

- Check for checkmarks in `tasks.md` — verify claimed completions against reality

### 2. Run Acceptance Checks

Read `specs/<slug>/acceptance.md` and execute every command listed under "Required Checks."

For each command, record:
- The exact command run
- Exit code
- Relevant output (failures, warnings)

### 3. Assess Manual Criteria

List all manual verification items from `acceptance.md` as "pending human confirmation." Do not check them off — only the user can.

### 4. Write verification.md

Write results to `specs/<slug>/verification.md`:

```markdown
# Verification: <slug>

## Run: YYYY-MM-DD HH:MM

### Completeness
- Phase 1: DONE (all tasks checked off, code verified)
- Phase 2: DONE
- Phase 3: PARTIAL — [detail]

### Automated Checks
- <command>: PASS (exit 0)
- <command>: PASS (exit 0)
- <command>: FAIL (exit 1)
  ```
  <relevant failure output>
  ```

### Manual Checks Pending
- [ ] <item from acceptance.md>
- [ ] <item from acceptance.md>

### Issues Found
- <any deviations, regressions, or concerns>
```

### 5. Fail Closed

If any required automated check fails, report it clearly and do NOT declare done. Present what failed and suggest next steps.

---

## Mode: Spec-Aware

Spec folder exists but no `acceptance.md`.

1. Read `tasks.md` — check for uncompleted phases
2. Detect and run verification commands from the project
3. Report results in conversation and write `verification.md`
4. If issues found, suggest creating `acceptance.md` for the next cycle

---

## Mode: Lightweight

No spec folder — just run verification.

1. Detect verification commands
2. Run them
3. Report results in conversation (no artifact written)
4. This mode is useful for quick "does the project still build/pass?" checks

---

## Guidelines

- **Run every check**: do not skip commands even if you expect them to pass.
- **Cite evidence**: when claiming something passes or fails, show the command and exit code.
- **Think critically**: question whether the implementation truly solves the problem, not just whether it compiles.
- **Check for regressions**: look beyond the feature — did existing behavior break?
- **Be constructive**: identify issues to fix, not to blame.

## Completion

1. If verification.md was written, present its location
2. Update `NOW.md` with verification status
3. If all checks pass: "Verification passed. Ready for `/pr` or `/commit`."
4. If checks fail: "Verification failed. [N] issues to address. Fix and re-run `/verify`."
