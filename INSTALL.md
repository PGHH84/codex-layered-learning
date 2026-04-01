# Installation Guide

## Prerequisites

- a Codex-compatible environment that can use local `SKILL.md` files
- access to `~/.agents/`, `~/.codex/`, and `~/.claude/`
- Bash for the install and verification scripts

## Install

```bash
git clone https://github.com/PGHH84/codex-layered-learning.git
cd codex-layered-learning
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```

The installer is idempotent. It:

- installs `wrap-up`, `diary`, and `reflect` under `~/.agents/skills/`
- ensures `~/.agents/global/PROJECT.md` and the sync helpers exist
- regenerates the global mirrors at `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md`
- ensures the required `~/.codex/` memory directories exist
- creates `~/.codex/memory/reflections/processed.log` when needed

## What To Use After Install

- `wrap-up` for end-of-session closure
- `diary` for standalone session capture
- `reflect` for cross-session pattern analysis

The runtime source of truth lives in:

- `skills/wrap-up/SKILL.md`
- `skills/diary/SKILL.md`
- `skills/reflect/SKILL.md`

If your environment does not auto-discover installed skills, point it at the installed copies or the repo `SKILL.md` files directly.

## Optional Personal Extension

You may create:

```text
~/.codex/skills/wrap-up/personal.md
```

This file is optional, machine-local, and not required for install verification. Use [examples/personal.md](examples/personal.md) as the redacted template.

## Update

```bash
git pull
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```

## Troubleshooting

### Verification reports a mismatch

Rerun the install and verify scripts. If the mismatch remains, inspect the `diff -u` output from the verifier.

### My runtime does not auto-load the installed skills

Use the installed files under `~/.agents/skills/` or point your environment at the repo `SKILL.md` files directly.

### Where does runtime state live?

- runtime memory lives under `~/.codex/`
- shared global guidance lives in `~/.agents/global/PROJECT.md`
- generated mirrors live in `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md`
