# Codex Layered Learning Design

**Date:** 2026-03-20

## Goal

Create a Codex-native layered learning system that produces the same outcome as Claude Layered Learning:

- retain useful project knowledge across sessions
- capture raw session history while context is fresh
- reflect on repeated patterns over time
- promote stable learnings into durable guidance only when justified

The design must not disturb Claude Code and must not create repo-local runtime memory directories in working repositories.

## Non-Goals

- Replacing Claude Layered Learning
- Sharing runtime state with Claude Code
- Using repo-local `Memories/` or similar folders for agent state
- Automatically editing global or repo instructions without approval
- Requiring a database or MCP server in v1

## Safety Boundaries

`Codex-Layered-Learning` is fully isolated from Claude runtime surfaces.

- It does not read from or write to `~/.claude/**`
- It does not install Claude hooks, commands, or skills
- It does not create repo-local memory folders
- It does not auto-commit, auto-push, auto-deploy, or perform destructive cleanup
- It does not mutate durable guidance without user approval

All Claude-compatible functionality continues to live in `Claude-Layered-Learning`.

## Architecture

Codex Layered Learning uses a two-loop architecture.

### Immediate Loop

The immediate loop runs at session close:

1. `wrap-up` inspects the current session
2. `wrap-up` updates project-scoped memory
3. `wrap-up` automatically invokes `diary`

This loop is responsible for preserving fresh session context before it is lost.

### Deferred Loop

The deferred loop runs separately:

1. `reflect` reads centralized diary entries
2. `reflect` groups repeated patterns
3. `reflect` proposes promotions to the right durable targets

This loop is responsible for identifying stable patterns instead of reacting to one-off events.

## Storage Model

Markdown files are the source of truth in v1.

### Runtime Layout

```text
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
```

### Rationale

- Project memory stays project-specific
- Diary stays centralized as the raw observation stream
- Reflections stay centralized as the synthesis layer
- Project-filtered reflection is driven by metadata inside diary entries, not by diary folder structure

This mirrors the current Claude Layered Learning setup while staying Codex-native.

## Commands

### `wrap-up`

`wrap-up` is the immediate loop entry point.

Behavior:

- Determine the current project slug from the working directory
- Inspect current session context first
- Optionally inspect repo state for changed files and verification evidence
- Summarize:
  - completed work
  - verification performed
  - open risks
  - durable-learning candidates
- Update `~/.codex/projects/<slug>/memory/MEMORY.md`
- Automatically trigger `diary`
- Offer optional follow-ups, but do not perform durable edits without approval

Hard constraints:

- No commit, push, deploy, or destructive cleanup by default
- No repo-local memory writes
- No automatic durable instruction changes

### `diary`

`diary` can run standalone and is always invoked by `wrap-up`.

Behavior:

- Use active conversation context as the primary source
- Fall back to session logs only when context is incomplete and needed
- Write a structured diary entry to `~/.codex/memory/diary/`
- Capture:
  - task summary
  - work summary
  - design decisions
  - actions taken
  - challenges and solutions
  - user preferences observed
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
  - project slug
  - keyword
- Read supporting context:
  - prior reflections
  - `processed.log`
  - project `MEMORY.md`
  - existing global `AGENTS.md` when considering global promotions
- Group repeated learnings
- Apply scope and confidence rules
- Write a reflection file to `~/.codex/memory/reflections/`
- Propose durable promotions without applying them automatically

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
- Existing repo docs
- Repo `AGENTS.md`
- Global `~/.codex/AGENTS.md`
- New skill
- No durable promotion

### Destination Rules

- One-off observations stay in diary or reflection only
- Stable project facts go to `project_*.md`
- Repeated project lessons go to `feedback_*.md`
- Stable cross-project behavior can become a global `AGENTS.md` candidate
- Reusable workflows and judgment-heavy procedures can become skill candidates
- Existing docs are preferred over new files when they already own the subject

### Approval Model

No durable edit is automatic.

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
**Project**: <abs path or slug>
**Git Branch**: <branch or n/a>
**Session**: N

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
