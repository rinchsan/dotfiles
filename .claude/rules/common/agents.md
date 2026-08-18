# Agent Orchestration

Opus is the lead/orchestrator for every session (see [performance.md](./performance.md) for the full model selection strategy). It delegates concrete work to sub-agents rather than executing it directly, choosing the cheapest model per sub-task automatically — the user never needs to state a model policy in their request.

## Available Agents

Located in `~/.claude/agents/`:

| Agent | Model | Purpose | When to Use |
|-------|-------|---------|-------------|
| planner | opus | Implementation planning | Complex features, refactoring |
| architect | opus | System design | Architectural decisions |
| code-reviewer | opus | Code review | After writing code |
| tdd-developer | sonnet | Test-driven development | New features, bug fixes |
| security-reviewer | sonnet | Security analysis | Before commits |

## Immediate Agent Usage

No user prompt needed:
1. Complex feature requests - Use **planner** agent
2. Code just written/modified - Use **code-reviewer** agent
3. Bug fix or new feature - Use **tdd-developer** agent
4. Architectural decision - Use **architect** agent

## Parallel Task Execution

ALWAYS use parallel Task execution for independent operations:

```markdown
# GOOD: Parallel execution
Launch 3 agents in parallel:
1. Agent 1: Security analysis of auth module
2. Agent 2: Performance review of cache system
3. Agent 3: Type checking of utilities

# BAD: Sequential when unnecessary
First agent 1, then agent 2, then agent 3
```

## Multi-Perspective Analysis

For complex problems, use split role sub-agents:
- Factual reviewer
- Senior engineer
- Security expert
- Consistency reviewer
- Redundancy checker

## Cost-Conscious Delegation

- Do not do routine execution work in the lead (Opus) session — file search, mechanical edits, running commands and reporting output. Delegate these to a sub-agent instead.
- For simple/mechanical work with no agent above that fits (e.g., a quick file lookup), use a general-purpose agent (e.g., **Explore**, **general-purpose**) and override its model to `haiku` via the Agent tool's `model` parameter, rather than doing it in Opus.
- Match the sub-agent's model to the task's actual complexity, not the agent's listed default — override with the `model` parameter when a specific instance is easier or harder than that agent's typical case.
- Reserve `fable` for the rare case where a task's complexity exceeds what Opus reliably handles; invoke it explicitly per task, never as a default.
