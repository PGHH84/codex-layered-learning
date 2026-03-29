# Codex-Layered-Learning — Project Instructions

## Orientation Trigger

If the user says `orient yourself` or asks for context, read the nearest
relevant `Start-Here.md` first if one exists; otherwise read this file and
summarize the current project context before doing substantive work.

## Project

A file-first layered learning system for Codex and OpenAI-oriented coding runtimes. `wrap-up` captures the immediate session state, `diary` records a structured session entry, and `reflect` analyzes accumulated entries to propose durable improvements without auto-applying them.

## Structure

```text
skills/
  wrap-up/
    SKILL.md
  diary/
    SKILL.md
  reflect/
    SKILL.md
commands/
  diary.md
  reflect.md
examples/
  personal.md
  sample-diary-entry.md
  sample-memory.md
  sample-reflection.md
scripts/
  install_codex_layered_learning.sh
  verify_codex_layered_learning_install.sh
tests/
  fixtures/
  manual-verification.md
```

## Key Rules

- Runtime authority lives in `skills/`. Behavioral changes land there first.
- `commands/` are reference-only summaries, not the behavior owner.
- After changing any runtime skill, rerun:
  - `bash scripts/install_codex_layered_learning.sh`
  - `bash scripts/verify_codex_layered_learning_install.sh`
- Public docs and examples must stay aligned with the runtime skills.
- Keep the repo isolated from Claude runtime surfaces:
  - no writes to `~/.claude/**`
  - no Claude hooks, commands, skills, or runtime files
- Do not commit live runtime memory from `~/.codex/`.
- Keep `examples/personal.md` redacted and shareable. Live personal machine-local files do not belong in the repo.
- When public behavior changes, update `CHANGELOG.md` and keep semver release notes coherent.

## Publication Hygiene

- Prefer generic example paths such as `/Users/example/...` when a concrete absolute path helps explain behavior.
- Keep real runtime-path contracts literal where they matter:
  - `~/.codex/...`
  - `~/.agents/skills/...`
  - `~/.claude/**` safety boundaries
- Do not let examples drift into one private workflow unless the file is explicitly described as a private machine-local pattern.
