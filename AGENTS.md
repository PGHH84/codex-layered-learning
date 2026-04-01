# Codex Layered Learning

This file is the repo-local guidance surface for the public Codex distribution repo.

## Scope

- Runtime behavior lives in [`skills/`](skills).
- Installation and verification live in [`scripts/`](scripts).
- Public docs and examples must stay aligned with the runtime skills.

## Rules

- Treat this repo as Codex-only. Do not add Claude hooks, Claude commands, or Claude runtime files here.
- Do not commit live runtime memory from `~/.codex/`.
- Keep machine-local examples redacted and shareable.
- When runtime behavior changes, update [`CHANGELOG.md`](CHANGELOG.md) and the relevant install docs in the same change.
- Prefer generic example paths such as `/Users/example/...` when an absolute path helps explain behavior.

## Verification

After changing runtime skills or install logic, rerun:

```bash
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```
