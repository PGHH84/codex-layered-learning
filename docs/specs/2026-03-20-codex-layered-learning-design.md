# Codex Layered Learning Design

**Date:** 2026-03-20

## Goal

Create a Codex-native layered learning system that mirrors Claude Layered Learning's workflow and information model while keeping raw runtime memory Codex-owned and durable guidance aligned through canonical local and global sources:

- retain useful project knowledge across sessions
- capture raw session history while context is fresh
- reflect on repeated patterns over time
- promote stable learnings into durable guidance only when justified
- restore Claude-equivalent closeout phases in `wrap-up`

The design must not disturb Claude Code and must not create repo-local runtime memory directories in working repositories.

## Non-Goals

- Replacing Claude Layered Learning
- Sharing diary or reflection runtime state with Claude Code
- Using repo-local `Memories/` or similar folders for agent state
- Automatically editing global or repo instructions without approval
- Requiring a database or MCP server in v1

## Safety Boundaries

`Codex-Layered-Learning` keeps raw runtime memory separate while allowing
explicit global mirror sync for durable operating guidance.

- It does not share diary or reflection storage with Claude
- It does not install Claude hooks, commands, or skills
- It does not create repo-local memory folders
- It does not perform speculative or destructive cleanup
- It does not mutate global durable guidance without user approval

Claude-compatible diary and reflection behavior continues to live in
`Claude-Layered-Learning`, while global mirror generation is handled through an
explicit sync path.

## Architecture

Codex Layered Learning uses a two-loop architecture.

### Immediate Loop

The immediate loop runs at session close:

1. `wrap-up` runs `Ship It`
2. `wrap-up` runs `Remember It`
3. `wrap-up` runs `Review & Apply`
4. `wrap-up` runs `Diary Capture`

This loop is responsible for preserving fresh session context before it is lost.

### Deferred Loop

The deferred loop runs separately:

1. `reflect` reads centralized diary entries
2. `reflect` groups repeated patterns
3. `reflect` proposes promotions to the right durable targets

This loop is responsible for identifying stable patterns instead of reacting to one-off events.

## Runtime authority

The repository runtime skills are the authoritative execution surface for Codex Layered Learning.

- `skills/wrap-up/SKILL.md`
- `skills/diary/SKILL.md`
- `skills/reflect/SKILL.md`

These runtime skills are the source of truth for behavior.

- Installed copies under `~/.agents/skills/` should be synchronized from the repository skill files
- `commands/*.md` are reference docs only if retained
- Behavioral changes must land in the runtime skills first
- Supporting docs, examples, fixtures, and scripts should be updated after the runtime skills to keep the repository aligned

## Storage Model

Markdown files are the source of truth in v1.

### Runtime Layout

```text
~/.agents/
  global/
    PROJECT.md
    sync_global_instructions.sh
    check_global_instructions_sync.sh
~/.codex/
  AGENTS.md
  memory/
    diary/
      YYYY-MM-DD-<project-slug>-session-N.md
    reflections/
      YYYY-MM-DD-reflection-N.md
      processed.log
  projects/
    <project-slug>/
      memory/
        MEMORY.md
        feedback_*.md
        project_*.md
        reference_*.md
        user_*.md
~/.claude/
  CLAUDE.md
```

### Rationale

- Project memory stays project-specific
- Diary stays centralized as the raw observation stream
- Reflections stay centralized as the synthesis layer
- Repo-local operating guidance converges through repo `PROJECT.md`
- Global operating guidance converges through canonical `~/.agents/global/PROJECT.md`
- Project-filtered reflection is driven by metadata inside diary entries, not by diary folder structure
- Project slugs are derived from canonical project root paths and collapse worktrees back to the main repo identity so one project does not fragment across worktrees

This mirrors the current Claude Layered Learning setup while staying Codex-native.

## Commands

`commands/*.md` can summarize purpose, data shape, and examples, but they are not runtime authority. The runtime skills own operational behavior.

### `wrap-up`

