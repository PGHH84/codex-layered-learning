---
name: reflect
description: Use when the user asks to review Codex diary entries over time, synthesize repeated patterns, propose durable learnings, or explicitly says reflect, run reflection, or review memory for Codex Layered Learning
---

# Codex Layered Learning Reflect

## Runtime authority

This skill is the runtime source of truth for `reflect`.

- `commands/reflect.md` is a reference-only summary
- behavioral changes must land here first and then be synchronized into installed copies under `~/.agents/skills/`

## Purpose

`reflect` is the deferred synthesis loop for Codex Layered Learning.

- it reads Codex diary entries and supporting memory
- it identifies repeated patterns, rule violations, contradictions, and one-off observations
- it routes durable learnings to canonical local or global instruction sources
- it applies approved durable promotions in the same reflection flow

`reflect` runs separately from `wrap-up`.

## Safety Boundaries

- never create repo-local runtime memory folders in working repositories
- never edit repo `AGENTS.md` or repo `CLAUDE.md` directly as operating-instruction sources
- never edit `~/.codex/AGENTS.md` or `~/.claude/CLAUDE.md` directly when a generated mirror path should be used
- never write arbitrary `~/.claude/**` state outside the approved global mirror-sync path
- keep markdown as the source of truth in this pass

## Runtime Paths

- diary input: `~/.codex/memory/diary/`
- reflections: `~/.codex/memory/reflections/`
- processed index: `~/.codex/memory/reflections/processed.log`
- project memory: `~/.codex/projects/<slug>/memory/`
- project operating guidance source: repo `PROJECT.md`
- global operating guidance source: `~/.agents/global/PROJECT.md`
- generated global mirrors: `~/.codex/AGENTS.md`, `~/.claude/CLAUDE.md`

## Promotion Model

Reflect routes candidates to the canonical durable destination for the signal.

| Scope | Target |
|---|---|
| Global, cross-project behavior | `~/.agents/global/PROJECT.md` |
| Project operating guidance | repo `PROJECT.md` |
| Project durable memory | typed notes under `~/.codex/projects/<slug>/memory/` |
| Reusable procedural workflow | skill candidate |
| Too weak or one-off | no durable promotion |

Before proposing any promotion, inspect the current destination if it exists and prefer strengthening existing guidance over creating a parallel duplicate.

## Path-To-Slug Transform

Use this exact transform so `reflect`, `wrap-up`, and `diary` agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. If that repo root contains `/.worktrees/`, strip the `/.worktrees/<name>` suffix and use the parent repo path as the canonical project root.
3. Otherwise, if not inside a git repository, use the canonical absolute working directory.
4. Resolve symlinks before deriving the slug.
5. Replace every `/` in the canonical absolute path with `-`.

## Inputs

Primary corpus:

- diary entries from `~/.codex/memory/diary/`

Supported filters:

- all unprocessed entries
- last `N` entries
- date range
- project slug using the shared path-derived slug scheme
- keyword

Supporting context:

- prior reflections from `~/.codex/memory/reflections/`
- `~/.codex/memory/reflections/processed.log`
- project `~/.codex/projects/<slug>/memory/MEMORY.md` when project context is relevant
- existing typed project memory notes under `~/.codex/projects/<slug>/memory/` when project-memory promotion candidates are being considered
- repo `PROJECT.md` when project operating-guidance candidates are being considered
- canonical global `~/.agents/global/PROJECT.md` when evaluating global promotion candidates

## Processing Workflow

1. Resolve the filter set and project slug mapping using the shared path-derived slug rule.
2. Load matching diary entries from `~/.codex/memory/diary/`.
3. Skip entries already listed in `processed.log` unless the user explicitly requests reprocessing.
4. Read supporting context relevant to the filtered corpus, including recent reflections and the current contents of plausible promotion targets.
5. Group repeated patterns, explicit rule violations, contradictions, and one-off observations.
6. Carry forward recent one-off observations from prior reflections when the same signal reappears.
7. Prioritize repeated violation of existing guidance over inventing a new rule.
8. Route each repeated learning by scope and destination, strengthening weak existing guidance before proposing a brand-new durable note.
9. Write the reflection file to `~/.codex/memory/reflections/YYYY-MM-DD-reflection-N.md`.
10. Present proposed durable edits with destination, evidence, and confidence.
11. If the user approves any durable edits, apply them in the same flow.
12. If approved global canonical edits were applied, run the global mirror-sync path.
13. Update `processed.log` only after the user accepts the reflection pass as complete and any approved durable edits for that pass were applied.

## Carry-Forward Rule

- read recent `One-Off Observations` before scoring new patterns
- if a current signal matches a recent one-off observation, count that prior occurrence toward the current confidence threshold
- use carry-forward only for clearly similar signals
- note the carry-forward when it materially affects confidence

## Rule Violation Priority

- check whether diary entries show the agent violating an existing global rule, repo rule, or project-memory lesson
- repeated violation of an existing rule is higher priority than inventing a new rule
- if patterns are contradictory, surface the contradiction instead of forcing a confident promotion

## Scope Routing

Use deterministic routing first and model judgment only for edge cases.

### Project-Specific Signals

