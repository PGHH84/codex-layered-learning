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
- it routes durable learnings to Codex-owned or repo-owned destinations
- it proposes durable promotions without applying them automatically

`reflect` runs separately from `wrap-up`.

## Safety Boundaries

- never create repo-local runtime memory folders in working repositories
- never auto-apply edits to repo `AGENTS.md`, `~/.codex/AGENTS.md`, repo docs, project typed notes, or skills
- never read from or write to `~/.claude/**`
- keep markdown as the source of truth in this pass

## Runtime Paths

- diary input: `~/.codex/memory/diary/`
- reflections: `~/.codex/memory/reflections/`
- processed index: `~/.codex/memory/reflections/processed.log`
- project memory: `~/.codex/projects/<slug>/memory/`
- global durable guidance candidate: `~/.codex/AGENTS.md`

## Promotion Model

Reflect routes candidates to the nearest Codex-owned equivalent of Claude's durable targets.

| Scope | Target |
|---|---|
| Global, cross-project Codex behavior | `~/.codex/AGENTS.md` |
| Repo-wide operating guidance | repo `AGENTS.md` |
| Existing project-owned documentation | repo docs |
| Project durable memory | typed notes under `~/.codex/projects/<slug>/memory/` |
| Reusable procedural workflow | skill candidate |
| Too weak or one-off | no durable promotion |

Before proposing any promotion, inspect the current destination if it exists and prefer strengthening existing guidance over creating a parallel duplicate.

## Path-To-Slug Transform

Use this exact transform so `reflect`, `wrap-up`, and `diary` agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. Otherwise, use the canonical absolute working directory.
3. Resolve symlinks before deriving the slug.
4. Replace every `/` in the canonical absolute path with `-`.

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
- repo `AGENTS.md` and relevant repo docs when repo-level promotion candidates are being considered
- global `~/.codex/AGENTS.md` when evaluating global promotion candidates

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
10. Update `processed.log` only after the user accepts the reflection pass as complete or explicitly asks to mark the analyzed diary entries as processed.

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
- repo docs, `AGENTS.md`, or a skill is the clearer durable destination
- the content is temporary task state rather than durable memory

## Approval Model

No durable edit is automatic.

- auto-write:
  - reflection markdown file
- require approval:
  - repo `AGENTS.md` edits
  - `~/.codex/AGENTS.md` edits
  - repo doc edits
  - project typed note creation or edits
  - skill candidate creation
- update `processed.log` only after the user accepts the reflection pass as complete

Every proposed promotion must include:

- the proposed learning
- supporting evidence
- confidence
- proposed destination
- the reason for project-specific or global scope

## `processed.log` Semantics

- store processed diary entry identifiers in `~/.codex/memory/reflections/processed.log`
- canonical line format: `<diary-filename> | <processed-date> | <reflection-filename> | accepted`
- acceptance of the reflection pass advances `processed.log`
- approval of durable edits is separate from reflection acceptance
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
   - **Violation pattern**: ...
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
- Prior one-offs carried forward:
- Reprocessing requested:
- Processed log status:
- Processed log entries to append:
```

## Verification Checklist

Before treating this skill as correct, verify that:

- filters cover unprocessed, last `N`, date range, project slug, and keyword
- the path-to-slug transform is explicit and shared with `wrap-up` and `diary`
- all runtime paths are Codex-native
- `processed.log` advancement depends on reflection acceptance, not durable-edit approval
- routing, confidence, approval, and destination rules remain consistent with the parity design
- destination checks include semantic duplicate review and conflict handling
- the typed note policy covers `feedback_*.md`, `project_*.md`, `reference_*.md`, and `user_*.md`
