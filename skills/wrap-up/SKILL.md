---
name: wrap-up
description: Use when the user says "wrap up", "close session", "end session", "wrap things up", "close out this task", or invokes /wrap-up for end-of-session closeout of the current Codex task
---

# Codex Layered Learning Wrap-Up

## Purpose

`wrap-up` is the immediate loop entry point for Codex Layered Learning. It preserves fresh session context before it is lost by updating project memory and then invoking `diary`.

## Non-Goals

- Reflecting across multiple sessions
- Applying durable promotions automatically
- Editing repo instructions or global instructions without approval
- Performing shipping actions such as commit, push, deploy, rename, move, or cleanup

## Hard Safety Boundaries

- Never install agent-specific hooks, commands, or runtime files without approval
- Never create repo-local runtime memory folders in working repositories
- Never auto-commit, auto-push, auto-deploy, auto-rename, auto-move, or do destructive cleanup
- Never make automatic durable instruction changes

## Runtime Paths

- Project memory: `~/.codex/projects/<slug>/memory/MEMORY.md`
  (symlinked → `~/.claude/projects/<slug>/memory/MEMORY.md` — shared with Claude Code)
- Central diary: `~/.agents/memory/diary/` (shared — read by both agents' reflect)
- Central reflections: `~/.agents/memory/reflections/`
- Optional personal extension: `~/.codex/skills/wrap-up/personal.md`

## Optional Personal Extension

`~/.codex/skills/wrap-up/personal.md` is an optional machine-local instruction file for private post-memory-update steps.

- it is separate from the installed runtime skills under `~/.agents/skills/`
- it is an extension point, not an override mechanism
- normal Codex approval and safety rules still apply
- if the file is absent, `wrap-up` continues with no warning noise
- if its instructions are unclear, blocked, or not approved, report that briefly and continue to `diary`
- keep edits scoped to the named files, entries, fields, or sections instead of broadening them to unrelated metadata
- when it constrains a field to exact values or formats, use one of those exact values or report the step as incomplete instead of guessing

## Trigger Phrases

Run this skill when the user says things like:

- `wrap up`
- `close session`
- `end session`
- `wrap things up`
- `close out this task`
- `/wrap-up`

## Execution Sequence

Run these steps in order:

1. Inspect the current session context first.
2. Inspect repository state only when it improves the summary:
   - changed files
   - verification commands and results
   - current branch, if any
3. Update `~/.codex/projects/<slug>/memory/MEMORY.md`.
4. Check for `~/.codex/skills/wrap-up/personal.md`.
5. If present, follow it as a machine-local instruction file under the normal Codex approval and safety rules.
6. If the personal-extension pass materially changed tracked project state or completed a pending wrap-up follow-up, reconcile `~/.codex/projects/<slug>/memory/MEMORY.md` so it reflects the final post-extension state.
7. Trigger `diary` using the installed sibling skill at `../diary/SKILL.md`.
8. Report optional promotion candidates and follow-ups without applying them.

## Session Inspection Rules

- Treat the active conversation as the primary source of truth
- Use shell or git inspection only to tighten accuracy
- If project identity is ambiguous, ask one direct question before writing memory
- Use `n/a` for git metadata when the working directory is not inside a git repository
- Derive `<slug>` from the canonical project root path using the same deterministic path-to-slug transform as `diary` and `reflect`
- Never use only the working-directory basename as the project slug

### Path-To-Slug Transform

Use this exact transform so all three skills agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. Otherwise, use the canonical absolute working directory.
3. Resolve symlinks before deriving the slug.
4. Replace every `/` in the canonical absolute path with `-`.

Example:

- `/Users/example/Developer/OneNote-To-Notion`
- `-Users-example-Developer-OneNote-To-Notion`

## Project Memory Update Rules

Project memory lives at `~/.codex/projects/<slug>/memory/MEMORY.md`, using the shared path-derived slug for the project root.

When updating `MEMORY.md`:

- keep `## Current State` to a short 2-5 line snapshot
- update `**Last updated:**` and `**Session:**`
- keep `**Next steps:**` as a short numbered list
- keep `## Key Notes` as an index of durable note files, not a second diary
- prefer linking existing durable notes instead of inventing new ones during wrap-up
- after the optional personal-extension pass, refresh `Current State` and `Next steps` when needed so `MEMORY.md` reflects the final post-extension state instead of a stale pre-extension snapshot
- create `MEMORY.md` if missing, using this structure:

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

## Session Number Source of Truth

The project memory file is the source of truth for the session number.

- preferred source of truth: `~/.codex/projects/<slug>/memory/MEMORY.md`
- fallback: scan matching diary files for the same project and date only when `MEMORY.md` is missing or uninitialized
- `wrap-up` must set or confirm the session number in `MEMORY.md` before triggering `diary`
- when `wrap-up` invokes `diary`, both steps must use the same session number instead of incrementing independently

## Typed Note Policy

When `wrap-up` surfaces a durable-learning candidate, use the typed memory policy in [`docs/typed-memory-notes.md`](../../docs/typed-memory-notes.md) to decide whether a typed note is warranted.

- `project_*.md`: stable project facts, invariants, storage layout, architecture, or repo-specific conventions
- `feedback_*.md`: repeated lessons or guardrails that future work in this project should follow
- `reference_*.md`: supporting reference material such as routing maps, glossaries, checklists, or lookup-oriented context
- `user_*.md`: stable recurring user or project preferences that materially affect execution

Avoid proposing a new typed note when:

- the observation is one-off or still uncertain
- the information belongs in the `Current State` snapshot or next steps only
- an existing typed note can be strengthened instead
- repo docs, `AGENTS.md`, or a skill would be the clearer long-term owner

`wrap-up` may mention a typed note candidate, but it must not create the note automatically.

## Promotion Reporting Levels

When reporting durable follow-ups, keep the recommendation at the right level:

- mention candidate only: the signal is worth noting but does not yet justify a durable edit
- propose creating a typed note: the evidence fits project memory and the note type is clear
- propose editing repo docs: the learning belongs in repository documentation that already owns the subject
- propose editing `AGENTS.md`: the learning is a repeated operating rule for repo-level or global agent behavior

All four are proposals only. `wrap-up` does not apply durable edits automatically.

## What To Summarize

The wrap-up summary should cover:

- completed work
- verification performed
- open risks or unresolved questions
- durable-learning candidates worth considering later

## Diary Trigger

`wrap-up` must always invoke `diary` after the project memory update succeeds.

- `diary` may also run standalone
- the diary entry should use current conversation context first
- `wrap-up` must not fold reflection or promotion logic into the diary step
- after the memory update, any optional personal-extension pass, and any required memory reconciliation, open and follow the installed sibling skill at `../diary/SKILL.md`
- `diary` still runs when the personal extension is absent
- `diary` still runs when the personal extension is only partially completed because its instructions were unclear, blocked, or not approved

## Personal Extension Guardrails

When `wrap-up` encounters `~/.codex/skills/wrap-up/personal.md`:

- treat it as a machine-local instruction file, not a shell script or repository skill
- do not let it override the core `wrap-up` contract or safety boundaries
- keep normal approval rules in force for any action it requests
- only edit the file, entry, fields, or sections named by the instruction
- do not modify unrelated headers, summaries, or metadata unless the instruction explicitly says to
- when an instruction constrains a field to exact values or formats, use one of those exact values; if the correct value cannot be chosen without guessing, report that step as incomplete and continue
- never write to `~/.claude/**`
- never create repo-local runtime memory
- never edit repo files unless the user explicitly requested that in the session
- never auto-commit, auto-push, auto-deploy, auto-rename, auto-move, or do destructive cleanup unless the user explicitly requested it in the session

## What Must Never Happen Automatically

- writing runtime memory into the working repository
- writing anything under `~/.claude/`
- creating or editing repo `AGENTS.md`, global `~/.codex/AGENTS.md`, or new skills without approval
- editing repo files unless the user explicitly requested that in the session
- creating new durable typed notes as a side effect of wrap-up unless the user explicitly approves that promotion
- commit, push, deploy, rename, move, or destructive cleanup

## Final Report

End with a concise report that states:

- what was captured in project memory
- whether the optional personal extension ran, was absent, or stopped short
- that `diary` was run
- any open risks
- any durable promotion candidates that need approval

## Verification Checklist

Before treating this skill spec as correct, verify that:

- the execution order is inspect session -> update project memory -> check optional personal extension -> reconcile project memory if needed -> trigger `diary` -> report promotions
- the execution order includes a memory reconciliation pass when the personal extension materially changes tracked state
- the safety boundaries forbid repo-local memory, `.claude` writes, auto shipping actions, and automatic durable instruction changes
- the optional personal extension path and its separation from installed runtime skills are explicit
- the optional personal extension cannot skip `diary` or weaken approval rules
- the optional personal extension stays within its named edit scope and does not invent alternative exact field values
- the memory update guidance includes the inline `MEMORY.md` structure and the shared path-to-slug transform
- the typed note policy covers `feedback_*.md`, `project_*.md`, `reference_*.md`, and `user_*.md`
- the session number source of truth and fallback are explicit
