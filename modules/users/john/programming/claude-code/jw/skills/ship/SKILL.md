---
name: ship
description: Full task pipeline - record task, plan, implement, then loop parallel review and fixes until no BLOCKER/MAJOR issues remain.
argument-hint: "[Title: ... | task slug] [--orchestrate-only] [--parallel] [--skip-plan] [--alternatives] [--max-rounds N] [target]"
disable-model-invocation: true
---

Read files under `${CLAUDE_PLUGIN_ROOT}` with `cat`; the Read tool can't access them.

Follow `${CLAUDE_PLUGIN_ROOT}/conventions.md`. You are the orchestrator. Record each phase's outcome and
every judgement call in `log.md`. With `--orchestrate-only`, make no edits to tracked project files
yourself (task files like `plan.md` and `log.md` are fine).

1. **Task**: resolve or create the task, resolve `<target>`, and state both.
2. **Plan** (skipped with `--skip-plan`): follow `${CLAUDE_PLUGIN_ROOT}/procedures/plan.md`, or for a
   large task delegate it to `jw:planner` and review what it returns. Stop and ask if there are open
   questions.
3. **Alternatives** (only with `--alternatives`; ignored with `--skip-plan`): spawn a fresh `jw:reviewer`
   with focus `alternatives`. Give it the absolute `plan.md` path and tell it the plan is what it's
   reviewing (there's no diff yet). Update the plan if something clearly better turns up.
4. **Implement**: follow `${CLAUDE_PLUGIN_ROOT}/procedures/implement.md`.
5. **Review loop**: follow `${CLAUDE_PLUGIN_ROOT}/procedures/review.md`, then:
   - **Any BLOCKER or MAJOR**: fix *all* findings, including MINORs, as described under "Review fixes"
     in the conventions. Always review again.
   - **Only MINORs**: use your judgement. Fix the worthwhile ones, and record the rest with reasons in
     `log.md`. Re-review the MINOR fixes only if you think it's warranted; otherwise stop.
   - **None**: stop.
   - If the same finding appears in two consecutive rounds, or reviewers contradict each other, make the
     call yourself, record it, and stop sending that finding around the loop.
   - Stop after `--max-rounds` (default 4), and report any BLOCKER or MAJOR issues still open.
6. **Fast-forward check**: if `<target>` has moved, rebase onto it and re-verify, so the branch can
   fast-forward.
7. **Report**:
   - branch, target and the final commit list
   - whether a force-push is needed
   - how each criterion was verified
   - finding counts per round
   - MINORs left and why
   - anything unverified or needing a human

Don't push, and don't squash commits beyond folding in fixups, unless asked.

$ARGUMENTS
