# Codex Layered Learning V1.1 Hardening Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox syntax for tracking. In this execution pass, all non-commit steps were completed and every commit step was deferred because the user explicitly disallowed automatic commits.

**Goal:** Close the main correctness and maintainability gaps in Codex Layered Learning by making the runtime contract authoritative, completing the typed-memory layer, hardening reflection routing, tightening wrap-up/diary behavior, and adding verification and maintenance support.

**Architecture:** The runtime skills under `skills/` are the Codex-facing execution surface and should become the single source of truth for behavior. Repository docs, examples, fixtures, and maintenance scripts should support those runtime skills, reduce drift, and preserve the hard isolation boundary from Claude.

**Tech Stack:** Markdown, Codex skills, shell scripts, repository docs, synthetic fixtures, manual verification scenarios.

---

### Task 1: Canonicalize the Runtime Contract

**Files:**
- Modify: `README.md`
- Modify: `docs/specs/2026-03-20-codex-layered-learning-design.md`
- Modify: `commands/diary.md`
- Modify: `commands/reflect.md`
- Modify: `skills/diary/SKILL.md`
- Modify: `skills/reflect/SKILL.md`

- [x] **Step 1: Record the current drift before editing**

Run:

```bash
diff -u commands/diary.md skills/diary/SKILL.md || true
diff -u commands/reflect.md skills/reflect/SKILL.md || true
```

Expected: current mismatches are visible and can be mapped to the review findings.

- [x] **Step 2: Declare the authoritative runtime surface**

Update `README.md` and `docs/specs/2026-03-20-codex-layered-learning-design.md` to say explicitly:
- `skills/*.md` are the runtime source of truth
- `commands/*.md` are reference docs only, if retained
- behavioral changes must land in the runtime skills first

- [x] **Step 3: Rewrite the command docs as thin reference contracts**

Keep `commands/diary.md` and `commands/reflect.md`, but convert them into clearly non-authoritative reference docs that:
- point to the runtime skills
- summarize the purpose and data shape
- avoid carrying independent behavioral rules that can drift

Expected: the command docs remain useful for readers, but the runtime behavior is owned by `skills/*.md`.

- [x] **Step 4: Restore missing runtime behavior that was lost during the skills split**

Ensure `skills/reflect/SKILL.md` includes:
- destination checks
- semantic dedupe
- conflict review
- preference for strengthening existing guidance over adding duplicates

Expected: the runtime skill covers the same promotion-safety logic as the design and reference docs.

- [x] **Step 5: Verify the contract is aligned**

Run:

```bash
rg -n "source of truth|Runtime authority|Destination Checks|semantic duplicate|conflict" README.md docs/specs skills commands
```

Expected:
- runtime authority wording is present
- `skills/reflect/SKILL.md` contains destination-check logic
- retained command docs clearly defer to the runtime skills

- [ ] **Step 6: Commit (deferred: user requested no automatic commits)**

```bash
git add README.md docs/specs/2026-03-20-codex-layered-learning-design.md commands/diary.md commands/reflect.md skills/diary/SKILL.md skills/reflect/SKILL.md
git commit -m "docs: canonicalize codex layered learning runtime contract"
```

### Task 2: Implement the Typed Memory Note Policy

**Files:**
- Create: `docs/typed-memory-notes.md`
- Modify: `README.md`
- Modify: `skills/wrap-up/SKILL.md`
- Modify: `skills/reflect/SKILL.md`
- Modify: `examples/sample-memory.md`
- Create: `examples/project_storage_layout.md`
- Create: `examples/reference_scope_routing.md`
- Create: `examples/feedback_no_repo_local_memory.md`

- [x] **Step 1: Write the typed-memory policy**

Document in `docs/typed-memory-notes.md`:
- allowed note types
- naming expectations
- when each note type is appropriate
- anti-patterns
- when not to create a new note

Must cover:
- `feedback_*.md`
- `project_*.md`
- `reference_*.md`
- `user_*.md`

- [x] **Step 2: Add concrete example notes that the current example index can actually point to**

