# Plan procedure

Write a plan for the task to `plan.md`, with these sections:

- **Approach**: the chosen approach, and in one line each, why it beats the obvious alternatives.
- **Steps**: numbered, each with the files it touches, the change, and how it's verified.
- **Parallel groups**: a group is the steps one implementer does in order, and groups run concurrently.
  Steps that share a file or a tightly coupled interface go in the same group; different groups never
  share files. Mark each group `shared` (verifiable on its own while other groups edit the same tree)
  or `worktree` (needs its own tree to verify). A `worktree` group starts from the current HEAD, so it
  can't depend on another group's output.
- **Completion criteria**: each criterion mapped to the step(s) that satisfy it and how that's verified.
- **Open questions**: anything that needs a human decision, rather than guessing.
