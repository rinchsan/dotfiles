---
description: Review code changes. Usage: /review-code <branch> [base-branch]
---

# Code Review

Usage: /review-code <branch> [base-branch]

- `<branch>`: Review target branch (required)
- `[base-branch]`: Base branch for diff (optional, default: `main`)

## Steps

### 1. Parse arguments

Extract `$BRANCH` and `$BASE` (default `main`) from `$ARGUMENTS`.

### 2. Ensure target branch is available locally

Always fetch first to ensure both `$BASE` and `$BRANCH` remote refs are up to date:

```bash
git fetch -p
```

Then switch to the branch (if it exists locally) or create it from the remote:

```bash
git switch $BRANCH
```

If that fails, create the local branch tracking the remote:

```bash
git switch -c $BRANCH origin/$BRANCH
```

If switch still fails after fetch, report the error and stop.

### 3. Gather diff

Use `origin/$BASE` for the base ref to avoid failures when `$BASE` has no local tracking branch:

```bash
git diff origin/$BASE...$BRANCH
git diff --name-only origin/$BASE...$BRANCH
```

### 4. Gather PR context (if a PR exists)

```bash
gh pr view $BRANCH --json title,body,comments,reviews 2>/dev/null
```

If a PR exists:
- Extract the PR title, description, and comment threads.
- Scan the PR description for linked GitHub Issues in any of these formats:
  - Same-repo short reference: `#123`, `Closes #456`
  - Cross-repo short reference: `org/other-repo#123`
  - Full URL: `https://github.com/owner/repo/issues/123`

For each linked issue, fetch its content using the appropriate form:

```bash
# Same-repo issue (short number)
gh issue view <number> --json title,body,comments 2>/dev/null

# Full URL — works for any repo, no --repo flag needed
gh issue view https://github.com/owner/repo/issues/123 --json title,body,comments 2>/dev/null

# Cross-repo short reference — must pass --repo
gh issue view <number> --repo org/other-repo --json title,body,comments 2>/dev/null
```

Use the PR description, review comments, and issue bodies as specification context during the review. Issue content often contains PRDs, acceptance criteria, and design decisions that are essential for evaluating correctness.

### 5. Delegate review to the code-reviewer agent

Launch the **code-reviewer** agent using the **Opus** model (`model: "opus"`).

Pass all of the following to the **code-reviewer** agent:

- The full diff (`git diff origin/$BASE...$BRANCH`)
- The list of changed files
- PR title, description, and comments (if available)
- Linked issue titles, bodies, and comments (if available)

Instruct the agent to:
- Evaluate code changes against the specification captured in the PR and issues
- Follow the review checklist in the agent definition (CRITICAL → HIGH → MEDIUM → LOW)
- Produce a structured report with severity, file location, issue description, and suggested fix
- End with the standard Review Summary table and verdict

### 6. Report verdict

Relay the code-reviewer agent's full output, including the summary table and verdict.
