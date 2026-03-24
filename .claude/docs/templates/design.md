# Design Document: [Title]

## Document Metadata

| Field | Value |
| --- | --- |
| Status | Draft / In Review / Approved / Implemented |
| Created | YYYY-MM-DD |
| Last Updated | YYYY-MM-DD |
| Author | |
| Related ADRs | [ADR-NNN: Title](../adr/NNN-title.md) |

---

## Overview

Brief description of what this document covers and why it is being written.

### Background

What problem or need prompted this work? What is the current state and what are its limitations?

### Goals

- Goal 1
- Goal 2

### Non-Goals

- Out-of-scope item 1
- Out-of-scope item 2

---

## Architecture Overview

High-level description of the solution approach and how it fits into the existing system.

```
[ASCII diagram or description of component relationships]
```

### Key Components

| Component | Responsibility |
| --- | --- |
| Component A | Description |
| Component B | Description |

---

## Detailed Design

### Data Model

Describe entities, their fields, and relationships.

```
Entity: ExampleEntity
  - id: string (required)
  - name: string (required)
  - createdAt: timestamp
```

### Sequence Diagrams

For key use cases, describe the interaction flow:

```
1. Client sends request to Component A
2. Component A validates input
3. Component A calls Component B
4. Component B returns result
5. Component A returns response to Client
```

### API Design (if applicable)

Describe any new or changed API endpoints:

```
POST /api/v1/resource
Request:  { field: string }
Response: { id: string, field: string }
```

### State Management (if applicable)

Describe any state changes or state machine transitions.

---

## Cross-Cutting Concerns

### Security

- Authentication and authorization requirements
- Input validation approach
- Sensitive data handling

### Error Handling

- Expected error scenarios
- Error response format
- Recovery strategies

### Performance

- Expected load characteristics
- Caching strategy (if applicable)
- Potential bottlenecks and mitigations

---

## Testing Strategy

- Unit test approach
- Integration test scope
- Key test scenarios (happy path + error cases)

---

## Migration Strategy (if applicable)

Steps required to migrate existing data or handle backwards compatibility.

---

## Risks and Open Questions

| Item | Type | Impact | Mitigation / Status |
| --- | --- | --- | --- |
| Risk 1 | Risk | High | Mitigation approach |
| Question 1 | Open question | Medium | Being investigated |

---

## References

- [Related document or issue](URL)
