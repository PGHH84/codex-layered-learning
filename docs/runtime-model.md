# Codex Runtime Model

Codex Layered Learning uses a file-first model:

- session closure runs through `wrap-up`
- raw session capture is stored by `diary`
- cross-session synthesis runs through `reflect`

Machine-local runtime state lives outside the repo:

- `~/.codex/memory/diary/`
- `~/.codex/memory/reflections/`
- `~/.codex/projects/<slug>/memory/`
- `~/.agents/skills/`

Shared global guidance is synchronized from `~/.agents/global/PROJECT.md` into the generated runtime mirrors at `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md`.
