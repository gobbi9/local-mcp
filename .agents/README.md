# .agents Workspace Guide

This file documents skills, memory artifacts, and state files under `.agents`.

## Skills

- `start-session/SKILL.md`: session bootstrap skill that loads persistent memory artifacts.
- `end-session/SKILL.md`: session close-out skill that persists new learnings into memory artifacts, refreshes `.agents/README.md`, and conditionally updates root `README.md` via `docs`.
- `seed-memory/SKILL.md`: historical seeding skill that ingests Zed threads and reconstructs long-term memory files.
- `memento/SKILL.md`: maintains session-to-session memory continuity (`memory.md`, `active_context.md`, `decisions.md`, `failures.md`).
- `theory-of-mind/SKILL.md`: compresses historical discussions into coherent project memory.
- `zed-threads/SKILL.md`: ingests Zed `threads.db` incrementally with cursor state.
- `ai-janitor/SKILL.md`: keeps this README synchronized whenever `.agents` artifacts change.
- `docs/SKILL.md`: updates root `README.md` only when non-`.agents` files changed in the session.

## Other Markdown Files

- `memory.md`: durable project overview, architecture, constraints, conventions, and security notes (including discovery/serving model).
- `active_context.md`: current focus, immediate issues, and next actions.
- `decisions.md`: chronological log of key technical/product decisions (including discovery endpoint and generation workflow choices).
- `failures.md`: chronological log of failed approaches and lessons learned (including stale Nu session pitfalls and stale generated launchd artifact pitfalls).
- `README.md`: canonical `.agents` workspace index and dependency map.

## State and Support Files

- `skills/zed-threads/state/nu.cursor`: integer cursor for incremental Zed-thread ingestion progress.

## Dependency Graph

### Start-session flow

```mermaid
graph LR
  startSkill["start-session/SKILL.md"] --> memento["memento/SKILL.md"]
  memento --> memory["memory.md"]
  memento --> active["active_context.md"]
  memento --> decisions["decisions.md"]
  memento --> failures["failures.md"]
```

### Seed-memory flow

```mermaid
graph LR
  seedSkill["seed-memory/SKILL.md"] --> zed["zed-threads/SKILL.md"]
  seedSkill --> tom["theory-of-mind/SKILL.md"]
  seedSkill --> janitor["ai-janitor/SKILL.md"]

  zed --> cursor["zed-threads/state/nu.cursor"]

  tom --> memory["memory.md"]
  tom --> active["active_context.md"]
  tom --> decisions["decisions.md"]
  tom --> failures["failures.md"]

  janitor --> readme["README.md"]
```

### End-session flow

```mermaid
graph LR
  endSkill["end-session/SKILL.md"] --> memento["memento/SKILL.md"]
  endSkill --> janitor["ai-janitor/SKILL.md"]
  endSkill --> docs["docs/SKILL.md"]

  memento --> memory["memory.md"]
  memento --> active["active_context.md"]
  memento --> decisions["decisions.md"]
  memento --> failures["failures.md"]

  janitor --> readme["README.md"]
  docs --> projectReadme["../README.md"]
```