- mentions repo-specific paths, commands, services, architecture, or quirks
- appears only inside one project corpus
- would look out of place in unrelated projects

### Global Signals

- applies to Codex behavior across repositories
- repeats across multiple projects or sessions
- reads like a general operating principle

### Technology-Specific Signals

- technology-specific patterns that recur across multiple projects can become global
- technology-specific patterns limited to one project stay project-specific
- technology choice alone does not force a global destination; repetition and scope still decide

## Confidence Rules

- 1 occurrence: keep as a one-off observation only
- 2 occurrences in one project: project candidate
- 3 or more occurrences, or repetition across projects: global candidate
- repeated violation of an existing rule raises promotion priority

## Signal vs Noise

Treat a pattern as signal when it has durable evidence and future decision value.

Repeated signal examples:

- the same project lesson appears in two diary entries for one project
- the same Codex operating rule violation appears across multiple sessions
- a technology-specific workflow repeats across multiple projects and reads like reusable guidance

Treat a pattern as noise when it is isolated, temporary, or not durable enough to promote.

Noise examples:

- a one-off workaround tied to a single broken tool invocation
- an abandoned idea that appears once and never returns
- a transient preference that does not materially affect future execution

## Typed Note Policy

When the chosen destination is project memory, use [`docs/typed-memory-notes.md`](../../docs/typed-memory-notes.md) to choose the note type:

- `project_*.md`: stable project facts, architecture, invariants, storage layout, or repo-specific conventions
- `feedback_*.md`: repeated project lessons, anti-patterns, or guardrails justified by recurring evidence
- `reference_*.md`: supporting reference material that helps interpret or apply other guidance
- `user_*.md`: stable recurring user or project preferences that materially affect future execution

Avoid creating a new typed note when:

- the signal is one-off, weak, or better kept in the reflection only
- an existing typed note can be strengthened instead
- repo `PROJECT.md` or a skill is the clearer durable destination
- the content is temporary task state rather than durable memory

## Approval Model

No durable edit is automatic until the user approves it.

- auto-write:
  - reflection markdown file
- require approval:
  - repo `PROJECT.md` edits
  - project typed note creation or edits
  - `~/.agents/global/PROJECT.md` edits
  - skill candidate creation
- auto-run after approved global canonical edits:
  - regenerate `~/.codex/AGENTS.md`
  - regenerate `~/.claude/CLAUDE.md`
- update `processed.log` only after the user accepts the reflection pass as complete and approved actions are resolved

Every proposed promotion must include:

- the proposed learning
- supporting evidence
- confidence
- proposed destination
- the reason for project-specific or global scope

## `processed.log` Semantics

- store processed diary entry identifiers in `~/.codex/memory/reflections/processed.log`
- canonical line format: `<diary-filename> | <processed-date> | <reflection-filename> | accepted`
- reflection acceptance is required before advancing `processed.log`
- approved durable edits must be applied in the same flow before advancing `processed.log`
- declining all durable edits does not block `processed.log` advancement if the user still accepts the reflection as complete
- `include all entries` analyzes both processed and unprocessed entries for the selected scope without deleting prior reflections
- targeted `reprocess` analyzes a named entry or filtered subset again when the user explicitly asks

## Missing-Surface Fallback Rules

- if no diary entries exist, suggest running `diary` or `wrap-up` first
- if all entries are already processed, suggest `include all entries`
- if a target destination does not exist, propose the change without creating the destination automatically unless approved

## Exact Template

```md
# Reflection: <scope>

**Generated**: YYYY-MM-DD HH:MM
**Entries Analyzed**: N
**Date Range**: ...
**Projects**: ...

## Summary
...

## Rule Violations Detected
[Omit this section if none.]

1. **Rule**: ...
   - **Frequency**: ...
   - **Violation pattern**: ...
   - **Root Cause**: ...
   - **Impact**: ...
   - **Strengthening action**: ...

## Patterns Identified

### Persistent Preferences
1. ...

### Design Decisions That Worked
1. ...

### Anti-Patterns To Avoid
1. ...

### Project-Specific Patterns
1. ...

## Efficiency Lessons
1. ...

## Notable Mistakes and Learnings
1. ...

## One-Off Observations
- ...

## Proposed Promotions

### Global canonical candidates
- ...

### Project `PROJECT.md` candidates
- ...

### Project memory candidates
- ...

### Skill candidates
- ...

## Metadata
- Diary entries analyzed:
- Prior one-offs carried forward:
- Reprocessing requested:
- Processed log status:
- Processed log entries to append:
```

## Verification Checklist

Before treating this skill as correct, verify that:

- filters cover unprocessed, last `N`, date range, project slug, and keyword
- the path-to-slug transform is explicit and shared with `wrap-up` and `diary`
- worktree roots collapse to the main repo identity before slugging
- runtime paths include the canonical global source and generated global mirrors
- approved durable edits can be applied in the same reflection flow
- `processed.log` advancement depends on reflection acceptance and approved-edit resolution
- routing, confidence, approval, and destination rules remain consistent with the parity design
- destination checks include semantic duplicate review and conflict handling
- the typed note policy covers `feedback_*.md`, `project_*.md`, `reference_*.md`, and `user_*.md`
