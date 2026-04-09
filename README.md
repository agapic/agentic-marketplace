# Agentic Marketplace

AI agent workflows for Claude Code and Cursor. The flagship plugin is `spec-driven` — a generic, cross-tool workflow that keeps intent in the repo, enforces verification before declaring done, and makes sessions resumable without chat history.

## Plugins

| Plugin | Commands | Agents | Description |
|--------|----------|--------|-------------|
| `spec-driven` | 12 | 4 | **Recommended.** Generic spec-driven workflow. No issue tracker dependency. Works in Claude Code and Cursor. |
| `humanlayer-workflows` | 27 | 6 | Legacy. Includes HumanLayer thoughts/ sync, Linear integration, HumanLayer-specific paths. |
| `ui-ux-pro-max` | — | — | UI/UX design intelligence (independent skill). |

---

## Plugin: `spec-driven`

A spec-first agent workflow built around a simple principle: **repo-held intent beats chat-held intent**. Features live in `specs/<slug>/`, verification is mechanical, and sessions are resumable from artifacts alone.

### Core Ideas

**Intent in the repo, not in chat.** Every non-trivial feature starts with a `spec.md` (IntentSpec YAML) and `tasks.md` (phased plan). These persist across sessions so the agent never re-derives intent from conversation history.

**Spec echo before implementation.** Before touching code, the agent restates what it's about to do and why. Corrections happen at that moment — not after files are changed.

**Verification is mechanical, not narrative.** "Done" means `acceptance.md` checks pass and `verification.md` exists. The agent can't self-report done — it must produce evidence.

**Sessions are resumable.** `/handoff` writes a structured artifact. `/resume` restores context from spec folder files in priority order. No need to re-explain what you were working on.

---

### Command Inventory

#### Core Loop

| Command | Purpose | Lines |
|---------|---------|-------|
| `/plan` | Create or iterate spec + phased implementation plan | ~200 |
| `/implement` | Execute plan phase by phase with spec echo and verification | ~180 |
| `/verify` | Run acceptance checks, cross-check completeness, write verification.md | ~120 |
| `/commit` | Atomic git commits with user approval | ~45 |
| `/pr` | Generate PR description enriched from spec artifacts | ~90 |

#### Investigation

| Command | Purpose | Lines |
|---------|---------|-------|
| `/investigate` | Evidence-first diagnosis — hypotheses before patches | ~150 |

#### Session Continuity

| Command | Purpose | Lines |
|---------|---------|-------|
| `/handoff` | Write structured session handoff to `specs/<slug>/handoff.md` | ~80 |
| `/resume` | Restore context from spec folder artifacts, validate current state | ~100 |

#### Exploration + Quality

| Command | Purpose | Lines |
|---------|---------|-------|
| `/research` | Deep parallel codebase exploration using sub-agents | ~120 |
| `/invariants` | Analyze codebase for correctness rules, write `INVARIANTS.md` | ~180 |
| `/tests` | Generate high-quality tests from invariants | ~180 |

#### Setup

| Command | Purpose | Lines |
|---------|---------|-------|
| `/bootstrap` | Scaffold new or existing repo to agent-ready state (Level 1–3) | ~120 |

**Total: ~1,565 lines across 12 commands.**

---

### Command Reference

#### `/plan`

Creates or iterates spec-driven implementation plans. Adaptive depth based on what already exists.

**Modes:**
- **Scope + Plan** (nothing exists): full creation — spec.md → research → tasks.md
- **Plan** (spec.md exists, no tasks.md): skip scoping, write tasks.md
- **Iterate** (both exist): present current plan, accept feedback, make surgical edits

**What it produces:**
- `specs/<slug>/spec.md` — IntentSpec YAML with objective, outcomes, constraints, edge cases
- `specs/<slug>/tasks.md` — phased plan with automated + manual success criteria per phase
- `specs/<slug>/research.md` — optional, for substantial architectural findings

**Key behavior:** Spawns parallel sub-agents (codebase-locator, codebase-analyzer, codebase-pattern-finder) for research before planning. Presents understanding and asks clarifying questions before writing the plan. Does not write code.

---

#### `/implement`

Executes an approved plan from `tasks.md`, phase by phase.

**Key behavior:**
- Reads `spec.md` + `tasks.md` + `acceptance.md` before starting
- Picks up from the first unchecked item if `tasks.md` has existing checkmarks
- **Spec echo** before each phase: "I'm about to change X for reason Y. Proceeding unless you stop me."
- Detects verification commands from `package.json`, `Makefile`, `Cargo.toml`, etc.
- Runs verification after each phase — fixes failures before moving on
- Commits once per phase with format `<slug>: phase N — <what was done>`
- Pauses for manual verification if the phase requires it
- Stops and asks when plan reality diverges structurally

