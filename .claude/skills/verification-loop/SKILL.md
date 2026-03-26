---
name: verification-loop
description: "A comprehensive verification system for Claude Code sessions."
---

# Verification Loop Skill

A comprehensive verification system for Claude Code sessions.

## When to Use

Invoke this skill:
- After completing a feature or significant code change
- Before creating a PR
- When you want to ensure quality gates pass
- After refactoring

## Verification Phases

### Phase 1: Build Verification
```bash
# Node.js / TypeScript
npm run build 2>&1 | tail -20
# OR
pnpm build 2>&1 | tail -20

# Go
go build ./... 2>&1 | head -20
```

If build fails, STOP and fix before continuing.

### Phase 2: Type Check
```bash
# TypeScript projects
npx tsc --noEmit 2>&1 | head -30

# Python projects
pyright . 2>&1 | head -30

# Go (vet catches type-level issues)
go vet ./... 2>&1 | head -30
```

Report all type errors. Fix critical ones before continuing.

### Phase 3: Lint & Format Check
```bash
# JavaScript/TypeScript — lint
npm run lint 2>&1 | head -30

# JavaScript/TypeScript — Prettier format check
# For monorepo workspace projects:
npx -w <workspace-name> prettier --check . 2>&1 | head -30
# For standard projects:
npx prettier --check . 2>&1 | head -30

# Python
ruff check . 2>&1 | head -30

# Go
golangci-lint run ./... 2>&1 | head -30
```

If Prettier check fails, auto-fix and re-verify:
```bash
npx -w <workspace-name> prettier --write .
npx -w <workspace-name> prettier --check . 2>&1 | head -10
```

### Phase 4: Test Suite
```bash
# Node.js — run tests with coverage
npm run test -- --coverage 2>&1 | tail -50

# Go — run tests with coverage
go test -cover ./... 2>&1 | tail -30

# Target: 80% minimum coverage
```

Report:
- Total tests: X
- Passed: X
- Failed: X
- Coverage: X%

### Phase 5: Security Scan

Run the `security-scan` skill for a comprehensive check of secrets, misconfigurations, and injection risks in Claude configuration files. For application code:

```bash
# Quick check: console.log left in source
grep -rn "console.log" --include="*.ts" --include="*.tsx" src/ 2>/dev/null | head -10

# Go: debug prints
grep -rn "fmt.Print" --include="*.go" . 2>/dev/null | head -10
```

For deeper secret scanning, use the `security-scan` skill (AgentShield-based).

### Phase 6: Diff Review
```bash
# Show what changed
git diff --stat
git diff HEAD~1 --name-only
```

Review each changed file for:
- Unintended changes
- Missing error handling
- Potential edge cases

## Output Format

After running all phases, produce a verification report:

```
VERIFICATION REPORT
==================

Build:     [PASS/FAIL]
Types:     [PASS/FAIL] (X errors)
Lint:      [PASS/FAIL] (X warnings)
Tests:     [PASS/FAIL] (X/Y passed, Z% coverage)
Security:  [PASS/FAIL] (X issues)
Diff:      [X files changed]

Overall:   [READY/NOT READY] for PR

Issues to Fix:
1. ...
2. ...
```

## Continuous Mode

For long sessions, run verification every 15 minutes or after major changes:

```markdown
Set a mental checkpoint:
- After completing each function
- After finishing a component
- Before moving to next task

Run: /verify
```

## Integration with Hooks

This skill complements PostToolUse hooks but provides deeper verification.
Hooks catch issues immediately; this skill provides comprehensive review.
