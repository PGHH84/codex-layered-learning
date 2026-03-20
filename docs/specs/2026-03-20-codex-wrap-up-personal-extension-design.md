# Codex Wrap-Up Personal Extension Design

**Date:** 2026-03-20

## Goal

Add a Codex-native equivalent of Claude's private `wrap-up` personal extension.

The extension should let the user define private, machine-local post-memory-update steps for `wrap-up` without placing those steps in the repository, the installed runtime skill copy, or any Claude-owned path.

## Scope

This design covers only a private machine-local `wrap-up` extension.

It does not add:

- private per-project local notes
- a general extension framework
- a compaction hook
- automatic creation of a personal extension file

## Runtime Path

The personal extension file lives at:

`~/.codex/skills/wrap-up/personal.md`

This location keeps the extension:

- Codex-native
- machine-local
- outside the repository
- separate from installed runtime skills under `~/.agents/skills/`

## Execution Contract

`wrap-up` executes in this order:

1. inspect session context
2. update `~/.codex/projects/<slug>/memory/MEMORY.md`
3. check for `~/.codex/skills/wrap-up/personal.md`
4. if present, read it and execute every step it defines
5. run `diary`
6. finish with the normal wrap-up report

If `personal.md` is absent, `wrap-up` continues normally with no warning noise.

## Safety Model

The personal extension is an extension point, not an override mechanism.

Core `wrap-up` safety rules still win.

The personal extension may:

- update private machine-local files
- update personal status trackers or logs
- write to user-owned non-repo locations

The personal extension must not:

- write to `~/.claude/**`
- create repo-local runtime memory folders
- auto-commit, auto-push, auto-deploy, auto-rename, auto-move, or perform destructive cleanup unless the user explicitly requested it in the session
- weaken or bypass the core runtime safety boundary

## Intended Use Cases

Good uses include:

- updating `~/Developer/project-status.md`
- appending to a private work log
- updating a private personal tracking file
- recording session outcomes in a private machine-local artifact

This feature is for personal workflow glue, not project memory promotion.

## Repository Changes

The implementation should:

- update `skills/wrap-up/SKILL.md` to define the lookup path, execution order, and safety guardrails
- update `README.md` to document the optional private extension point
- add `examples/personal.md` as a Codex-native template

The implementation may:

- ensure `~/.codex/skills/wrap-up/` exists during install

The implementation should not:

- create `personal.md` automatically
- fail verification when `personal.md` is absent

## Install and Verification Behavior

Installer behavior:

- safe to rerun
- may create `~/.codex/skills/wrap-up/`
- must not create a default `personal.md`

Verification behavior:

- should verify the normal runtime skills and directories as before
- should treat `personal.md` as optional
- may verify the optional parent directory if the install script creates it

## Non-Goals

- sharing configuration with Claude
- syncing personal extensions from the repository into `~/.agents/skills/`
- making `personal.md` part of project memory
- expanding this into multi-file extension discovery

## Success Criteria

The design is successful if:

- Codex `wrap-up` automatically detects `~/.codex/skills/wrap-up/personal.md`
- the extension runs only after project memory is updated
- the extension remains private and machine-local
- the extension cannot silently weaken the existing safety model
- the repository documents the feature clearly without making it required
