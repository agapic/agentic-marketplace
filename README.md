# HumanLayer Marketplace

AI agent workflows for Claude Code and Cursor — implementation planning, codebase research, debugging, session handoffs, and more.
Fork from https://github.com/humanlayer/humanlayer that makes it easy to add as a marketplace.

## What's Included

### Plugin: `humanlayer-workflows`

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

This copies commands to `~/.cursor/commands/`, agents to `~/.cursor/agents/`, and scripts to `~/.cursor/scripts/`.

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
