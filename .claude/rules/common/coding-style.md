# Coding Style

## Immutability (CRITICAL)

ALWAYS create new objects, NEVER mutate existing ones:

```
// Pseudocode
WRONG:  modify(original, field, value) → changes original in-place
CORRECT: update(original, field, value) → returns new copy with change
```

Rationale: Immutable data prevents hidden side effects, makes debugging easier, and enables safe concurrency.

## File Organization

MANY SMALL FILES > FEW LARGE FILES:
- High cohesion, low coupling
- 200-400 lines typical, 800 max
- Extract utilities from large modules
- Organize by feature/domain, not by type

## Error Handling

ALWAYS handle errors comprehensively:
- Handle errors explicitly at every level
- Provide user-friendly error messages in UI-facing code
- Log detailed error context on the server side
- Never silently swallow errors

## Input Validation

ALWAYS validate at system boundaries:
- Validate all user input before processing
- Use schema-based validation where available
- Fail fast with clear error messages
- Never trust external data (API responses, user input, file content)

## Documentation & Procedural Writing

Applies to any document describing steps or instructions — README, design docs, `.claude/commands/*.md`, `.claude/skills/*/SKILL.md`, etc., not just commands/skills.

State the action only. Do not add a parenthetical justifying why a default was left as-is, why something was NOT done, or why an omission is fine — a reader executing the step doesn't need that reasoning. Only add an explanation when the reader must make a non-obvious judgment call at that step (e.g. choosing between two valid options).

Never bake in meta-commentary about the edit itself — e.g. "per your request", "as discussed", "removed per feedback", "no longer specifying X since you asked". If the surrounding conversation prompted a change, that belongs in the chat reply or commit message, never in the document body — the document should read the same whether it was authored fresh or edited ten times.

```
WRONG: "Launch the X agent (its own definition already pins the model — do not override it here)."
WRONG: "Launch the X agent (no longer pinning the model per your feedback)."
CORRECT: "Launch the X agent."
```

## Code Quality Checklist

Before marking work complete:
- [ ] Code is readable and well-named
- [ ] Functions are small (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] No deep nesting (>4 levels)
- [ ] Proper error handling
- [ ] No hardcoded values (use constants or config)
- [ ] No mutation (immutable patterns used)
