# Installation Guide

## Who This Is For

This repository is for Codex and OpenAI coding workflows that can use local skill files and machine-local runtime storage. That includes Codex desktop, CLI-driven Codex usage, and IDE or API-based coding setups that can follow the same file-first conventions.

The architecture is the same across those surfaces. The main difference is how your runtime discovers or invokes the installed skills.

## Prerequisites

- A local environment that can use Codex-style skills or can directly consume the `SKILL.md` files as runtime instructions
- Access to your home directory so the runtime can use:
  - `~/.agents/skills/`
  - `~/.codex/`
- Bash available for the install and verify scripts

## Install

### 1. Clone the repo

```bash
git clone https://github.com/PGHH84/codex-layered-learning.git
cd codex-layered-learning
```

### 2. Run the installer

```bash
bash scripts/install_codex_layered_learning.sh
```

The installer is idempotent. It:

- installs the runtime skills to:
  - `~/.agents/skills/wrap-up/SKILL.md`
  - `~/.agents/skills/diary/SKILL.md`
  - `~/.agents/skills/reflect/SKILL.md`
- ensures these runtime directories exist:
  - `~/.codex/skills/wrap-up/`
  - `~/.codex/memory/diary/`
  - `~/.codex/memory/reflections/`
  - `~/.codex/projects/`
- creates `~/.codex/memory/reflections/processed.log` if missing

### 3. Verify the install

```bash
bash scripts/verify_codex_layered_learning_install.sh
```

Verification checks:

- repo skill files exist
- installed copies exist
- installed copies match the repo
- required `~/.codex/` runtime directories exist
- `processed.log` exists
- `~/.codex/skills/wrap-up/personal.md` is treated as optional

## Using The Skills

The runtime source of truth lives in:

- `skills/wrap-up/SKILL.md`
- `skills/diary/SKILL.md`
- `skills/reflect/SKILL.md`

If your Codex environment auto-discovers installed skills under `~/.agents/skills/`, use them normally there.

If your CLI or API-driven setup does not auto-discover them, use the installed copies or the repo `SKILL.md` files directly as local instructions. The architecture and output locations stay the same.

## Optional Personal Wrap-Up Extension

You may create:

```text
~/.codex/skills/wrap-up/personal.md
```

This file is:

- optional
- machine-local
- private to your setup
- not created by the installer
- not required by the verifier

Use the redacted template in [examples/personal.md](50_Developer/56_Codex-Layered-Learning/examples/personal.md) as a starting point.

## Updating

```bash
git pull
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```

This refreshes the installed runtime skills from the repo and rechecks sync.

## Uninstalling Or Manual Cleanup

To remove the installed skill copies:

```bash
rm -rf ~/.agents/skills/wrap-up ~/.agents/skills/diary ~/.agents/skills/reflect
```

To remove runtime memory and the optional personal extension too:

```bash
rm -rf ~/.codex/skills/wrap-up ~/.codex/memory/diary ~/.codex/memory/reflections ~/.codex/projects
```

Only do the second cleanup step if you explicitly want to remove your machine-local runtime state.

## Troubleshooting

### Verification reports an installed skill mismatch

Rerun:

```bash
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```

If the mismatch remains, inspect the reported `diff -u` output from the verifier.

### `personal.md` is missing

That is valid. The optional personal extension is not required for install verification.

### My runtime does not auto-load the installed skills

Use the repo or installed `SKILL.md` files directly in your Codex/OpenAI coding workflow. This repo defines the file layout and the expected runtime behavior; auto-discovery is a convenience, not the core contract.

### Is there a Codex equivalent of the Claude PreCompact hook here?

No. This repo intentionally does not ship a Claude-style hook flow. Context-loss fallback remains manual-only until a safe Codex-native trigger surface is confirmed.

### Where should runtime memory live?

Under `~/.codex/` only. Do not create repo-local runtime memory folders in working repositories.
