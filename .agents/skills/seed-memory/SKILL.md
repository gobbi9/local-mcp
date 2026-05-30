---
name: seed-memory
description: Seed memory by ingesting historical Zed threads and summarizing them into project memory artifacts.
---

# Seed Memory

Apply `@.agents/skills/zed-threads/SKILL.md`.
Apply `@.agents/skills/theory-of-mind/SKILL.md`.
Apply `@.agents/skills/ai-janitor/SKILL.md`.

Use `zed-threads` to ingest and process thread records incrementally before updating memory files.

Then update:

- `@.agents/memory.md`
- `@.agents/active_context.md`
- `@.agents/decisions.md`
- `@.agents/failures.md`

Finally refresh:

- `@.agents/README.md`
