---
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(git blame:*), Bash(git show:*)
description: Code review local changes against main
---

Provide a code review for the current branch diffed against `main`.

To do this, follow these steps precisely:

1. Use a Haiku agent to check the current state of the working directory:
   - Run !`git status` to see what files have changes and the state of the git repo is.
   - Run !`git branch --show-current` to find the current-branch
   - Run `git diff main...current-branch` to show diffs against main.
   - If there are no changes, do not proceed and inform the user
   - Return a summary of what files changed and the nature of the changes

2. Use another Haiku agent to find any relevant CLAUDE.md files: the root CLAUDE.md file (if one exists), as well as any CLAUDE.md files in the directories containing modified files

3. Then, launch 5 parallel Sonnet agents to independently code review the changes. Each agent should read the full file context when needed. The agents should return a list of issues and the reason each issue was flagged:
   a. Agent #1: Audit the changes to make sure they comply with any CLAUDE.md and the !`cat dev_ai/assets/production_readiness_checklist.md` guideline. Note that CLAUDE.md is guidance for Claude as it writes code, so not all instructions will be applicable during code review.
   b. Agent #2: Read the file changes, then scan for bugs, logic errors, and edge cases. Focus on significant bugs, avoid nitpicks. Check for: null/undefined issues, off-by-one errors, race conditions, resource leaks, error handling gaps.
   c. Agent #3: Scan for security vulnerabilities (OWASP top 10): injection flaws, XSS, auth bypass, sensitive data exposure, insecure dependencies, etc.
   d. Agent #4: Check for Rust type-driven-design issues, performance problems, and code quality concerns that would fail code review.
   e. Agent #5 (Code Simplifier): You are an expert code simplification specialist focused on enhancing code clarity, consistency, and maintainability while preserving exact functionality. Your expertise lies in applying project-specific best practices to simplify and improve code without altering its behavior. You prioritize readable, explicit code over overly compact solutions.

      Analyze the changed code and flag issues related to:

      1. **Preserve Functionality**: Flag any simplification that would change what the code does - only how it does it matters. All original features, outputs, and behaviors must remain intact.

      2. **Apply Project Standards**: Flag violations of coding standards from CLAUDE.md including:
         - Use cargo crates with proper import sorting (`Cargo.toml` looks well maintained)
         - Consider idiomatic solutions
         - Prefer iterators over loops
         - Follow proper Type-Driven-Design patterns to make invalid states impossible to represent
         - Use proper error handling patterns, consider `thiserror` and `anyhow` as much as possible
         - Maintain consistent naming conventions

      3. **Enhance Clarity**: Flag code that could be simplified by:
         - Reducing unnecessary complexity and nesting
         - Eliminating redundant code and abstractions
         - Improving readability through clear variable and function names
         - Consolidating related logic
         - Removing unnecessary comments that describe obvious code
         - Choose clarity over brevity - explicit code is often better than overly compact code

      4. **Maintain Balance**: Do NOT flag issues that would lead to over-simplification:
         - Avoid reducing code clarity or maintainability
         - Avoid creating overly clever solutions that are hard to understand
         - Avoid combining too many concerns into single functions or components
         - Avoid removing helpful abstractions that improve code organization
         - Avoid prioritizing "fewer lines" over readability (e.g., long complex function chains)
         - Avoid making the code harder to debug or extend

      Return a list of code clarity and maintainability issues found in the changed code.

4. For each issue found in #3, launch a parallel Haiku agent that takes the issue description and CLAUDE.md files (from step 2), and returns a confidence score from 0-100. The scale is:
   a. 0: Not confident at all. This is a false positive that doesn't stand up to light scrutiny, or is a pre-existing issue.
   b. 25: Somewhat confident. This might be a real issue, but may also be a false positive. If the issue is stylistic, it was not explicitly called out in CLAUDE.md.
   c. 50: Moderately confident. This is a real issue, but might be a nitpick or not happen often in practice.
   d. 75: Highly confident. Verified this is very likely a real issue that will be hit in practice. Very important and will directly impact functionality.
   e. 100: Absolutely certain. Confirmed this is definitely a real issue that will happen frequently.

5. Filter out any issues with a score less than 80. If there are no issues that meet this criteria, report that no significant issues were found.

6. Present the filtered issues to the user, grouped by severity:
   - Critical (score 95-100): Must fix before committing
   - Warning (score 80-94): Should consider fixing
   - Simplification (from Agent #5): Code clarity improvements to consider

Examples of false positives to filter out in steps 3 and 4:

- Pre-existing issues (not introduced in current changes)
- Pedantic nitpicks that a senior engineer wouldn't call out
- Issues that a linter, typechecker, or compiler would catch
- General code quality issues unless explicitly required in CLAUDE.md
- Issues silenced by lint ignore comments
- Changes in functionality that are likely intentional

Notes:

- Do not attempt to build or typecheck the app
- Make a todo list first
- For each issue, include:
  - File path and line number
  - Brief description of the problem
  - Why it matters
  - Suggested fix (with code snippet if helpful)
- If no issues found, confirm the code looks good for commit

Output format:

---

### Local Code Review

Found N issues in uncommitted changes:

**Critical** (N issues)

1. **file.rs:42** - <brief description>

   <explanation and suggested fix>

**Warning** (N issues)

1. **file.rs:15** - <brief description>

   <explanation and suggested fix>

**Simplification** (N issues)

1. **file.rs:28** - <brief description>

   <explanation and suggested simplification>

---

Or, if no issues:

---

### Local Code Review

No significant issues found. Code looks good for commit.

Checked for: bugs, security vulnerabilities, CLAUDE.md compliance, type safety, code clarity.

---
