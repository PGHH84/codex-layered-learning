#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC_DIR="$ROOT_DIR/skills"
SKILLS_DST_DIR="$HOME/.agents/skills"
CODEX_ROOT_DIR="$HOME/.codex"

normalize_owned_dir() {
  local path="$1"
  local tmp_dir

  if [[ -L "$path" ]]; then
    tmp_dir="$(mktemp -d)"

    if [[ -d "$path" ]]; then
      cp -R "$path"/. "$tmp_dir"/ 2>/dev/null || true
    fi

    rm "$path"
    mkdir -p "$path"

    if [[ -n "$(find "$tmp_dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
      cp -R "$tmp_dir"/. "$path"/
    fi

    rm -rf "$tmp_dir"
    printf 'Normalized legacy symlinked runtime path: %s\n' "$path"
    return
  fi

  mkdir -p "$path"
}

# Safe to rerun. Each invocation refreshes the installed skill copies from the
# repository source of truth and ensures the required runtime directories exist.

install_skill() {
  local skill_name="$1"
  mkdir -p "$SKILLS_DST_DIR/$skill_name"
  cp "$SKILLS_SRC_DIR/$skill_name/SKILL.md" "$SKILLS_DST_DIR/$skill_name/SKILL.md"
}

mkdir -p "$SKILLS_DST_DIR"
install_skill "wrap-up"
install_skill "diary"
install_skill "reflect"

mkdir -p "$CODEX_ROOT_DIR/skills"
mkdir -p "$CODEX_ROOT_DIR/memory"

normalize_owned_dir "$CODEX_ROOT_DIR/skills/wrap-up"
normalize_owned_dir "$CODEX_ROOT_DIR/memory/diary"
normalize_owned_dir "$CODEX_ROOT_DIR/memory/reflections"
normalize_owned_dir "$CODEX_ROOT_DIR/projects"

if [[ -d "$CODEX_ROOT_DIR/projects" ]]; then
  while IFS= read -r legacy_memory_dir; do
    normalize_owned_dir "$legacy_memory_dir"
  done < <(find "$CODEX_ROOT_DIR/projects" -type l -path '*/memory')
fi

touch "$CODEX_ROOT_DIR/memory/reflections/processed.log"

printf 'Codex Layered Learning installer is idempotent; rerun it any time to resync installed skills.\n'
printf 'Repository source of truth: %s\n' "$SKILLS_SRC_DIR"
printf 'Installed Codex Layered Learning skills to %s\n' "$SKILLS_DST_DIR"
printf 'Ensured runtime directories exist under %s\n' "$CODEX_ROOT_DIR"
printf 'Optional personal wrap-up directory is ready at %s\n' "$CODEX_ROOT_DIR/skills/wrap-up"