---

#### `/verify`

Verifies implementation is correct and complete. Adaptive depth.

**Modes:**
- **Full** (`acceptance.md` exists): cross-checks tasks.md + runs acceptance commands + writes `verification.md`
- **Spec-aware** (spec folder, no acceptance.md): detect and run verification, compare against tasks.md
- **Lightweight** (no spec folder): detect and run verification, report in conversation

**What it produces:** `specs/<slug>/verification.md` with completeness, automated check results, manual checks pending, and issues found.

**Key behavior:** Fails closed — will not declare done if any required check fails.

---

#### `/investigate`

Evidence-first diagnosis. Does not patch code first.

**Process:**
1. Gather the exact symptom
2. Generate 3–5 ranked hypotheses (runtime → environment → security → code → data)
3. Run fastest discriminating check for top 2 hypotheses
4. Record every check and result
5. Propose the smallest fix backed by evidence
6. Implement and verify after user approves

**Key behavior:** For browser/runtime issues, requires observable evidence (console, network, headers, CSP, storage) before touching code. Never proposes a fix without citing the evidence that led to it.

---

#### `/commit`

Creates atomic git commits with user approval.

**Process:** Reviews changes → groups related files → drafts commit messages (imperative mood, why not what) → presents plan → executes on confirmation.

---

#### `/pr`

Generates PR descriptions enriched from spec artifacts.

**What it reads:** git diff, commit history, `spec.md` (objective + non-goals), `acceptance.md` (criteria), `verification.md` (test results). Runs verification before generating if commands are detected.

**Output sections:** Summary, Changes (by area, not file), Non-goals, Verification, Testing, Notes for reviewers.

---

#### `/handoff`

Writes a structured handoff document for session transfer.

**What it captures:** current status, tasks with completion state, last verification results, recent changes with file:line references, learnings and gotchas, open issues, next action, git state.

**Output:** `specs/<slug>/handoff.md`, or expanded `NOW.md` for cross-cutting work.

---

#### `/resume`

Restores context from spec folder artifacts and validates current state before continuing.

**Reading order (priority):** `NOW.md` → `spec.md` → `tasks.md` → `acceptance.md` → `verification.md` → `handoff.md` → `research.md`

**Key behavior:** Never assumes handoff matches reality. Validates git state (branch, uncommitted changes, new commits since handoff). Presents findings and waits for confirmation before writing code.

---

#### `/research`

Deep parallel codebase exploration using specialized sub-agents.

**Sub-agents spawned concurrently:** codebase-locator (WHERE), codebase-analyzer (HOW), codebase-pattern-finder (existing patterns), web-search-researcher (external docs, if requested).

**Output:** Synthesized findings with file:line references. Writes to `specs/<slug>/research.md` if a spec folder exists, otherwise to conversation.

---

#### `/invariants`

Analyzes the codebase and creates or refreshes `INVARIANTS.md` — a source of truth for correctness rules.

**Sections produced:** System overview, domain invariants, state machine/transition invariants, contract invariants, persistence invariants, failure/recovery invariants, highest-risk regression areas, suggested tests.

**Output:** `INVARIANTS.md` at repository root. Feeds directly into `/tests`.

---

#### `/tests`

Generates high-quality tests from invariants. Uses `INVARIANTS.md` as primary source of truth.

**Principles:** Test behavior not trivia. Mock only at true boundaries (network, third-party APIs). Cover happy paths, edge cases, and failures. Test at multiple layers (unit, integration, scenario).

**Process:** Inspect repo → create testing strategy → write critical-path tests first → expand coverage without lowering quality.

---

#### `/bootstrap`

Scaffolds a new or existing repo for spec-driven workflow.

**Detects:** stack (Node.js, Rust, Python, Go), framework (Next.js, Django, etc.), existing CLAUDE.md, existing verification scripts, monorepo structure.

