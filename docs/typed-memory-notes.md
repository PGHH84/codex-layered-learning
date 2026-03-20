# Typed Memory Notes

## Purpose

Typed memory notes are the durable, project-scoped notes stored under `~/.codex/projects/<slug>/memory/`.

The runtime skills decide when to propose them. This document defines the allowed note types, naming policy, and anti-patterns so `wrap-up`, `reflect`, examples, and project memory all use the same taxonomy.

## Allowed note types

### `feedback_*.md`

Use `feedback_*.md` for repeated project lessons, anti-patterns, and guardrails that future work in the same project should follow.

Use it when:

- the lesson has repeated inside one project
- the note should read like reusable advice for future sessions
- the content is about what to do or avoid, not just what exists

Do not use it for one-off incidents, temporary status, or neutral project facts.

### `project_*.md`

Use `project_*.md` for stable project facts such as architecture, storage layout, naming conventions, invariants, or repository-specific operating rules.

Use it when:

- the note describes how this project is structured
- the fact should remain true across multiple sessions
- future work would benefit from reloading the fact quickly

Do not use it for transient task state or general cross-project guidance.

### `reference_*.md`

Use `reference_*.md` for supporting material that helps interpret or apply other guidance, such as routing maps, glossaries, checklists, lookup-oriented conventions, or compact reference tables.

Use it when:

- the content is consulted more like a lookup than a rule
- the material supports multiple future decisions in the project
- the information is durable but secondary to the project’s primary policy docs

Do not use it when an existing repo doc already owns the subject more clearly.

### `user_*.md`

Use `user_*.md` for stable recurring user or project preferences that materially change how Codex should operate in this project.

Use it when:

- the preference has repeated enough to look durable
- the preference changes implementation or collaboration behavior
- keeping it in project memory will reduce repeated correction

Do not use it for one-session preferences, temporary requests, or stylistic noise that does not materially affect future work.

## Naming expectations

- Filenames must start with one of the four exact prefixes: `feedback_`, `project_`, `reference_`, or `user_`
- Use lowercase snake_case after the prefix
- Keep the topic short, specific, and durable
- Use one durable lesson or fact per file
- Do not include dates, session numbers, branches, or temporary ticket IDs in filenames
- Prefer strengthening an existing note over creating a near-duplicate sibling

Examples:

- `feedback_no_repo_local_memory.md`
- `project_storage_layout.md`
- `reference_scope_routing.md`
- `user_prefers_explicit_verification.md`

## Recommended note shape

Typed notes should be easy to scan and easy to link from `MEMORY.md`.

Recommended structure:

```md
---
name: short-topic-name
description: One-sentence explanation of why this note exists
type: feedback | project | reference | user
---

[One short durable statement]

**Why:** [evidence or rationale]

**How to apply:** [practical reuse guidance]
```

## Selection rules

Choose the smallest durable owner that matches the content:

- If it is a stable project fact, use `project_*.md`
- If it is a repeated project lesson or guardrail, use `feedback_*.md`
- If it is supporting lookup material, use `reference_*.md`
- If it is a stable recurring preference, use `user_*.md`

If none of those fit cleanly, the information probably belongs in `MEMORY.md`, a repo doc, `AGENTS.md`, a skill, or only in the current reflection.

## Anti-patterns

- Creating a typed note for a one-off observation
- Using `MEMORY.md` as a second diary or status log
- Splitting one concept across several near-duplicate notes
- Copying large chunks of repo docs, `AGENTS.md`, or skill text into project memory
- Storing secrets, raw tokens, credentials, or sensitive customer data
- Creating repo-local runtime memory folders instead of using `~/.codex/`

## When not to create a new note

Do not create a new typed note when:

- the observation is weak, new, contradictory, or still under review
- the content is temporary execution state that belongs in `## Current State`
- an existing typed note can be edited to absorb the new evidence
- repo docs, `AGENTS.md`, or a skill is the clearer durable destination
- the only change is a supporting citation that does not create a new durable concept
