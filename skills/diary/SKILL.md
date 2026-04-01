---
name: diary
description: Use when the user asks to capture a session diary entry, record fresh work context, write a project diary, or explicitly says diary, write diary, or capture session notes for Codex Layered Learning
---

# Codex Layered Learning Diary

## Runtime authority

This skill is the runtime source of truth for `diary`.

- `commands/diary.md` is a reference-only summary
- behavioral changes must land here first and then be synchronized into installed copies under `~/.agents/skills/`

## Purpose

`diary` captures a structured session record while context is still fresh.

- it can run standalone
- `wrap-up` must always invoke it after updating project memory
- it is the observation layer, not the analysis layer

## Safety Boundaries

- never create repo-local runtime memory folders in working repositories
- never perform reflection, confidence scoring, or promotion routing inside `diary`
- never copy secrets, tokens, keys, cookies, credentials, or other highly sensitive raw values into the diary entry
- replace sensitive values with short descriptions such as `[redacted token]` or `[sensitive customer data omitted]`

## Runtime Paths

- diary output: `~/.codex/memory/diary/YYYY-MM-DD-<project-slug>-session-N.md`
- project memory that may already exist: `~/.codex/projects/<slug>/memory/MEMORY.md`

## Session Number Source of Truth

Use one source of truth for the session number so `wrap-up` and standalone `diary` do not diverge.

- preferred source of truth: `~/.codex/projects/<slug>/memory/MEMORY.md`
- fallback: scan matching diary files for the same project and date only when `MEMORY.md` is missing or uninitialized
- if `wrap-up` already updated `MEMORY.md`, reuse that session number instead of incrementing again
- include a `Session ID` line only when a runtime session identifier is actually available

## Path-To-Slug Transform

Use this exact transform so `diary`, `wrap-up`, and `reflect` agree on project identity:

1. If inside a git repository, resolve the canonical project root with `git rev-parse --show-toplevel`.
2. If that repo root contains `/.worktrees/`, strip the `/.worktrees/<name>` suffix and use the parent repo path as the canonical project root.
3. Otherwise, if not inside a git repository, use the canonical absolute working directory.
4. Resolve symlinks before deriving the slug.
5. Replace every `/` in the canonical absolute path with `-`.

Example:

- `/Users/example/Developer/OneNote-To-Notion`
- `-Users-example-Developer-OneNote-To-Notion`

## Inputs

- current conversation context as the primary evidence source
- canonical project root path and derived slug
- optional repository context such as changed files, branch name, and verification commands
- existing diary entries for the same date and project slug so the next session number can be chosen
- session logs only when conversation context is incomplete and the missing detail matters

## Workflow

1. Determine the canonical project root, shared path-derived slug, and next session number.
2. Inspect the current conversation first.
3. Pull in repository state only when it improves accuracy:
   - branch name
   - changed files
   - verification commands and outcomes
4. Use logs only if a required section would otherwise be incomplete.
5. If context is still incomplete, say so explicitly instead of inventing details.
6. Redact or summarize sensitive values before writing.
7. Capture only stable user preferences that materially affect future execution.
8. Write the diary entry to `~/.codex/memory/diary/`.

## Required Sections

Every diary entry must include:

- `Task Summary`
- `Time`
- `Work Summary`
- `Design Decisions Made`
- `Actions Taken`
- `Challenges Encountered`
- `Solutions Applied`
- `User Preferences Observed`
- `Code Patterns and Decisions`
- `Context and Technologies`
- `Notes`

Within `Actions Taken`, always cover:

- files created
- files edited
- commands executed
- verification performed

Within `User Preferences Observed`, always include:

- `Communication & Workflow`
- `Code Quality Preferences`
- `Technical Preferences`

Capture only preferences that are stable enough to help future sessions. Do not record one-off phrasing or low-signal stylistic noise.

## Fallback Rules

- if context is incomplete, prefer explicit incompleteness over guessed details
- if no session identifier is available, omit `Session ID`
- if no branch is available, use `n/a`
- if a section has limited evidence, mark the limits plainly in that section instead of fabricating precision

## Exact Template

```md
# Session Diary Entry

**Date**: YYYY-MM-DD
**Time**: HH:MM:SS
**Project**: <canonical absolute project root path>
**Git Branch**: <branch or n/a>
**Session**: N
**Session ID**: <optional when available>

## Task Summary
...

## Time
- Session timing:
- Sequence or milestones:

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

### Code Quality Preferences
- ...

### Technical Preferences
- ...

## Code Patterns and Decisions
- ...

## Context and Technologies
- ...

## Notes
- ...
```

## Standalone vs `wrap-up`

- standalone `diary` writes the session record directly from the current context
- `wrap-up` must invoke `diary` after updating `~/.codex/projects/<slug>/memory/MEMORY.md`
- the same path-derived slug must be used in both flows
- `wrap-up` and `diary` must use the same session number when they run in one closeout flow

## Verification Checklist

Before treating this skill as correct, verify that:

- the path-to-slug transform is explicit and shared with `wrap-up` and `reflect`
- worktree roots collapse to the main repo identity before slugging
- the diary output path stays under `~/.codex/memory/diary/`
- the required sections match the exact template
- the skill remains context-first and uses logs only as fallback
- `commands/diary.md` clearly defers runtime behavior to this skill
- the session number source of truth, fallback, session ID handling, and redact guidance are explicit
