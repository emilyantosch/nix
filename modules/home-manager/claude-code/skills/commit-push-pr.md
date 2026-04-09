---
name: commit-push-pr
desc: Commit all changes, push to remote and open draft PR using gh
---
# Commit-Push-PR

Current Git Status: !`git status`
Recent commits: !`git log --oneline -5`
Current branch: !`git branch --show-current`

DO NOT, UNDER ANY CIRCUMSTANCES, MENTION IN ANY MESSAGE THAT THIS COMMIT OR PR HAS BEEN COAUTHORED BY AI. THIS WILL BE MADE TRANSPARENT THROUGH DIFFERENT MEANS.

## Committing

1. Review all staged and unstaged changes with `sem diff` and `sem diff --format json`
2. Group related changes into logical commits (split where it makes sense)
3. Stage files with `git add` as needed
4. Commit using conventional commits format: `type(scope): description`
   - Types: feat, fix, refactor, docs, test, chore, style, perf, build, ci
   - Keep messages under 60 characters
   - Do NOT add any AI-generated remarks, footers, or co-author lines
5. Push to origin: `git push origin {branch_name}`
6. If the push is rejected, because of any problems with the remote, report back to the user and stop execution.

## Creating PR

1. Check if there is already a PR for the current branch. If yes, you are done and can stop execution.
2. Extract ticket number from branch name (the part before the first `/`)
3. Create draft PR with `gh pr create`:
   - Title: `[ticket_number] Short description of changes`
   - Body: Brief summary of what the PR contains (2-3 sentences max). Do not use misdirection, just type the string as is (no EOF and pipes).
   - Always use `--draft` flag

## Example

Branch: `ABC-123/add-user-auth`
Commit: `feat(auth): add login endpoint`
PR Title: `[ABC-123] Add user authentication`
PR Body: `Adds login endpoint with JWT token generation. Includes basic validation.`
