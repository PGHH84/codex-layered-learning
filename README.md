# Codex Layered Learning

A file-first layered learning system for Codex and OpenAI coding runtimes. It preserves session context, keeps durable project knowledge under `~/.codex/`, and proposes reusable improvements over time without auto-applying them.

## Who It Is For

This repo is for Codex-oriented coding workflows:

- Codex desktop
- Codex CLI
- IDE or API-driven OpenAI coding setups that can use the same local skill files and runtime storage model

It is not a ChatGPT project, and it is intentionally separate from Claude-specific runtime surfaces.

## Safety Boundary

This project is intentionally isolated from Claude Code.

- No writes to `~/.claude/**`
- No Claude-compatible hooks, commands, or runtime files
- No repo-local runtime memory folders in working repositories
- Runtime memory lives only under `~/.codex/`

Claude-compatible functionality remains in the separate Claude Layered Learning repository.

## How It Works

The system has two learning loops:

**Immediate loop:** `wrap-up` inspects the current session, updates project memory, optionally follows `~/.codex/skills/wrap-up/personal.md`, reconciles final state if needed, and always triggers `diary`.

**Deferred loop:** `reflect` analyzes accumulated diary entries, prior reflections, and project memory to identify repeated patterns and propose durable promotions.

```text
Session work
    |
    v
wrap-up (immediate loop)
    |-- inspect current session
    |-- update project MEMORY.md
    |-- optionally follow personal.md
    |-- reconcile final project state
    |-- trigger diary
    |-- report promotion candidates only
    |
    v
diary (observation layer)
    |-- standalone or wrap-up-triggered
    |-- structured session capture
    |-- saved to ~/.codex/memory/diary/
    |
    v
reflect (pattern layer)
    |-- cross-session analysis
    |-- routing by project/global scope
    |-- proposal-only durable promotions
    |-- saved to ~/.codex/memory/reflections/
```

## What Each Loop Can Touch

| Destination | Immediate loop (`wrap-up`) | Deferred loop (`reflect`) |
|---|---|---|
| Project `MEMORY.md` | Yes | Reads only |
| Central diary | Triggers `diary` | Reads |
| Central reflections | No | Yes |
| Project typed notes | Proposal only | Proposal only |
| Repo docs / repo `AGENTS.md` | No automatic edits | Proposal only, approval-gated |
| Global `~/.codex/AGENTS.md` | No automatic edits | Proposal only, approval-gated |
| `~/.codex/skills/wrap-up/personal.md` | Optional machine-local extension | No |

## Runtime Authority

The runtime source of truth is the repository skill set under `skills/`:

- [`skills/wrap-up/SKILL.md`](skills/wrap-up/SKILL.md)
- [`skills/diary/SKILL.md`](skills/diary/SKILL.md)
- [`skills/reflect/SKILL.md`](skills/reflect/SKILL.md)

Supporting rules:

- installed runtime copies under `~/.agents/skills/` must stay synchronized from those repository skill files
- `commands/*.md` are reference-only summaries, not the behavior owner
- behavioral changes land in the runtime skills first, then supporting docs, examples, and scripts

## Quickstart

```bash
git clone https://github.com/PGHH84/codex-layered-learning.git
cd codex-layered-learning
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```

Then in your Codex/OpenAI coding workflow:

- use `wrap-up` at the end of a session
- use `diary` when you want standalone session capture
- use `reflect` when you want to analyze diary entries over time

If your runtime does not auto-discover installed skills under `~/.agents/skills/`, use the repo or installed `SKILL.md` files directly as local instructions.

For the full operational guide, see [INSTALL.md](INSTALL.md).

## Runtime Storage

