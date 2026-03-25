# Development Workflow

> This file extends [common/git-workflow.md](./git-workflow.md) with the full feature development process that happens before git operations.

The Feature Implementation Workflow describes the development pipeline: research, planning, TDD, code review, and then committing to git.

## Feature Implementation Workflow

0. **Research & Reuse** _(mandatory before any new implementation)_
   - **GitHub code search first:** Run `gh search repos` and `gh search code` to find existing implementations, templates, and patterns before writing anything new.
   - **Library docs second:** Use Context7 or primary vendor docs to confirm API behavior, package usage, and version-specific details before implementing.
   - **Exa only when the first two are insufficient:** Use Exa for broader web research or discovery after GitHub search and primary docs.
   - **Check package registries:** Search npm, PyPI, crates.io, and other registries before writing utility code. Prefer battle-tested libraries over hand-rolled solutions.
   - **Search for adaptable implementations:** Look for open-source projects that solve 80%+ of the problem and can be forked, ported, or wrapped.
   - Prefer adopting or porting a proven approach over writing net-new code when it meets the requirement.

   **Decision matrix:**

   | Signal | Action |
   |--------|--------|
   | Exact match, well-maintained, MIT/Apache | **Adopt** — install and use directly |
   | Partial match, good foundation | **Extend** — install + write thin wrapper |
   | Multiple weak matches | **Compose** — combine 2-3 small packages |
   | Nothing suitable found | **Build** — write custom, but informed by research |

   **Search order (Quick Mode):**
   0. Does this already exist in the repo? → `rg` through relevant modules/tests first
   1. Is this a common problem? → Search npm/PyPI
   2. Is there an MCP for this? → Check `~/.claude/settings.json` and search
   3. Is there a skill for this? → Check `~/.claude/skills/`
   4. Is there a GitHub implementation/template? → Run GitHub code search for maintained OSS

   **Search shortcuts by category:**
   - **Linting/Formatting** → `eslint`, `ruff`, `textlint`, `prettier`, `black`, `gofmt`, `markdownlint`
   - **Testing** → `jest`, `pytest`, `go test`, `playwright`
   - **Pre-commit** → `husky`, `lint-staged`, `pre-commit`
   - **HTTP clients** → `httpx` (Python), `ky`/`got` (Node)
   - **Validation** → `zod` (TS), `pydantic` (Python)
   - **AI/LLM** → Claude SDK via Context7; document processing: `unstructured`, `pdfplumber`, `mammoth`
   - **Markdown** → `remark`, `unified`, `markdown-it`
   - **Image** → `sharp`, `imagemin`
   - **Database** → Check for MCP servers first

1. **Plan First**
   - Use **planner** agent to create implementation plan
   - Generate planning docs before coding: PRD, architecture, system_design, tech_doc, task_list
   - Identify dependencies and risks
   - Break down into phases

2. **TDD Approach**
   - Use **tdd-developer** agent
   - Write tests first (RED)
   - Implement to pass tests (GREEN)
   - Refactor (IMPROVE)
   - Verify 80%+ coverage

3. **Code Review**
   - Use **code-reviewer** agent immediately after writing code
   - Address CRITICAL and HIGH issues
   - Fix MEDIUM issues when possible

4. **Commit & Push**
   - Detailed commit messages
   - Follow conventional commits format
   - See [git-workflow.md](./git-workflow.md) for commit message format and PR process

## Automated Workflow with /ship

Use `/ship <description> [--docs <path>]` to automate the full development lifecycle.
The optional `--docs` flag sets the directory where design docs, ADRs, and plans are saved (default: `.claude/docs`).

```
1. Pre-flight    — recommend whether design phase is needed, get user confirmation
2. Design        — /design (optional, creates design doc + ADR via architect agent)
3. Plan          — /plan (creates work plan with risk assessment via architect agent)
4. Worktree      — creates isolated git worktree for the branch
5. Implement     — /implement (executes planned tasks, commits)
6. Self-review   — code-reviewer agent reviews git diff main...HEAD
7. Fix + Push    — fixes Critical/High issues, pushes branch
8. PR            — creates draft PR via gh
```

Individual phase commands can also be run standalone:

| Command | Purpose |
| --- | --- |
| `/design` | Requirements analysis and design doc creation (architect agent for docs/ADRs) |
| `/plan` | Work plan creation from design docs (architect agent for risk assessment) |
| `/implement` | Implementation from a work plan |

Document templates are located in `.claude/docs/templates/`:
- `design.md` — design document
- `adr.md` — architecture decision record
- `plan.md` — work plan

Actual docs are saved under the docs directory (`<docs-dir>/design/`, `<docs-dir>/adr/`, `<docs-dir>/plans/`).
Add these to your project's `.gitignore` if you don't want to commit them to version control.
