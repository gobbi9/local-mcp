# Decisions

### 2026-05-18

Decision:
- Use `mcp.toml` as the single source of truth and generate runtime artifacts from it.

Reason:
- Centralized configuration avoids drift across `mise`, Caddy, and launchd.

Consequences:
- Operational changes should be made in `mcp.toml` and regenerated, not hand-edited in outputs.

### 2026-05-18

Decision:
- Resolve service transport using `type` vs `supergatewayProxy`, with inferred direct HTTP mode when both are omitted and `port`/`path` exist.

Reason:
- Support both direct services and transport conversion while keeping config concise.

Consequences:
- Supergateway is used only when transport conversion is required.
- Direct services (including inferred HTTP services) still integrate with Caddy and launchd generation.

### 2026-05-18

Decision:
- Add explicit Caddy handling for Inspector root asset paths when Inspector is mounted under a subpath.

Reason:
- Inspector frontend serves assets from absolute root URLs.

Consequences:
- Generated Caddy routes include `/assets*` and `/mcp.svg` forwarding for Inspector.

### 2026-05-21

Decision:
- Re-seed `.ai` memory for this repository and remove copied context from unrelated projects.

Reason:
- Existing memory/decisions/failures referenced another codebase and polluted context.

Consequences:
- `.ai/memory.md`, `.ai/decisions.md`, and `.ai/failures.md` now describe `mcp` only.

### 2026-05-21

Decision:
- Remove `tests` skill from this `.ai` workspace.

Reason:
- It was copied from another project workflow and does not apply here.

Consequences:
- End-session flow is now `memento -> ai-janitor -> docs`.
- `.ai` docs and prompts no longer reference `tests/SKILL.md`.

### 2026-05-21

Decision:
- Scope `zed-threads` filter to `mcp` and reset cursor baseline (`nu.cursor = 0`).

Reason:
- Thread ingestion must be project-specific and restartable from clean state.

Consequences:
- Historical seeding aligns with this repository’s threads.

### 2026-05-21

Decision:
- Add an idempotency guard for repeated adaptation prompts during thread ingestion.

Reason:
- Duplicate historical prompt records can cause update loops and duplicated entries.

Consequences:
- Replayed adaptation prompt is treated as no-op unless drift is detected.

### 2026-05-21

Decision:
- In `mcp-install.nu`, remove stale LaunchAgents only for managed plist names with the `dev.` prefix.

Reason:
- Avoid deleting unrelated user/system LaunchAgents while still pruning obsolete generated services.

Consequences:
- Install runs now clean up stale `dev.*.plist` entries in `~/Library/LaunchAgents` and leave non-managed plists untouched.