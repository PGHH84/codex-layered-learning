# Public Distribution Repo Migration Implementation Plan

Parent: [[docs/MOC]]
Related: [[2026-03-31-codex-claude-full-parity-design]], [[2026-03-31-codex-claude-parity-plan]]

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Split the public GitHub repos from the private Vault authoring repos while preserving meaningful public history, release tags, and runtime-specific documentation.

**Architecture:** Keep the existing Vault repos as private source-of-truth authoring repos. Create two separate public distribution repos under `50_Public-Projects/`, rewrite their history from the engine subtrees, and publish only GitHub-safe runtime layouts at repo root. Future public releases should flow through an export-and-publish pipeline instead of pushing the Vault repos directly.

**Tech Stack:** Git, `git filter-repo`, shell scripts, Markdown docs, GitHub remotes, tags.

**Model Guidance:** The main session cannot switch its own model in place. It can, however, spawn cheaper subagents with explicit `model` and `reasoning_effort` overrides. Use that intentionally:
- Main agent (`gpt-5.4` or current frontier model): orchestrate history rewrites, remote swaps, and final verification.
- Read-only audit workers (`gpt-5.4-mini`, low/medium): inventory files, compare old vs rewritten trees, scan for Vault leakage.
- Mechanical doc check workers (`gpt-5.1-codex-mini`, medium): verify README/INSTALL/link hygiene and release metadata after export.
- Do not delegate the actual destructive or remote-mutating git steps; keep those on the main agent.

---

### Task 1: Freeze Inputs And Define Public Targets

**Files:**
- Create: `/Users/pawelgershkovich/Vault/50_Public-Projects/codex-layered-learning/`
- Create: `/Users/pawelgershkovich/Vault/50_Public-Projects/claude-layered-learning/`
- Modify: `/Users/pawelgershkovich/Vault/30_Projects/38_Codex-Layered-Learning/Engine/381-Codex-Layered-Learning/docs/MOC.md`
- Modify: `/Users/pawelgershkovich/Vault/30_Projects/36_Claude-Layered-Learning/Engine/361-Claude-Layered-Learning/docs/MOC.md` (if a mirrored plan is later added there)

- [ ] **Step 1: Record the source and target repo mapping**

Document the four canonical paths:
- private Codex source repo
- private Claude source repo
- public Codex distribution repo
- public Claude distribution repo

Expected: every later step uses the same source and target directories.

- [ ] **Step 2: Define the public-root file trees**

Lock in the exported public layouts:
- Codex public root contains `README.md`, `LICENSE`, `CHANGELOG.md`, `INSTALL.md`, `AGENTS.md`, `skills/`, `scripts/`, `examples/`, `docs/`
- Claude public root contains `README.md`, `LICENSE`, `CHANGELOG.md`, `INSTALL.md`, `CLAUDE.md`, `skills/`, `commands/`, `hooks/`, `examples/`, `docs/`

Expected: there is no ambiguity about what the public repos should contain after rewrite.

- [ ] **Step 3: Define the hard exclusions**

Document the files and conventions that must not survive into the public repos:
- root `PROJECT.md`
- `Start-Here.md`
- `MOC.md`
- `Status.md`
- Vault wikilinks
- personal OS task/status conventions
- `Engine/361-*` and `Engine/381-*` nesting

Expected: later audits have a concrete deny-list.

### Task 2: Back Up Current Public Remotes Before Rewriting

**Files:**
- Create: `/Users/pawelgershkovich/Vault/50_Public-Projects/_repo-backups/codex-layered-learning.git/`
- Create: `/Users/pawelgershkovich/Vault/50_Public-Projects/_repo-backups/claude-layered-learning.git/`

- [ ] **Step 1: Create mirror backups of the current public remotes**

Run mirror clones for both public GitHub repos into `_repo-backups/`.

Expected: there is a byte-for-byte local fallback before any history rewrite or force-push.

- [ ] **Step 2: Verify tags and default branches in the backups**

Confirm both backups contain:
- `main`
- release tags such as `v1.2.0` and `v1.3.0`

Expected: recovery is possible without depending on GitHub state.

