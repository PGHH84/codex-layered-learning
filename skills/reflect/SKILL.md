---
name: reflect
description: Use when the user asks to review Codex diary entries over time, synthesize repeated patterns, propose durable learnings, or explicitly says reflect, run reflection, or review memory for Codex Layered Learning
---

# Codex Layered Learning Reflect

## Runtime authority

This skill is the runtime source of truth for `reflect`.

- `commands/reflect.md` is a reference-only summary
- Behavioral changes must land here first and then be synchronized into installed copies under `~/.agents/skills/`

## Purpose

`reflect` is the deferred synthesis loop for Codex Layered Learning. It reads diary entries and supporting memory, identifies repeated patterns, routes them by scope, and proposes durable promotions without applying them automatically.

`reflect` runs separately from `wrap-up`.

## Safety Boundaries

- Never create repo-local runtime memory folders in working repositories
- Never auto-apply edits to instruction files, repo docs, project memory notes, or skills
- Keep markdown as the source of truth in v1

## Runtime Paths

- Central diary: `~/.agents/memory/diary/` (shared — written by both Claude Code and Codex)
- Central reflections: `~/.agents/memory/reflections/`
- Processed index: `~/.agents/memory/reflections/processed.log`
- Project memory: `~/.codex/projects/<slug>/memory/` (symlinked → `~/.claude/projects/<slug>/memory/`)
- Global durable guidance candidates: `~/.codex/AGENTS.md` AND `~/.claude/CLAUDE.md`

## Promotion Model

Reflect always promotes to **both agents** — no agent-specific rules.

| Scope | Target |
|-------|--------|
| Global (cross-project) | `~/.claude/CLAUDE.md` AND `~/.codex/AGENTS.md` |
| Project (triumvirate — `SKILL.md` exists) | `[project]/SKILL.md` only (CLAUDE.md @imports it; AGENTS.md mirrors it) |
| Project (non-triumvirate) | `[project]/CLAUDE.md` AND `[project]/AGENTS.md` |

Before promoting, check if `[project]/SKILL.md` exists to determine the project target.

## Path-To-Slug Transform

Use this exact transform so `reflect`, `wrap-up`, and `diary` agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. Otherwise, use the canonical absolute working directory.
3. Resolve symlinks before deriving the slug.
4. Replace every `/` in the canonical absolute path with `-`.

## Inputs

Primary corpus:

- centralized diary entries from `~/.agents/memory/diary/`

Supported filters:

- all unprocessed entries
- last `N` entries
- date range
- project slug using the shared path-derived slug scheme
- keyword

Supporting context:

- prior reflections from `~/.agents/memory/reflections/`
- `~/.agents/memory/reflections/processed.log`
- project `~/.codex/projects/<slug>/memory/MEMORY.md` when project context is relevant
- existing typed project memory notes under `~/.codex/projects/<slug>/memory/` when project-memory promotion candidates are being considered
- repo `AGENTS.md`, repo `SKILL.md`, and relevant repo docs when repo-level promotion candidates are being considered
- global `~/.codex/AGENTS.md` AND `~/.claude/CLAUDE.md` when evaluating global promotion candidates

## Processing Workflow

1. Resolve the filter set and project slug mapping using the shared path-derived slug rule.
2. Load matching diary entries from `~/.agents/memory/diary/`.
3. Skip entries already listed in `processed.log` unless the user explicitly requests reprocessing.
4. Read supporting context that is relevant to the filtered corpus, including recent reflections and the current contents of plausible promotion targets (both agents).
5. Group repeated patterns, explicit rule violations, contradictions, and one-off observations.
6. Carry forward recent one-off observations from prior reflections when the same signal reappears.
7. Route each repeated learning by scope and destination using the Promotion Model, strengthening weak existing guidance before proposing a brand-new durable note.
8. Write the reflection file to `~/.agents/memory/reflections/YYYY-MM-DD-reflection-N.md`.
9. Update `processed.log` only after the user accepts the reflection pass as complete or explicitly asks to mark the analyzed diary entries as processed.

