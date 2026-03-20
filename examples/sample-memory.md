# Codex Layered Learning Memory

## Current State
**Last updated:** 2026-03-20 | **Session:** 3

Initial design complete. The project is explicitly isolated from Claude Code runtime surfaces and uses markdown under `~/.codex/` as the canonical memory store. The next step is to define the operational command docs for `wrap-up`, `diary`, and `reflect`.

**Next steps:**
1. Define the `wrap-up` skill behavior
2. Define the `diary` command contract
3. Define the `reflect` command contract

## Key Notes
- [feedback-local-files-first.md](feedback-local-files-first.md) — example of a typed durable feedback note
- `project_storage_layout.md` — canonical runtime layout under `~/.codex/`
- `feedback_no_repo_local_memory.md` — do not create repo-local runtime memory folders
- `reference_scope_routing.md` — global vs project-specific routing rules
