---
name: task
description: Record a task (title, description, completion criteria) to .claude/tasks/<slug>/task.md for the other jw skills, from given fields or a Jira issue.
argument-hint: "Title: ... Description: ... Completion Criteria: ... | --jira <KEY-123 | URL>"
disable-model-invocation: true
---

Read files under `${CLAUDE_PLUGIN_ROOT}` with `cat`; the Read tool can't access them.

Follow `${CLAUDE_PLUGIN_ROOT}/conventions.md` to create the task from the arguments, then reply with its
absolute path only.

$ARGUMENTS
