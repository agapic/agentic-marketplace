---
description: Evidence-first investigation — diagnose before patching
---

# Investigate

Diagnose a problem using evidence, not speculation. Do NOT patch code first.

## Context Resolution

1. If an argument was provided, use it as the problem description or spec slug
2. If `NOW.md` exists at repo root, check for a current blocker
3. If neither, ask: "What problem are you seeing?"

If a spec folder exists for this work, write findings to `specs/<slug>/research.md`. Otherwise, output to conversation.

## Process

### 1. Do Not Patch Code

Resist the urge to fix anything before you understand it. Read this entire process before acting.

### 2. Gather the Symptom

Get precise details:
- Exact error message or unexpected behavior
- When it started (after a deploy? a code change? a config update?)
- What was expected vs. what happened
- Steps to reproduce

### 3. Generate Hypotheses

Produce 3-5 ranked hypotheses, ordered by investigation priority:

1. **Runtime/browser** — console errors, network failures, stack traces, promise hangs, rendering issues
2. **Environment/infrastructure** — deploy config, CLI versions, working directories, DNS, missing env vars, wrong branch
3. **Security/headers** — CSP, CORS, auth cookies, session state, blocked requests
4. **Application code** — only after runtime is checked: logic errors, missing null checks, wrong imports
5. **Data/state** — database, config files, cached state, stale builds, corrupted local storage

Present them:
```
Hypotheses (most likely first):
1. [hypothesis] — fastest check: [one command or observation]
2. [hypothesis] — fastest check: [one command or observation]
3. [hypothesis] — fastest check: [one command or observation]
```

### 4. Run Discriminating Checks

For the top 2 hypotheses, run the fastest check that would confirm or eliminate each:

**Project-agnostic discovery** — don't hardcode paths, discover them:
- Log files: scan for `.log` files, common log dirs, `docker logs`
- Databases: scan for `.db`, `.sqlite`, connection strings in config
- Deploy config: scan for `vercel.json`, `Dockerfile`, `fly.toml`, `netlify.toml`
- Running services: check `ps`, `docker ps`, listening ports
- Environment: check env vars, CLI versions, working directory
- Browser: console errors, network tab, response headers, CSP headers, storage state

Record every check you run and its result:
```
Check: [command or observation]
Result: [what was found]
Conclusion: [confirms/eliminates hypothesis N]
```

### 5. Propose the Smallest Fix

Based on evidence (not guess), propose the minimum change that addresses the root cause.

Present:
```
Root cause: [evidence-backed explanation]
Evidence: [what you found in step 4]
Proposed fix: [smallest change]
Files to change: [list]
Risk: [what could go wrong]
```

### 6. Implement and Verify

After the user approves (or if the fix is clearly safe):
1. Make the smallest change
2. Run verification (detect from project)
3. Confirm the original symptom is resolved
4. If a spec folder exists, update `specs/<slug>/research.md` with findings

## For Browser/Runtime Issues

When the symptom smells like runtime, require observable evidence before touching code:
- Console output (errors, warnings)
- Network requests (failed, blocked, wrong status)
- Response headers (CSP, CORS, cache)
- Storage/session state
- Stack traces with exact file:line

Do NOT assume the bug is in React/component code until runtime checks are done.

## Guidelines

- **Evidence before patches**: never propose a fix without citing what check produced the evidence
- **Runtime before code**: most "code bugs" are actually environment, config, or runtime issues
- **Smallest fix**: once you know the cause, change the minimum necessary
- **Record everything**: findings are valuable even if the first hypothesis was wrong
- **Ask for help**: if checks require access you don't have (production logs, browser console), tell the user exactly what to check and what to look for

## Completion

1. If a spec folder was used, present `specs/<slug>/research.md` location
2. Update `NOW.md` with investigation status
3. If fixed: "Root cause identified and fixed. Verification: [PASS/FAIL]."
4. If blocked: "Investigation narrowed to [hypothesis]. Need [specific access/info] to proceed."
