# Codex Public Repository Documentation Design

**Date:** 2026-03-21

## Goal

Prepare `Codex-Layered-Learning` for public release as a Codex-native, OpenAI-oriented repository that is useful to:

- Codex desktop users
- Codex CLI users
- IDE or API-driven OpenAI coding workflows that can use the same local skill files and runtime storage conventions

The public repository should be understandable from the top-level docs alone while remaining faithful to the current runtime contract in `skills/`.

## Non-Goals

- Reframing the project around ChatGPT
- Reintroducing Claude-compatible hooks, commands, or runtime files
- Changing the runtime architecture to match the older Claude repository
- Publishing live private runtime files from `~/.codex/`
- Turning reference docs into the behavior source of truth

## Design Principles

### 1. Optimize for Codex, not for symmetry with Claude

The Claude repository is a reference and input, not the target shape.

Codex public docs should center:

- `~/.codex/` runtime storage
- repository `skills/` as runtime authority
- `commands/` as reference-only summaries
- approval-gated durable promotions
- manual-first operation where no safe Codex-native hook surface exists

### 2. Treat Codex desktop, CLI, and API-driven coding runtimes as one family

The core architecture does not change between Codex desktop, CLI, IDE, or API-oriented coding usage.

Only the integration surface may differ:

- whether installed skills are auto-discovered
- how the user invokes the skills
- whether additional automation exists outside this repo

Top-level docs should explain one shared model and mention surface-specific caveats only where they materially affect setup.

### 3. Keep the runtime contract anchored in `skills/`

Public documentation must reinforce the current behavior model:

- `skills/wrap-up/SKILL.md`
- `skills/diary/SKILL.md`
- `skills/reflect/SKILL.md`

Top-level docs should explicitly say that behavioral changes land in `skills/` first, then flow outward into supporting docs, examples, and scripts.

### 4. Make the public repository complete on its own

The repository should include the standard public-release surfaces expected by a new user:

- `README.md`
- `INSTALL.md`
- `CHANGELOG.md`
- `LICENSE`
- root `AGENTS.md`

These docs should explain what the project is, how to install it, how to verify it, and what guarantees or limitations apply.

### 5. Sanitize public examples

Public examples and fixtures should not depend on one private machine layout.

They may still show realistic file paths and machine-local extension patterns, but should:

- avoid personal usernames in examples where not required
- avoid presenting a private workflow as the default expected setup
- keep `examples/personal.md` as a redacted optional pattern

## Public Information Architecture

### README

The README should answer, in order:

1. what Codex Layered Learning is
2. who it is for
3. how the two loops work
4. what each loop can touch
5. how to install and verify
6. where the runtime files live
7. how the optional personal extension works
8. how this differs from Claude Layered Learning

### INSTALL

`INSTALL.md` should be the operational guide for:

- prerequisites
- install
- verify
- optional personal-extension setup
- update
- uninstall or manual cleanup
- troubleshooting

It should describe the actual repository scripts and make clear that there is no Claude-style hook flow in this repo.

### CHANGELOG

`CHANGELOG.md` should establish a public semver contract for releases.

At minimum it should:

- define semver expectations
- record the initial public Codex release
- summarize the currently implemented runtime surfaces and safety boundaries

### Root AGENTS

The root `AGENTS.md` should be the Codex-native equivalent of the Claude repo's root guidance file, adapted to this repository's architecture.

It should cover:

- repo purpose
- file structure
- runtime-authority rule
- sync and verification expectations
- public-release hygiene, including sanitization and versioning

## Required Documentation Changes

### Add

- `INSTALL.md`
- `CHANGELOG.md`
- `LICENSE`
- `AGENTS.md`
- `docs/specs/2026-03-21-codex-public-repo-documentation-design.md`
- `docs/plans/2026-03-21-codex-public-repo-documentation.md`
- `.gitignore`

### Rewrite or tighten

- `README.md`
- `examples/personal.md`
- `examples/sample-diary-entry.md`
- sample fixtures that still carry personal-machine paths
- any public-facing slug example that unnecessarily embeds the local username

## Sanitization Rules

When preparing the public repo:

- use generic paths such as `/Users/example/...` where a concrete absolute path helps
- keep `~/.codex/` paths literal because they are part of the real runtime contract
- keep `~/.claude/**` warnings literal because they are part of the safety boundary
- treat `examples/personal.md` as a redacted optional pattern, not a copy of the live private file

## Acceptance Criteria

The public-release documentation pass is complete when:

- a new Codex/OpenAI coding user can understand the system from the root docs alone
- install and verify instructions match the actual scripts
- the repo has a license and changelog
- the repo includes Codex-native root guidance
- public-facing examples no longer depend on the personal username or private status-file example when a generic example is sufficient
- the top-level docs stay consistent with the current runtime skills
