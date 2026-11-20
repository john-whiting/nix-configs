# Implement procedure

Implement the task, following `plan.md` if it exists and recording any deviations in `log.md`. Verify
every completion criterion. Commit the work as good commits, one per logical change (usually one per
plan step or group).

**Parallelism** (with `--parallel`, or when the plan has parallel groups):

- Spawn one `jw:implementer` per group in a single message. Give each one the absolute task/plan paths,
  the steps it owns and the files it owns. If there are no plan groups, split the work into groups with
  disjoint files yourself, or run it serially.
- Groups marked `worktree` get `isolation: "worktree"` and `Mode: worktree` in the brief. All other
  groups get `Mode: shared`.
- When all groups are done, commit each shared group's work yourself, one commit per group, staging only
  that group's files (`git add` its new files, then `git commit -- <files>`). Then bring in the worktree
  branches and run the full verification.

Serial work: do it yourself, or give it to a single `jw:implementer` in `Mode: shared` if it's large,
telling it that it's the only implementer running so it commits its own work.
With `--orchestrate-only`, all edits go through subagents, so serial work always goes to that
implementer.
