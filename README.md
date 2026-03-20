# Codex Layered Learning

A file-first layered memory system for Codex that captures session history, retains durable project knowledge, and proposes reusable best practices over time.

## Safety Boundary

This project is intentionally isolated from Claude Code.

- No writes to `~/.claude/**`
- No Claude-compatible hooks, commands, or runtime files
- No repo-local runtime memory folders in working repositories
- Runtime memory lives only under `~/.codex/`

All Claude-compatible functionality remains in `Claude-Layered-Learning`.

## Architecture

The system keeps the same two-loop shape as Claude Layered Learning, but routes everything through Codex-native storage and approval-gated promotion targets.

- Immediate loop: `wrap-up` inspects the session, updates project memory, and always triggers `diary`
- Observation layer: `diary` writes structured session records to a centralized diary corpus
- Deferred loop: `reflect` mines the diary corpus, prior reflections, and project memory to identify repeated patterns
- Promotion layer: `reflect` proposes updates to global `AGENTS.md`, project docs, project memory, or new skills, but never applies durable changes without approval

## Runtime Storage

```text
~/.codex/
  AGENTS.md
  memory/
    diary/
    reflections/
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

## Core Rules

- Project memory is project-scoped under `~/.codex/projects/<slug>/memory/`
- Diary entries are centralized under `~/.codex/memory/diary/`
- Reflections are centralized under `~/.codex/memory/reflections/`
- `reflect` supports all-project and project-filtered analysis by metadata, not by folder layout
- Markdown is the source of truth in v1
- Any future SQLite or MCP layer is an index, not the canonical store

## Commands

- `wrap-up`: closes the session, updates project memory, and triggers `diary`
- `diary`: standalone structured session capture
- `reflect`: standalone cross-session synthesis and promotion proposal

## Implemented Specs

- [`commands/diary.md`](commands/diary.md): command contract, capture rules, and exact diary template
- [`commands/reflect.md`](commands/reflect.md): reflection filters, routing rules, `processed.log` behavior, and exact reflection template
- [`skills/wrap-up/SKILL.md`](skills/wrap-up/SKILL.md): immediate-loop skill definition for memory update plus automatic `diary` invocation

## Status

This repository currently contains the initial design, implementation plan, examples, and the first v1 operational specs.

- Design: `docs/specs/2026-03-20-codex-layered-learning-design.md`
- Plan: `docs/plans/2026-03-20-codex-layered-learning-v1.md`
- Examples: `examples/`
- Commands: `commands/`
- Skills: `skills/`
