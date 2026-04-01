# Codex Claude Full Parity Implementation Plan

Parent: [[docs/MOC]]
Related: [[2026-03-31-codex-claude-full-parity-design]], [[2026-03-31-codex-claude-parity-design]], [[2026-03-20-codex-layered-learning-design]]

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore Codex Layered Learning to full Claude-behavior parity by aligning runtime skills, local instruction routing, global durable guidance, and worktree identity with the approved full-parity design.

**Architecture:** Keep runtime skills installed under `~/.agents/skills/` and project memory under `~/.codex/`, but route project-local operating guidance through repo `PROJECT.md`, route global operating guidance through canonical `~/.agents/global/PROJECT.md`, generate `~/.codex/AGENTS.md` and `~/.claude/CLAUDE.md` from that global source, and collapse git worktrees to one project-memory identity.

**Tech Stack:** Markdown runtime specs, bash install/verify scripts, local skill files, repository docs and manual verification fixtures

---

### Task 1: Align the plan and design docs to the full parity architecture

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/docs/specs/2026-03-31-codex-claude-parity-design.md`
- Add: `Engine/381-Codex-Layered-Learning/docs/specs/2026-03-31-codex-claude-full-parity-design.md`
- Modify: `Engine/381-Codex-Layered-Learning/docs/plans/2026-03-31-codex-claude-parity-plan.md`
- Modify: `Engine/381-Codex-Layered-Learning/docs/MOC.md`

- [ ] **Step 1: Add the superseding full-parity design**

Write the new design spec covering:
- local `PROJECT.md` routing
- canonical global `~/.agents/global/PROJECT.md`
- generated global mirrors
- worktree slug collapse
- fuller `reflect` behavior and same-flow application

- [ ] **Step 2: Retain the older parity design only as historical context**

Update the older parity design only as needed to point readers at the new full
parity design when requirements differ.

- [ ] **Step 3: Rewrite the implementation plan to the new architecture**

Replace the older Codex-only parity tasks with the new full-parity workstreams.

- [ ] **Step 4: Link the new design in `docs/MOC.md`**

Expected: the new spec is not orphaned and links cleanly from the docs index

### Task 2: Update `wrap-up` for local `PROJECT.md` routing and global canonical routing

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/skills/wrap-up/SKILL.md`
- Modify: `Engine/381-Codex-Layered-Learning/commands/wrap-up.md` only if present and retained
- Modify: `Engine/381-Codex-Layered-Learning/README.md`

- [ ] **Step 1: Remove the now-obsolete push prompt from the parity contract**

Edit `wrap-up/SKILL.md` and supporting docs so the closeout flow ends after
`Diary Capture` with reporting, not push confirmation.

- [ ] **Step 2: Replace the old destination mapping**

Local operating guidance must route to repo `PROJECT.md`, not repo `AGENTS.md`.
Global operating guidance must route to `~/.agents/global/PROJECT.md`.

- [ ] **Step 3: Update the approval matrix**

Reflect the new rules:
- `PROJECT.md` local operating improvements are auto-applied in `wrap-up`
- global canonical edits still require approval
- global mirror sync auto-runs after approved global edits

- [ ] **Step 4: Update worktree identity rules**

Document and use the collapsed worktree-to-main-repo slug transform in
`wrap-up`.

- [ ] **Step 5: Verify the high-level phase language**

Run: `rg -n "Ship It|Remember It|Review & Apply|Diary Capture|Push to remote|ask whether to push" Engine/381-Codex-Layered-Learning/skills/wrap-up/SKILL.md Engine/381-Codex-Layered-Learning/README.md`
Expected: no stale push-prompt requirement remains

