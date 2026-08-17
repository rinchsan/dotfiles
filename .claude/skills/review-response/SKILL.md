---
name: review-response
description: Use this skill when the user wants to check PR review comments and address them — e.g. "there are comments on the PR", "address the review feedback", "reply to reviewers". Fetches inline and general PR comments, proposes fixes or replies, and commits per fix with a linked commit reference.
allowed-tools: Bash(gh:*), Bash(git commit:*), Bash(git push:*), Edit
---

# Review Response

Check the review comments on the current branch's PR and address them.

## Steps

1. **Identify PR number**
   - If given explicitly (e.g. a PR number in the request): use it directly (must be a positive integer; reject non-numeric input)
   - Otherwise: `gh pr view --json number` to get the PR for the current branch

2. **Get repository info**
   - `gh repo view --json owner,name` to get owner and repo name

3. **Fetch review comments**
   - General comments: `gh pr view {PR number} --comments`
   - Inline review comments: `gh api repos/{owner}/{repo}/pulls/{PR number}/comments` (required)

4. **Analyze each comment and present**
   - Summary of the feedback
   - Whether action is needed
   - Proposed approach if action is needed

5. **Address based on user instruction**
   - If code changes are needed: make the edits
   - If reply only: post via `gh api`
   - After making changes, confirm with the user before committing and pushing; commit per fix
   - After each commit, get the hash with `git rev-parse HEAD` and build a commit link:
     - Format: `https://github.com/{owner}/{repo}/pull/{PR number}/changes/{commit_hash}`
   - Include the commit link in the reply to the review comment (e.g. `{response}\n\n{commit_url}`)

6. **Display the PR URL** after all comments are addressed
