# Codex Public Repository Documentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prepare `Codex-Layered-Learning` for public release with Codex-native top-level docs, release metadata, root guidance, and sanitized public examples.

**Architecture:** Keep the existing runtime contract in `skills/` intact and build a public-facing documentation layer around it. The top-level docs should optimize for Codex/OpenAI coding users, while examples and fixtures should be sanitized enough for public distribution without weakening the actual runtime-path contract.

**Tech Stack:** Markdown, shell scripts, repository docs, examples, fixtures.

---

### Task 1: Add the Public Release Skeleton

**Files:**
- Create: `INSTALL.md`
- Create: `CHANGELOG.md`
- Create: `LICENSE`
- Create: `AGENTS.md`
- Create: `.gitignore`

- [ ] **Step 1: Add the missing top-level public docs**

Create the missing public-release files so the repo has the same baseline surfaces expected of a public project, but written for Codex instead of Claude.

Expected: the repo no longer depends on `README.md` alone to explain setup and release policy.

- [ ] **Step 2: Keep the new root guidance Codex-native**

Make the root `AGENTS.md` describe:
- runtime authority in `skills/`
- installed-copy sync via the install script
- verification via the verify script
- public-release hygiene for examples, live runtime files, and versioning

Expected: the repo gets a Codex-native root guidance document instead of a copied Claude contract.

- [ ] **Step 3: Add a minimal repo hygiene ignore file**

Create `.gitignore` with at least `.DS_Store` ignored.

Expected: macOS metadata files stop polluting public-repo status.

### Task 2: Rewrite the README for Public Codex Users

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Rewrite the README entry point**

Restructure the README around:
- purpose
- audience
- two-loop architecture
- touch-surface model
- quickstart
- runtime layout
- optional personal extension
- compatibility notes
- credits
- license

Expected: a new user can understand the project from the root page without reading deep internal docs first.

- [ ] **Step 2: Keep the README faithful to the runtime contract**

Make sure the README reflects:
- `skills/` as runtime authority
- `commands/` as reference-only
- approval-gated durable promotions
- manual-only context-loss fallback
- no Claude hooks or Claude runtime files

Expected: the public README matches actual Codex behavior rather than the older Claude model.

### Task 3: Write a Codex-Native Install Guide

**Files:**
- Create: `INSTALL.md`

- [ ] **Step 1: Document the actual install and verify flow**

Describe:
- cloning the repo
- `bash scripts/install_codex_layered_learning.sh`
- `bash scripts/verify_codex_layered_learning_install.sh`
- what directories and files the installer creates

Expected: users can install and verify the repo without reverse-engineering the scripts.

- [ ] **Step 2: Cover update, uninstall, and troubleshooting**

Document:
- reinstall/update flow
- optional personal-extension setup
- manual cleanup
- skill sync mismatch
- missing optional `personal.md`
- the lack of a Codex-native hook surface in this repo

Expected: operational questions are answered outside the README.

### Task 4: Sanitize Public Examples and Fixtures

**Files:**
- Modify: `examples/personal.md`
- Modify: `examples/sample-diary-entry.md`
- Modify: `skills/wrap-up/SKILL.md`
- Modify: `skills/diary/SKILL.md`
- Modify: `tests/fixtures/sample-diary-batch/2026-03-20-project-alpha-session-1.md`
- Modify: `tests/fixtures/sample-diary-batch/2026-03-21-project-alpha-session-2.md`
- Modify: `tests/fixtures/sample-diary-batch/2026-03-22-project-beta-session-1.md`

- [ ] **Step 1: Redact the public personal-extension example**

Replace the current repo example with a generic optional pattern suitable for publication.

Expected: `examples/personal.md` is shareable and no longer reads like a copy of one live private setup.

- [ ] **Step 2: Sanitize usernames in public examples**

Replace unnecessary username-specific absolute paths with generic equivalents such as `/Users/example/...`.

Expected: public examples stay realistic without exposing one private machine layout.

- [ ] **Step 3: Keep real runtime-path contracts intact**

Do not sanitize:
- `~/.codex/...`
- `~/.agents/skills/...`
- `~/.claude/**` safety warnings

Expected: public sanitization does not weaken the actual runtime contract.

### Task 5: Final Verification and Publication Readiness Review

**Files:**
- Modify as needed based on verification findings

- [ ] **Step 1: Run consistency checks**

Run:

```bash
bash scripts/verify_codex_layered_learning_install.sh
git diff --check
rg -n "project-status\\.md" README.md INSTALL.md AGENTS.md CHANGELOG.md docs examples skills tests scripts
```

Expected:
- install verification passes
- diff hygiene passes
- public-facing docs and examples no longer depend on the personal username or private status-file example

- [ ] **Step 2: Review publication readiness**

Confirm:
- top-level docs are present
- release metadata is present
- public examples are sanitized
- the repo still accurately documents the current Codex runtime contract

Expected: the repo is ready for a first public Codex release.
