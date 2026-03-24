---
description: Execute planned tasks following existing codebase patterns
---

# /implement - Implementation Phase

Execute the tasks defined in the work plan, following existing codebase patterns and conventions.

Task / Plan: ${args}

---

## Pre-implementation Checklist

Before starting each task, confirm:

1. **Applicable rules**: Which rules in `.claude/rules/` apply to this task?
2. **Existing patterns**: Search for similar implementations using Grep/Glob to follow established conventions
3. **Prohibited actions**: What must be avoided for this specific task?

## Implementation Approach

### Pattern Discovery

Before writing new code, search for existing patterns:
- Grep for similar function signatures or class names
- Read existing files in the same module or package
- Follow naming conventions and file organization found in the codebase
- Reuse existing utilities and helpers rather than reinventing them

### TDD (when applicable)

For new functions or modules:
1. Write failing tests first (RED)
2. Implement minimal code to pass tests (GREEN)
3. Refactor while keeping tests green (IMPROVE)

### Committing

After completing each logical unit of work:

```bash
git add -p  # stage only relevant changes
git commit -m "<type>: <description>"
```

Follow conventional commits: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `perf`

## ⚠️ Responsibility Boundaries

### ✅ Do in this phase
- Implement tasks as specified in the plan
- Create and edit files listed in the plan
- Write test code
- Fix bugs discovered during implementation
- Refactor within the planned scope

### ❌ Do NOT in this phase
- Add features not in the plan
- Change the design (requires going back to /design)
- Expand scope beyond what was requested
- Make new architectural decisions unilaterally
- Refactor code outside the planned scope

**Important**: Execute only planned tasks. When all planned tasks are complete, stop immediately.