Create:
- `examples/project_storage_layout.md`
- `examples/reference_scope_routing.md`
- `examples/feedback_no_repo_local_memory.md`

Expected: every linked note in `examples/sample-memory.md` exists after this step.

- [x] **Step 3: Repair the project-memory example index**

Update `examples/sample-memory.md` so:
- every note reference points to a real example file
- note names align with the policy
- the index demonstrates the intended split between project, feedback, and reference notes

- [x] **Step 4: Route the runtime skills through the new policy**

Update `skills/wrap-up/SKILL.md` and `skills/reflect/SKILL.md` to say:
- when to propose a typed note
- when to avoid creating one
- how to choose between `feedback_*`, `project_*`, `reference_*`, and `user_*`

- [x] **Step 5: Verify example and policy alignment**

Run:

```bash
test -f docs/typed-memory-notes.md
for f in examples/project_storage_layout.md examples/reference_scope_routing.md examples/feedback_no_repo_local_memory.md; do test -f "$f"; done
rg -n "feedback_\\*|project_\\*|reference_\\*|user_\\*" docs/typed-memory-notes.md skills/wrap-up/SKILL.md skills/reflect/SKILL.md examples/sample-memory.md
```

Expected:
- the policy file exists
- all example note files exist
- the same note taxonomy appears in the policy, runtime skills, and sample memory

- [ ] **Step 6: Commit (deferred: user requested no automatic commits)**

```bash
git add docs/typed-memory-notes.md README.md skills/wrap-up/SKILL.md skills/reflect/SKILL.md examples/sample-memory.md examples/project_storage_layout.md examples/reference_scope_routing.md examples/feedback_no_repo_local_memory.md
git commit -m "docs: add typed memory note policy"
```

### Task 3: Harden `reflect` Routing and Processed Entry Semantics

**Files:**
- Modify: `skills/reflect/SKILL.md`
- Modify: `commands/reflect.md`
- Modify: `examples/sample-reflection.md`
- Modify: `README.md`

- [x] **Step 1: Add the missing technology-specific routing branch**

Document the classification rule:
- technology-specific patterns that recur across multiple projects can become global
- technology-specific patterns limited to one project stay project-specific

Expected: the Codex router matches the strongest part of the Claude LL classifier without importing Claude surfaces.

- [x] **Step 2: Define the exact `processed.log` record format**

Document one canonical line shape, for example:

```text
<diary-filename> | <processed-date> | <reflection-filename> | accepted
```

Use one exact format everywhere:
- `skills/reflect/SKILL.md`
- `commands/reflect.md`
- `README.md` if referenced there

- [x] **Step 3: Add signal-vs-noise and reprocessing examples**

Document:
- repeated signal examples
- one-off/noise examples
- “include all entries”
- targeted reprocessing

- [x] **Step 4: Tighten the reflection template and metadata**

Update `examples/sample-reflection.md` and the reflection template so they cover:
- rule violations
- carry-forward
- proposed destinations
- processed-log update status
- reprocessing clarity when relevant

- [x] **Step 5: Verify the reflection rules are all present**

Run:

```bash
rg -n "technology|signal|noise|processed\\.log|reprocess|include all entries|semantic duplicate|conflict" skills/reflect/SKILL.md commands/reflect.md examples/sample-reflection.md
```

Expected:
- technology routing appears
- `processed.log` format is explicit
- signal/noise guidance is explicit
- reprocessing language is explicit

- [ ] **Step 6: Commit (deferred: user requested no automatic commits)**

```bash
git add skills/reflect/SKILL.md commands/reflect.md examples/sample-reflection.md README.md
git commit -m "docs: harden reflect routing and processed entry handling"
```

### Task 4: Tighten `wrap-up` and `diary` Operational Rules

**Files:**
- Modify: `skills/wrap-up/SKILL.md`
- Modify: `skills/diary/SKILL.md`
- Modify: `commands/diary.md`
- Modify: `examples/sample-diary-entry.md`
- Modify: `examples/sample-memory.md`

- [x] **Step 1: Define one session counter source of truth**

