---
description: Execute spec-driven implementation plans phase by phase with verification
---

# Implement

Execute an approved implementation plan from `specs/<slug>/tasks.md`, phase by phase, with verification between phases.

## Context Resolution

1. If an argument was provided, use it as the spec slug
2. If `NOW.md` exists at repo root, read the current feature slug from it
3. If neither, ask: "Which spec should I implement?"

Then read completely:
- `specs/<slug>/spec.md` — feature intent and constraints
- `specs/<slug>/tasks.md` — the phased plan
- `specs/<slug>/acceptance.md` — exit criteria (if exists)

If `tasks.md` has existing checkmarks (`- [x]`), pick up from the first unchecked item.

## Verification Detection

Before starting implementation, detect the project's verification commands:

| File | Look for |
|------|----------|
| `package.json` | `scripts.verify`, `scripts.test`, `scripts.typecheck`, `scripts.lint` |
| `Makefile` | `check`, `test`, `lint` targets |
| `Cargo.toml` | `cargo check`, `cargo test`, `cargo clippy` |
| `pyproject.toml` | pytest, ruff, mypy config |
| `go.mod` | `go vet`, `go test` |

If `scripts.verify` exists, prefer it (it likely bundles everything). Store the detected commands — run them after each phase.

**Always prefix verification commands with `rtk`** to suppress passing output and only surface failures:

```bash
rtk pnpm typecheck       # Delegates to tsc filter (83% reduction)
rtk lint                 # ESLint/Biome (84% reduction)
rtk cargo test           # Rust tests (90% reduction)
rtk vitest run           # Vitest (99% reduction)
```

For commands RTK can't filter (e.g. `pnpm build`), redirect output and check exit code:
```bash
pnpm build > /tmp/build.log 2>&1; echo "exit: $?"
```
One line on pass. Read the log only on failure. Never pipe raw build output into context.

## Spec Echo (Mandatory)

Before writing any code for a phase, restate your intent:

```
Phase [N]: [Phase name]

I'm about to:
- [Change 1]: [file] — [why]
- [Change 2]: [file] — [why]

Assumptions:
- [Assumption 1]
- [Assumption 2]

Proceeding unless you stop me.
```

Wait briefly for objection. If the user approves or says nothing, proceed. If they correct you, adapt before coding.

## Phase Execution

For each phase in `tasks.md`:

1. **Spec echo** — restate intent (see above)
2. **Implement** the changes described in the phase
3. **Run verification** using detected commands. Fix failures before moving on.
4. **Check off** completed items in `tasks.md`
5. **Commit** the phase:
   - One commit per completed phase
   - Message format: `<slug>: phase N — <what was done>`
   - Example: `recon-csv-export: phase 1 — add export button and CSV generation`
6. **Pause for manual verification** if the phase has manual criteria:
   ```
   Phase [N] Complete — Ready for Manual Verification

   Automated verification passed:
   - [check]: PASS
   - [check]: PASS

   Manual verification needed:
   - [ ] [item from tasks.md]

   Let me know when manual testing is complete so I can proceed to Phase [N+1].
   ```

If instructed to execute multiple phases consecutively, skip pauses until the last phase. Do not check off manual items until confirmed by the user.

## Mismatch Handling

If reality differs from the plan:

**Small discrepancies** (renamed variable, moved file) — adapt silently and note it.

**Structural mismatches** (missing module, different architecture, wrong assumptions) — STOP:

```
Mismatch in Phase [N]:
Plan says: [expected]
Reality: [what I found]
Impact: [why this matters]

Options:
1. [Adapt approach — describe how]
2. [Skip and flag for plan revision]
3. [Your call — describe the tradeoff]
```

Wait for guidance before proceeding.

## Sub-Agent Usage

Use sub-agents sparingly during implementation — for targeted exploration, not general coding:

- **codebase-analyzer**: understand unfamiliar code the plan references
- **codebase-locator**: find where something is used across the codebase
- **codebase-pattern-finder**: find an existing pattern to model after

## Resuming

If `tasks.md` has existing checkmarks:
- Trust that completed work is done
- Pick up from the first unchecked item
- Verify previous work only if something seems off

## Completion

After all phases are done:

1. Run full verification one final time
2. Check off all completed items in `tasks.md`
3. Update `NOW.md`: status, what was done, next action
4. Report:
   ```
   Implementation complete for <slug>.

   All phases done. Verification: [PASS/FAIL with details].

   Suggested next step: /verify <slug>
   ```

## Philosophy

Plans are carefully designed, but reality can be messy. Follow the plan's intent while adapting to what you find. The plan is your guide, but your judgment matters too. Keep the end goal in mind and maintain forward momentum.
