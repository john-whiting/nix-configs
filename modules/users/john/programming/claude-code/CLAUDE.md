# Commits and comments

- Commit messages and code comments describe the code as it stands permanently. Leave out process
  details: no notes about decisions made while implementing, review rounds, plans, or what changed from
  a previous attempt.
- Keep them clear and concise: what, and why when the why isn't obvious. Only comment where it adds
  something the code doesn't already say.

# Git history

- Every commit is a good commit: one logical change that stands on its own and builds. No WIP,
  "fix review comments", or "fix typo" commits.
- When something in an earlier commit needs changing, fold the fix into that commit
  (`git commit --fixup=<sha>`, or `git commit --fixup=reword:<sha> -m "<new message>"` for a message,
  then `git rebase --autosquash <base>`). Don't add a new commit on top.
- Merges are fast-forward only. Rebase onto the target so it can fast-forward, then
  `git merge --ff-only`. Never create merge commits.
- Don't push. If a branch with an upstream has had its history rewritten, say that it needs a force-push.
