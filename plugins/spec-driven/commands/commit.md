---
description: Create git commits with user approval
---

# Commit

Create atomic git commits for the changes made during this session.

## Process

1. **Understand what changed:**
   - Review what was accomplished in this session
   - Run `git status` to see current changes
   - Run `git diff` to understand the modifications
   - Consider whether changes should be one commit or multiple logical commits

2. **Plan your commit(s):**
   - Group related files together
   - Draft clear, descriptive commit messages
   - Use imperative mood ("add", "fix", "update", not "added", "fixed")
   - Focus on why the changes were made, not just what
   - If working on a spec, reference the slug in the message

3. **Present your plan:**
   - List the files for each commit
   - Show the commit message(s)
   - Ask: "I plan to create [N] commit(s). Shall I proceed?"

4. **Execute upon confirmation:**
   - Use `git add` with specific files (never `-A` or `.`)
   - Create commits with planned messages
   - Show result with `git log --oneline -n [N]`

## Rules

- Never add co-author attribution or AI-generated notices
- Commits should read as if the user wrote them
- Keep commits focused and atomic
- Group related changes, split unrelated ones