**Creates (only what's missing):** `CLAUDE.md`, `specs/_templates/`, `NOW.md`, verification script in `package.json`/`Makefile`, `.cursor/rules/verification.mdc`.

**Reports maturity level:**

| Level | Name | Requirements |
|-------|------|--------------|
| 1 | Guided | CLAUDE.md + specs/ + /plan available |
| 2 | Verified | Level 1 + /verify works + acceptance.md for active features + post-edit rule |
| 3 | Enforced | Level 2 + CI gate for verify + spec presence on PRs |

---

### Sub-Agents

| Agent | Job |
|-------|-----|
| `codebase-analyzer` | Deep-dive into HOW specific code works. Returns file:line references and behavioral analysis. |
| `codebase-locator` | Find WHERE files and components live. Super grep/glob/ls. |
| `codebase-pattern-finder` | Find existing patterns and working code examples to model after. |
| `web-search-researcher` | Find up-to-date documentation, best practices, and API references from the web. |

---

### Always-On Rules

| Rule | Purpose |
|------|---------|
| `agent-discipline.mdc` | Spec echo before changes, evidence-backed claims, escalation on structural mismatches |
| `verification-after-edit.mdc` | Auto-detect and run fast verification after code edits |

---

### Spec Folder Structure

Each feature gets its own folder under `specs/`:

```
specs/
  _templates/          # Copy these to start a new spec
    spec.md
    tasks.md
    acceptance.md
    handoff.md
  <slug>/
    spec.md            # IntentSpec YAML — what and why (created by /plan)
    tasks.md           # Phased plan with success criteria (created by /plan)
    acceptance.md      # Required checks + manual verification (created by /plan)
    research.md        # Optional — architecture findings, design tradeoffs
    verification.md    # Machine proof of completion (written by /verify)
    handoff.md         # Session transfer artifact (written by /handoff)
```

`spec.md` uses IntentSpec YAML frontmatter:

```yaml
---
id: "recon-csv-export"
objective: "Add CSV export to the reconciliation report screen"
outcomes:
  - "Export button visible on reconciliation screen"
  - "CSV downloads with data matching screen values"
constraints:
  - "Must not break existing PDF export"
  - "Export must respect active filters"
edgeCases:
  - scenario: "Export with no data"
    expected: "Empty CSV with headers, not an error"
healthMetrics:
  - "Existing reconciliation screen renders without change"
status: draft
owner: ""
created: 2026-04-08
---
```

---

### Sample Workflows

#### Greenfield: new repo from scratch

```
/bootstrap
  Detects stack (Next.js from package.json)
  Asks: "What does this project do?"
  Scaffolds: CLAUDE.md, specs/_templates/, NOW.md, verification rule
  Adds "verify" script to package.json
  Reports: Level 1 (Guided)

/plan "build the user authentication flow"
  Creates specs/user-auth/spec.md (IntentSpec YAML)
  Spawns parallel sub-agents to research existing patterns
  Creates specs/user-auth/tasks.md (phased plan)
  Updates NOW.md → "Feature: user-auth"

/implement user-auth
  Reads spec.md + tasks.md
  Spec echo: "I'm about to implement Phase 1: session middleware. I'll change X, Y, Z..."
  Implements, runs detected verification between phases
  Commits per phase: "user-auth: phase 1 — add session middleware"

/verify user-auth
  Runs acceptance checks from acceptance.md
  Cross-checks tasks.md (all phases done?)
  Writes verification.md

/commit → /pr → ship
```

#### Brownfield: joining an existing repo

```
/bootstrap
  Detects existing stack, existing CLAUDE.md
  Scaffolds only what's missing: specs/_templates/, NOW.md
  Does NOT overwrite existing CLAUDE.md (adds suggestions)
  Reports: Level 1, suggests adding "verify" script

/research "how does the payment processing work?"
  Spawns codebase-locator + codebase-analyzer in parallel
  Synthesizes findings with file:line references
  Outputs to conversation (no spec folder yet — just learning)

/plan "add Stripe webhook signature verification"
  Creates specs/stripe-webhook-verify/spec.md
  Research phase finds existing webhook handler patterns
  Creates tasks.md modeled after existing patterns

/implement → /verify → /commit → /pr
```

#### Feature development: plan → implement → verify

```
/plan "add CSV export to the reconciliation report"
  Creates specs/recon-csv-export/spec.md + tasks.md
  acceptance.md includes: export button visible, CSV downloads, data matches screen

/implement recon-csv-export
  Spec echo before each phase
  Discovers edge case not in plan → STOPS
  Presents mismatch: "Plan says X, reality is Y. Options: 1) adapt 2) skip 3) your call"
  User says "handle it" → adapts, continues

/verify recon-csv-export
  All automated checks pass
  Manual: "[ ] export button visible" → listed as pending human confirmation

/handoff recon-csv-export
  Writes specs/recon-csv-export/handoff.md
  Updates NOW.md

--- next session ---

/resume
  Reads NOW.md → finds recon-csv-export
  Reads spec.md, verification.md, handoff.md
  "All automated checks pass, manual verification pending"
  "Ready for you to test the export button"
```

#### Architecture: design before building

```
/plan "redesign the data pipeline to support multi-tenant"
  Spawns deep research: codebase-analyzer on current pipeline,
    codebase-locator for all tenant-related code,
    codebase-pattern-finder for existing multi-tenant patterns
  Writes specs/multi-tenant-pipeline/research.md
  Presents 2-3 design options with tradeoffs
  User picks approach → writes detailed 4-phase tasks.md

/invariants
  Analyzes codebase, produces INVARIANTS.md
  "Tenant isolation must hold across all queries"
  Suggests test candidates for each invariant

/tests
  Reads INVARIANTS.md
  Generates tests for critical invariants first
  "Tenant data never leaks across boundaries" → integration test

/implement multi-tenant-pipeline --phase 1
  Implements only Phase 1
  Runs verification, pauses for manual confirmation
```

#### Bug fix: evidence-first investigation

```
/investigate "users are getting 500 errors on /api/export"
  Does NOT patch code first
  Hypotheses (ranked):
    1. Database connection timeout (runtime)
    2. Missing env var in production (environment)
    3. Unhandled null in export query (code)
    4. File permission on temp directory (infra)
  Fastest check for #1: database connection pool metrics
  Fastest check for #2: compare env vars between staging and prod
  Runs checks → EXPORT_BUCKET env var missing in prod
  Proposes fix: add env var to deploy config
  Creates specs/fix-export-500/spec.md

/implement fix-export-500
/verify fix-export-500
```

#### Quick task: no spec needed

```
User: "fix the typo in the footer — it says 'Copyrigth'"
  Agent recognizes this is trivial — no spec folder
  Fixes the typo
  Runs verification (detected: pnpm typecheck && pnpm lint)
  Reports: "Fixed. Verification passes."

/commit
```

#### Resuming after a break

```
--- new session, cold start ---

/resume
  Reads NOW.md → current feature: recon-csv-export
  Reads spec.md → objective and constraints
  Reads tasks.md → Phase 1 and 2 checked off, Phase 3 pending
  Reads verification.md → last run: typecheck PASS, lint PASS, build PASS
  Reads handoff.md → "Phase 3 not started; export logic needs CSV library choice"
  Validates git state: branch correct, no uncommitted changes

  Presents:
    "Resuming recon-csv-export. Phases 1-2 done. Phase 3 (CSV generation) is next.
     Handoff notes: need to choose between papaparse and csv-writer.
     Shall I start Phase 3?"

User: "yes" → /implement proceeds from Phase 3
```

---

## Installation

### Claude Code

```bash
claude plugin install /path/to/agentic-marketplace
```

Or from GitHub:

```bash
claude plugin install github:agapic/agentic-marketplace
```

### Cursor

```bash
# Global install (available in all projects)
./install-cursor.sh

# Project-level install (current project only)
./install-cursor.sh --project
```

<<<<<<< Updated upstream
This copies commands to `~/.cursor/commands/`, agents to `~/.cursor/agents/`, rules to `~/.cursor/rules/`, scripts to `~/.cursor/scripts/`, and skills to `~/.cursor/skills/`. Use `./install-cursor.sh --project` to install into the current project's `.cursor/` instead.
=======
This copies commands to `~/.cursor/commands/`, agents to `~/.cursor/agents/`, rules to `~/.cursor/rules/`, and templates to `~/.cursor/skills/spec-driven/templates/`.
>>>>>>> Stashed changes

---

## Plugin: `humanlayer-workflows` (legacy)

27 commands built for the HumanLayer platform. Includes thoughts/ sync, Linear integration, and HumanLayer-specific paths. Not recommended for new projects — use `spec-driven` instead.

Commands not ported to `spec-driven`: `oneshot`, `oneshot_plan`, `founder_mode`, `local_review`, `create_worktree`, `linear`, `ralph_*` — all HumanLayer/Linear-specific.

---

## Plugin: `ui-ux-pro-max`

<<<<<<< Updated upstream
| Path | Description |
|------|-------------|
| `skills/ui-ux-pro-max/SKILL.md` | Full skill instructions with quick reference and workflow |
| `skills/ui-ux-pro-max/scripts/search.py` | CLI search tool for domains, design systems, and stacks |
| `skills/ui-ux-pro-max/scripts/core.py` | Core search engine |
| `skills/ui-ux-pro-max/scripts/design_system.py` | Design system generator with reasoning rules |
| `skills/ui-ux-pro-max/data/*.csv` | Design data: styles, colors, typography, products, UX, charts, and more |
| `skills/ui-ux-pro-max/data/stacks/*.csv` | Stack-specific guidelines (React Native, Next.js, SwiftUI, Flutter, etc.) |
=======
UI/UX design intelligence for web and mobile. 50+ styles, 161 color palettes, 57 font pairings, 10 stacks (React, Next.js, Vue, Svelte, SwiftUI, React Native, Flutter, Tailwind, shadcn/ui, HTML/CSS), 99 UX guidelines, 25 chart types.
>>>>>>> Stashed changes

See `plugins/ui-ux-pro-max/SKILL.md` for full reference.
