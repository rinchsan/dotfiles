---
description: Orchestrate the full development lifecycle: design -> plan -> implement -> self-review -> PR
---

# /ship - Development Workflow

Understands the request, runs design, plan, implementation, and self-review phases, then creates a PR ready for human review. Each phase is delegated to a sub-agent to distribute context usage.

Request: ${args}

---

## Phase 1: Pre-flight (orchestrator runs directly)

### 1-0. Parse arguments

Extract from `${args}`:
- **Request**: the description of what to build (everything except `--docs`)
- **Docs directory** (`$DOCS_DIR`): the path after `--docs` if specified, otherwise `.claude/docs`

```
# Examples
/ship "add login feature"                     → $DOCS_DIR = .claude/docs
/ship "add login feature" --docs ~/my-docs    → $DOCS_DIR = ~/my-docs
/ship --docs /tmp/docs "add login feature"    → $DOCS_DIR = /tmp/docs
```

Store `$DOCS_DIR` and use it when instructing sub-agents.

### 1-1. Confirm design phase

Analyze the request and share your recommendation with the user.

**Analysis criteria:**

| Recommend design phase | Design phase likely unnecessary |
| --- | --- |
| New feature addition | Refactoring with clear scope |
| Architecture changes spanning multiple components | Bug fix |
| Adding external service integration | Adding or improving tests |
| Data model / schema changes | Small adjustments or tweaks |

State your recommendation (design phase yes or no, with reasoning), then ask the user for final confirmation:

> "[Analysis and recommendation]
>
> Should we run the design phase (/design)?
> - **Yes**: Create requirements analysis, design doc, and ADR before moving to planning
> - **No**: Skip design and start directly from the planning phase"

**Do not skip this on your own judgment. Always get user confirmation before proceeding.**

---

## Phase 2: Design (only if Yes in Phase 1)

**Delegate to a sub-agent.**

Sub-agent instructions:
- Follow the procedure in `.claude/commands/design.md`
- Request: `${args}` (the request part, excluding `--docs`)
- Docs directory: `$DOCS_DIR` (save design docs to `$DOCS_DIR/design/`, ADRs to `$DOCS_DIR/adr/`)
- Completion condition: user approves the design doc
- Return: design doc content as text in the conversation (no file write needed)

After the sub-agent completes, store the design doc content as `$DESIGN_DOC` and proceed to Phase 3.

---

## Phase 3: Plan

**Delegate to a sub-agent.**

Sub-agent instructions:
- Follow the procedure in `.claude/commands/plan.md`
- Design doc: `$DESIGN_DOC` (if Phase 2 was skipped, create a plan directly from the request)
- Docs directory: `$DOCS_DIR` (find design docs in `$DOCS_DIR/design/`, save plan to `$DOCS_DIR/plans/`)
- Completion condition: user approves the work plan
- Return: work plan content as text in the conversation (no file write needed)

After the sub-agent completes, store the work plan content as `$PLAN` and proceed to Phase 4.

---

## Phase 4: Worktree and branch creation (orchestrator runs directly)

### 4-1. Determine branch name

Generate a branch name from the plan content (format: `<kebab-case-description>`, no prefix).
Store as `$BRANCH_NAME` and proceed immediately without user confirmation.

### 4-2. Create worktree

```bash
git fetch origin main
REPO_NAME="$(basename $(git rev-parse --show-toplevel))"
WORKTREE_DIR="$(git rev-parse --show-toplevel)/../${REPO_NAME}-${BRANCH_NAME}"
git worktree add -b "$BRANCH_NAME" "$WORKTREE_DIR" origin/main
WORKTREE_DIR="$(cd "$WORKTREE_DIR" && pwd)"
git worktree list
```

Store the absolute path of `$WORKTREE_DIR`.

---

## Phase 5: Implementation

**Delegate to a sub-agent.**

Sub-agent instructions:
- Follow the procedure in `.claude/commands/implement.md`
- Work plan content: `$PLAN`
- **Important: All file operations must use absolute paths under `$WORKTREE_DIR`. Do not edit files in the main working directory.**
- After implementation, commit inside the worktree:
  ```bash
  cd "$WORKTREE_DIR"
  git add -p
  git commit -m "<conventional-commit-message>"
  ```
- Return: confirmation of commit completion and a summary of the commit message

After the sub-agent completes, proceed to Phase 6.

---

## Phase 6: Self-review

**Delegate to a sub-agent.**

Sub-agent instructions:
- Act as the `code-reviewer` agent
- Working directory: `$WORKTREE_DIR`
- Run: `git diff main...HEAD` to get the full diff for this branch
- Review the diff following the code-reviewer checklist
- Return: review summary with counts and details by severity (Critical/High/Medium/Low)

---

## Phase 7: Fix issues and push (orchestrator runs directly)

Based on the review results, fix files under `$WORKTREE_DIR`:

| Severity | Action |
| --- | --- |
| **Critical / High** | Must fix and commit |
| **Medium** | Fix if trivial |
| **Low** | Leave for human reviewer |

If there are fixes:

```bash
cd "$WORKTREE_DIR"
git add -p
git commit -m "fix: address self-review findings"
```

Then push:

```bash
cd "$WORKTREE_DIR"
git push origin "$BRANCH_NAME"
```

---

## Phase 8: Create PR (orchestrator runs directly)

In `$WORKTREE_DIR`:

1. Check for a PR template:
   ```bash
   ls .github/pull_request_template.md .github/PULL_REQUEST_TEMPLATE.md 2>/dev/null
   ```
2. Get diff and commit history:
   ```bash
   git log main..$BRANCH_NAME
   git diff main..$BRANCH_NAME
   ```
3. Generate PR title and description based on the changes (follow the template if one was found)
4. Create the PR:
   - If no PR exists: `gh pr create --draft --title "$TITLE" --body "$DESCRIPTION"`
   - If a PR already exists: `gh pr edit --title "$TITLE" --body "$DESCRIPTION"`
5. Store the PR URL as `$PR_URL`

Display completion information:

```
✅ PR created.

PR URL   : $PR_URL
Branch   : $BRANCH_NAME
Worktree : $WORKTREE_DIR

To remove the worktree when done: git worktree remove "$WORKTREE_DIR"
```
