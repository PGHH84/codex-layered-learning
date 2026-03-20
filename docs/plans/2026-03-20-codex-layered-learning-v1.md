# Codex Layered Learning V1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first working Codex-native layered learning system with markdown as the source of truth, centralized diary/reflection storage, project-scoped memory, and approval-gated promotion targets.

**Architecture:** The system is documentation-first and file-first. Runtime memory lives under `~/.codex/`, while this repository contains the commands, skills, schemas, and examples used to operate that runtime safely. Claude-compatible behavior is explicitly out of scope.

**Tech Stack:** Markdown, Codex skills/command docs, shell for file operations, optional Python stdlib helpers, markdown examples, manual verification scenarios.

---

### Task 1: Repository Scaffolding

**Files:**
- Create: `README.md`
- Create: `docs/specs/2026-03-20-codex-layered-learning-design.md`
- Create: `docs/plans/2026-03-20-codex-layered-learning-v1.md`
- Create: `examples/sample-memory.md`
- Create: `examples/sample-diary-entry.md`
- Create: `examples/sample-reflection.md`
- Create: `examples/feedback-local-files-first.md`

- [ ] **Step 1: Verify the repository skeleton exists**

Run: `find . -maxdepth 2 -type d | sort`
Expected: `docs/`, `docs/specs/`, `docs/plans/`, and `examples/` exist

- [ ] **Step 2: Review the written design against user constraints**

Check for:
- no `.claude` runtime writes
- no repo-local memory folders
- `wrap-up` triggers `diary`
- `diary` and `reflect` can run standalone

Expected: all constraints are documented explicitly

- [ ] **Step 3: Review the examples for consistency with the schemas**

Check:
- headings
- metadata shape
- promotion language
- no Claude-specific surfaces

Expected: examples match the design spec exactly enough to guide implementation

- [ ] **Step 4: Commit the documentation scaffold**

```bash
git add README.md docs/specs docs/plans examples
git commit -m "docs: add codex layered learning design and examples"
```

### Task 2: Author `diary` Command Specification

**Files:**
- Create: `commands/diary.md`
- Modify: `README.md`
- Test: `examples/sample-diary-entry.md`

- [ ] **Step 1: Write the command contract**

Document:
- inputs
- output file path convention
- context-first behavior
- fallback to session logs only when needed
- secret-handling rules

- [ ] **Step 2: Add the exact diary entry template**

Include:
- task summary
- work summary
- design decisions
- actions taken
- verification performed
- user preferences

- [ ] **Step 3: Verify the contract against the example**

Check: every required section in `commands/diary.md` exists in `examples/sample-diary-entry.md`

Expected: no missing sections

- [ ] **Step 4: Update `README.md` command summary**

Add `diary` to the repository overview and usage section

- [ ] **Step 5: Commit**

```bash
git add commands/diary.md README.md examples/sample-diary-entry.md
git commit -m "docs: define diary command"
```

### Task 3: Author `wrap-up` Skill Specification

**Files:**
- Create: `skills/wrap-up/SKILL.md`
- Modify: `README.md`
- Test: `examples/sample-memory.md`

- [ ] **Step 1: Write the `wrap-up` skill frontmatter and trigger description**

Include:
- end-of-session trigger phrases
- non-goals
- hard safety boundaries

- [ ] **Step 2: Define the execution sequence**

Sequence must be:
1. inspect session
2. update project memory
3. trigger `diary`
4. report optional promotions

- [ ] **Step 3: Define what `wrap-up` must never do automatically**

Must forbid:
- repo-local runtime memory folders
- `.claude` writes
- auto commit/push/deploy
- automatic durable instruction changes

- [ ] **Step 4: Verify memory update behavior**

Check `skills/wrap-up/SKILL.md` against `examples/sample-memory.md`

Expected: skill instructions explain how to keep `MEMORY.md` concise and indexed

- [ ] **Step 5: Commit**

```bash
git add skills/wrap-up/SKILL.md README.md examples/sample-memory.md
git commit -m "docs: define wrap-up skill"
```

### Task 4: Author `reflect` Command Specification

**Files:**
- Create: `commands/reflect.md`
- Modify: `README.md`
- Test: `examples/sample-reflection.md`

- [ ] **Step 1: Write the reflection inputs and filters**

Include:
- all entries
- last N
- date range
- project slug
- keyword

- [ ] **Step 2: Define routing and confidence logic**

Include:
- one-off vs repeated patterns
- project-specific vs global scope
- candidate destinations
- approval model

- [ ] **Step 3: Define `processed.log` behavior**

Document:
- default skip processed entries
- reprocess options
- reflection output naming

- [ ] **Step 4: Verify the reflection template**

Check `commands/reflect.md` against `examples/sample-reflection.md`

Expected: sections and promotion buckets match

- [ ] **Step 5: Commit**

```bash
git add commands/reflect.md README.md examples/sample-reflection.md
git commit -m "docs: define reflect command"
```

### Task 5: Author Typed Memory Note Policy

**Files:**
- Create: `docs/typed-memory-notes.md`
- Test: `examples/feedback-local-files-first.md`

- [ ] **Step 1: Document allowed note types**

Define:
- `feedback_*.md`
- `project_*.md`
- `reference_*.md`
- `user_*.md`

- [ ] **Step 2: Define when each note type is appropriate**

Include:
- examples
- anti-patterns
- when not to create a new file

- [ ] **Step 3: Verify note template compatibility**

Check `docs/typed-memory-notes.md` against `examples/feedback-local-files-first.md`

Expected: example fully conforms to policy

- [ ] **Step 4: Commit**

```bash
git add docs/typed-memory-notes.md examples/feedback-local-files-first.md
git commit -m "docs: define typed memory note policy"
```

### Task 6: Add Lightweight Verification Fixtures

**Files:**
- Create: `tests/fixtures/sample-diary-batch/`
- Create: `tests/fixtures/sample-project-memory/`
- Create: `tests/manual-verification.md`

- [ ] **Step 1: Add fixture diary entries**

Create a small synthetic batch with:
- one one-off observation
- one repeated project lesson
- one repeated cross-project lesson

- [ ] **Step 2: Add a sample project memory fixture**

Include:
- `MEMORY.md`
- one `feedback_*.md`
- one `project_*.md`

- [ ] **Step 3: Write manual verification scenarios**

Scenarios:
- `wrap-up` updates project memory and runs `diary`
- `diary` standalone
- `reflect` project-filtered
- `reflect` all-project
- promotion proposal without auto-apply

- [ ] **Step 4: Commit**

```bash
git add tests/fixtures tests/manual-verification.md
git commit -m "test: add codex layered learning verification fixtures"
```

### Task 7: Add Optional Search-Index Design Stub

**Files:**
- Create: `docs/future-indexing.md`

- [ ] **Step 1: Document the v2 index constraints**

Include:
- markdown remains canonical
- index is optional
- no behavior change for core commands

- [ ] **Step 2: Describe likely index backends**

Compare:
- SQLite metadata index
- MCP-backed semantic search

- [ ] **Step 3: Commit**

```bash
git add docs/future-indexing.md
git commit -m "docs: add future indexing design stub"
```
