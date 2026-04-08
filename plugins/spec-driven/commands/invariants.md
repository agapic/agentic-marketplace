---
description: Analyze the codebase and create or refresh INVARIANTS.md with domain rules, state transitions, contracts, and risky edge cases
argument-hint: "[optional focus area, feature, or module]"
---

# Invariants

Inspect this codebase and create a high-quality `INVARIANTS.md` at the repository root. This file defines the deepest correctness rules of the system so that test-generation commands can use it as a source of truth.

If `INVARIANTS.md` already exists, read it first. Preserve anything still accurate. Improve, expand, and correct where needed.

## What Counts as an Invariant

An invariant is a rule that must always hold true for the system to be correct.

**Good invariants:**
- Describe stable behavioral truth
- Are implementation-agnostic where possible
- Would matter to a user, operator, or downstream system if broken
- Help drive tests, reviews, and refactors

**Bad invariants:**
- Merely restate code structure
- Describe incidental implementation details
- Are too vague to test
- Are speculative with no grounding in the codebase

## Optional Focus

If the user passed an argument, prioritize that area: `$ARGUMENTS`

If no argument was provided, analyze the highest-value core domain first.

## What to Inspect

Examine:
- Core domain entities and their relationships
- Main user journeys
- Key lifecycles (resources, sessions, transactions, processes)
- Persistence boundaries
- API and event contracts
- Auth/session assumptions
- External dependencies
- Places where state can drift or become inconsistent

Look at:
- Domain/service logic
- API routes and handlers
- State management (reducers, stores, event handlers)
- Persistence/repository code
- Validation and parsing code
- Event/message definitions
- Existing tests, docs, or comments that reveal intended behavior

## Required Sections

### 1. System Overview
Short. Summarize the core purpose, major entities, and most important user journeys.

### 2. Domain Invariants
Rules about the core business model: uniqueness constraints, correctness rules, membership rules, ownership/authority, accepted vs rejected actions, impossible states.

For each invariant:
- Name
- Statement of the invariant
- Why it matters
- What kind of bug would violate it
- Best test layer: unit, integration, contract, or scenario

### 3. State Machine / Transition Invariants
Important state transitions and forbidden transitions. Key states, valid transitions, invalid transitions, one-way transitions, transitions that must be atomic.

Use tables where they improve clarity. For each transition rule: from-state, event/action, allowed next-states, forbidden next-states, failure/retry notes.

### 4. Contract Invariants
API, event, and message contract expectations: important message/event names, required fields, validation expectations, error semantics, backwards compatibility, shape coupling risks between components.

### 5. Persistence Invariants
What must persist, what may be ephemeral, what must remain consistent after restart/reconnect, how stored state relates to live state, whether persistence failure blocks progression or only affects durability.

### 6. Failure and Recovery Invariants
What must still hold under failure: disconnects, malformed input, failed persistence, partial operations, duplicate requests, stale state, timeout/retry behavior.

### 7. Highest-Risk Regression Areas
Top areas where a change is most likely to break real behavior. For each: why it's risky, which invariants are involved, strongest test types.

### 8. Suggested Tests Derived from Invariants
Map the most important invariants to candidate tests: invariant name, recommended test name, test layer, why this test is high value.

This section directly feeds the `/tests` command.

## Quality Bar

The file must be:
- Concrete and testable
- Implementation-aware but not implementation-trapped
- Grounded in actual code (cite file:line references)
- Useful for automated test generation

Do not invent product rules with no evidence. If something is inferred, state the evidence and mark it as needing confirmation.

## Execution

1. Inspect the repository (use sub-agents for parallel exploration)
2. Read any existing `INVARIANTS.md`
3. Derive the system's major entities, flows, and risks
4. Write or update `INVARIANTS.md`
5. Ensure it is useful as a source of truth for `/tests`

Think like a skeptical staff engineer who wants to prevent regressions in this specific system.