- [ ] **Step 3: Compare public-backup history against private-source history**

Before rewriting from the private source repos, compare:
- release tags
- release commits touching `CHANGELOG.md`
- any public-root docs or metadata commits that may exist only in the current public remotes

Record any public-only commits that must be preserved manually in the rewritten public history.

Expected: the rewrite source is chosen deliberately and does not silently drop meaningful public-only history.

### Task 3: Build Rewritten Public History Candidates

**Files:**
- Create: `/Users/pawelgershkovich/Vault/50_Public-Projects/_staging/codex-layered-learning/`
- Create: `/Users/pawelgershkovich/Vault/50_Public-Projects/_staging/claude-layered-learning/`

- [ ] **Step 1: Clone each private source repo into a disposable staging repo**

Create fresh staging clones from:
- `/Users/pawelgershkovich/Vault/30_Projects/38_Codex-Layered-Learning`
- `/Users/pawelgershkovich/Vault/30_Projects/36_Claude-Layered-Learning`

Expected: the history rewrite happens in disposable clones, not in the private source repos.

- [ ] **Step 2: Filter Codex history down to `Engine/381-Codex-Layered-Learning/`**

Use `git filter-repo` to keep only the Codex engine subtree, then rewrite that path to repo root.

Expected: the staging Codex repo looks like a normal GitHub project rooted at the engine content.

- [ ] **Step 3: Filter Claude history down to `Engine/361-Claude-Layered-Learning/`**

Use `git filter-repo` to keep only the Claude engine subtree, then rewrite that path to repo root.

Expected: the staging Claude repo looks like a normal GitHub project rooted at the engine content.

- [ ] **Step 4: Verify that release tags survived or note which ones must be recreated**

List surviving tags and compare them to the pre-rewrite repos.

Expected: tag continuity is known before any remote swap.

- [ ] **Step 5: Build an explicit old-tag to new-commit mapping table**

For each version tag to preserve:
- identify the old tagged commit in the source history
- identify the corresponding rewritten commit in the staging repo
- record the mapping in the execution notes before any retagging

Preferred matching rule:
- first choice: rewritten commit that contains the same release change to `CHANGELOG.md`
- second choice: rewritten commit with the same commit message and release content

Expected: tag recreation is deterministic rather than ad hoc.

### Task 4: Rebuild Public-Root Docs And Runtime Entry Points

**Files:**
- Modify: `/Users/pawelgershkovich/Vault/50_Public-Projects/_staging/codex-layered-learning/README.md`
- Modify: `/Users/pawelgershkovich/Vault/50_Public-Projects/_staging/codex-layered-learning/AGENTS.md`
- Modify: `/Users/pawelgershkovich/Vault/50_Public-Projects/_staging/claude-layered-learning/README.md`
- Modify: `/Users/pawelgershkovich/Vault/50_Public-Projects/_staging/claude-layered-learning/CLAUDE.md`
- Modify: public `INSTALL.md`, `CHANGELOG.md`, `docs/`, `examples/` as needed in both staging repos

- [ ] **Step 1: Rewrite root README files for normal GitHub users**

Make each README a conventional repo landing page:
- what the project is
- who it is for
- install/verify links
- runtime-specific usage
- release/version notes

Expected: GitHub users no longer land in a Vault-shaped repo with no root explanation.

- [ ] **Step 2: Keep only runtime-appropriate instruction files**

Codex public repo keeps `AGENTS.md`.
Claude public repo keeps `CLAUDE.md`.

Do not keep the private triumvirate in the public repos.

Expected: each public repo targets one runtime user, not the dual-runtime private setup.

- [ ] **Step 3: Remove or rewrite Vault-only references**

Replace or remove:
- wikilinks
- references to `Start-Here.md`, `Status.md`, `MOC.md`
- personal OS registry and task-bucket language

Expected: the public repos read like standalone GitHub projects.

- [ ] **Step 4: Rewrite relative links after the engine-to-root lift**

After filtering and path lifting, audit and fix relative links across:
- `README.md`
- `INSTALL.md`
- `CHANGELOG.md`
- `docs/`
- `examples/`

