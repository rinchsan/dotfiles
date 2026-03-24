# Work Plan: [Title]

## Metadata

| Field | Value |
| --- | --- |
| Created | YYYY-MM-DD |
| Type | Feature / Bug Fix / Refactor / Infrastructure |
| Estimated Files | N |
| Priority | High / Medium / Low |
| Related Design Doc | [Link](../design/NNN-title.md) |
| Related ADR | [Link](../adr/NNN-title.md) |

---

## Objective

What will be accomplished by completing this plan?

---

## Scope

### Files to Create
- `path/to/new/file`

### Files to Modify
- `path/to/existing/file` — description of change

### Tests
- `path/to/file_test`

### Documentation
- Files that need documentation updates

---

## PR Split Plan (if applicable)

> Consider splitting when: 10+ files changed, 500+ line diff, multiple independent units, or staged rollout needed.

| PR | Scope | Dependencies |
| --- | --- | --- |
| PR 1 | Description | None |
| PR 2 | Description | PR 1 |

---

## Implementation Phases

### Phase 1: [Name]

**Goal**: What this phase achieves

**Tasks:**

- [ ] Task 1: Description
  - Files: `path/to/file`
  - Completion: How to verify this task is done
- [ ] Task 2: Description
  - Files: `path/to/file`
  - Completion: How to verify this task is done

**Phase gate**: Criteria that must be met before moving to Phase 2

---

### Phase 2: [Name]

**Goal**: What this phase achieves

**Tasks:**

- [ ] Task 1: Description
  - Files: `path/to/file`
  - Completion: How to verify this task is done

---

## Quality Standards

- [ ] All tests pass
- [ ] No linting errors
- [ ] Code follows existing patterns in the codebase
- [ ] Error handling is explicit (no silent failures)
- [ ] No hardcoded values (use constants or config)

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
| --- | --- | --- | --- |
| Risk description | High / Medium / Low | High / Medium / Low | Mitigation approach |

---

## Definition of Done

**Functional:**
- [ ] All planned tasks completed
- [ ] Core scenarios work end-to-end

**Quality:**
- [ ] Tests written and passing (80%+ coverage for new code)
- [ ] Self-review completed via `/ship`, human review via PR

**Documentation:**
- [ ] Code comments added where logic is non-obvious
- [ ] Relevant docs updated

---

## Progress Log

| Date | Phase | Status | Notes |
| --- | --- | --- | --- |
| YYYY-MM-DD | Phase 1 | In Progress | |
