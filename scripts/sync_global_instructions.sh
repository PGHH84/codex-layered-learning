#!/usr/bin/env bash

set -euo pipefail

GLOBAL_ROOT_DIR="${CODEX_GLOBAL_ROOT_DIR:-$HOME/.agents/global}"
CANONICAL_FILE="${CODEX_GLOBAL_CANONICAL_FILE:-$GLOBAL_ROOT_DIR/PROJECT.md}"
CODEX_MIRROR_FILE="${CODEX_GLOBAL_CODEX_MIRROR_FILE:-$HOME/.codex/AGENTS.md}"
CLAUDE_MIRROR_FILE="${CODEX_GLOBAL_CLAUDE_MIRROR_FILE:-$HOME/.claude/CLAUDE.md}"

render_mirror() {
  local source_file="$1"
  local target_file="$2"
  local tmp_file

  tmp_file="$(mktemp)"
  {
    printf '<!-- Generated from %s. Do not edit directly. -->\n\n' "$CANONICAL_FILE"
    cat "$source_file"
  } > "$tmp_file"

  mkdir -p "$(dirname "$target_file")"
  mv "$tmp_file" "$target_file"
}

if [[ ! -f "$CANONICAL_FILE" ]]; then
  printf 'Canonical global instruction file missing: %s\n' "$CANONICAL_FILE" >&2
  exit 1
fi

render_mirror "$CANONICAL_FILE" "$CODEX_MIRROR_FILE"
render_mirror "$CANONICAL_FILE" "$CLAUDE_MIRROR_FILE"

printf 'Synced global instruction mirrors from %s\n' "$CANONICAL_FILE"
printf '  -> %s\n' "$CODEX_MIRROR_FILE"
printf '  -> %s\n' "$CLAUDE_MIRROR_FILE"
