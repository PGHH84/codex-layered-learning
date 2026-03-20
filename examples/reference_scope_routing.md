---
name: scope-routing
description: Reference signals for deciding whether a reflection pattern is project-specific or global
type: reference
---

Use project-specific scope for signals tied to repo-specific paths, services, architecture, or quirks. Use global scope for behavior that repeats across projects and reads like a general Codex operating rule.

**Why:** Scope routing should be deterministic first so repeated evidence is classified consistently before a destination is proposed.

**How to apply:** Check project spread, recurrence count, and whether the wording would feel out of place in an unrelated repository before routing a reflection candidate.
