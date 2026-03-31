# Codex Claude Parity Design

Parent: [[docs/MOC]]
Related: [[2026-03-20-codex-layered-learning-design]], [[typed-memory-notes]], [[2026-03-31-codex-claude-parity-plan]]

**Date:** 2026-03-31

## Goal

Bring Codex Layered Learning to behavioral parity with Claude Layered Learning while remaining compliant with the current Codex documentation:

- Codex runtime memory stays under `~/.codex/`
- installed Codex runtime skills stay under `~/.agents/skills/`
- Codex does not read from or write to `~/.claude/**`
- Codex mirrors Claude's workflow and information model as closely as possible without cross-agent storage sharing

## Non-Goals

- introducing shared durable memory between Codex and Claude
- introducing shared diary or reflection storage
- introducing Claude hook behavior into Codex before a documented Codex-native trigger exists
- changing Claude Layered Learning

## Constraints From Current Docs

- Codex is documented as isolated from Claude runtime surfaces
- Codex project memory is documented under `~/.codex/projects/<slug>/memory/`
- Codex diary and reflection storage are documented under `~/.codex/memory/`
- Codex durable global guidance is documented under `~/.codex/AGENTS.md`
- Codex project durable memory uses typed notes under `~/.codex/projects/<slug>/memory/`

These constraints rule out shared Claude/Codex durable memory in this pass.

## Claude To Codex Destination Mapping

Behavior parity does not mean path parity. Claude destinations should map to the nearest Codex-owned equivalent.

| Claude concept | Claude destination | Codex equivalent for this pass |
|---|---|---|
| Global durable behavior guidance | `~/.claude/CLAUDE.md` | `~/.codex/AGENTS.md` |
| Project durable operating guidance | project `CLAUDE.md` | repo `AGENTS.md` or project typed notes under `~/.codex/projects/<slug>/memory/`, depending on content |
| Scoped topic rules | `.claude/rules/` | repo docs, repo `AGENTS.md`, or a skill candidate |
| Private per-machine session follow-up | `~/.claude/skills/wrap-up/personal.md` | `~/.codex/skills/wrap-up/personal.md` |
| Auto memory / discovered project facts | Claude project memory hierarchy | Codex `MEMORY.md` plus typed notes under `~/.codex/projects/<slug>/memory/` |
| Reflection output | `~/.claude/memory/reflections/` | `~/.codex/memory/reflections/` |

Selection rules:

- stable project facts -> `project_*.md`
- repeated project lessons or guardrails -> `feedback_*.md`
- supporting lookup material -> `reference_*.md`
- stable recurring user preferences -> `user_*.md`
- repo-wide operating rules -> repo `AGENTS.md`
- cross-project Codex behavior rules -> `~/.codex/AGENTS.md`
- reusable procedural workflows -> skill candidate

## Parity Target

### `wrap-up`

Codex `wrap-up` should regain Claude's end-of-session phase structure:

1. `Ship It`
   - documentation sync when directly affected
   - commit flow when uncommitted changes exist
   - file placement check
   - deploy if the project has a documented deploy path
   - task cleanup
2. `Remember It`
   - update `MEMORY.md`
   - run optional `personal.md`
   - place knowledge in the right Codex durable layer
3. `Review & Apply`
   - identify self-improvement findings
   - auto-apply Codex-side actionable findings where the current docs allow it
   - keep approval gates for global durable changes
4. `Diary Capture`
   - always run `diary`
5. `Final Step`
   - ask whether to push

### `diary`

Codex `diary` should match Claude's richer observation model:

- keep context-first capture
- keep session-number coordination with `MEMORY.md`
- add the richer section coverage Claude uses:
  - `Time`
  - `Code Quality Preferences`
  - `Code Patterns and Decisions`
  - `Context and Technologies`
- keep Codex-safe redact rules and path-derived project identity

### `reflect`

Codex `reflect` should match Claude's synthesis behavior while routing to Codex-owned targets:

- analyze diary entries with the same pattern thresholds and carry-forward logic
- prioritize rule violations and strengthening weak existing guidance
- propose updates to Codex equivalents of Claude targets:
  - global `~/.codex/AGENTS.md`
  - repo `AGENTS.md`
  - repo docs
  - project typed memory notes under `~/.codex/projects/<slug>/memory/`
  - skills when the learning is procedural
- keep approval gates aligned with the current Codex docs

## Approval Model For This Pass

To keep parity behavior concrete, approval requirements must be destination-specific.

### `wrap-up`

