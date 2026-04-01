#!/usr/bin/env bash

set -euo pipefail

GLOBAL_ROOT_DIR="${CODEX_GLOBAL_ROOT_DIR:-$HOME/.agents/global}"
CANONICAL_FILE="${CODEX_GLOBAL_CANONICAL_FILE:-$GLOBAL_ROOT_DIR/PROJECT.md}"
CODEX_MIRROR_FILE="${CODEX_GLOBAL_CODEX_MIRROR_FILE:-$HOME/.codex/AGENTS.md}"
CLAUDE_MIRROR_FILE="${CODEX_GLOBAL_CLAUDE_MIRROR_FILE:-$HOME/.claude/CLAUDE.md}"

status=0

render_expected() {
  local source_file="$1"
  local tmp_file

  tmp_file="$(mktemp)"
  {
    printf '<!-- Generated from %s. Do not edit directly. -->\n\n' "$CANONICAL_FILE"
    cat "$source_file"
  } > "$tmp_file"
  printf '%s\n' "$tmp_file"
}

check_file() {
  local path="$1"
  local label="$2"

  if [[ -f "$path" ]]; then
    printf '[ok] %s: %s\n' "$label" "$path"
  else
    printf '[fail] %s missing: %s\n' "$label" "$path" >&2
    status=1
  fi
}

check_rendered_match() {
  local expected_file="$1"
  local actual_file="$2"
  local label="$3"

  if cmp -s "$expected_file" "$actual_file"; then
    printf '[ok] %s matches canonical source\n' "$label"
  else
    printf '[fail] %s differs from canonical source: %s\n' "$label" "$actual_file" >&2
    diff -u "$expected_file" "$actual_file" || true
    status=1
  fi
}

check_file "$CANONICAL_FILE" "canonical global instructions"
check_file "$CODEX_MIRROR_FILE" "Codex global mirror"
check_file "$CLAUDE_MIRROR_FILE" "Claude global mirror"

if [[ -f "$CANONICAL_FILE" && -f "$CODEX_MIRROR_FILE" && -f "$CLAUDE_MIRROR_FILE" ]]; then
  expected_file="$(render_expected "$CANONICAL_FILE")"
  trap 'rm -f "$expected_file"' EXIT
  check_rendered_match "$expected_file" "$CODEX_MIRROR_FILE" "Codex global mirror"
  check_rendered_match "$expected_file" "$CLAUDE_MIRROR_FILE" "Claude global mirror"
fi

if [[ "$status" -eq 0 ]]; then
  printf 'Global instruction sync check passed.\n'
else
  printf 'Global instruction sync check failed.\n' >&2
fi

exit "$status"
