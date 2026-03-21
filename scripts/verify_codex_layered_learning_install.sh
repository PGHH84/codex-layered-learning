#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC_DIR="$ROOT_DIR/skills"
SKILLS_DST_DIR="$HOME/.agents/skills"
CODEX_ROOT_DIR="$HOME/.codex"

status=0

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

check_dir() {
  local path="$1"
  local label="$2"

  if [[ -d "$path" ]]; then
    printf '[ok] %s: %s\n' "$label" "$path"
  else
    printf '[fail] %s missing: %s\n' "$label" "$path" >&2
    status=1
  fi
}

check_skill_sync() {
  local skill_name="$1"
  local src="$SKILLS_SRC_DIR/$skill_name/SKILL.md"
  local dst="$SKILLS_DST_DIR/$skill_name/SKILL.md"

  check_file "$src" "repo skill $skill_name"
  check_file "$dst" "installed skill $skill_name"

  if [[ -f "$src" && -f "$dst" ]]; then
    if cmp -s "$src" "$dst"; then
      printf '[ok] installed copy matches repo: %s\n' "$skill_name"
    else
      printf '[fail] installed copy differs from repo: %s\n' "$skill_name" >&2
      diff -u "$src" "$dst" || true
      status=1
    fi
  fi
}

check_skill_sync "wrap-up"
check_skill_sync "diary"
check_skill_sync "reflect"

check_dir "$CODEX_ROOT_DIR/skills/wrap-up" "personal wrap-up directory"
check_dir "$CODEX_ROOT_DIR/memory/diary" "diary directory"
check_file "$CODEX_ROOT_DIR/memory/reflections/processed.log" "processed.log"
check_dir "$CODEX_ROOT_DIR/projects" "projects directory"

if [[ -f "$CODEX_ROOT_DIR/skills/wrap-up/personal.md" ]]; then
  printf '[ok] optional personal extension present: %s\n' "$CODEX_ROOT_DIR/skills/wrap-up/personal.md"
else
  printf '[ok] optional personal extension absent: %s\n' "$CODEX_ROOT_DIR/skills/wrap-up/personal.md"
fi

if [[ "$status" -eq 0 ]]; then
  printf 'Codex Layered Learning install verification passed.\n'
else
  printf 'Codex Layered Learning install verification failed.\n' >&2
fi

exit "$status"
