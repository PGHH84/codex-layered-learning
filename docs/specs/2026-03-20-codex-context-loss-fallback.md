# Codex Context-Loss Fallback Decision

**Date:** 2026-03-20

## Decision

Codex Layered Learning remains manual-only for context-loss recovery in v1.

No safe Codex-native end-of-session or compaction trigger surface was confirmed from the inspected local runtime surfaces. The current fallback is therefore a manual recovery workflow built on existing Codex state rather than a new automatic mechanism.

## Local Surfaces Checked

The inspection was limited to local Codex runtime surfaces:

- `~/.codex/config.toml`
- `~/.codex/.codex-global-state.json`
- `~/.codex/history.jsonl`
- `~/.codex/session_index.jsonl`
- `~/.codex/sessions/`
- `~/.codex/shell_snapshots/`
- `~/.codex/memory/`
- `~/.codex/projects/`
- presence check for `~/.codex/automations/`
- repository-like support content under `~/.codex/superpowers/`

## What Was Found

- `~/.codex/config.toml` currently contains model, trust, and MCP server configuration, but no end-of-session trigger configuration
- `~/.codex/automations/` is absent in the inspected runtime
- `~/.codex/history.jsonl`, `~/.codex/session_index.jsonl`, `~/.codex/sessions/`, and `~/.codex/shell_snapshots/` are retrospective session artifacts that can help reconstruct work after context loss
- `~/.codex/memory/` and `~/.codex/projects/` already provide the durable storage targets that `wrap-up`, `diary`, and `reflect` expect
- content under `~/.codex/superpowers/` is support material, not the Codex runtime contract for this project

## Why No Automatic Trigger Is Being Added

- The inspected local runtime exposes passive history and session artifacts, not a confirmed end-of-session execution entry point
- Adding an automatic mechanism without a verified Codex-native trigger would create undocumented behavior and increase maintenance risk
- Codex Layered Learning already has a safe manual recovery path using existing runtime artifacts, so v1 does not need speculative automation

## Manual Recovery Workflow

If context is lost before `wrap-up` runs, recover in this order:

1. Re-open the project and read the project `README.md`, active spec, active plan, and current repo state
2. Read `~/.codex/projects/<slug>/memory/MEMORY.md` first; treat it as the durable handoff if it exists
3. If `MEMORY.md` is missing, stale, or obviously incomplete, inspect recent `~/.codex/sessions/`, `~/.codex/history.jsonl`, and `~/.codex/shell_snapshots/` to reconstruct the last meaningful actions
4. Run `diary` manually to capture the reconstructed session if the durable record is incomplete
5. Run `reflect` later only if the recovered work adds enough repeated evidence to justify synthesis

## Future State

Future automation is optional, not rejected in principle.

An opt-in fallback can be reconsidered later if one of these becomes true:

- Codex exposes a stable local trigger surface for end-of-session or compaction events
- a user explicitly sets up a Codex-native automation flow and wants recovery integrated into it
- the manual workflow proves too lossy in repeated real use

Until then, Codex Layered Learning should stay explicit: manual recovery first, durable memory second, no speculative trigger layer.
