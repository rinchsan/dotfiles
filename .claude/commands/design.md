---
description: Requirements analysis through design doc creation
---

# /design - Design Phase

Analyze requirements, explore the codebase, and create design documents. Engage in dialogue with the user to clarify the true intent behind the request before producing artifacts.

Requirements: ${args}

---

## Step 0: Resolve Output Directories

If called from `/ship`, use the `$DOCS_DIR` provided in the sub-agent instructions.
Otherwise (called standalone), default to `.claude/docs`.

Set:
- `$DESIGN_DIR = $DOCS_DIR/design`
- `$ADR_DIR = $DOCS_DIR/adr`

## Step 1: Codebase Exploration

Before designing, explore the codebase to understand existing patterns:

- Use Glob to discover directory structure and file organization
- Use Grep to find existing implementations related to the feature area
- Use Read to examine similar components and understand conventions
- Note: architecture patterns, naming conventions, error handling approaches, test patterns

## Step 2: Requirements Clarification

Engage in dialogue to understand the true purpose:
- What problem is being solved?
- Expected outcomes and success criteria
- Relationship to existing system components
- Constraints and non-goals

## Step 3: Scope Assessment

Based on exploration and clarified requirements, classify the work scale:

| Scale | Threshold | Documentation Required |
| --- | --- | --- |
| Small | 1–2 files, single function | None |
| Medium | 3–5 files, multiple components | Design Doc |
| Large | 6+ files, architecture change | Design Doc + ADR |

**ADR required when:**
- Changing type systems or data models significantly
- Altering core data flows
- Making architectural decisions that affect multiple components
- Adding external dependencies

## Step 4: Design Document Creation

**Enable Extended Thinking** before delegating. This step involves complex architectural reasoning — deeper thinking directly improves design quality.

**Delegate to the `architect` agent** with:
- The requirements and clarified goals from Step 2
- The codebase context from Step 1 (existing patterns, conventions)
- The scope classification from Step 3
- The template at `.claude/docs/templates/design.md`
- Instructions to produce a complete design doc covering: problem statement, proposed solution, alternatives considered, trade-offs, and any open questions

After the architect agent returns its output, save the design doc to `$DESIGN_DIR/<NNN>-<title>.md`.

Present the design doc to the user for approval and iterate until approved.

## Step 5: ADR (if needed)

When the scope is Large or an explicit architectural decision must be recorded:

**Enable Extended Thinking** before delegating. ADRs capture irreversible decisions — thorough reasoning here prevents costly mistakes later.

**Delegate to the `architect` agent** with:
- The approved design doc content
- The specific architectural decision to record
- The template at `.claude/docs/templates/adr.md`
- Instructions to draft an ADR covering: context, decision, consequences (positive/negative), and alternatives considered

After the architect agent returns its output, save the ADR to `$ADR_DIR/<NNN>-<title>.md`.

## ⚠️ Responsibility Boundaries

### ✅ Do in this phase
- Requirements analysis and clarification
- Codebase exploration to inform design
- Creating design docs and ADRs (via architect agent)
- Obtaining user approval

### ❌ Do NOT in this phase
- Write implementation code (not even samples)
- Create or edit files other than design docs and ADRs
- Create work plans (that is /plan's responsibility)
- Break down tasks (that is /plan's responsibility)

## Completion

After user approves the design doc:
- Output the design doc content as text in the conversation
- State that the design phase is complete and the doc is saved
- **Stop immediately.** Do not proceed to planning or implementation.