## Carry-Forward Rule

- Read recent `One-Off Observations` before scoring new patterns
- If a current signal matches a recent one-off observation, count that prior occurrence toward the current confidence threshold
- Use carry-forward only for clearly similar signals
- Note the carry-forward when it materially affects confidence

## Rule Violation Priority

- Check whether diary entries show the agent violating an existing global rule, repo rule, or project-memory lesson
- Repeated violation of an existing rule is higher priority than inventing a new rule
- If patterns are contradictory, surface the contradiction instead of forcing a confident promotion

## Scope Routing

Use deterministic routing first and model judgment only for edge cases.

### Project-Specific Signals

- Mentions repo-specific paths, commands, services, architecture, or quirks
- Appears only inside one project corpus
- Would look out of place in unrelated projects

### Global Signals

- Applies to Codex behavior across repositories
- Repeats across multiple projects or sessions
- Reads like a general operating principle

### Technology-Specific Signals

- technology-specific patterns that recur across multiple projects can become global
- technology-specific patterns limited to one project stay project-specific
- technology choice alone does not force a global destination; repetition and scope still decide

## Confidence Rules

- 1 occurrence: keep as a one-off observation only
- 2 occurrences in one project: project candidate
- 3 or more occurrences, or repetition across projects: global candidate
- Repeated violation of an existing rule raises promotion priority

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

## Candidate Destinations

- Project typed note under `~/.codex/projects/<slug>/memory/`
- Existing repo docs
- Repo `AGENTS.md`
- Global `~/.codex/AGENTS.md`
- New skill
- No durable promotion

Prefer existing docs over new files when they already own the subject.

## Typed Note Policy

When the chosen destination is project memory, use the typed memory policy in [`docs/typed-memory-notes.md`](../../docs/typed-memory-notes.md) to choose the note type:

- `project_*.md`: stable project facts, architecture, invariants, storage layout, or repo-specific conventions
- `feedback_*.md`: repeated project lessons, anti-patterns, or guardrails justified by recurring evidence
- `reference_*.md`: supporting reference material that helps interpret or apply other guidance
- `user_*.md`: stable recurring user or project preferences that materially affect future execution

Avoid creating a new typed note when:

- the signal is one-off, weak, or better kept in the reflection only
- an existing typed note can be strengthened instead
- repo docs, `AGENTS.md`, or a skill is the clearer durable destination
- the content is temporary task state rather than durable memory

## Destination Checks

Before proposing any promotion:

- Inspect the relevant destination if it already exists
- Skip a semantic duplicate even when the wording differs
- Prefer strengthening existing guidance over adding a parallel duplicate
- Flag any conflict between candidate guidance and existing guidance for user review instead of auto-resolving it

## Approval Model

No durable edit is automatic. Every proposed promotion must include:

- the proposed learning
- supporting evidence
- confidence
- proposed destination
- the reason for project-specific or global scope

## `processed.log` Behavior

- Store processed diary entry identifiers in `~/.codex/memory/reflections/processed.log`
- Canonical line format: `<diary-filename> | <processed-date> | <reflection-filename> | accepted`
- Only add identifiers after the user accepts the reflection pass as complete or explicitly asks to mark entries as processed
- Default behavior is to skip diary entries already listed there
- `include all entries` means analyze both processed and unprocessed entries for the selected scope without deleting prior reflections
- targeted `reprocess` means analyze a named entry or filtered subset again when the user explicitly asks
- If the user explicitly requests reprocessing, allow already-processed entries back into the analysis set
- Reprocessing does not require deleting old reflections

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
- `processed.log` is approval-gated, not automatically advanced
- routing, confidence, and destination rules remain consistent with the Codex Layered Learning design
- destination checks include semantic duplicate review and conflict handling
- the typed note policy covers `feedback_*.md`, `project_*.md`, `reference_*.md`, and `user_*.md`
- technology routing, signal vs noise guidance, and reprocess modes are explicit
