---
description: Review PRD quality. Usage: /review-prd <branch> [base-branch]
---

# PRD Review

Usage: /review-prd <branch> [base-branch]

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

### 3. Identify PRD files

Get the list of changed files on the branch:

```bash
git diff --name-only origin/$BASE...origin/$BRANCH
```

From the changed files, identify PRD candidates — document files (`.md`, `.txt`, `.rst`) whose path or filename contains any of: `prd`, `spec`, `requirement`, `要件`, `仕様`.

If no PRD candidates are found, report that no PRD files were detected and stop.

If multiple candidates are found, review all of them.

### 4. Read PRD content

For each identified PRD file, retrieve its content from the branch without a local checkout:

```bash
git show origin/$BRANCH:<path>
```

Also capture recent commit history on the branch for context:

```bash
git log origin/$BASE..origin/$BRANCH --oneline
```

### 5. Gather PR context (if a PR exists)

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

Use the PR description, review comments, and issue bodies as supplementary context during the review. Issue content often contains background, business objectives, or stakeholder discussions that help evaluate PRD completeness.

### 6. Delegate review to the prd-reviewer agent

Launch the **prd-reviewer** agent using the **Opus** model (`model: "opus"`).

**CRITICAL: Always pass raw content verbatim. Never manually transcribe, summarize, or paraphrase the PRD content or any other command output. Copy-paste the exact content from each command.**

Pass all of the following to the **prd-reviewer** agent:

- The PRD file content — copy the **exact raw output** of `git show origin/$BRANCH:<path>` without any modification
- Commit history — copy the **exact raw output** of `git log origin/$BASE..origin/$BRANCH --oneline`
- PR title, description, and comments (if available)
- Linked issue titles, bodies, and comments (if available)

Instruct the agent to:
- Review the PRD using the review checklist in the agent definition (CRITICAL → HIGH → MEDIUM → LOW)
- Use PR and issue context as background to better assess completeness and intent
- Produce a structured report with severity, section reference, issue description, and suggested improvement
- End with the standard Review Summary table and verdict

### 7. Report verdict

Relay the prd-reviewer agent's full output, including the summary table and verdict.
