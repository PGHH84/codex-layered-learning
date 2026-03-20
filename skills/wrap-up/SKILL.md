---
name: wrap-up
description: Use when the user says "wrap up", "close session", "end session", "wrap things up", "close out this task", or invokes /wrap-up. Runs the Codex Layered Learning immediate loop: inspect the session, update project memory, and trigger diary.
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

- Never write to `~/.claude/**`
- Never install Claude-compatible hooks, commands, skills, or runtime files
- Never create repo-local runtime memory folders in working repositories
- Keep runtime memory only under `~/.codex/`
- Never auto-commit, auto-push, auto-deploy, auto-rename, auto-move, or do destructive cleanup
- Never make automatic durable instruction changes

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
4. Trigger `diary` using the contract in [`commands/diary.md`](../../commands/diary.md).
5. Report optional promotion candidates and follow-ups without applying them.

## Session Inspection Rules

- Treat the active conversation as the primary source of truth
- Use shell or git inspection only to tighten accuracy
- If project identity is ambiguous, ask one direct question before writing memory
- Use `n/a` for git metadata when the working directory is not inside a git repository

## Project Memory Update Rules

Project memory lives at `~/.codex/projects/<slug>/memory/MEMORY.md`.

When updating `MEMORY.md`:

- keep `## Current State` to a short 2-5 line snapshot
- update `**Last updated:**` and `**Session:**`
- keep `**Next steps:**` as a short numbered list
- keep `## Key Notes` as an index of durable note files, not a second diary
- prefer linking existing durable notes instead of inventing new ones during wrap-up
- create `MEMORY.md` if missing, using the structure shown in [`examples/sample-memory.md`](../../examples/sample-memory.md)

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

## What Must Never Happen Automatically

- writing runtime memory into the working repository
- writing anything under `~/.claude/`
- creating or editing repo `AGENTS.md`, global `~/.codex/AGENTS.md`, or new skills without approval
- creating new durable typed notes as a side effect of wrap-up unless the user explicitly approves that promotion
- commit, push, deploy, rename, move, or destructive cleanup

## Final Report

End with a concise report that states:

- what was captured in project memory
- that `diary` was run
- any open risks
- any durable promotion candidates that need approval

## Verification Checklist

Before treating this skill spec as correct, verify that:

- the execution order is inspect session -> update project memory -> trigger `diary` -> report promotions
- the safety boundaries forbid repo-local memory, `.claude` writes, auto shipping actions, and automatic durable instruction changes
- the memory update guidance stays consistent with [`examples/sample-memory.md`](../../examples/sample-memory.md)
