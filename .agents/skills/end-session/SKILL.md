---
name: end-session
description: Close a session by persisting memory updates, refreshing .agents/README.md, and conditionally updating root README.md.
---

# End Session

Apply `@.agents/skills/memento/SKILL.md`.
Apply `@.agents/skills/ai-janitor/SKILL.md`.
Apply `@.agents/skills/docs/SKILL.md`.

Update:

- `@.agents/memory.md`
- `@.agents/active_context.md`
- `@.agents/decisions.md`
- `@.agents/failures.md`

Finally refresh:

- `@.agents/README.md`
