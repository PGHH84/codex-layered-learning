---
name: wrap-up
description: Use when the user says "wrap up", "close session", "end session", "wrap things up", "close out this task", or invokes /wrap-up for end-of-session closeout of the current Codex task
---

# Codex Layered Learning Wrap-Up

## Runtime authority

This skill is the runtime source of truth for `wrap-up`.

- `commands/` summaries are reference-only
- behavioral changes must land here first and then be synchronized into installed copies under `~/.agents/skills/`

## Purpose

`wrap-up` is the immediate closeout loop for Codex Layered Learning.

Run four phases in order:

1. `Ship It`
2. `Remember It`
3. `Review & Apply`
4. `Diary Capture`

Then ask whether to push.

## Non-Goals

- cross-session synthesis across many diary entries
- writing runtime memory into the working repository
- reading from or writing to `~/.claude/**`
- cross-agent memory sharing in this pass

## Hard Safety Boundaries

- never create repo-local runtime memory folders in working repositories
- never write runtime memory under `~/.agents/memory/` or `~/.claude/**`
- never auto-push
- never auto-apply repo `AGENTS.md`, global `~/.codex/AGENTS.md`, typed-note, or new-skill changes without approval
- never do speculative doc edits, speculative file moves, or destructive cleanup

## Runtime Paths

- project memory: `~/.codex/projects/<slug>/memory/MEMORY.md`
- project durable typed notes: `~/.codex/projects/<slug>/memory/`
- diary output: `~/.codex/memory/diary/`
- reflections: `~/.codex/memory/reflections/`
- global durable guidance: `~/.codex/AGENTS.md`
- optional personal extension: `~/.codex/skills/wrap-up/personal.md`

## Trigger Phrases

Run this skill when the user says things like:

- `wrap up`
- `close session`
- `end session`
- `wrap things up`
- `close out this task`
- `/wrap-up`

## Path-To-Slug Transform

Use this exact transform so `wrap-up`, `diary`, and `reflect` agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. Otherwise, use the canonical absolute working directory.
3. Resolve symlinks before deriving the slug.
4. Replace every `/` in the canonical absolute path with `-`.

Example:

- `/Users/example/Developer/OneNote-To-Notion`
- `-Users-example-Developer-OneNote-To-Notion`

## Execution Sequence

Run these phases in order, then ask whether to push.

### Phase 1: `Ship It`

#### Documentation sync

1. Review the diff in each repo touched during the session.
2. If the change affects project-maintained docs such as README, changelog, setup guides, runbooks, or verification docs, update only the documents directly affected.
3. If no project-maintained docs were directly affected, skip this step.

#### Commit

1. Run `git status` in each repo touched during the session.
2. If uncommitted changes exist, use the repo's normal commit path.
3. If no `/commit` skill exists, use normal git commands directly.
4. If the working directory is not inside a git repository, skip commit with `n/a`.

#### File placement check

1. If files were created or saved during the session, verify that obvious naming and placement rules were followed.
2. Auto-fix only obvious violations:
   - document-type files created at repo root or code directories that clearly belong in docs
   - files that clearly violate an existing documented convention
3. If file placement conventions are not documented, avoid speculative renames or moves.

#### Deploy

1. Check whether the project has a documented deploy script or deploy skill.
2. If one exists, run it.
3. If none exists, skip deploy without asking for a manual deploy path.

#### Task cleanup

1. Check the repo's task surface if one exists.
2. Mark completed tasks done and flag stale or orphaned ones.
3. If no task file or documented task surface exists, skip task cleanup and report that no project task surface was found.

### Phase 2: `Remember It`

#### Always do first

Update `~/.codex/projects/<slug>/memory/MEMORY.md` with:

- `## Current State`
- `**Last updated:**`
- `**Session:**`
- `**Next steps:**`
- `## Key Notes`

Keep `Current State` to a short 2-5 line snapshot and `Next steps` to a short numbered list.

Create `MEMORY.md` if missing using this structure:

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

#### Session number source of truth

- preferred source of truth: `~/.codex/projects/<slug>/memory/MEMORY.md`
- fallback: scan matching diary files for the same project and date only when `MEMORY.md` is missing or uninitialized
- `wrap-up` must set or confirm the session number in `MEMORY.md` before triggering `diary`
- when `wrap-up` invokes `diary`, both steps must use the same session number instead of incrementing independently

#### Optional personal extension

Check whether `~/.codex/skills/wrap-up/personal.md` exists.

- if present, follow it as a machine-local instruction file under normal Codex approval and safety rules
- it is an extension point, not an override mechanism
- if absent, continue silently
- if unclear, blocked, or not approved, report that briefly and continue

