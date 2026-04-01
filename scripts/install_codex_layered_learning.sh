#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC_DIR="$ROOT_DIR/skills"
SKILLS_DST_DIR="$HOME/.agents/skills"
GLOBAL_ROOT_DIR="$HOME/.agents/global"
CODEX_ROOT_DIR="$HOME/.codex"
CLAUDE_ROOT_DIR="$HOME/.claude"
GLOBAL_CANONICAL_FILE="$GLOBAL_ROOT_DIR/PROJECT.md"
GLOBAL_SYNC_SRC="$ROOT_DIR/scripts/sync_global_instructions.sh"
GLOBAL_SYNC_DST="$GLOBAL_ROOT_DIR/sync_global_instructions.sh"
GLOBAL_CHECK_SRC="$ROOT_DIR/scripts/check_global_instructions_sync.sh"
GLOBAL_CHECK_DST="$GLOBAL_ROOT_DIR/check_global_instructions_sync.sh"

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

install_helper_script() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  chmod 755 "$dst"
}

seed_global_canonical_file() {
  local seed_source=""

  if [[ -f "$GLOBAL_CANONICAL_FILE" ]]; then
    return
  fi

  if [[ -f "$CODEX_ROOT_DIR/AGENTS.md" ]]; then
    seed_source="$CODEX_ROOT_DIR/AGENTS.md"
  elif [[ -f "$CLAUDE_ROOT_DIR/CLAUDE.md" ]]; then
    seed_source="$CLAUDE_ROOT_DIR/CLAUDE.md"
  fi

  mkdir -p "$GLOBAL_ROOT_DIR"

  if [[ -n "$seed_source" ]]; then
    if head -n 1 "$seed_source" | grep -q '^<!-- Generated from '; then
      tail -n +3 "$seed_source" > "$GLOBAL_CANONICAL_FILE"
    else
      cp "$seed_source" "$GLOBAL_CANONICAL_FILE"
    fi
    printf 'Seeded canonical global instruction file from %s\n' "$seed_source"
    return
  fi

  cat > "$GLOBAL_CANONICAL_FILE" <<'EOF'
# Global Operating Principles

Add your cross-project operating guidance here.
EOF
  printf 'Created starter canonical global instruction file at %s\n' "$GLOBAL_CANONICAL_FILE"
}

mkdir -p "$SKILLS_DST_DIR"
install_skill "wrap-up"
install_skill "diary"
install_skill "reflect"
install_helper_script "$GLOBAL_SYNC_SRC" "$GLOBAL_SYNC_DST"
install_helper_script "$GLOBAL_CHECK_SRC" "$GLOBAL_CHECK_DST"

mkdir -p "$CODEX_ROOT_DIR/skills"
mkdir -p "$CODEX_ROOT_DIR/memory"
mkdir -p "$CLAUDE_ROOT_DIR"

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
seed_global_canonical_file
"$GLOBAL_SYNC_DST"

printf 'Codex Layered Learning installer is idempotent; rerun it any time to resync installed skills.\n'
printf 'Repository source of truth: %s\n' "$SKILLS_SRC_DIR"
printf 'Installed Codex Layered Learning skills to %s\n' "$SKILLS_DST_DIR"
printf 'Ensured runtime directories exist under %s\n' "$CODEX_ROOT_DIR"
printf 'Canonical global instruction source: %s\n' "$GLOBAL_CANONICAL_FILE"
printf 'Installed global sync helpers under %s\n' "$GLOBAL_ROOT_DIR"
printf 'Optional personal wrap-up directory is ready at %s\n' "$CODEX_ROOT_DIR/skills/wrap-up"
