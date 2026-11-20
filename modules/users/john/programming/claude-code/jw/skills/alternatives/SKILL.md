---
name: alternatives
description: Review a branch against its base and evaluate alternative implementation approaches that may be better than the proposed changes.
argument-hint: "[branch] [target] [task slug] [extra instructions]"
disable-model-invocation: true
---

Read files under `${CLAUDE_PLUGIN_ROOT}` with `cat`; the Read tool can't access them.

Follow `${CLAUDE_PLUGIN_ROOT}/conventions.md` to resolve the branch, target and task. Then spawn one
fresh `jw:reviewer` with focus `alternatives`, passing on any extra instructions. Relay what it returns,
dropping anything you can show is wrong.

$ARGUMENTS
