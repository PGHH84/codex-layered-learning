# Codex Layered Learning Memory

## Current State
**Last updated:** 2026-03-20 | **Session:** 3

The runtime contract is now anchored in the repository skills, and this `MEMORY.md` file is the source of truth for the current session number. Standalone `diary` uses a diary-scan fallback only when project memory is missing or uninitialized.

**Next steps:**
1. Add install verification and manual fixtures
2. Document the Codex-native context-loss fallback decision
3. Run the final consistency sweep

## Key Notes
- `project_*.md`: [project_storage_layout.md](examples/project_storage_layout.md) — canonical runtime layout under `~/.codex/`
- `feedback_*.md`: [feedback_no_repo_local_memory.md](feedback_no_repo_local_memory.md) — keep runtime memory out of working repositories
- `reference_*.md`: [reference_scope_routing.md](reference_scope_routing.md) — supporting rules for project-vs-global routing
- `user_*.md`: no example note yet; create one only when a stable recurring user preference materially affects future execution
