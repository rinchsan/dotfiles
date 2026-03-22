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

### 2. Fetch latest remote state

Always fetch first to ensure both `$BASE` and `$BRANCH` remote refs are up to date:

```bash
git fetch -p
```

Verify the remote branch exists:

```bash
git ls-remote --exit-code origin $BRANCH
```

If the remote branch does not exist, report the error and stop.

### 3. Gather diff

Use remote refs (`origin/`) for both sides so that no local checkout is required and the review always reflects the current state on the remote:

```bash
git diff origin/$BASE...origin/$BRANCH
git diff --name-only origin/$BASE...origin/$BRANCH
```

Also capture recent commit history on the branch for context:

```bash
git log origin/$BASE..origin/$BRANCH --oneline
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

**CRITICAL: Always pass raw command output verbatim. Never manually transcribe, summarize, or paraphrase the diff or any other command output. Copy-paste the exact stdout from each command.**

Pass all of the following to the **code-reviewer** agent:

- The full diff — copy the **exact raw output** of `git diff origin/$BASE...origin/$BRANCH` without any modification
- The list of changed files — copy the **exact raw output** of `git diff --name-only origin/$BASE...origin/$BRANCH`
- Commit history — copy the **exact raw output** of `git log origin/$BASE..origin/$BRANCH --oneline`
- PR title, description, and comments (if available)
- Linked issue titles, bodies, and comments (if available)

Instruct the agent to:
- Evaluate code changes against the specification captured in the PR and issues
- Follow the review checklist in the agent definition (CRITICAL → HIGH → MEDIUM → LOW)
- Produce a structured report with severity, file location, issue description, and suggested fix
- End with the standard Review Summary table and verdict

### 6. Report verdict

Relay the code-reviewer agent's full output, including the summary table and verdict.
