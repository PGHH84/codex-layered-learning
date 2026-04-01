# Codex Layered Learning

Codex Layered Learning is a file-first learning system for Codex and OpenAI coding runtimes. It gives you an end-of-session `wrap-up` workflow, standalone `diary` capture, and a cross-session `reflect` pass that turns repeated lessons into durable local or global guidance.

## What You Get

- runtime skills for `wrap-up`, `diary`, and `reflect`
- install and verification scripts for Codex-style local skill setups
- shareable examples and memory-note conventions
- a Codex-facing repo guide in [`AGENTS.md`](AGENTS.md)
- release notes in [`CHANGELOG.md`](CHANGELOG.md)

## Runtime Model

The system has two loops:

- `wrap-up` closes a session, captures durable project memory, and triggers diary capture
- `reflect` analyzes accumulated diary entries and proposes durable guidance updates

Runtime state stays machine-local:

- Codex memory and reflections live under `~/.codex/`
- installed skills live under `~/.agents/skills/`
- shared global guidance is synchronized from `~/.agents/global/PROJECT.md`

The public repository itself stays GitHub-conventional. Repo-local guidance for this distribution copy lives in [`AGENTS.md`](AGENTS.md).

## Quickstart

```bash
git clone https://github.com/PGHH84/codex-layered-learning.git
cd codex-layered-learning
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```

After install:

- use `wrap-up` to close a coding session
- use `diary` for standalone session capture
- use `reflect` to review repeated patterns across diary entries

## Repository Layout

- [`skills/`](skills) contains the runtime behavior
- [`scripts/`](scripts) contains install and verification helpers
- [`examples/`](examples) contains shareable sample files
- [`docs/`](docs) contains public reference docs
- [`INSTALL.md`](INSTALL.md) covers setup and troubleshooting

## Notes

- This repo is for Codex-oriented runtimes. It does not ship Claude hooks or Claude-specific runtime files.
- `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md` are generated mirrors of shared global guidance, not primary authoring files.
- Typed project memory notes follow the conventions in [`docs/typed-memory-notes.md`](docs/typed-memory-notes.md).

## Credits

- [PGHH84/claude-layered-learning](https://github.com/PGHH84/claude-layered-learning)
- [rlancemartin/claude-diary](https://github.com/rlancemartin/claude-diary)
- [thebenlamm PR #3](https://github.com/rlancemartin/claude-diary/pull/3)
- **[jonathanmalkin/jules](https://github.com/jonathanmalkin/jules)** and his **[Reddit post](https://www.reddit.com/r/ClaudeCode/comments/1r89084/comment/o9sv777/?context=3)** — the original wrap-up skill concept that inspired the immediate loop. The idea of closing a session by shipping, remembering, and reviewing comes from that work.

## License

MIT License — see [LICENSE](LICENSE).
