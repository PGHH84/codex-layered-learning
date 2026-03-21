#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC_DIR="$ROOT_DIR/skills"
SKILLS_DST_DIR="$HOME/.agents/skills"
CODEX_ROOT_DIR="$HOME/.codex"

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

mkdir -p \
  "$CODEX_ROOT_DIR/skills/wrap-up" \
  "$CODEX_ROOT_DIR/memory/diary" \
  "$CODEX_ROOT_DIR/memory/reflections" \
  "$CODEX_ROOT_DIR/projects"

touch "$CODEX_ROOT_DIR/memory/reflections/processed.log"

printf 'Codex Layered Learning installer is idempotent; rerun it any time to resync installed skills.\n'
printf 'Repository source of truth: %s\n' "$SKILLS_SRC_DIR"
printf 'Installed Codex Layered Learning skills to %s\n' "$SKILLS_DST_DIR"
printf 'Ensured runtime directories exist under %s\n' "$CODEX_ROOT_DIR"
printf 'Optional personal wrap-up directory is ready at %s\n' "$CODEX_ROOT_DIR/skills/wrap-up"