`wrap-up` is the immediate loop entry point.

Behavior:

- Determine the current project slug from the canonical project root path, not only the working-directory basename
- Inspect current session context first
- Optionally inspect repo state for changed files and verification evidence
- run `Ship It`:
  - documentation sync when directly affected
  - commit flow when uncommitted changes exist
  - obvious file placement fixes
  - deploy when a documented deploy path exists
  - task cleanup when a documented task surface exists
- Update `~/.codex/projects/<slug>/memory/MEMORY.md`
- optionally follow `~/.codex/skills/wrap-up/personal.md`
- reconcile `MEMORY.md` if the personal-extension step materially changed tracked state
- route project-local operating guidance to repo `PROJECT.md`
- route global operating guidance to `~/.agents/global/PROJECT.md`
- run `Review & Apply` with approval-gated durable edits
- Automatically trigger `diary`

Hard constraints:

- No repo-local memory writes
- No automatic global durable instruction changes without approval
- No direct editing of generated mirror files when canonical sources should be updated instead

### `diary`

`diary` can run standalone and is always invoked by `wrap-up`.

Behavior:

- Use active conversation context as the primary source
- Fall back to session logs only when context is incomplete and needed
- Derive the project slug from the canonical project root path so identical basenames do not collide
- Write a structured diary entry to `~/.codex/memory/diary/`
- Capture:
  - task summary
  - time
  - work summary
  - design decisions
  - actions taken
  - challenges and solutions
  - user preferences observed
  - code patterns and decisions
  - context and technologies
  - verification performed
  - notes / next-step context

Hard constraints:

- No promotion or analysis inside `diary`
- No secret-bearing or highly sensitive raw values in diary entries

### `reflect`

`reflect` runs separately from `wrap-up`.

Behavior:

- Read centralized diary entries from `~/.codex/memory/diary/`
- Support filters:
  - all unprocessed entries
  - last N entries
  - date range
  - project slug derived from the canonical project root path
  - keyword
- Read supporting context:
  - prior reflections
  - `processed.log`
  - project `MEMORY.md`
  - project typed notes when project-memory promotion is being considered
  - repo `PROJECT.md` when project operating-guidance promotion is being considered
  - canonical global `~/.agents/global/PROJECT.md` when considering global promotions
- Group repeated learnings
- Prioritize repeated rule violations over inventing new rules
- Apply scope and confidence rules
- Write a reflection file to `~/.codex/memory/reflections/`
- Apply approved durable promotions in the same reflection flow
- Update `processed.log` only after the user accepts the reflection pass as complete and approved actions are resolved

## Scope Routing

Scope routing should be deterministic first and model-assisted only for edge cases.

### Project-Specific Signals

- Mentions repo-specific paths, commands, services, architecture, or quirks
- Only appears in one project corpus
- Would look out of place in unrelated projects

### Global Signals

- Applies to Codex behavior across repositories
- Repeats across multiple projects or sessions
- Reads like a general operating principle

### Confidence Thresholds

- 1 occurrence: keep in diary or one-off observations
- 2 occurrences in one project: project candidate
- 3 or more occurrences, or repetition across projects: global candidate
- Repeated violation of an existing rule raises promotion priority

## Promotion Targets

Scope is only the first routing decision. The final destination depends on what kind of knowledge the system has found.

### Candidate Destinations

- Project typed note under `~/.codex/projects/<slug>/memory/`
- Repo `PROJECT.md`
- Global `~/.agents/global/PROJECT.md`
- New skill
- No durable promotion

### Destination Rules

- One-off observations stay in diary or reflection only
- Stable project facts go to `project_*.md`
- Repeated project lessons go to `feedback_*.md`
- Stable project operating guidance belongs in repo `PROJECT.md`
- Stable cross-project behavior can become a canonical global `PROJECT.md` candidate
- Reusable workflows and judgment-heavy procedures can become skill candidates
- Existing docs are preferred over new files when they already own the subject

### Approval Model

No durable edit is automatic.

