# Agentic Marketplace

AI agent workflows for Claude Code and Cursor — implementation planning, codebase research, debugging, session handoffs, and more.

## Plugins

| Plugin | Commands | Agents | Description |
|--------|----------|--------|-------------|
| `spec-driven` | 12 | 4 | **Recommended.** Generic spec-driven workflow. No issue tracker dependency, cross-tool. |
| `humanlayer-workflows` | 27 | 6 | Legacy. Includes thoughts/ sync, Linear integration, game-specific content. |
| `ui-ux-pro-max` | — | — | UI/UX design intelligence (independent). |

## What's Included

### Plugin: `spec-driven` (recommended)

**12 Commands** — generic, cross-tool agent workflow:

| Command | Description |
|---------|-------------|
| `/plan` | Create or iterate spec + phased implementation plan (adaptive depth) |
| `/implement` | Execute plan phase by phase with spec echo and verification |
| `/verify` | Run acceptance checks and cross-check completeness |
| `/investigate` | Evidence-first diagnosis — hypotheses before patches |
| `/commit` | Atomic git commits with user approval |
| `/pr` | Generate PR descriptions enriched from specs |
| `/research` | Deep parallel codebase exploration using sub-agents |
| `/invariants` | Analyze codebase for correctness rules |
| `/tests` | Generate high-quality tests from invariants |
| `/handoff` | Write structured session handoff to specs/ |
| `/resume` | Restore context from spec artifacts |
| `/bootstrap` | Scaffold new repo to agent-ready state |

**4 Subagents:**

| Agent | Description |
|-------|-------------|
| `codebase-analyzer` | Deep-dive into HOW code works with file:line references |
| `codebase-locator` | Find WHERE code lives — super grep/glob/ls |
| `codebase-pattern-finder` | Find existing patterns and code examples |
| `web-search-researcher` | Find up-to-date information from the web |

**2 Always-On Rules** (`.mdc`):

| Rule | Purpose |
|------|---------|
| `agent-discipline.mdc` | Spec echo before changes, evidence-backed claims, escalation rules |
| `verification-after-edit.mdc` | Auto-detect and run fast verification after code edits |

**4 Templates** (`specs/_templates/`):

| Template | Purpose |
|----------|---------|
| `spec.md` | IntentSpec YAML: objective, outcomes, constraints, edge cases |
| `tasks.md` | Phased plan with automated + manual success criteria |
| `acceptance.md` | Required checks and manual verification steps |
| `handoff.md` | Session transition: status, open issues, next action |

### Plugin: `humanlayer-workflows` (legacy)

**27 Commands** (slash commands invoked with `/`):

| Command | Description |
|---------|-------------|
| `/create_plan` | Interactive implementation planning with subagent research |
| `/create_plan_generic` | Generic version (no HumanLayer-specific paths) |
| `/create_plan_nt` | Planning without thoughts/ directory |
| `/research_codebase` | Comprehensive codebase research using parallel subagents |
| `/research_codebase_generic` | Generic version |
| `/research_codebase_nt` | Research without thoughts/ directory |
| `/implement_plan` | Execute plans phase-by-phase with verification |
| `/iterate_plan` | Update existing plans based on feedback |
| `/iterate_plan_nt` | Iterate plans without thoughts/ directory |
| `/validate_plan` | Verify implementation against plan |
| `/commit` | Interactive atomic git commits (with user approval) |
| `/ci_commit` | Non-interactive git commits |
| `/describe_pr` | Generate PR descriptions from diffs |
| `/ci_describe_pr` | CI-oriented PR descriptions |
| `/describe_pr_nt` | PR descriptions without thoughts/ directory |
| `/debug` | Systematic debugging via logs, state, and git |
| `/create_handoff` | Create session handoff documents |
| `/resume_handoff` | Resume work from a handoff |
| `/create_worktree` | Set up git worktree for parallel work |
| `/local_review` | Set up worktree for reviewing a branch |
| `/linear` | Linear ticket management (create, update, search) |
| `/ralph_plan` | Create plan for highest-priority Linear ticket |
| `/ralph_research` | Research highest-priority Linear ticket |
| `/ralph_impl` | Implement highest-priority Linear ticket |
| `/founder_mode` | Experimental work → ticket + PR flow |
| `/oneshot` | Research + launch planning session |
| `/oneshot_plan` | Plan + implement for a ticket |

**6 Subagents** (auto-delegated specialized agents):

| Agent | Description |
|-------|-------------|
| `codebase-analyzer` | Deep-dive into HOW code works with file:line references |
| `codebase-locator` | Find WHERE code lives — super grep/glob/ls |
| `codebase-pattern-finder` | Find existing patterns and code examples |
| `thoughts-analyzer` | Extract high-value insights from research/design docs |
| `thoughts-locator` | Discover existing docs, plans, research, handoffs |
| `web-search-researcher` | Find up-to-date information from the web |

**2 Scripts** (supporting automation):

| Script | Description |
|--------|-------------|
| `spec_metadata.sh` | Collect git/repo metadata for document frontmatter |
| `create_worktree.sh` | Create and set up git worktrees for parallel development |

## Installation

### Claude Code

```bash
claude plugin install /path/to/humanlayer-marketplace
```

Or if hosted on GitHub:

```bash
claude plugin install github:humanlayer/humanlayer-marketplace
```

### Cursor

Run the install script:

```bash
# Global install (available in all projects)
./install-cursor.sh

# Project-level install (current project only)
./install-cursor.sh --project
```

This copies commands to `~/.cursor/commands/`, agents to `~/.cursor/agents/`, rules to `~/.cursor/rules/`, scripts to `~/.cursor/scripts/`, and skills to `~/.cursor/skills/`.

### Plugin: `ui-ux-pro-max`

**UI/UX Design Intelligence** — comprehensive design guide for web and mobile applications.

| Resource | Count |
|----------|-------|
| UI Styles | 50+ |
| Color Palettes | 161 |
| Font Pairings | 57 |
| Product Types | 161 |
| UX Guidelines | 99 |
| Chart Types | 25 |
| Technology Stacks | 10 |

**Key Features:**

- **Design System Generator** — generates complete design systems (pattern, style, colors, typography, effects) with reasoning
- **Searchable Database** — search by domain: product, style, color, typography, chart, UX, landing, Google Fonts, React perf, and more
- **Priority-Based Rules** — 10 rule categories ranked by impact (Accessibility → Charts & Data)
- **Pre-Delivery Checklist** — visual quality, interaction, light/dark mode, layout, and accessibility verification
- **Stack Guidelines** — implementation-specific best practices for React Native and other stacks

**Included Files:**

| Path | Description |
|------|-------------|
| `SKILL.md` | Full skill instructions with quick reference and workflow |
| `scripts/search.py` | CLI search tool for domains, design systems, and stacks |
| `scripts/core.py` | Core search engine |
| `scripts/design_system.py` | Design system generator with reasoning rules |
| `data/*.csv` | Design data: styles, colors, typography, products, UX, charts, and more |
| `data/stacks/*.csv` | Stack-specific guidelines (React Native, Next.js, SwiftUI, Flutter, etc.) |

## Notes

- Commands referencing `thoughts/` use the [HumanLayer thoughts](https://github.com/humanlayer/humanlayer) system for persistent document storage. The `_nt` variants work without it.
- Commands referencing Linear (`/linear`, `/ralph_*`) require Linear MCP tools and contain HumanLayer-specific workspace IDs.
- Scripts reference `humanlayer` CLI commands in some paths; adapt as needed for your setup.
- The `_generic` command variants have HumanLayer-specific references removed for use in any project.
