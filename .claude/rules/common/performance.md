# Performance Optimization

## Model Selection Strategy

The session's default model is whatever is configured in `~/.claude/settings.json` (currently Sonnet). For simple requests, the session model handles the work directly — no delegation or orchestration overhead is needed.

For complex or high-effort requests, switch to a lead/orchestrator pattern: the lead interprets the request, breaks it into sub-tasks, and delegates concrete work to sub-agents running the cheapest model that can do the job well.

### When to Use Lead/Orchestrator Mode

Use full orchestration (delegate + review) when the request meets one or more of:
- Spans multiple files or multiple layers (UI/domain/data, etc.)
- Requires an architecture or design decision — no established pattern to follow, direction must be chosen
- Has broad impact or is hard to reverse (large-scale refactor, breaking change)
- Requires exploratory research or comparing approaches — no clear implementation pattern exists

Handle the request directly in the session, without spinning up sub-agents, when it looks like:
- A single-file or small-scope fix
- Implementation that follows an existing pattern as-is
- Answering a question, explaining code, or light investigation

If the session isn't running Opus and the request warrants orchestration, propose that the user switch models (e.g. `/model opus`) before starting the orchestration flow — don't silently orchestrate on a weaker lead model.

### Lead Agent — Orchestration Only

- Interpret requests, break work into sub-tasks, choose which agent and which model each sub-task needs
- Do complex reasoning itself: architecture/design decisions, cross-cutting judgment calls, final synthesis and review of sub-agent output
- Avoid doing routine execution itself (file search, boilerplate edits, running tests) — delegate those to a cheaper sub-agent instead of spending lead-model tokens on them
- Excessive lead-model usage most often comes from the lead doing execution work directly instead of delegating — watch for this

### Sub-Agent Model Selection (by task complexity)

| Complexity | Model | Examples |
|---|---|---|
| Simple / mechanical | **Haiku** | File search, simple lookups, boilerplate/repetitive edits, running a known command and reporting output |
| Simple design & implementation | **Sonnet** | Standard feature implementation, straightforward bug fixes, TDD on well-scoped work, routine code review |
| Complex research & design | **Opus** | Architecture decisions, ambiguous/high-risk changes, multi-file refactors, planning |
| Exceptionally complex | **Fable** | Only when a task exceeds what Opus reliably handles alone — genuinely novel research/design with no established pattern to follow. Use sparingly; explicitly justify before invoking. |

When launching a sub-agent, override its default model with the `model` parameter on the Agent tool call if the task's actual complexity differs from that agent's typical default (e.g., escalate a normally-Sonnet agent to Opus for an unusually hard instance, or invoke Fable explicitly for the rare exceptionally-complex case). Otherwise rely on the agent's own pinned default — see [agents.md](./agents.md) for the per-agent table.

Default to the cheapest model that can complete the sub-task correctly; escalate only when the task's actual demands justify it.

## Context Window Management

Avoid last 20% of context window for:
- Large-scale refactoring
- Feature implementation spanning multiple files
- Debugging complex interactions

Lower context sensitivity tasks:
- Single-file edits
- Independent utility creation
- Documentation updates
- Simple bug fixes

## Extended Thinking + Plan Mode

Extended thinking is enabled by default, reserving up to 31,999 tokens for internal reasoning.

Control extended thinking via:
- **Toggle**: Option+T (macOS) / Alt+T (Windows/Linux)
- **Config**: Set `alwaysThinkingEnabled` in `~/.claude/settings.json`
- **Budget cap**: `export MAX_THINKING_TOKENS=10000`
- **Verbose mode**: Ctrl+O to see thinking output

For complex tasks requiring deep reasoning:
1. Ensure extended thinking is enabled (on by default)
2. Enable **Plan Mode** for structured approach
3. Use multiple critique rounds for thorough analysis
4. Use split role sub-agents for diverse perspectives

## Build Troubleshooting

If build fails:
1. Analyze error messages carefully
2. Fix incrementally
3. Verify after each fix