| Destination | Default behavior |
|---|---|
| `MEMORY.md` current-state update | auto-apply |
| `~/.codex/skills/wrap-up/personal.md` follow-up | execute only under normal Codex approval rules |
| repo docs directly affected by session work | auto-apply |
| commit creation | auto-apply when uncommitted changes exist |
| deploy step | auto-apply only when a documented deploy script or skill exists |
| task-list cleanup in repo-owned task files | auto-apply |
| new or edited typed note under `~/.codex/projects/<slug>/memory/` | require approval |
| repo `AGENTS.md` edits | require approval |
| `~/.codex/AGENTS.md` edits | require approval |
| new skill or skill-spec creation | require approval |
| push to remote | always ask explicitly |

### `reflect`

| Destination | Default behavior |
|---|---|
| reflection markdown file | auto-write |
| `processed.log` | update only after the user accepts the reflection pass as complete |
| repo `AGENTS.md` edits | require approval |
| `~/.codex/AGENTS.md` edits | require approval |
| repo doc edits | require approval |
| project typed note creation or edits | require approval |
| skill candidate creation | require approval |

This keeps reflection proposal-first while still allowing `wrap-up` to regain Claude-like automatic session-close behavior where the current Codex docs already support it.

## Processed Log Semantics

`reflect` should use one explicit state transition:

1. read unprocessed diary entries by default
2. generate the reflection file
3. present findings and proposed durable edits
4. wait for the user to accept the reflection pass as complete, whether or not they approved any durable edits
5. append the analyzed diary entries to `processed.log`

Rules:

- acceptance of the reflection pass advances `processed.log`
- approval of durable edits is separate from reflection acceptance
- declining all durable edits does not block `processed.log` advancement if the user still accepts the reflection as complete
- `include all entries` and targeted `reprocess` still bypass the default skip logic without deleting prior reflection files

## Missing-Surface Fallback Rules

Claude's workflow assumes some capabilities that Codex may not always expose. Codex parity should therefore use explicit fallbacks instead of silent omission.

### `wrap-up` fallbacks

- if no `/commit` skill exists, use normal git commands directly
- if the working directory is not a git repository, skip commit and push with `n/a`
- if no documented deploy script or deploy skill exists, skip deploy without asking for a manual deploy
- if no repo task file or documented task surface exists, skip task cleanup and state that no project task surface was found
- if file placement conventions are not documented, only correct obvious misplaced document files and avoid speculative renames or moves
- if a required approval is denied, report the skipped step and continue the remaining phases

### `diary` fallbacks

- if context is incomplete, prefer explicit incompleteness over guessed details
- if no session identifier is available, omit `Session ID`
- if no branch is available, use `n/a`

### `reflect` fallbacks

- if no diary entries exist, suggest running `diary` or `wrap-up` first
- if all entries are already processed, suggest `include all entries`
- if a target destination does not exist, propose the change without creating the destination automatically unless approved

## Storage Model For This Pass

### Codex

- installed skills: `~/.agents/skills/`
- optional personal extension: `~/.codex/skills/wrap-up/personal.md`
- project durable memory: `~/.codex/projects/<slug>/memory/`
- diary: `~/.codex/memory/diary/`
- reflections: `~/.codex/memory/reflections/`

### Claude

- unchanged and out of scope

This preserves the current documented boundary and avoids another storage migration during the parity repair.

## Required Corrections

1. Remove all runtime references that currently point Codex diary or reflection behavior at `~/.agents/memory/...`.
2. Remove all Codex runtime references that claim shared or symlinked memory with Claude.
3. Restore Claude-equivalent behavior in the Codex skills without violating Codex-native storage boundaries.
4. Align README, INSTALL, tests, and design docs with the repaired runtime contract.

## Expected Outcome

After this pass:

- Codex and Claude have the same conceptual workflow
- Codex stores its own runtime memory in the places its docs currently promise
- Claude remains untouched
- the Codex repo, installed skills, and local runtime paths become internally consistent again

## Acceptance Criteria

This parity pass is complete only when all of the following are true:

1. Codex `wrap-up` documents the same high-level phase structure as Claude: `Ship It`, `Remember It`, `Review & Apply`, `Diary Capture`, and explicit push confirmation.
2. Codex `diary` captures the richer Claude-equivalent session template while retaining Codex-native project identity and redact rules.
3. Codex `reflect` documents the same pattern-analysis priorities as Claude, but routes durable targets only to Codex-owned or repo-owned destinations.
4. No Codex runtime skill, installer, verifier, or public doc claims that Codex writes runtime memory to `~/.agents/memory/` or `~/.claude/**`.
5. README, INSTALL, design docs, and manual verification instructions all match the runtime skill behavior.
6. Running the installer and verifier leaves the installed skill copies synchronized with the repo copies.