If the personal-extension pass materially changes tracked project state, reconcile `MEMORY.md` so it reflects the final post-extension state.

#### Claude-to-Codex destination mapping

Use this mapping when deciding where learned material belongs:

- stable project facts -> `project_*.md`
- repeated project lessons or guardrails -> `feedback_*.md`
- supporting lookup material -> `reference_*.md`
- stable recurring user preferences -> `user_*.md`
- repo-wide operating rules -> repo `AGENTS.md`
- cross-project Codex behavior rules -> `~/.codex/AGENTS.md`
- reusable procedural workflows -> skill candidate
- current-session state only -> `MEMORY.md`

#### Approval matrix for this phase

- auto-apply:
  - `MEMORY.md` current-state update
  - repo docs directly affected by session work
  - commit creation when uncommitted changes exist
  - deploy when a documented deploy path exists
  - repo-owned task cleanup
- require approval:
  - new or edited typed note under `~/.codex/projects/<slug>/memory/`
  - repo `AGENTS.md` edits
  - `~/.codex/AGENTS.md` edits
  - new skill or skill-spec creation
- always ask explicitly:
  - push to remote

`wrap-up` may surface typed-note, repo-`AGENTS.md`, global-`AGENTS.md`, or skill candidates, but it must not create or edit them automatically without approval.

### Phase 3: `Review & Apply`

Analyze the current session for self-improvement findings.

Only say `Nothing to improve` when the session was genuinely short or purely informational.

Finding categories:

- `Skill gap`
- `Friction`
- `Knowledge`
- `Automation`

Action types:

- repo doc update
- typed note candidate
- repo `AGENTS.md` candidate
- global `~/.codex/AGENTS.md` candidate
- skill candidate
- no action needed

Rules:

- prioritize repeated violation of an existing rule over inventing a new rule
- strengthen existing guidance before proposing a parallel duplicate
- auto-apply only actions allowed by the approval matrix
- present approval-gated items as targeted proposals with destination and rationale

Present findings in two sections:

- `Findings (applied)`
- `No action needed`

### Phase 4: `Diary Capture`

After Phases 1-3 are complete, always invoke the installed sibling skill at `../diary/SKILL.md`.

Rules:

- this step always runs
- `wrap-up` must not fold reflection logic into the diary step
- `diary` still runs when the personal extension is absent
- `diary` still runs when approval-gated durable changes were declined
- `diary` still runs when some wrap-up steps were skipped with documented fallback status

### Final Step: Push

After the four phases are complete, ask:

`Push to remote? (y/n)`

- if yes, push committed changes
- if no or no response, skip

## Typed Note Policy

When a durable-learning candidate belongs in project memory, use [`docs/typed-memory-notes.md`](../../docs/typed-memory-notes.md):

- `project_*.md`: stable project facts, invariants, storage layout, architecture, or repo-specific conventions
- `feedback_*.md`: repeated lessons or guardrails that future work in this project should follow
- `reference_*.md`: supporting reference material such as routing maps, glossaries, checklists, or lookup-oriented context
- `user_*.md`: stable recurring user or project preferences that materially affect execution

Avoid proposing a new typed note when:

- the observation is one-off or still uncertain
- the information belongs in the `Current State` snapshot or next steps only
- an existing typed note can be strengthened instead
- repo docs, `AGENTS.md`, or a skill would be the clearer long-term owner

## Missing-Surface Fallback Rules

- if no `/commit` skill exists, use normal git commands directly
- if the working directory is not a git repository, skip commit and push with `n/a`
- if no documented deploy script or deploy skill exists, skip deploy without asking for a manual deploy
- if no repo task file or documented task surface exists, skip task cleanup and state that no project task surface was found
- if file placement conventions are not documented, only correct obvious misplaced document files and avoid speculative renames or moves
- if a required approval is denied, report the skipped step and continue the remaining phases

## Final Report

End with a concise report that states:

- what was shipped or explicitly skipped
- what was captured in `MEMORY.md`
- whether the optional personal extension ran, was absent, or stopped short
- that `diary` was run
- any open risks
- any approval-gated durable candidates that remain

## Verification Checklist

Before treating this skill spec as correct, verify that:

- the high-level phase structure is `Ship It` -> `Remember It` -> `Review & Apply` -> `Diary Capture` -> push confirmation
- runtime storage paths point only to `~/.codex/...` and `~/.agents/skills/...`
- the destination mapping matches the parity design
- the approval matrix and fallback rules are explicit
- `diary` cannot be skipped by a missing personal extension or declined durable edits
- the session-number source of truth is `MEMORY.md` with diary fallback only when needed
