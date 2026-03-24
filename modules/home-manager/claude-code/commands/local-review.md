---
name: local-review
description: Code review local changes against main branch
---

Provide a code review for the current git branch diffed against `main`.

To do this, follow these steps precisely:

1. Use a lightweight agent to check the current state of the working directory:
    - Run `git status` to see what files have changes and the state of the git repo is.
    - Run `git branch --show-current` to find the current-branch
    - Run `git diff main...current-branch` to show diffs against main.
    - If there are no changes, do not proceed and inform the user
    - Return a summary of what files changed and the nature of the changes

2. Use another lightweight agent to find any relevant CLAUDE.md files: the root CLAUDE.md file (if one exists), as well
   as any CLAUDE.md files in the directories containing modified files

3. Then, launch powerful agents in parallel to independently code review the changes with specific focus. Each agent
   should
   read the full file context when needed. The agents should return a list of issues:
    - "Stale code and docs"-Agent: Check for code or documentation that becomes stale BECAUSE OF the changes and should
      therefore be updated along with the change. Pay special attention to
      unit-tests that are poorly named or obsolete after the change. It is fine if you don't find any problems.
    - "Code-Compliance"-Agent: Check for existing documentation in `.md` on how to write code, most importantly
      CLAUDE.md. Augment the given context with your knowledge on how to write idiomatic code. It is fine if you don't
      find any problems.
    - "Logic"-Agent: Read the file changes, then scan for bugs, logic errors, and edge cases. Focus on changes where you
      have strong indication that they were not intended by the developer. It is fine if you don't find any problems.
    - "Copy-paste"-Agent: Look out for hard-to-spot bugs that are usually result of too generously copy & paste. For
      example, accidentally inverting latitude & longitude in conversion functions or the order of function arguments of
      the same type. It is fine if you don't find any problems.
    - "Legal"-Agent: Audit the changes with respect to data minimization and legal compliance. Take the angle of GDPR,
      data protection, AI act, and the like. It is fine if you don't find any problems.
    - "Security"-Agent: Scan for security vulnerabilities: injection flaws, XSS, auth bypass, sensitive data exposure.
      But keep a focus on the changes. It is fine if you don't find any problems.
    - "Simplicity"-Agent: You are an expert code simplification specialist focused on enhancing code clarity,
      consistency, and maintainability while preserving exact functionality. Audit the changes with that perspective. It
      is fine if you don't find any problems.

4. For each issue found in #3, launch a parallel Haiku agent that takes the issue description and classify it:
    - Critical: Strong recommendation to fix before shipping. Note, that this category can include obvious trivial
      mistakes.
    - Warning: High confidence that there's something wrong here.
    - Info: This should be audited as intentional by an expert.
    - Nit: Something to consider, but definitely non-critical.

Notes:

- Do not attempt to build or typecheck the app
- Make a todo list first
- If no issues found, confirm the code looks good for shipping, otherwise use the output format below

Output format: All findings grouped by severity (Critical, Warning, Info, Nit).

For each finding, report:

- The relevant lines of code, for example, **file.rs:42-46** (use the colon syntax to specify the exact lines in the
  file)
- Brief description of the problem and why it matters
- A suggested fix (with a code snippet if helpful)
