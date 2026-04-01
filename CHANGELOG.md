# Changelog

All notable changes to this project will be documented here.

Format: [Semantic Versioning](https://semver.org/) — `MAJOR.MINOR.PATCH`
- **MAJOR**: breaking changes to the public runtime contract or install flow
- **MINOR**: new features or new runtime/documentation surfaces, backwards compatible
- **PATCH**: fixes, clarifications, or verification hardening with no new public feature

---

## [1.3.0] - 2026-03-31

### Changed
- Restored Claude-equivalent `wrap-up` phase structure in the Codex runtime:
  - `Ship It`
  - `Remember It`
  - `Review & Apply`
  - `Diary Capture`
- Repaired the runtime storage contract so the Codex skills, docs, and verification flows consistently use `~/.codex/` for runtime memory
- Expanded `diary` to the richer Claude-equivalent capture shape, including `Time`, `Code Quality Preferences`, `Code Patterns and Decisions`, and `Context and Technologies`
- Clarified `reflect` routing, approval behavior, and `processed.log` advancement so reflection acceptance, approved-edit application, and processed-entry advancement follow one coherent flow
- Routed project-local operating guidance through repo `AGENTS.md` instead of generated home-directory mirrors
- Introduced canonical global operating guidance under `~/.agents/global/PROJECT.md` with generated mirrors at `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md`
- Collapsed git worktrees back to the main repo slug so one project does not fragment across worktree-specific memory identities

### Fixed
- Removed contradictory public/runtime claims that Codex diary or reflection memory lived under `~/.agents/memory/`
- Removed contradictory runtime claims of shared or symlinked Codex/Claude memory
- Aligned README, INSTALL, reference docs, design docs, scripts, and manual verification with the repaired runtime behavior
- Hardened install verification so legacy symlinked runtime paths are detected instead of silently passing
- Made the global mirror-sync checker safe to invoke under `zsh` as well as `bash`

## [1.2.0] - 2026-03-21

### Added
- Public Codex release with the runtime skills:
  - `wrap-up`
  - `diary`
  - `reflect`
- Codex-native install and verification scripts:
  - `scripts/install_codex_layered_learning.sh`
  - `scripts/verify_codex_layered_learning_install.sh`
- Project-scoped memory under `~/.codex/projects/<slug>/memory/`
- Centralized diary and reflection storage under `~/.codex/memory/`
- Typed project memory note guidance in `docs/typed-memory-notes.md`
- Optional machine-local personal wrap-up extension path at `~/.codex/skills/wrap-up/personal.md`
- Public top-level documentation for installation, verification, release tracking, and repo guidance

### Changed
- Established `skills/` as the runtime source of truth and `commands/` as reference-only summaries
- Locked durable promotions behind approval instead of applying them automatically
- Kept the repository fully isolated from Claude runtime surfaces
- Folded in the v1.1 hardening pass and the Codex-native wrap-up personal-extension work before the first public tag

### Notes
- Markdown is the source of truth in v1
- Context-loss fallback remains manual-only until a safe Codex-native trigger surface is available
