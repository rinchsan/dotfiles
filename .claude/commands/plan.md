---
description: Work plan creation from design docs
---

# /plan - Planning Phase

Create an actionable work plan from the design document. Engage in dialogue to refine and obtain user approval.

---

## Step 0: Resolve Output Directories

If called from `/ship`, use the `$DOCS_DIR` provided in the sub-agent instructions.
Otherwise (called standalone), default to `.claude/docs`.

Set:
- `$DESIGN_DIR = $DOCS_DIR/design`
- `$PLANS_DIR = $DOCS_DIR/plans`

## Step 1: Read Design Doc

If called from `/ship`, use the `$DESIGN_DOC` provided. Otherwise, look for relevant design docs in `$DESIGN_DIR` and read the appropriate one.

## Step 2: Codebase Exploration

Before planning, explore to identify concrete file paths:
- Use Glob to find files that will need to be created or modified
- Use Read to examine existing similar implementations for patterns to follow
- Identify test file conventions and where new tests should live

## Step 3: Create Work Plan

Use the template at `.claude/docs/templates/plan.md`.

**Task granularity guidelines:**
- Each task should be executable in 1–2 focused sessions
- Tasks should be independently testable where possible
- Each task should have a single clear responsibility
- Define explicit completion criteria for each task

**PR split decision:**

Consider splitting into multiple PRs when:
- Changes will span 10+ files
- Total diff is likely to exceed 500 lines
- Multiple independent functional units exist
- Staged rollout is preferable

If splitting is needed, include a clear PR split plan section.

**TDD integration:**
- For new functions or modules: plan to write tests first (RED), then implement (GREEN)
- For changes to existing code: plan to add regression tests before refactoring

## Step 4: Risk Assessment

**Enable Extended Thinking** before delegating. Risk assessment requires anticipating non-obvious failure modes — deeper reasoning surfaces risks that fast thinking misses.

**Delegate to the `architect` agent** with:
- The design doc content
- The proposed task breakdown from Step 3
- The codebase context gathered in Step 2
- Instructions to identify: technical risks, unknowns, dependencies on external systems, scalability concerns, and rollback strategies for each phase

After the architect agent returns its output, incorporate the risk findings into the work plan.

## Step 5: Obtain Approval

Present the work plan (with risk assessment) to the user and iterate until approved.

Save the final plan to `$PLANS_DIR/<NNN>-<title>.md`.

## ⚠️ Responsibility Boundaries

### ✅ Do in this phase
- Reading and understanding design docs
- Exploring the codebase to identify affected files
- Creating the work plan with concrete file paths
- Defining tasks, dependencies, and completion criteria
- Risk assessment and mitigation strategies (via architect agent)

### ❌ Do NOT in this phase
- Write any implementation code
- Create or edit files other than the plan doc
- Start implementation (that is /implement's responsibility)

## Completion

After user approves the work plan:
- Output the work plan content as text in the conversation
- State that the planning phase is complete and the plan is saved
- **Stop immediately.** Do not begin implementation.