```text
~/.codex/
  AGENTS.md
  skills/
    wrap-up/
      personal.md            # optional, machine-local
  memory/
    diary/
      YYYY-MM-DD-<project-slug>-session-N.md
    reflections/
      YYYY-MM-DD-reflection-N.md
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

Core rules:

- project memory is scoped under `~/.codex/projects/<slug>/memory/`
- diary entries are centralized under `~/.codex/memory/diary/`
- reflections are centralized under `~/.codex/memory/reflections/`
- `processed.log` uses the canonical accepted-entry format: `<diary-filename> | <processed-date> | <reflection-filename> | accepted`
- typed project memory notes use the `feedback_*.md`, `project_*.md`, `reference_*.md`, and `user_*.md` taxonomy described in [`docs/typed-memory-notes.md`](docs/typed-memory-notes.md)
- markdown is the source of truth in v1
- any future database or MCP layer is an index, not the canonical store

## Optional Personal Wrap-Up Extension

`wrap-up` can optionally read:

```text
~/.codex/skills/wrap-up/personal.md
```

This file is:

- machine-local and private to your setup
- separate from the installed runtime skill copies under `~/.agents/skills/`
- an instruction file, not a repository skill or override mechanism
- optional: if it is absent, `wrap-up` continues normally

Guardrails:

- `wrap-up` should leave `MEMORY.md` reflecting the final post-extension state before `diary`
- personal-extension edits should stay scoped to the named files, entries, fields, or sections
- if the instruction defines exact allowed values or formats, `wrap-up` should use one of those exact values or report the step as incomplete instead of guessing
- core safety rules still win, including no writes to `~/.claude/**`, no repo-local runtime memory, and no repo-file edits unless explicitly requested in-session
- if the file is present but blocked or unclear, `wrap-up` still runs `diary`

Use the redacted template in [examples/personal.md](examples/personal.md) as a starting point.

## Commands And Skills

- `wrap-up`: runtime behavior lives in [`skills/wrap-up/SKILL.md`](skills/wrap-up/SKILL.md)
- `diary`: reference summary in [`commands/diary.md`](commands/diary.md), runtime behavior in [`skills/diary/SKILL.md`](skills/diary/SKILL.md)
- `reflect`: reference summary in [`commands/reflect.md`](commands/reflect.md), runtime behavior in [`skills/reflect/SKILL.md`](skills/reflect/SKILL.md)

## Context-Loss Fallback

Context-loss recovery is manual-only in v1.

- No safe Codex-native end-of-session or compaction trigger surface was confirmed from the inspected runtime
- Recovery falls back to `~/.codex/projects/<slug>/memory/MEMORY.md` first, then recent session/history artifacts under `~/.codex/` if needed
- Future automation remains deferred until a stable Codex-native trigger surface or explicit user-managed automation flow is available

## Repository Contents

- [`skills/`](skills): runtime source of truth for `wrap-up`, `diary`, and `reflect`
- [`commands/`](commands): reference-only summaries for `diary` and `reflect`
- [`examples/`](examples): sample outputs and redacted templates
- [`docs/`](docs): specs, plans, and typed-memory guidance
- [`scripts/`](scripts): install and verification helpers
- [`tests/`](tests): fixtures and manual verification coverage

## Built On

This project directly reuses and extends work by others. Huge kudos to:

- **[PGHH84/claude-layered-learning](https://github.com/PGHH84/claude-layered-learning)** — the closest conceptual predecessor and the main repository reference for the Codex adaptation, public documentation shape, and separation of immediate vs deferred learning loops.
- **[rlancemartin/claude-diary](https://github.com/rlancemartin/claude-diary)** — the original diary/reflect pattern and processed-entry tracking model. The diary template, reflection workflow, processed-entry indexing, and the broader observe-reflect-retrieve architecture originate here. Lance's [blog post](https://rlancemartin.github.io/2025/12/01/claude_diary/) on the Generative Agents paper and CoALA framework is still the clearest explanation of why this approach works.
- **[PR #3](https://github.com/rlancemartin/claude-diary/pull/3) by [thebenlamm](https://github.com/thebenlamm)** — the global vs project-specific routing framework that informed how `reflect` classifies durable candidates by scope.
- **[jonathanmalkin/jules](https://github.com/jonathanmalkin/jules)** and his **[Reddit post](https://www.reddit.com/r/ClaudeCode/comments/1r89084/comment/o9sv777/?context=3)** — the original wrap-up skill concept that inspired the immediate loop. The idea of closing a session by shipping, remembering, and reviewing comes from that work.

What this repository adds: a Codex-native runtime layout under `~/.codex/`, skill-first runtime authority, approval-gated durable promotions, project-scoped typed memory notes, install/verification scripts, and a Codex-native machine-local `personal.md` extension surface.

## Status

This repository contains the Codex-native v1 runtime skills, examples, verification fixtures, release docs, and maintenance scripts.

See also:

- [INSTALL.md](INSTALL.md)
- [CHANGELOG.md](CHANGELOG.md)
- [docs/typed-memory-notes.md](docs/typed-memory-notes.md)
- [docs/specs/2026-03-20-codex-layered-learning-design.md](docs/specs/2026-03-20-codex-layered-learning-design.md)

## License

MIT License — see [LICENSE](LICENSE).
