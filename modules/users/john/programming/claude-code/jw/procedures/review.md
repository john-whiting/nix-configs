# Review procedure

Spawn fresh `jw:reviewer` subagents (the focus areas are defined in the reviewer agent), passing on any
extra instructions. Leave out the `commits` focus if `<branch>` has no commits ahead of `<target>`.

1. **`--single`, or under 150 changed lines** (the conventions diff's `--shortstat`, plus the line counts
   of untracked files): spawn one reviewer with every focus area except `alternatives`.
2. **Otherwise**: spawn these reviewers in a single message:
   - `security, error-handling`
   - `correctness`
   - `over-engineering, tests`
   - `cleanliness-reuse, consistency, readability, commits`
3. **Merge their results**:
   - drop duplicates and any findings you can show are wrong
   - fix mis-graded severities
   - output BLOCKER → MAJOR → MINOR, with a count for each
4. **If there's a task**: write the merged findings to `reviews/round-<n>.md` (n = existing rounds + 1).
