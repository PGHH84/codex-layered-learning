# Codex Wrap-Up Personal Extension Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a Codex-native private `wrap-up` personal extension point at `~/.codex/skills/wrap-up/personal.md` with explicit execution semantics, failure behavior, and safety guardrails.

**Architecture:** The implementation should tighten the design contract first, then extend the runtime `wrap-up` skill and supporting docs around that contract. The personal extension remains machine-local and optional; repository files only define how Codex should detect it, when it runs, and what it is allowed to do.

**Tech Stack:** Markdown, Codex skills, shell scripts, repository docs, manual verification scenarios.

---

### Task 1: Close the Design Gaps Found in Review

**Files:**
- Modify: `docs/specs/2026-03-20-codex-wrap-up-personal-extension-design.md`

- [ ] **Step 1: Define the execution model precisely**

Update the spec to say exactly what `personal.md` is:
- a machine-local instruction file read by Codex during `wrap-up`
- not a shell script
- not a repository skill
- still subject to normal Codex approval and safety rules when it leads to actions

Expected: the implementation is no longer forced to guess what “execute every step it defines” means.

- [ ] **Step 2: Define failure and interruption behavior**

Document:
- what happens if the personal extension is missing
- what happens if it contains unusable or unclear instructions
- what happens if a requested action needs approval and approval is not granted
- whether `diary` must still run after a failed or partial personal-extension pass

Expected: the spec protects the fresh-session capture path even if the personal extension is not completed.

- [ ] **Step 3: Make the repository-write rule explicit**

Add a direct rule that the personal extension must not edit repository files as part of `wrap-up` unless the user explicitly requested that in the session.

Expected: the machine-local extension cannot silently become a repo-mutation path.

- [ ] **Step 4: Verify the design closes all review findings**

Run:

```bash
rg -n "not a shell script|approval|diary must still run|missing|unclear|repository files|repo files|machine-local instruction file" docs/specs/2026-03-20-codex-wrap-up-personal-extension-design.md
```

Expected:
- the execution model is explicit
- failure behavior is explicit
- the repo-write rule is explicit

### Task 2: Extend the Runtime `wrap-up` Contract

**Files:**
- Modify: `skills/wrap-up/SKILL.md`
- Modify: `README.md`

- [ ] **Step 1: Add the personal extension runtime path**

Update `skills/wrap-up/SKILL.md` to include:
- `~/.codex/skills/wrap-up/personal.md` as an optional machine-local extension path
- the fact that it is separate from installed runtime skills under `~/.agents/skills/`

Expected: the runtime contract names the extension surface directly.

- [ ] **Step 2: Insert the personal extension into the execution sequence**

Update the execution order so `wrap-up`:
1. inspects session context
2. updates project memory
3. checks for the personal extension
4. follows it if present
5. runs `diary`
6. finishes the normal report

Document that `diary` still runs even when the personal extension is absent or not fully completed.

Expected: the runtime sequence matches the approved design and preserves session capture.

- [ ] **Step 3: Add runtime guardrails**

Document in `skills/wrap-up/SKILL.md`:
- the personal extension is an instruction file, not a way to override wrap-up
- normal approval rules still apply
- no writes to `~/.claude/**`
- no repo-local runtime memory
- no repo file edits unless explicitly requested in-session
- no auto-commit/push/deploy/rename/move/destructive cleanup unless explicitly requested

Expected: the safety model is explicit at the runtime surface.

- [ ] **Step 4: Document the feature in the README**

Add a short README section that covers:
- optional machine-local path
- when it runs
- that it is private and not synced into installed skill copies
- that it does not override core safety rules

Expected: readers can discover the feature without confusing it with repository configuration.

- [ ] **Step 5: Verify the runtime contract**

Run:

```bash
rg -n "personal\\.md|~/.codex/skills/wrap-up/personal\\.md|approval|diary|repo files|~/.claude|installed runtime skills" skills/wrap-up/SKILL.md README.md
```

Expected:
- the personal extension path is documented
- the execution order is documented
- safety boundaries are documented

### Task 3: Add the Example Template

**Files:**
- Create: `examples/personal.md`
- Modify: `README.md`

- [ ] **Step 1: Create a Codex-native example template**

Write `examples/personal.md` as a private template for `~/.codex/skills/wrap-up/personal.md`.

The template should:
- explain that the real file lives under `~/.codex/skills/wrap-up/personal.md`
- explain that it is optional and machine-local
- include one concrete example based on `~/work-log.md`
- state that normal approval and safety rules still apply