`wrap-up` may auto-apply only:

- `MEMORY.md` current-state updates
- directly affected repo docs
- commit creation when uncommitted changes exist
- deploy when a documented deploy path exists
- repo-owned task cleanup
- local operating guidance updates to repo `PROJECT.md`
- clearly memory-scoped project typed-note edits

`wrap-up` and `reflect` both require approval for:

- repo `PROJECT.md` edits during `reflect`
- global `~/.agents/global/PROJECT.md` edits
- project typed note creation or edits
- skill candidate creation
- repo doc edits not already covered by directly affected session-close doc sync

`reflect` should always show:

- proposed learning
- supporting evidence
- confidence
- proposed destination
- reason for global vs project-specific scope

## Schemas

### Project `MEMORY.md`

Purpose:

- index of durable notes
- current state snapshot
- next-step handoff

Structure:

```md
# <Project Name> Memory

## Current State
**Last updated:** YYYY-MM-DD | **Session:** N

[2-5 lines on current state]

**Next steps:**
1. ...
2. ...

## Key Notes
- [project_*.md](...) — durable project facts
- [feedback_*.md](...) — reusable lessons from this project
- [reference_*.md](...) — supporting references
- [user_*.md](...) — stable user/project preferences when justified
```

### Typed Note

Purpose:

- one durable lesson per file
- easy linking from `MEMORY.md`
- easy reuse by `reflect`

Structure:

```md
---
name: local-files-first
description: Prefer local filesystem discovery before expensive API traversal when both are available
type: feedback
---

[Short rule]

**Why:** [evidence from prior work]

**How to apply:** [practical rule]
```

### Diary Entry

Purpose:

- raw session observation
- centralized evidence corpus

Structure:

```md
# Session Diary Entry

**Date**: YYYY-MM-DD
**Project**: <canonical absolute project root path>
**Git Branch**: <branch or n/a>
**Session**: N
**Session ID**: <optional when available>

## Task Summary
...

## Work Summary
- ...

## Design Decisions Made
- ...

## Actions Taken
- Files created:
- Files edited:
- Commands executed:
- Verification performed:

## Challenges Encountered
- ...

## Solutions Applied
- ...

## User Preferences Observed
### Communication & Workflow
- ...

### Technical Preferences
- ...

## Notes
- ...
```

### Reflection

Purpose:

- deferred synthesis
- promotion proposal, not automatic mutation

Structure:

```md
# Reflection: <scope>

**Generated**: YYYY-MM-DD HH:MM
**Entries Analyzed**: N
**Date Range**: ...
**Projects**: ...

## Summary
...

## Patterns Identified

### Persistent Preferences
1. ...

### Design Decisions That Worked
1. ...

### Anti-Patterns To Avoid
1. ...

### Project-Specific Patterns
1. ...

## One-Off Observations
- ...

## Proposed Promotions

### Global AGENTS.md candidates
- ...

### Project memory candidates
- ...

### Repo AGENTS.md / docs candidates
- ...

### Skill candidates
- ...

## Metadata
- Diary entries analyzed:
- Processed log updated:
```

## Examples

Include a small curated example set.

Required:

- `examples/sample-memory.md`
- `examples/sample-diary-entry.md`
- `examples/sample-reflection.md`
- `examples/feedback-local-files-first.md`

Rationale:

- examples improve routing and formatting quality
- they clarify intended granularity
- they teach the promotion logic with concrete artifacts

Do not build a large example library in v1.

## Future Evolution

v2 may add a local SQLite or MCP-backed index.

Constraints for v2:

- markdown remains canonical
- index is read/search only
- no change to the storage contract
- no Claude runtime interference

## Open Questions Resolved

- Project name: `Codex-Layered-Learning`
- No repo-local runtime memory folders
- `wrap-up` always triggers `diary`
- `diary` and `reflect` can run standalone
- Diary and reflections are centralized
- Project memory is project-scoped
- v1 is markdown-first
- Claude-compatible behavior stays in `Claude-Layered-Learning`
