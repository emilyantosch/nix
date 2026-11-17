---
name: local-review
description: Review branch, pull-request, or working-tree changes for actionable defects and maintenance risks.
---

# Local review

Review only. Do not edit files or publish comments unless asked.

## Scope

Use the requested scope. Otherwise, review the current branch against the PR target or repository default branch.
For branch or PR reviews, use `git diff <base>...<head>`. If the base is unclear, ask.
For working-tree reviews, inspect staged, unstaged, and untracked files within scope.

## Review

1. Read task requirements and applicable repository guidelines, including `AGENTS.md`.
2. Read every change in context.
3. Trace affected callers, dependencies, and data flows.
4. Check the areas below where relevant.
5. Run relevant tests and static checks when safe and available.

Use repository check commands without automatic fixes.

- **Correctness:** intended behavior, edge cases, error handling, concurrency, resource cleanup, and copy-paste mistakes.
- **Security:** trust boundaries, input validation, authentication, authorization, injection, and secret or personal-data exposure.
- **Compatibility:** API and schema changes, migrations, configuration, dependencies, and realistic performance risks.
- **Maintainability:** design, unnecessary complexity, duplication, naming, and repository standards.
- **Tests and docs:** missing regression coverage, ineffective assertions, obsolete tests, and stale comments or instructions.
- **UI:** usability and accessibility.

## Findings

Report only actionable issues introduced or worsened by the change.
Verify each finding against surrounding code and existing safeguards.
Omit personal preferences, speculative risks, and unrelated pre-existing issues.
Combine findings with the same root cause. Separate unresolved questions from findings.

Rate severity by impact and likelihood, not confidence or fix size:

- **Critical:** severe security compromise, data loss, or widespread outage.
- **High:** major failure in a supported workflow.
- **Medium:** limited failure or a meaningful maintenance problem.
- **Low:** minor defect with a clear effect.

List findings from highest to lowest severity.
Use `[Severity] file:line — problem` for each finding.
Use the smallest relevant changed line range.
State the trigger, impact, evidence, and suggested fix.

List checks run, their results, and review limits.
If there are no findings, say “No actionable findings.” Do not claim release readiness.
