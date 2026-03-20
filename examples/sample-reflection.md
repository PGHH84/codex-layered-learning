# Reflection: Storage Boundary and Routing Patterns

**Generated**: 2026-03-22 18:10
**Entries Analyzed**: 3
**Date Range**: 2026-03-20 to 2026-03-22
**Projects**: project-alpha, project-beta

## Summary

The clearest signal is the repeated need to keep runtime memory outside working repositories. A second signal is that runtime authority should stay in the repository skills, with supporting docs following behind. Noise in this batch included a one-off idea about adding a database index immediately; it appeared once and did not change the v1 direction. A technology-specific shell workflow appeared in both projects, which makes it a plausible global candidate rather than a project-only note.

## Rule Violations Detected

1. **Rule**: Runtime memory must stay outside working repositories
   - **Violation pattern**: Early notes in both projects drifted toward repo-local memory folders before the storage boundary was tightened
   - **Impact**: That would have mixed agent memory with source files and increased accidental-commit risk
   - **Strengthening action**: Keep the no-repo-local-memory rule explicit in the README, typed memory policy, and reflection guidance

## Patterns Identified

### Persistent Preferences
1. **Prefer markdown as the source of truth before adding indexing layers**
   - **Confidence**: High
   - **Evidence**: Both projects returned to file-first storage with optional indexing later

### Design Decisions That Worked
1. **Runtime skills first, supporting docs second**
   - **What worked**: Making the runtime skills authoritative reduced drift between behavior and documentation

### Anti-Patterns To Avoid
1. **Treating one-off ideas as durable guidance**
   - **What to do instead**: Keep noise in the reflection until the same idea repeats with stronger evidence

### Project-Specific Patterns
1. **Project-local storage layout notes belong in project memory**
   - **Target**: `project_*.md`
   - **Reason**: The storage layout is durable and repo-specific, even when the broader principle is global

## One-Off Observations
- A future search index may still help once diary volume grows, but this batch does not justify promoting it yet

## Proposed Promotions

### Global AGENTS.md candidates
- `Prefer transparent file-first runtime storage before adding indexing layers.`
- `When a technology-specific workflow repeats across multiple projects, treat it as a global candidate instead of forcing it to remain project-local.`

### Project memory candidates
- `feedback_no_repo_local_memory.md` — repeated project lesson: keep runtime memory outside working repositories
- `project_storage_layout.md` — stable project fact: runtime memory layout and path-derived slug use
- `reference_scope_routing.md` — supporting reference for project-vs-global routing decisions

### Repo AGENTS.md / docs candidates
- Strengthen the reflection docs to distinguish signal from noise and document the canonical `processed.log` format

### Skill candidates
- None in this pass

## Metadata
- Diary entries analyzed:
  - `2026-03-20-project-alpha-session-1.md`
  - `2026-03-21-project-alpha-session-2.md`
  - `2026-03-22-project-beta-session-1.md`
- Prior one-offs carried forward:
  - `Runtime skills should be the behavior owner` from `2026-03-21-reflection-1.md`
- Reprocessing requested: no
- Processed log status: pending user approval
- Processed log entries to append:
  - `2026-03-20-project-alpha-session-1.md | 2026-03-22 | 2026-03-22-reflection-1.md | accepted`
  - `2026-03-21-project-alpha-session-2.md | 2026-03-22 | 2026-03-22-reflection-1.md | accepted`
  - `2026-03-22-project-beta-session-1.md | 2026-03-22 | 2026-03-22-reflection-1.md | accepted`
