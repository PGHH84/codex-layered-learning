---
name: no-repo-local-memory
description: Do not create runtime memory folders inside working repositories
type: feedback
---

Do not write Codex runtime memory into the working repository; keep runtime state under `~/.codex/`.

**Why:** Repo-local runtime state is noisy, easy to commit accidentally, and breaks the isolation boundary between project source files and agent memory.

**How to apply:** Store diary entries, reflections, and project memory in the central runtime tree and point documentation to those locations instead of creating local memory folders.
