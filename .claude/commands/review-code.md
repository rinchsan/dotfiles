---
description: Review code changes. Usage: /review-code <branch|PR-reference> [base-branch]
---

# Code Review

Usage: /review-code <branch|PR-reference> [base-branch]

- `<branch|PR-reference>`: Review target (required). One of:
  - A branch name (e.g. `feature/foo`)
  - A full PR URL (e.g. `https://github.com/owner/repo/pull/123`)
  - A cross-repo PR reference (e.g. `owner/repo#123`)
  - A bare PR number in the current repository (e.g. `#123` or `123`)
- `[base-branch]`: Base branch for diff (optional, default: `main`; ignored when the target resolves to a PR, since the PR's own base branch is used instead)

## Steps

### 1. Parse arguments

Determine which form `$ARGUMENTS` takes:

- Full PR URL `https://github.com/<owner>/<repo>/pull/<number>` → extract `$OWNER`, `$REPO`, `$PR_NUMBER`.
- Cross-repo reference `<owner>/<repo>#<number>` → extract `$OWNER`, `$REPO`, `$PR_NUMBER`.
- Bare PR reference `#<number>` or a plain integer → set `$PR_NUMBER`; take `$OWNER`/`$REPO` from the current repository's `origin` remote.
- Otherwise → treat the first token as `$BRANCH` and the second token (optional) as `$BASE` (default `main`); take `$OWNER`/`$REPO` from the current repository's `origin` remote.

### 2. Resolve the target repository and branch

Determine `$REPO_PATH`:
- If `$OWNER`/`$REPO` match the current repository's `origin` remote, `$REPO_PATH` is the current working directory.
- Otherwise, `$REPO_PATH` is `~/go/src/github.com/$OWNER/$REPO`.

If `$REPO_PATH` does not exist or is not a git repository, report the error and stop. Do not clone it automatically.

If `$PR_NUMBER` was set, resolve `$BRANCH` and `$BASE` from the PR itself and reuse the result as the PR context gathered in step 5 (skip the separate `gh pr view` call there):

```bash
gh pr view $PR_NUMBER --repo $OWNER/$REPO --json title,body,comments,reviews,headRefName,baseRefName
```

Set `$BRANCH` to `headRefName` and `$BASE` to `baseRefName` from the result.

All commands in the remaining steps run against `$REPO_PATH` (use `git -C $REPO_PATH ...`, or `cd` there first).

### 3. Fetch latest remote state

Always fetch first to ensure both `$BASE` and `$BRANCH` remote refs are up to date:

```bash
git -C $REPO_PATH fetch -p
```

Verify the remote branch exists:

```bash
git -C $REPO_PATH ls-remote --exit-code origin $BRANCH
```

If the remote branch does not exist, report the error and stop.

### 4. Gather commit history

Capture recent commit history on the branch for context (lightweight — the diff itself is gathered later by the review agent, not here):

```bash
git -C $REPO_PATH log origin/$BASE..origin/$BRANCH --oneline
```

### 5. Gather PR context (if a PR exists)

If `$PR_NUMBER` was already resolved in step 2, reuse that output. Otherwise, look up the PR from the branch name:

```bash
gh pr view $BRANCH --repo $OWNER/$REPO --json title,body,comments,reviews 2>/dev/null
```

If a PR exists:
- Extract the PR title, description, and comment threads.
- Scan the PR description for linked GitHub Issues in any of these formats:
  - Same-repo short reference: `#123`, `Closes #456`
  - Cross-repo short reference: `org/other-repo#123`
  - Full URL: `https://github.com/owner/repo/issues/123`

If there are multiple linked issues, fetch all of them in a single Bash call (loop or chain the commands with `;`) rather than one Bash call per issue:

```bash
# Same-repo issue (short number)
gh issue view <number> --json title,body,comments 2>/dev/null

# Full URL — works for any repo, no --repo flag needed
gh issue view https://github.com/owner/repo/issues/123 --json title,body,comments 2>/dev/null

# Cross-repo short reference — must pass --repo
gh issue view <number> --repo org/other-repo --json title,body,comments 2>/dev/null
```

Use the PR description, review comments, and issue bodies as specification context during the review. Issue content often contains PRDs, acceptance criteria, and design decisions that are essential for evaluating correctness.

### 6. Delegate review to the code-reviewer agent

Launch the **code-reviewer** agent.

Do **not** fetch or paste the diff yourself. The agent has its own Bash tool and gathers the diff itself — pass it the repository path and ref range and let it run the command.

**Pass raw PR/issue command output verbatim. Never manually transcribe, summarize, or paraphrase it.**

Pass all of the following to the **code-reviewer** agent:

- The repository path to operate in: `$REPO_PATH`
- The ref range to review: `origin/$BASE...origin/$BRANCH` (state the resolved `$BRANCH` and `$BASE` values)
- Commit history — copy the **exact raw output** of `git log origin/$BASE..origin/$BRANCH --oneline`
- PR title, description, and comments (if available)
- Linked issue titles, bodies, and comments (if available)

Instruct the agent to:
- Run `git -C $REPO_PATH diff origin/$BASE...origin/$BRANCH` itself (and `git -C $REPO_PATH diff --name-only` for the file list, if useful) before reviewing
- Evaluate code changes against the specification captured in the PR and issues
- Follow the review checklist in the agent definition (CRITICAL → HIGH → MEDIUM → LOW)
- Produce a structured report with severity, file location, issue description, and suggested fix
- End with the standard Review Summary table and verdict

### 7. Report verdict

Relay the code-reviewer agent's full output, including the summary table and verdict.
