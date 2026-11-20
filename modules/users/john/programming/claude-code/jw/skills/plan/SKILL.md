---
name: plan
description: Write an implementation plan for a recorded task to .claude/tasks/<slug>/plan.md.
argument-hint: "[task slug | Title: ...] [extra instructions]"
disable-model-invocation: true
---

Read files under `${CLAUDE_PLUGIN_ROOT}` with `cat`; the Read tool can't access them.

Follow `${CLAUDE_PLUGIN_ROOT}/conventions.md` to resolve the task, then
`${CLAUDE_PLUGIN_ROOT}/procedures/plan.md`. For a large task, you may delegate the plan to `jw:planner`
and review what it returns. Reply with the plan's path, a short summary, and any open questions.

$ARGUMENTS