Document:
- preferred source: `~/.codex/projects/<slug>/memory/MEMORY.md`
- fallback source: diary file scan when project memory is missing or uninitialized

Expected: `wrap-up` and `diary` cannot increment session numbers independently.

- [x] **Step 2: Clarify wrap-up promotion behavior**

Update `skills/wrap-up/SKILL.md` to distinguish:
- mention candidate only
- propose creating a typed note
- propose editing repo docs
- propose editing `AGENTS.md`

Expected: `wrap-up` does not blur observation, proposal, and durable edits.

- [x] **Step 3: Improve diary capture edge cases**

Update `skills/diary/SKILL.md`, `commands/diary.md`, and `examples/sample-diary-entry.md` to cover:
- optional session ID when available
- incomplete-context wording
- explicit redaction guidance
- stronger user-preference capture guidance

- [x] **Step 4: Verify `wrap-up` and `diary` align on numbering and diary shape**

Run:

```bash
rg -n "Session:|session number|source of truth|fallback|session ID|redact|User Preferences Observed" skills/wrap-up/SKILL.md skills/diary/SKILL.md commands/diary.md examples/sample-diary-entry.md examples/sample-memory.md
```

Expected:
- one source-of-truth rule for session numbering
- diary template and example still match
- redaction and incomplete-context guidance are explicit

- [ ] **Step 5: Commit (deferred: user requested no automatic commits)**

```bash
git add skills/wrap-up/SKILL.md skills/diary/SKILL.md commands/diary.md examples/sample-diary-entry.md examples/sample-memory.md
git commit -m "docs: tighten wrap-up and diary behavior"
```

### Task 5: Research a Codex-Native Context-Loss Fallback

**Files:**
- Create: `docs/specs/2026-03-20-codex-context-loss-fallback.md`
- Modify: `README.md`

- [x] **Step 1: Inspect local Codex surfaces for safe end-of-session or compaction triggers**

Check local surfaces only:

```bash
find ~/.codex -maxdepth 3 \\( -type f -o -type d \\) | sort | sed -n '1,240p'
rg -n "hook|compact|session|trigger|automation" ~/.codex
```

Expected: enough evidence to decide whether Codex exposes a safe trigger surface without touching Claude.

- [x] **Step 2: Write the decision note**

In `docs/specs/2026-03-20-codex-context-loss-fallback.md`, record:
- what surfaces were checked
- whether a safe Codex-native fallback trigger exists
- if yes: what the opt-in design should be
- if no: the manual recovery workflow and why no automation is being added yet

Do not implement an automatic trigger in this task. This task is decision and design only.

- [x] **Step 3: Update the README with the decision**

Add one short section:
- current fallback state
- whether the system is manual-only for now
- whether future automation is blocked or optional

- [x] **Step 4: Verify no Claude paths or unsupported magic were introduced**

Run:

```bash
rg -n "~/.claude|CLAUDE.md|PreCompact|hook" README.md docs/specs/2026-03-20-codex-context-loss-fallback.md
```

Expected:
- no new `.claude` runtime behavior is introduced
- any contrast mentions of Claude are clearly comparative, not operational
- if hook-like behavior is discussed, it is explicitly marked as Codex-native research only

- [ ] **Step 5: Commit (deferred: user requested no automatic commits)**

```bash
git add docs/specs/2026-03-20-codex-context-loss-fallback.md README.md
git commit -m "docs: record codex context-loss fallback decision"
```

### Task 6: Add Verification Fixtures and Manual Scenarios

**Files:**
- Create: `tests/fixtures/sample-diary-batch/2026-03-20-project-alpha-session-1.md`
- Create: `tests/fixtures/sample-diary-batch/2026-03-21-project-alpha-session-2.md`
- Create: `tests/fixtures/sample-diary-batch/2026-03-22-project-beta-session-1.md`
- Create: `tests/fixtures/sample-project-memory/MEMORY.md`
- Create: `tests/fixtures/sample-project-memory/feedback_local_files_first.md`
- Create: `tests/fixtures/sample-project-memory/project_storage_layout.md`
- Create: `tests/manual-verification.md`

