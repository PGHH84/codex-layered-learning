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

## Runtime authority

- The runtime source of truth is the repository skill set under `skills/`, especially `skills/wrap-up/SKILL.md`, `skills/diary/SKILL.md`, and `skills/reflect/SKILL.md`
- Installed runtime copies under `~/.agents/skills/` must stay synchronized from those repository skill files
- `commands/*.md` are retained as reference docs only; they summarize purpose and data shape but do not own behavior
- Behavioral changes must land in the runtime skills first, then supporting docs, examples, and scripts can be updated to match

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

- Project memory is project-scoped under `~/.codex/projects/<slug>/memory/`, where `<slug>` is derived from the canonical project root path rather than the working-directory basename
- Diary entries are centralized under `~/.codex/memory/diary/`
- Reflections are centralized under `~/.codex/memory/reflections/`
- `processed.log` uses one canonical accepted-entry format: `<diary-filename> | <processed-date> | <reflection-filename> | accepted`
- Typed project memory notes use the `feedback_*.md`, `project_*.md`, `reference_*.md`, and `user_*.md` taxonomy described in [`docs/typed-memory-notes.md`](docs/typed-memory-notes.md)
- `reflect` supports all-project and project-filtered analysis by metadata, not by folder layout
- technology-specific patterns can become global when they repeat across multiple projects; technology-specific patterns limited to one project stay project-specific
- Markdown is the source of truth in v1
- Any future SQLite or MCP layer is an index, not the canonical store

## Reference Command Docs

- `wrap-up`: runtime behavior lives in `skills/wrap-up/SKILL.md`
- `diary`: reference summary in [`commands/diary.md`](commands/diary.md), runtime behavior in [`skills/diary/SKILL.md`](skills/diary/SKILL.md)
- `reflect`: reference summary in [`commands/reflect.md`](commands/reflect.md), runtime behavior in [`skills/reflect/SKILL.md`](skills/reflect/SKILL.md)

## Runtime Skills

- [`skills/wrap-up/SKILL.md`](skills/wrap-up/SKILL.md): installed `wrap-up` skill for Codex
- [`skills/diary/SKILL.md`](skills/diary/SKILL.md): installed `diary` skill for standalone or delegated diary capture
- [`skills/reflect/SKILL.md`](skills/reflect/SKILL.md): installed `reflect` skill for deferred synthesis

## Installation

Initial install:

```bash
bash scripts/install_codex_layered_learning.sh
```

Reinstall or update:

- Rerun `bash scripts/install_codex_layered_learning.sh`
- The installer is idempotent and refreshes `~/.agents/skills/` from the repository runtime skills

Verification:

```bash
bash scripts/verify_codex_layered_learning_install.sh
```

Uninstall or manual cleanup:

- Remove the installed skill copies under `~/.agents/skills/{wrap-up,diary,reflect}` only if you explicitly want to disable the runtime skills
- Remove `~/.codex/memory/diary/`, `~/.codex/memory/reflections/`, or `~/.codex/projects/` only as an explicit manual cleanup action if you intend to delete runtime memory
- No destructive cleanup is performed automatically by this repository

## Context-Loss Fallback

Context-loss recovery is manual-only in v1.

- No safe Codex-native end-of-session or compaction trigger surface was confirmed from the inspected local runtime
- Recovery falls back to `~/.codex/projects/<slug>/memory/MEMORY.md` first, then recent session/history artifacts under `~/.codex/` if needed
- Future automation is optional, but it remains deferred until a stable Codex-native trigger surface or explicit user-managed automation flow is available

## Implemented Specs

- [`skills/wrap-up/SKILL.md`](skills/wrap-up/SKILL.md): runtime source of truth for the immediate loop, project memory update, and automatic `diary` invocation
- [`skills/diary/SKILL.md`](skills/diary/SKILL.md): runtime source of truth for standalone and delegated diary capture
- [`skills/reflect/SKILL.md`](skills/reflect/SKILL.md): runtime source of truth for deferred synthesis and promotion proposal behavior
- [`commands/diary.md`](commands/diary.md): reference-only diary summary and data-shape guide
- [`commands/reflect.md`](commands/reflect.md): reference-only reflection summary and output-shape guide
- [`docs/typed-memory-notes.md`](docs/typed-memory-notes.md): naming, routing, and anti-pattern guidance for typed project memory notes
- [`docs/specs/2026-03-20-codex-context-loss-fallback.md`](docs/specs/2026-03-20-codex-context-loss-fallback.md): manual-only context-loss fallback decision
- [`scripts/verify_codex_layered_learning_install.sh`](scripts/verify_codex_layered_learning_install.sh): install and sync verification for the runtime skill copies and `~/.codex/` directories

## Status

This repository now contains the v1 runtime skills, reference docs, hardening guidance, verification fixtures, and install-maintenance scripts.

- Design: `docs/specs/2026-03-20-codex-layered-learning-design.md`
- Hardening plan: `docs/plans/2026-03-20-codex-layered-learning-v1-1-hardening.md`
- Tests: `tests/`
- Scripts: `scripts/`
- Examples: `examples/`
- Commands: `commands/`
- Skills: `skills/`