### Task 3: Update `diary` for worktree-collapse identity and richer capture depth

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/skills/diary/SKILL.md`
- Modify: `Engine/381-Codex-Layered-Learning/commands/diary.md`
- Modify: `Engine/381-Codex-Layered-Learning/tests/manual-verification.md`

- [ ] **Step 1: Replace the shared slug transform**

Update `diary` so git worktrees collapse to the main repo slug before diary
file naming and `MEMORY.md` lookup.

- [ ] **Step 2: Preserve Claude-equivalent richer sections**

Verify and, if needed, refine the current diary template so it still covers:
- `Time`
- `Code Quality Preferences`
- `Code Patterns and Decisions`
- `Context and Technologies`

- [ ] **Step 3: Align the reference doc and manual verification**

Expected: `commands/diary.md` and `tests/manual-verification.md` match the live
runtime template and identity rules

### Task 4: Update `reflect` for full parity routing, richer synthesis, and same-flow application

- Modify: `Engine/381-Codex-Layered-Learning/skills/reflect/SKILL.md`
- Modify: `Engine/381-Codex-Layered-Learning/commands/reflect.md`
- Modify: `Engine/381-Codex-Layered-Learning/docs/specs/2026-03-20-codex-layered-learning-design.md`
- Modify: repo `PROJECT.md` only where documentation of the triumvirate needs to reference the new routing behavior

- [ ] **Step 1: Replace the promotion model**

Route:
- local operating improvements -> repo `PROJECT.md`
- global operating improvements -> `~/.agents/global/PROJECT.md`
- project memory content -> typed notes

- [ ] **Step 2: Expand the reflection template**

Add the fuller Claude-equivalent sections:
- `Frequency`
- `Root Cause`
- `Efficiency Lessons`
- `Notable Mistakes and Learnings`

- [ ] **Step 3: Change the application model**

Approved local and global edits must be appliable in the same reflection flow.

- [ ] **Step 4: Update `processed.log` semantics**

Match the new rule:
- reflection file first
- approved edits applied next
- processed entries appended only after the pass is accepted and the approved
  edit path is resolved

- [ ] **Step 5: Update worktree identity rules**

Use the collapsed worktree-to-main-repo slug transform here too.

- [ ] **Step 6: Align the reference doc and design docs**

Edit `commands/reflect.md` and the main design spec so the documented routing and proposal flow match the runtime skill.

- [ ] **Step 7: Verify processed-log and output-path consistency**

Run: `rg -n "processed.log|~/.codex/memory/reflections|~/.codex/memory/diary" Engine/381-Codex-Layered-Learning`
Expected: reflection paths are consistently Codex-native

### Task 5: Introduce the canonical global source and sync scripts

**Files:**
- Add: `Engine/381-Codex-Layered-Learning/scripts/sync_global_instructions.sh`
- Add: `Engine/381-Codex-Layered-Learning/scripts/check_global_instructions_sync.sh`
- Modify: `Engine/381-Codex-Layered-Learning/scripts/install_codex_layered_learning.sh`
- Modify: `Engine/381-Codex-Layered-Learning/scripts/verify_codex_layered_learning_install.sh`
- Add or seed at install time: `~/.agents/global/PROJECT.md`

- [ ] **Step 1: Create the sync script contract**

The sync script must render:
- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`
from canonical `~/.agents/global/PROJECT.md`

- [ ] **Step 2: Create the drift-check script**

Expected: a deterministic comparison path exists for generated global mirrors

- [ ] **Step 3: Update installer behavior**

Installer must ensure:
- `~/.agents/global/` exists
- canonical global file exists or is seeded safely
- sync script is available
- global mirrors can be generated

- [ ] **Step 4: Update verifier behavior**

Verifier must confirm:
- canonical global source exists
- both global mirrors exist
- sync check passes

### Task 6: Align installer, verifier, tests, and repo docs with the new parity architecture

**Files:**
- Modify: `Engine/381-Codex-Layered-Learning/README.md`
- Modify: `Engine/381-Codex-Layered-Learning/INSTALL.md`
- Modify: `Engine/381-Codex-Layered-Learning/tests/manual-verification.md`
- Modify: `Engine/381-Codex-Layered-Learning/docs/specs/2026-03-20-codex-layered-learning-design.md`
- Modify: `Engine/381-Codex-Layered-Learning/CHANGELOG.md`

- [ ] **Step 1: Find all stale storage or behavior claims**

Run: `rg -n "~/.agents/memory|proposal-only|same outcome|isolated from Claude|ask whether to push|push confirmation|repo AGENTS.md" Engine/381-Codex-Layered-Learning`
Expected: stale claims are listed before docs are edited

- [ ] **Step 2: Update the public docs**

Edit README, INSTALL, and the design spec so they describe:
- repo-local `PROJECT.md` routing
- canonical global `~/.agents/global/PROJECT.md`
- generated global mirrors
- no final push prompt in `wrap-up`
- collapsed worktree identity

- [ ] **Step 3: Update the verification doc**

Edit `tests/manual-verification.md` so scenario expectations match the repaired runtime behavior.

- [ ] **Step 4: Record the behavior change**

Add a `CHANGELOG.md` entry describing the parity repair and path consistency fix.

- [ ] **Step 5: Re-read the updated docs**

Run: `sed -n '1,240p' Engine/381-Codex-Layered-Learning/README.md`
Run: `sed -n '1,220p' Engine/381-Codex-Layered-Learning/INSTALL.md`
Expected: docs match runtime behavior and no longer contradict the skills

### Task 7: Prepare live install and verification, but do not run it until explicitly approved

**Files:**
- No additional files beyond the ones already updated above

- [ ] **Step 1: Verify repo copies are internally consistent**

Run: `cmp -s Engine/381-Codex-Layered-Learning/skills/wrap-up/SKILL.md Engine/381-Codex-Layered-Learning/skills/wrap-up/SKILL.md`
Expected: trivial repo self-check passes before any live install step

- [ ] **Step 2: Stop before touching live runtime**

Do not run installer or verifier until the user explicitly approves touching:
- `~/.agents/skills/`
- `~/.agents/global/`
- `~/.codex/`
- `~/.claude/`
