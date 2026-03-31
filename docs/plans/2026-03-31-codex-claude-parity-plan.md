# Codex Claude Parity Implementation Plan

Parent: [[docs/MOC]]
Related: [[2026-03-31-codex-claude-parity-design]], [[2026-03-20-codex-layered-learning-design]]

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore Codex Layered Learning to Claude-behavior parity while keeping Codex memory and runtime storage compliant with the current Codex documentation.

**Architecture:** Rebuild the Codex runtime around the current documented storage contract: `~/.codex/` for memory and `~/.agents/skills/` for installed skills. Restore Claude-equivalent workflow phases and richer capture/synthesis behavior in the runtime skills, then align all supporting docs, tests, and installer expectations to the same contract.

**Tech Stack:** Markdown runtime specs, bash install/verify scripts, local skill files, repository docs and manual verification fixtures

---

### Task 1: Repair the runtime storage contract in the skill specs

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/skills/wrap-up/SKILL.md`
- Modify: `Engine/381-Codex-Layered-Learning/skills/diary/SKILL.md`
- Modify: `Engine/381-Codex-Layered-Learning/skills/reflect/SKILL.md`
- Test: `Engine/381-Codex-Layered-Learning/tests/manual-verification.md`

- [ ] **Step 1: Identify every incorrect runtime-path reference**

Run: `rg -n "~/.agents/memory|~/.claude|symlinked|shared with Claude Code" Engine/381-Codex-Layered-Learning/skills`
Expected: all incorrect references are listed before edits start

- [ ] **Step 2: Update `wrap-up` to the Codex-only storage contract**

Edit `Engine/381-Codex-Layered-Learning/skills/wrap-up/SKILL.md` so runtime paths, safety boundaries, and final reporting all point only at Codex-native locations.

- [ ] **Step 3: Update `diary` to the Codex-only storage contract**

Edit `Engine/381-Codex-Layered-Learning/skills/diary/SKILL.md` so diary output and verification rules point only at `~/.codex/memory/diary/`.

- [ ] **Step 4: Update `reflect` to the Codex-only storage contract**

Edit `Engine/381-Codex-Layered-Learning/skills/reflect/SKILL.md` so diary, reflections, processed-log behavior, and promotion targets no longer reference Claude or `~/.agents/memory/`.

- [ ] **Step 5: Re-read the edited skill specs**

Run: `sed -n '1,260p' Engine/381-Codex-Layered-Learning/skills/wrap-up/SKILL.md`
Run: `sed -n '1,220p' Engine/381-Codex-Layered-Learning/skills/diary/SKILL.md`
Run: `sed -n '1,320p' Engine/381-Codex-Layered-Learning/skills/reflect/SKILL.md`
Expected: no remaining Claude-sharing or `~/.agents/memory` runtime claims

### Task 2: Restore Claude-equivalent `wrap-up` behavior in Codex

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/skills/wrap-up/SKILL.md`
- Modify: `Engine/381-Codex-Layered-Learning/README.md`
- Modify: `Engine/381-Codex-Layered-Learning/docs/specs/2026-03-20-codex-layered-learning-design.md`

- [ ] **Step 1: Write the failing behavior delta list**

Add or update notes in `wrap-up/SKILL.md` so the missing Claude phases are explicitly enumerated before rewriting the execution flow.
Expected: current gaps are represented directly in the spec text

- [ ] **Step 2: Restore the phase structure**

Edit `wrap-up/SKILL.md` to reintroduce:
- `Ship It`
- `Remember It`
- `Review & Apply`
- `Diary Capture`
- push confirmation

- [ ] **Step 3: Apply the documented memory-destination mapping**

Inside `wrap-up/SKILL.md`, implement the mapping from the parity design:
- project durable guidance -> repo `AGENTS.md` or typed notes, depending on content
- global guidance -> `~/.codex/AGENTS.md`
- scoped topic rules -> repo docs, repo `AGENTS.md`, or skill candidates
- personal machine-local notes -> `~/.codex/skills/wrap-up/personal.md`

- [ ] **Step 4: Apply the approval matrix and fallback rules**

Edit `wrap-up/SKILL.md` so auto-apply, approval-gated, and fallback behavior match the parity design exactly.

- [ ] **Step 5: Update README and design doc to match**

Edit `README.md` and `docs/specs/2026-03-20-codex-layered-learning-design.md` so they describe the restored phase-based immediate loop.

- [ ] **Step 6: Verify the phase language is consistent**

Run: `rg -n "Ship It|Remember It|Review & Apply|Diary Capture|Push" Engine/381-Codex-Layered-Learning`
Expected: phase language appears in runtime and supporting docs consistently