Expected: users have a copyable template without committing personal config.

- [ ] **Step 2: Link the template from the README**

Add or extend README documentation so the new example is discoverable from the repository docs.

Expected: the example is visible from the main entry point.

- [ ] **Step 3: Verify the example wording**

Run:

```bash
rg -n "~/.codex/skills/wrap-up/personal\\.md|project-status\\.md|approval|optional|machine-local" examples/personal.md README.md
```

Expected:
- the example points to the correct runtime path
- the example is clearly optional
- the example includes the concrete status-file use case

### Task 4: Align Install and Verification Behavior

**Files:**
- Modify: `scripts/install_codex_layered_learning.sh`
- Modify: `scripts/verify_codex_layered_learning_install.sh`
- Modify: `README.md`

- [ ] **Step 1: Decide and document installer behavior**

Update the installer so it ensures `~/.codex/skills/wrap-up/` exists, but does not create `personal.md`.

Expected: the parent directory is ready for use without generating personal configuration automatically.

- [ ] **Step 2: Update verification behavior**

Update `scripts/verify_codex_layered_learning_install.sh` so it:
- keeps the current required checks
- treats `personal.md` as optional
- optionally checks that `~/.codex/skills/wrap-up/` exists if the installer now creates it

Expected: install verification stays strict for required runtime surfaces but non-failing for the optional personal file.

- [ ] **Step 3: Document install and verification details**

Update the README install/maintenance section so it says:
- the installer may create `~/.codex/skills/wrap-up/`
- the user may add `personal.md` there manually
- verification does not require the personal file to exist

Expected: install, update, and optional local configuration are not conflated.

- [ ] **Step 4: Verify the maintenance flow**

Run:

```bash
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```

Expected:
- the installer completes without creating `personal.md`
- verification passes without requiring `personal.md`

### Task 5: Extend Manual Verification Coverage

**Files:**
- Modify: `tests/manual-verification.md`

- [ ] **Step 1: Add a personal-extension scenario**

Add a manual scenario that verifies:
- `wrap-up` finds `~/.codex/skills/wrap-up/personal.md` when present
- the extension runs after `MEMORY.md` update
- `diary` still runs afterward

Expected: the manual checklist covers the new runtime path.

- [ ] **Step 2: Add a failure-path scenario**

Add a manual scenario that verifies:
- absent `personal.md` causes no warning noise
- unclear or blocked personal steps do not silently skip `diary`
- repo safety boundaries still apply

Expected: the checklist covers the critical failure behavior from the review findings.

- [ ] **Step 3: Verify the new manual coverage**

Run:

```bash
rg -n "personal\\.md|after MEMORY\\.md|diary still runs|no warning noise|blocked|approval" tests/manual-verification.md
```

Expected:
- the happy path and failure path are both documented

### Task 6: Final Consistency Sweep

**Files:**
- Modify: `README.md`
- Modify: `docs/specs/2026-03-20-codex-wrap-up-personal-extension-design.md`
- Modify: `skills/wrap-up/SKILL.md`
- Modify: `tests/manual-verification.md`
- Modify: `scripts/install_codex_layered_learning.sh`
- Modify: `scripts/verify_codex_layered_learning_install.sh`
- Create: `examples/personal.md`

- [ ] **Step 1: Re-read the touched files**

Focus on:
- execution order
- failure behavior
- safety model
- install behavior
- optional-file verification behavior

- [ ] **Step 2: Run the static consistency checks**

Run:

```bash
git diff --check
rg -n "personal\\.md|~/.codex/skills/wrap-up/personal\\.md|repo files|~/.claude|diary still runs|optional" README.md docs/specs/2026-03-20-codex-wrap-up-personal-extension-design.md skills/wrap-up/SKILL.md tests/manual-verification.md scripts examples
```

Expected:
- no diff formatting issues
- the feature path and guardrails are consistent across docs, skill, scripts, and example

- [ ] **Step 3: Update any stale wording**

Fix any wording that still implies:
- the extension is synced from the repo
- the extension can override safety rules
- `diary` can be skipped on personal-extension failure

- [ ] **Step 4: Commit only if explicitly requested**

```bash
git add README.md docs/specs/2026-03-20-codex-wrap-up-personal-extension-design.md skills/wrap-up/SKILL.md tests/manual-verification.md scripts examples/personal.md
git commit -m "feat: add codex wrap-up personal extension contract"
```
