---
name: storage-layout
description: Runtime memory stays under ~/.codex with project memory isolated by canonical path-derived slug
type: project
---

Keep Codex Layered Learning runtime memory under `~/.codex/`, with project-scoped durable notes under `~/.codex/projects/<slug>/memory/`.

**Why:** This preserves the isolation boundary, prevents accidental repo-local runtime state, and avoids collisions between unrelated projects that share the same basename.

**How to apply:** Derive the slug from the canonical project root path, keep `MEMORY.md` as the index, and store typed notes beside it instead of creating working-repo memory folders.
