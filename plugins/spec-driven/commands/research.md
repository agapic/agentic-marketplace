---
description: Deep parallel codebase exploration using specialized sub-agents
---

# Research

Conduct comprehensive codebase research by spawning parallel sub-agents and synthesizing findings. Your job is to document and explain the codebase as it exists — not to critique or improve it.

## Context Resolution

1. If an argument was provided, use it as the research question
2. If invoked without a question, ask: "What would you like to understand about this codebase?"

If a spec folder exists for related work, write findings to `specs/<slug>/research.md`. Otherwise, output to conversation.

## Process

### 1. Read Mentioned Files First

If the user references specific files, read them completely before spawning sub-agents. You need full context before decomposing the research.

### 2. Decompose the Question

Break the query into composable research areas. Create a todo list to track exploration tasks.

### 3. Spawn Parallel Sub-Agents

Use specialized agents concurrently for efficiency:

- **codebase-locator**: find WHERE files and components live
- **codebase-analyzer**: understand HOW specific code works
- **codebase-pattern-finder**: find examples of existing patterns

For external information (only if the user asks):
- **web-search-researcher**: documentation, best practices, API references

Each agent knows its job — provide what you're looking for, not instructions on how to search. Be specific about directories to focus on.

### 4. Synthesize Findings

Wait for ALL sub-agents to complete, then:
- Compile results, prioritizing live codebase findings as primary source of truth
- Connect findings across components
- Include specific file paths and line numbers
- Answer the user's question with concrete evidence

### 5. Write Research Document

If writing to `specs/<slug>/research.md`:

```markdown
# Research: [Topic]

**Date**: YYYY-MM-DD
**Git Commit**: [hash]
**Branch**: [branch]

## Research Question
[Original query]

## Summary
[High-level answer]

## Detailed Findings

### [Component/Area 1]
- [Finding with file:line reference]
- [How it connects to other components]

### [Component/Area 2]
...

## Code References
- `path/to/file.py:123` — Description
- `another/file.ts:45-67` — Description

## Architecture
[Current patterns, conventions, and design found in the codebase]

## Open Questions
[Areas that need further investigation]
```

### 6. Handle Follow-ups

If the user has follow-up questions:
- Spawn new sub-agents for additional investigation
- Append to the research document under `## Follow-up: [topic]`
- Update the date

## Guidelines

- **Document what IS, not what SHOULD BE** — you are a technical writer, not a consultant
- **Parallel agents for speed** — don't serialize what can run concurrently
- **File:line references** — every claim must cite where it was found
- **Read fully** — no partial file reads, no limit/offset
- **Fresh research** — always run live codebase searches, don't rely solely on existing documents

## Completion

1. Present findings with key file references
2. If written to `specs/<slug>/research.md`, state the location
3. Ask if follow-up questions remain
