# Git Workflow

## Commit Message Format

```text
<type>: <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci

Note: Attribution disabled globally via ~/.claude/settings.json.

## Commit Workflow

Split changes into separate commits by concern (one commit = one reviewable unit):

- **Non-app vs. app:** Commit repo/support files separately: `README.md`, `.gitignore`, Dockerfile, CI config, etc. Application code in its own commits.
- **By layer:** When the repo is layered, use one commit per layer (UI/presentation, domain, data, infrastructure). Use one commit per feature only when the change is small and spans layers as a single unit.
- **By feature/domain:** When organized by feature (see [coding-style.md](./coding-style.md)), align commits to those boundaries.
- **Docs and tests:** Prefer separate commits for docs-only or test-only changes.
- Use `git add -p` or staging by file to build commits; avoid mixing unrelated edits in one commit.

## Pull Request Workflow

When creating PRs:

1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch

> For the full development process (planning, TDD, code review) before git operations,
> see [development-workflow.md](./development-workflow.md).