### Task 3: Restore Claude-equivalent `diary` capture depth in Codex

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/skills/diary/SKILL.md`
- Modify: `Engine/381-Codex-Layered-Learning/commands/diary.md`
- Modify: `Engine/381-Codex-Layered-Learning/tests/manual-verification.md`

- [ ] **Step 1: Compare the current template against Claude's**

Use the existing review notes to enumerate the missing sections and metadata.
Expected: a clear section delta list before edits

- [ ] **Step 2: Expand the Codex diary template**

Edit `skills/diary/SKILL.md` to add the richer Claude-equivalent fields while preserving:
- Codex path-derived slugging
- session-number coordination with `MEMORY.md`
- redact requirements

- [ ] **Step 3: Add explicit fallback behavior**

Edit `skills/diary/SKILL.md` so incompleteness, missing session ID, and missing branch behavior match the parity design.

- [ ] **Step 4: Align the reference doc**

Edit `commands/diary.md` so the reference summary matches the runtime template exactly.

- [ ] **Step 5: Update manual verification**

Edit `tests/manual-verification.md` so standalone diary verification checks the richer template and metadata.

- [ ] **Step 6: Re-read the final diary template**

Run: `sed -n '1,260p' Engine/381-Codex-Layered-Learning/skills/diary/SKILL.md`
Expected: the template is richer and internally consistent with the reference doc

### Task 4: Restore Claude-equivalent `reflect` synthesis flow in Codex

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/skills/reflect/SKILL.md`
- Modify: `Engine/381-Codex-Layered-Learning/commands/reflect.md`
- Modify: `Engine/381-Codex-Layered-Learning/docs/specs/2026-03-20-codex-layered-learning-design.md`

- [ ] **Step 1: Reintroduce Claude's prioritization model**

Edit `skills/reflect/SKILL.md` so rule violations, strengthening actions, pattern grouping, and proposal formatting are aligned with Claude's reflect behavior.

- [ ] **Step 2: Keep Codex-native destinations**

Edit the promotion model so Claude targets map to Codex equivalents without cross-agent writes:
- global -> `~/.codex/AGENTS.md`
- project durable memory -> typed notes under `~/.codex/projects/<slug>/memory/`
- repo docs / repo `AGENTS.md` / skills -> proposal targets as documented

- [ ] **Step 3: Add explicit approval and processed-log semantics**

Edit `skills/reflect/SKILL.md` so destination approvals and `processed.log` advancement match the parity design exactly.

- [ ] **Step 4: Align the reference doc and design doc**

Edit `commands/reflect.md` and the main design spec so the documented routing and proposal flow match the runtime skill.

- [ ] **Step 5: Verify processed-log and output-path consistency**

Run: `rg -n "processed.log|~/.codex/memory/reflections|~/.codex/memory/diary" Engine/381-Codex-Layered-Learning`
Expected: reflection paths are consistently Codex-native

### Task 5: Align installer, verifier, tests, and repo docs with the repaired runtime

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/README.md`
- Modify: `Engine/381-Codex-Layered-Learning/INSTALL.md`
- Modify: `Engine/381-Codex-Layered-Learning/tests/manual-verification.md`
- Modify: `Engine/381-Codex-Layered-Learning/docs/specs/2026-03-20-codex-layered-learning-design.md`
- Modify: `Engine/381-Codex-Layered-Learning/CHANGELOG.md`

- [ ] **Step 1: Find all stale storage or behavior claims**

Run: `rg -n "~/.agents/memory|~/.claude|proposal-only|same outcome|isolated from Claude" Engine/381-Codex-Layered-Learning`
Expected: stale claims are listed before docs are edited

- [ ] **Step 2: Update the public docs**

Edit README, INSTALL, and the design spec so they describe:
- Codex-native storage
- Claude-parity behavior
- no cross-agent durable sharing in this pass

- [ ] **Step 3: Update the verification doc**

Edit `tests/manual-verification.md` so scenario expectations match the repaired runtime behavior.

- [ ] **Step 4: Record the behavior change**

Add a `CHANGELOG.md` entry describing the parity repair and path consistency fix.

- [ ] **Step 5: Re-read the updated docs**

Run: `sed -n '1,240p' Engine/381-Codex-Layered-Learning/README.md`
Run: `sed -n '1,220p' Engine/381-Codex-Layered-Learning/INSTALL.md`
Expected: docs match runtime behavior and no longer contradict the skills

### Task 6: Reinstall and verify the live Codex skill copies

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/scripts/install_codex_layered_learning.sh` only if required
- Modify: `Engine/381-Codex-Layered-Learning/scripts/verify_codex_layered_learning_install.sh` only if required

- [ ] **Step 1: Run the installer**

Run: `bash scripts/install_codex_layered_learning.sh`
Expected: installed skill copies refresh under `~/.agents/skills/`

- [ ] **Step 2: Run the verifier**

Run: `bash scripts/verify_codex_layered_learning_install.sh`
Expected: install verification passes

- [ ] **Step 3: Spot-check installed files**

Run: `cmp -s skills/wrap-up/SKILL.md ~/.agents/skills/wrap-up/SKILL.md`
Run: `cmp -s skills/diary/SKILL.md ~/.agents/skills/diary/SKILL.md`
Run: `cmp -s skills/reflect/SKILL.md ~/.agents/skills/reflect/SKILL.md`
Expected: all three comparisons succeed

- [ ] **Step 4: Confirm runtime directories**

Run: `ls -ld ~/.codex/skills/wrap-up ~/.codex/memory/diary ~/.codex/memory/reflections ~/.codex/projects`
Expected: all documented Codex runtime directories exist
