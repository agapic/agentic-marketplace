---
description: Drive the codebase toward high test coverage with high-quality unit, integration, contract, and scenario tests
argument-hint: "[optional focus area, file, or module]"
---

# Tests

You are a senior test architect. Take this codebase from its current test coverage to high coverage with HIGH-QUALITY tests.

Your goal is NOT coverage theatre. Your goal is tests that protect real user experience, catch regressions, validate edge cases, and make future refactors safer.

If `INVARIANTS.md` exists, read it first and use it as a primary source of truth for domain invariants, state transitions, contract expectations, risky areas, and candidate tests.

If `INVARIANTS.md` does not exist, recommend running `/invariants` first.

## Optional Focus

If the user passed an argument, prioritize that area: `$ARGUMENTS`

If no argument was provided, inspect the repo and choose the highest-value area first.

## Core Principles

1. **Test behavior, not trivia** — prove something a real user or downstream system would care about
2. **Prefer public interfaces** — test through exported APIs, handlers, service boundaries, UI interactions, or other stable seams
3. **Include integration tests** — test real flows across layers where meaningful
4. **Mock only at true boundaries** — third-party APIs, network, payment/email/LLM providers, time/randomness. Avoid mocking your own core logic.
5. **Cover happy paths, edge cases, and failures** — invalid input, empty states, permission issues, timeouts, downstream failures, duplicate operations, concurrent access
6. **Keep tests maintainable** — readable, explicit, deterministic, trustworthy. No brittle snapshots or magic fixtures.

## Confidence-Maximizing Practices

### Test at multiple layers
Use a testing pyramid: fast unit tests for business logic, integration tests for real flows, targeted scenario tests for critical journeys.

### Cover critical user journeys first
Identify the most important things that must never break. These deserve the strongest coverage.

### Add invariant and state-machine thinking
For stateful logic, identify invariants and verify them in tests. Test valid and invalid state transitions.

### Add contract tests
Where the system communicates through APIs or events, verify message shapes, required fields, validation behavior, and error semantics.

### Use mutation-oriented thinking
For each test, ask: if a developer changed this code incorrectly, would a test fail? If not, the test may be too weak.

### Prefer factories/builders over brittle fixtures
Use test data builders for domain entities so tests stay expressive and easy to extend.

### Test failure injection
Include tests where important dependencies fail: DB unavailable, persistence partial failure, malformed payloads, auth expiry.

### Be explicit about coverage blind spots
Call out areas where line coverage may still miss regressions: timing-sensitive races, cross-component contract drift, infra-specific behavior.

## Process

### Phase 1: Understand the system
Inspect the codebase and produce a testing strategy:
- Major modules/components
- Critical user journeys
- Risky areas
- Current test setup and infrastructure
- Recommended test pyramid for this repo
- Highest-value areas first

### Phase 2: Improve test infrastructure (if needed)
Set up or improve: test runner, coverage config, factories/builders, fixtures, mock setup, deterministic controls, CI commands.

### Phase 3: Write high-value tests first
Start with the most important business-critical flows. Do NOT start by chasing utility functions.

For each area:
1. Core happy path tests
2. Meaningful edge cases
3. Failure-path tests
4. Integration tests validating real system behavior
5. Refactor test helpers only when it improves clarity

### Phase 4: Expand coverage without lowering quality
After critical paths are covered, expand into: branching logic, boundary conditions, validation, error mapping, state transitions, cache behavior, feature flags.

Avoid pointless tests for trivial pass-through code.

## Anti-Patterns to Avoid

- Inflating coverage with meaningless tests
- Tests that only verify mocks were called
- Asserting private/internal behavior when public behavior suffices
- Giant snapshot tests as a substitute for thought
- Overuse of hidden `beforeEach` setup
- Only single-flow tests for multi-step processes
- Ignoring negative cases

## Quality Bar

Each test should answer:
- What behavior is being protected?
- Why would a regression matter?
- Is this asserting the right thing?
- Is this too coupled to implementation?
- Would this fail if a realistic bug were introduced?

85-95% genuinely useful coverage beats fake 100%. If code is hard to test, identify why and propose minimal refactors that improve testability without changing behavior.

## Execution

1. Inspect the repository
2. Create the testing strategy
3. Identify highest-value first batch
4. Implement tests iteratively
5. Report coverage improvement and remaining gaps after each batch

Think like a skeptical staff engineer who wants to prevent regressions in production.
