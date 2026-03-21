# Example: personal.md for Codex wrap-up

This is a template for `~/.codex/skills/wrap-up/personal.md` — a private machine-local file that extends `wrap-up` with steps specific to your own workflow.

**How it works:** After `wrap-up` updates `MEMORY.md` and before it runs `diary`, it may check whether this file exists at `~/.codex/skills/wrap-up/personal.md`. If it does, Codex follows the instructions here under the normal approval and safety rules. The file stays on your machine and should not be committed to the repo.

Copy this file to `~/.codex/skills/wrap-up/personal.md` and replace the example steps with your own.

---

## Example: append to a private work log

After updating `MEMORY.md`, append a short entry to `~/work-log.md`:

```text
## YYYY-MM-DD — [project name]
- [one sentence: what was done]
- Next: [one sentence: what's next]
```

Create the file if it does not exist.

---

## Other ideas for personal extensions

- Update a private project tracker or status dashboard
- Append to a local planning or time-tracking log
- Trigger a backup step for sensitive local work
- Record a short private summary outside the repository

---

## Guardrails

- This file is optional and machine-local
- Normal approval and safety rules still apply
- Do not write to `~/.claude/**`
- Do not create repo-local runtime memory
- Do not edit repo files unless explicitly requested in-session
- Do not auto-commit, auto-push, auto-deploy, auto-rename, auto-move, or do destructive cleanup
