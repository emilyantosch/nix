---
name: commit-push-pr
description: Stage tracked changes only, commit them, push the current branch, and create a draft GitHub PR when no open PR exists. Use when the user asks to commit current tracked work and ensure it has a PR.
---

# Commit tracked changes and ensure a PR

1. Confirm this is a Git repository on a named, non-default branch.
2. Inspect `git status --short`, `git diff`, and recent commit subjects. Do not stage untracked files.
3. Run `git add -u`, review `git diff --cached`, and infer a concise commit message using conventional commit format.
4. Commit with these trailers:
   - `Co-Authored-By: $1 via Pi <noreply@anthropic.com>`
   - `AI-Assisted-By: $1`
5. Check for an open PR for the current branch with `gh pr list --head <branch> --state open`.
6. Before any push or PR creation, verify the push remote URL belongs to one of these GitHub organizations: `moia-dev`, `moia-oss`, `moia-playground`, `moia-test`, `moia-challenges`, or `vw-admt`. Refuse if it does not, or if ownership is ambiguous. Do not add or rewrite remotes.
7. Push the branch to its verified remote. If no PR exists, run `gh pr create --draft --fill` and report the new URL.
