---
name: review
description: Review a branch against its base with fresh, parallel focused reviewers; findings flagged BLOCKER/MAJOR/MINOR.
argument-hint: "[branch] [target] [task slug] [--single] [extra instructions]"
disable-model-invocation: true
---

Read files under `${CLAUDE_PLUGIN_ROOT}` with `cat`; the Read tool can't access them.

Follow `${CLAUDE_PLUGIN_ROOT}/conventions.md` to resolve the branch, target and task, then
`${CLAUDE_PLUGIN_ROOT}/procedures/review.md`.

$ARGUMENTS
