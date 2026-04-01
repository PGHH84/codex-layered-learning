# Codex Claude Full Parity Design

Parent: [[docs/MOC]]
Related: [[2026-03-31-codex-claude-parity-design]], [[2026-03-20-codex-layered-learning-design]], [[typed-memory-notes]]

**Date:** 2026-03-31
**Status:** Proposed
**Supersedes:** [[2026-03-31-codex-claude-parity-design]] where the two conflict

## Goal

Bring Codex Layered Learning to full functional parity with the current Claude
Layered Learning workflow while preserving the runtime-specific file surfaces
that each agent expects.

Parity in this pass means:

- the same high-level `wrap-up`, `diary`, and `reflect` behaviors
- the same local operating-guidance flow in repos that use the triumvirate
- the same durable global-learning outcomes across Codex and Claude
- one coherent project-memory identity even when work happens in git worktrees

## Non-Goals

- making `AGENTS.md` and `CLAUDE.md` text-identical for style alone
- preserving the older Codex-only global-isolation model
- changing the Claude implementation itself
- introducing shared diary storage
- introducing shared reflection storage

## Current Problem

The current parity repair fixed the largest Codex runtime inconsistencies, but
it still stops short of full parity in four ways:

1. local operating improvements are not yet routed through the project
   triumvirate
2. global durable improvements still lack a canonical cross-agent source
3. `reflect` remains thinner and more proposal-gated than Claude
4. worktree paths still fragment project-memory identity

## Design Principles

### One Canonical Source Per Layer

Each durable-instruction layer should have one editable source of truth and one
or more generated or mirrored runtime files.

### Same Behavior, Different Runtime Surfaces

Claude and Codex can keep their native file names and formatting conventions,
but they should produce the same operating behavior and the same durable
learnings.

### Local Operating Guidance Lives In The Repo

In repositories that use the project triumvirate, operating guidance belongs in
`PROJECT.md`, not in generated mirrors and not in external memory notes.

### Memory And Instructions Are Different Things

Project facts, preferences, references, and recurring lessons still belong in
Codex project memory under `~/.codex/projects/<slug>/memory/`. Repo operating
rules belong in `PROJECT.md`.

## Local Architecture

### Project Triumvirate

Every project in scope guarantees this structure:

| File | Role | Writable source |
|---|---|---|
| `PROJECT.md` | canonical project operating instructions | yes |
| `CLAUDE.md` | Claude-facing stub or import of `PROJECT.md` | no |
| `AGENTS.md` | generated Codex-facing mirror of `PROJECT.md` | no |

### Local Routing Rules

Project-local operating improvements found by either `wrap-up` or `reflect`
must route as follows:

- operating rules, workflow rules, repo conventions -> `PROJECT.md`
- stable project facts and architecture notes -> `project_*.md`
- repeated lessons and guardrails that are memory rather than repo operating
  instructions -> `feedback_*.md`
- supporting lookup material -> `reference_*.md`
- stable recurring user preferences -> `user_*.md`

Rule:

- do not write project operating improvements directly to repo `AGENTS.md`
- do not write project operating improvements directly to repo `CLAUDE.md`
- update `PROJECT.md`, then let the existing pre-commit machinery regenerate
  repo `AGENTS.md`

## Global Architecture

### Canonical Global Source

Introduce one neutral global operating-instructions source:

- `~/.agents/global/PROJECT.md`

This file becomes the only editable durable source for global cross-project
operating guidance shared by Codex and Claude.

### Global Runtime Mirrors

Generate these runtime mirrors from the canonical global source:

- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`

The mirrors may differ slightly in presentation when the runtime requires it,
but they must remain behaviorally equivalent.

### Mirror Rules

- edit only `~/.agents/global/PROJECT.md`
- treat `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md` as generated files
- both mirrors must include a generated-file notice
- direct manual edits to either mirror are considered drift and should be
  overwritten on the next sync

### Sync Mechanism

Add a dedicated sync script:

- `~/.agents/global/sync_global_instructions.sh`

Responsibilities:

1. validate that `~/.agents/global/PROJECT.md` exists
2. render the Codex mirror at `~/.codex/AGENTS.md`
3. render the Claude mirror at `~/.claude/CLAUDE.md`
4. overwrite both mirrors atomically
5. exit non-zero on any render or write failure

Optional supporting check:

- `~/.agents/global/check_global_instructions_sync.sh`

This check compares freshly rendered output against the live mirrors and reports
drift.

### Global Routing Rules

Global operating improvements found by either `wrap-up` or `reflect` route to:

- `~/.agents/global/PROJECT.md`

After an approved global edit is applied, the sync script must run immediately
so both runtime mirrors stay aligned.

## Project Identity And Worktrees

### Problem

The current path-to-slug rule creates separate project-memory identities for git
worktrees, which fragments `MEMORY.md`, diary references, and reflection scope.

### New Rule

When the current repo root lives under a `/.worktrees/<name>/` path, collapse
the identity back to the primary repo root before deriving the slug.

Examples:

- main repo path:
  - `/Users/pawelgershkovich/Vault/30_Projects/38_Codex-Layered-Learning`
- worktree path:
  - `/Users/pawelgershkovich/Vault/30_Projects/38_Codex-Layered-Learning/.worktrees/codex-claude-parity`
- canonical project identity for both:
  - `/Users/pawelgershkovich/Vault/30_Projects/38_Codex-Layered-Learning`

### Required Shared Transform

`wrap-up`, `diary`, and `reflect` must all use the same algorithm:

1. if inside a git repository, resolve repo root
2. if the repo root contains `/.worktrees/`, strip the `/.worktrees/<name>`
   suffix and use the parent repo path
3. resolve symlinks
4. replace every `/` with `-`

## Skill Parity Targets

### `wrap-up`

Codex `wrap-up` should match Claude's current phase structure:

1. `Ship It`
2. `Remember It`
3. `Review & Apply`
4. `Diary Capture`

No final push prompt is required in this parity target.

#### `Ship It`

Expected behavior:

- sync directly affected repo docs when needed
- commit when uncommitted changes exist
- verify file placement
- run deploy only if the project has a documented deploy path
- clean up project task state

#### `Remember It`

Expected behavior:

- update `MEMORY.md`
- run optional personal follow-up logic if configured
- route project facts and durable memory into the right typed notes
- route project operating improvements into `PROJECT.md`
- route global operating improvements into `~/.agents/global/PROJECT.md`

#### `Review & Apply`

Expected behavior:

- identify immediate self-improvement findings
- apply project-local operating improvements directly to `PROJECT.md`
- apply approved global improvements to `~/.agents/global/PROJECT.md`
- trigger global mirror sync after global changes are applied

#### `Diary Capture`

Expected behavior:

- always run `diary`

### `diary`

Codex `diary` should match Claude's richer observational capture while using
Codex-owned diary storage.

Requirements:

- keep context-first capture
- keep session-number coordination with `MEMORY.md`
- preserve explicit incompleteness rather than guessing
- include the richer Claude-equivalent sections:
  - `Time`
  - `Code Quality Preferences`
  - `Code Patterns and Decisions`
  - `Context and Technologies`
- use the collapsed canonical project slug so worktrees attach to the same
  project identity

Diary storage remains split from Claude:

- `~/.codex/memory/diary/`
- `~/.claude/memory/diary/`

### `reflect`

Codex `reflect` should match Claude's richer synthesis behavior while
respecting the new local and global source-of-truth model.

Requirements:

- analyze diary entries with Claude-equivalent thresholds and carry-forward
- prioritize repeated rule violations over inventing new guidance
- include the fuller Claude-style sections:
  - `Rule Violations Detected`
  - `Patterns Identified`
  - `Efficiency Lessons`
  - `Notable Mistakes and Learnings`
  - `One-Off Observations`
  - `Proposed Promotions`
- route local operating improvements to `PROJECT.md`
- route global operating improvements to `~/.agents/global/PROJECT.md`
- route project memory content to typed notes under
  `~/.codex/projects/<slug>/memory/`

### Reflection Storage

Reflection outputs remain split by agent:

- Codex reflections: `~/.codex/memory/reflections/`
- Claude reflections: `~/.claude/memory/reflections/`

The durable outcomes of reflection can still converge because they now target
shared canonical instruction sources at the local and global layers.

### `processed.log` Semantics

To match the intended Claude behavior more closely:

1. generate the reflection file
2. present findings and proposed durable edits
3. apply any approved durable edits
4. if global edits were applied, run the global sync script
5. mark analyzed diary entries as processed only after the reflection pass is
   accepted and approved edits for this pass have been applied or explicitly
   declined

Rules:

- reflection acceptance is still required
- accepted-but-declined durable edits can still allow processing to advance
- accepted-and-approved durable edits should be applied in the same flow, not
  deferred to a separate manual step
- `include all entries` and targeted `reprocess` still bypass default skip
  logic

## Approval Model

### `wrap-up`

| Destination | Default behavior |
|---|---|
| `MEMORY.md` current-state update | auto-apply |
| repo docs directly affected by session work | auto-apply |
| commit creation | auto-apply when uncommitted changes exist |
| deploy step | auto-apply only when a documented deploy path exists |
| project task cleanup | auto-apply |
| `PROJECT.md` local operating improvements | auto-apply |
| typed-note creation or edits under `~/.codex/projects/<slug>/memory/` | auto-apply when clearly memory, not repo operating guidance |
| `~/.agents/global/PROJECT.md` edits | require approval |
| global mirror sync after approved global edit | auto-run |

### `reflect`

| Destination | Default behavior |
|---|---|
| reflection markdown file | auto-write |
| `PROJECT.md` local operating improvements | require approval, then apply in the same flow |
| typed-note creation or edits under `~/.codex/projects/<slug>/memory/` | require approval, then apply in the same flow |
| `~/.agents/global/PROJECT.md` edits | require approval, then apply in the same flow |
| global mirror sync after approved global edit | auto-run |
| `processed.log` | update only after the reflection pass is accepted and approved actions are resolved |

## Documentation Model

The repo docs must now describe two distinct but aligned instruction systems:

### Local

- canonical: repo `PROJECT.md`
- Claude mirror: repo `CLAUDE.md`
- Codex mirror: repo `AGENTS.md`

### Global

- canonical: `~/.agents/global/PROJECT.md`
- Claude mirror: `~/.claude/CLAUDE.md`
- Codex mirror: `~/.codex/AGENTS.md`

Public and internal docs must stop describing Codex global behavior as isolated
from Claude if the approved architecture now includes the explicit global sync
path.

## Required Implementation Workstreams

1. update the parity design and plan docs to reflect the new source-of-truth
   model
2. update `wrap-up` routing to write local operating changes to `PROJECT.md`
3. update `reflect` routing to write approved local operating changes to
   `PROJECT.md`
4. expand `reflect` output structure to match the fuller Claude analysis
5. update worktree slug logic across `wrap-up`, `diary`, and `reflect`
6. introduce the canonical global file and sync scripts
7. update installer, verifier, README, INSTALL, and manual verification to
   match the new architecture
8. verify generated global mirrors and repo-local mirrors behave as intended

## Migration Notes

### Existing Global Files

Seed `~/.agents/global/PROJECT.md` from the stronger current global source, then
generate:

- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`