This includes links that previously assumed the `Engine/361-*` or `Engine/381-*` prefix.

Expected: the exported repos have working root-relative and file-relative links after the path rewrite.

### Task 5: Add Public-Repo Fences Inside The Vault

**Files:**
- Create: local-only root fence files in each public repo working copy if required by the local tooling model
- Modify: public repo local `.git/info/exclude` or equivalent local ignore mechanism if needed

- [ ] **Step 1: Add a local-only root instruction fence to each public repo if needed**

If the public repos live inside the Vault and local tooling would otherwise inherit parent instructions, add an untracked local fence that explicitly says:
- this repo is a public distribution repo
- no Vault wikilinks
- no `Status.md`, `MOC.md`, or personal task conventions
- standard GitHub layout only

Do not commit this fence into the public repo history.

Expected: keeping the public repos inside the Vault does not cause personal OS conventions to leak back in, without reintroducing private authoring conventions into the public repos.

- [ ] **Step 2: Keep the local fence runtime-specific**

Codex public repo root guidance should be Codex-facing.
Claude public repo root guidance should be Claude-facing.

Expected: the local-only fence matches the repo’s target audience and runtime.

### Task 6: Audit The Rewritten Public History

**Files:**
- Modify as needed in both staging repos based on audit findings

- [ ] **Step 1: Run a leakage audit**

Search both staging repos for:
- `[[`
- `Start-Here.md`
- `Status.md`
- `MOC.md`
- `PROJECT.md`
- personal usernames or Vault-private paths not meant for publication

Expected: public repos contain no accidental private-OS traces.

- [ ] **Step 1.5: Confirm no tracked fence files leaked into public history**

Verify that any local-only Vault fence files remain untracked and excluded from commits.

Expected: the public repos stay GitHub-conventional even if local working copies need a Vault override.

- [ ] **Step 2: Run runtime-specific verification**

Codex staging repo:
- run install/verify docs checks
- ensure `AGENTS.md` and skills still agree

Claude staging repo:
- ensure `CLAUDE.md`, commands, hooks, and install docs are coherent

Expected: the rewrite preserves real usability, not just cosmetic cleanliness.

- [ ] **Step 3: Reattach or recreate missing release tags**

If `v1.2.0`, `v1.3.0`, or other relevant tags were lost in filtering, recreate them using the explicit old-tag to new-commit mapping table prepared in Task 3.

Expected: public semantic version history remains intact even though SHAs changed.

### Task 7: Swap The GitHub Remotes Safely

**Files:**
- Modify: public GitHub remotes only

- [ ] **Step 1: Choose a cutover method**

Preferred order:
- archive or rename the current public repos, or keep them untouched until validation is complete
- push the rewritten staging repos to temporary remotes first if you want one last review pass

Expected: there is no irreversible cutover without a rollback path.

- [ ] **Step 2: Push the cleaned histories to the canonical public repo names**

Once validated, force-push the rewritten histories and tags to:
- `PGHH84/codex-layered-learning`
- `PGHH84/claude-layered-learning`

Expected: the public GitHub repos now present the clean distribution history and layout.

- [ ] **Step 3: Verify the GitHub landing pages**

Check:
- root README renders
- tags/releases exist
- repo roots look conventional
- no Vault-only files are visible

Expected: the public repos now look like normal open-source GitHub projects.

### Task 8: Add The Ongoing Publish Workflow

**Files:**
- Create: private-repo export scripts under each engine `scripts/` directory, or a shared private publishing helper location
- Modify: private repo `README.md` / `docs/` to document the new authoring-vs-public split

- [ ] **Step 1: Add a repeatable export command**

Create a publish script or documented command sequence that:
- refreshes the public staging repo from the private source repo
- applies the same file mapping and sanitization rules
- stops before push for human review

Expected: future releases do not require manual repo surgery.

- [ ] **Step 2: Document the new operating model**

Write down:
- private repos are authoring repos
- public repos are distribution repos
- public changes should flow from private source, not the other way around

Expected: future sessions do not regress to pushing Vault repos directly to GitHub.