- [x] **Step 1: Add a synthetic diary batch**

The fixture batch must include:
- one one-off observation
- one repeated project lesson
- one repeated cross-project lesson

- [x] **Step 2: Add a sample project-memory fixture**

Include:
- one `MEMORY.md`
- one `feedback_*.md`
- one `project_*.md`

- [x] **Step 3: Write manual verification scenarios**

`tests/manual-verification.md` must include:
- `wrap-up` updates project memory and runs `diary`
- standalone `diary`
- project-filtered `reflect`
- all-project `reflect`
- promotion proposal without auto-apply
- installed skill sync verification

- [x] **Step 4: Verify fixture coverage**

Run:

```bash
find tests -maxdepth 3 -type f | sort
rg -n "wrap-up|standalone diary|project-filtered|all-project|auto-apply|sync verification" tests/manual-verification.md
```

Expected:
- all fixture files exist
- manual scenarios cover the five required behaviors plus install verification

- [ ] **Step 5: Commit (deferred: user requested no automatic commits)**

```bash
git add tests
git commit -m "test: add codex layered learning verification fixtures"
```

### Task 7: Strengthen Installation, Sync, and Maintenance

**Files:**
- Modify: `scripts/install_codex_layered_learning.sh`
- Create: `scripts/verify_codex_layered_learning_install.sh`
- Modify: `README.md`

- [x] **Step 1: Make the installation story explicitly idempotent**

Update `scripts/install_codex_layered_learning.sh` comments or output so rerunning it is clearly safe and intended for updates.

- [x] **Step 2: Add an installation verification script**

Create `scripts/verify_codex_layered_learning_install.sh` that checks:
- installed `~/.agents/skills/{wrap-up,diary,reflect}/SKILL.md` exist
- installed copies match repo source
- `~/.codex/memory/diary/` exists
- `~/.codex/memory/reflections/processed.log` exists
- `~/.codex/projects/` exists

- [x] **Step 3: Document update and uninstall behavior**

Update `README.md` with:
- install
- reinstall/update
- verification
- uninstall/manual cleanup

Do not add destructive cleanup by default; document it only as an explicit manual action.

- [x] **Step 4: Verify the maintenance flow**

Run:

```bash
bash scripts/install_codex_layered_learning.sh
bash scripts/verify_codex_layered_learning_install.sh
```

Expected:
- installer completes without error
- verification script exits 0 and reports all expected runtime files and directories

- [ ] **Step 5: Commit (deferred: user requested no automatic commits)**

```bash
git add scripts/install_codex_layered_learning.sh scripts/verify_codex_layered_learning_install.sh README.md
git commit -m "chore: add codex layered learning install verification"
```

### Task 8: Final Consistency Review

**Files:**
- Modify: `README.md`
- Modify: `docs/specs/2026-03-20-codex-layered-learning-design.md`
- Modify: `docs/plans/2026-03-20-codex-layered-learning-v1-1-hardening.md`

- [x] **Step 1: Re-read the repository after implementation**

Focus on:
- README promises
- runtime skill behavior
- example integrity
- verification coverage
- Claude isolation boundary

- [x] **Step 2: Run the full static consistency sweep**

Run:

```bash
git diff --check
rg -n "~/.claude|CLAUDE.md|repo-local runtime memory|processed\\.log|source of truth|typed memory|project slug" README.md docs skills commands tests scripts
```

Expected:
- `git diff --check` returns clean
- no accidental Claude runtime behavior was introduced
- the new canonical/runtime wording is consistent

- [x] **Step 3: Update plan checkboxes and any stale wording**

Mark completed steps, fix any stale references, and ensure the plan still describes the implemented state.

- [ ] **Step 4: Commit (deferred: user requested no automatic commits)**

```bash
git add README.md docs/specs/2026-03-20-codex-layered-learning-design.md docs/plans/2026-03-20-codex-layered-learning-v1-1-hardening.md
git commit -m "docs: finalize codex layered learning v1.1 hardening"
```
