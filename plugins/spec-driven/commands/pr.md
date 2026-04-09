---
description: Generate comprehensive PR descriptions enriched from spec artifacts
---

# PR Description

Generate a pull request description by analyzing the diff, commit history, and spec artifacts.

## Process

### 1. Identify the PR

- Check if current branch has a PR: `gh pr view --json url,number,title,state 2>/dev/null`
- If no PR exists, list open PRs: `gh pr list --limit 10 --json number,title,headRefName`
- Ask user which PR if ambiguous

### 2. Gather Context

**From git:**
- Full diff: `gh pr diff {number}` or `git diff main...HEAD`
- Commit history: `git log main..HEAD --oneline`
- Changed files: `git diff main...HEAD --name-only`

**From specs (if available):**
- Read `specs/<slug>/spec.md` for objective and non-goals
- Read `specs/<slug>/acceptance.md` for verification criteria
- Read `specs/<slug>/verification.md` for test results
- These enrich the PR description with "why" context that the diff alone can't provide

### 3. Analyze Changes

Read the entire diff carefully:
- What problem does this solve?
- What is the implementation approach?
- Are there user-facing changes?
- Are there breaking changes or migration needs?
- What was explicitly NOT changed (and why)?

### 4. Run Verification

If the project has verification commands (detect from `package.json`, `Makefile`, etc.):
- Run them before generating the description
- Include results in the PR — reviewers should know the state

### 5. Generate Description

Write the PR description with:

```markdown
## Summary

[1-3 sentences: what this PR does and why]

## Changes

- [Grouped by component/area, not by file]
- [Focus on behavior changes, not line-by-line diffs]

## Non-goals

[What this PR explicitly does NOT do — from spec if available]

## Verification

- [check]: PASS/FAIL
- [check]: PASS/FAIL

## Testing

[How to test manually, if relevant]

## Notes for reviewers

[Anything non-obvious: tradeoffs made, areas of concern, follow-up work needed]
```

### 6. Apply

- Write to PR: `gh pr edit {number} --body-file /tmp/pr-description.md`
- Or present for user to copy if no `gh` access

## Guidelines

- Focus on **why** as much as **what**
- Be thorough but scannable — reviewers skim
- If the PR touches multiple components, organize by area
- Include breaking changes prominently
- Reference the spec slug if one exists