### Existing Project Repos

Projects already using the triumvirate need no architectural change. They only
need the parity routing update so local operating improvements land in
`PROJECT.md`.

### Existing Project Memory

No diary or reflection migration is required in this pass. Only routing and
identity rules change.

## Expected Outcome

After this pass:

- `wrap-up`, `diary`, and `reflect` behave like the current Claude layered
  learning workflow
- project-local operating improvements converge through `PROJECT.md`
- global operating improvements converge through `~/.agents/global/PROJECT.md`
- Codex and Claude keep native runtime mirror files without manual drift
- worktrees no longer create fragmented project-memory identities

## Acceptance Criteria

This full parity pass is complete only when all of the following are true:

1. `wrap-up` routes project-local operating improvements to `PROJECT.md`.
2. `reflect` routes approved project-local operating improvements to
   `PROJECT.md` in the same flow.
3. both skills route approved global improvements to
   `~/.agents/global/PROJECT.md`.
4. the global sync script regenerates `~/.codex/AGENTS.md` and
   `~/.claude/CLAUDE.md` from the canonical global file.
5. repo-local triumvirate behavior remains intact:
   - `PROJECT.md` is canonical
   - `CLAUDE.md` is a stub or import
   - `AGENTS.md` is generated
6. `wrap-up`, `diary`, and `reflect` all collapse worktree paths to the main
   repo slug before resolving project memory.
7. Codex `reflect` includes the fuller Claude-equivalent synthesis sections and
   applies approved durable edits in the same flow.
8. documentation, install scripts, verification scripts, and manual
   verification all describe the same architecture.
