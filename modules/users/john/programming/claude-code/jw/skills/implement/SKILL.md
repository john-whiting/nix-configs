---
name: implement
description: Implement a recorded task or its plan, optionally fanning independent plan steps out to parallel implementer subagents.
argument-hint: "[task slug | Title: ...] [--parallel] [--orchestrate-only] [extra instructions]"
disable-model-invocation: true
---

Read files under `${CLAUDE_PLUGIN_ROOT}` with `cat`; the Read tool can't access them.

Follow `${CLAUDE_PLUGIN_ROOT}/conventions.md` to resolve the task, then
`${CLAUDE_PLUGIN_ROOT}/procedures/implement.md`.

Report:

- changes by file
- how each criterion was verified
- deviations
- anything left undone

$ARGUMENTS
