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

### 2026-05-23

Decision:
- Add a local GitHub MCP service using the upstream release binary via `mise` GitHub backend (`"github:github/github-mcp-server" = "latest"`), proxied as `stdio -> streamableHttp`.
- Source `GITHUB_PERSONAL_ACCESS_TOKEN` from 1Password at runtime using `op run` and secret reference `op://Personal/gh-cli/password`.

Reason:
- Avoid Docker dependency for this MCP service.
- Keep version resolution generic (`latest`) and platform-aware (Darwin arm64 asset selected by `mise`).
- Keep PAT out of config files and require successful 1Password resolution at service startup.

Consequences:
- `mcp.github` is available at `/github` on port `10003`.
- Startup behavior now depends on 1Password CLI/app availability in the user session.
- Token retrieval occurs at process start (not guaranteed per individual MCP tool call).

### 2026-05-23

Decision:
- Use 1Password secret reference `op://Personal/gh-cli/token` (not `.../password`) for GitHub PAT injection.

Reason:
- The `gh-cli` item field label is `token`; using `password` causes child process startup failures.

Consequences:
- GitHub MCP startup now succeeds after biometric auth and token resolution.
- PAT remains externalized to 1Password with no hardcoded secret in config.

### 2026-05-23

Decision:
- Generate `dev.caddy` LaunchAgent to run Caddy through `mise` (`/opt/homebrew/bin/mise x caddy@latest -- caddy run ...`) instead of relying on a resolved direct `caddy` path from Nu lookup.

Reason:
- Nu path lookup produced an empty caddy program path in generated plist in this environment, causing launchd exit code 78.

Consequences:
- Caddy startup is deterministic in launchd-managed runs.
- `localhost:8765` proxy availability no longer depends on shell PATH resolution quirks.

### 2026-05-23

Decision:
- Expose a generated discovery document at gateway root (`GET http://localhost:8765`) and generate it from `mcp.toml` metadata.

Reason:
- Give agents a single bootstrap endpoint to discover MCP routes and protocol expectations.

Consequences:
- `generate-mcp.nu` now writes `generated/discovery.json` and generates a Caddy root handler that rewrites `/` to that file.
- Root discovery behavior is regenerated on every `mcp-install` run.

### 2026-05-23

Decision:
- Use `[discovery]` in `mcp.toml` as source of truth for discovery protocol/client-hint metadata and keep service entries minimal.

Reason:
- Avoid duplicated/overly noisy fields while preserving practical guidance for agent request order.

Consequences:
- Discovery JSON includes protocol + client hints from config.
- Service-level hint clutter (`intentKeywords`, `examples`, `preferredForIntents`, `defaultTool`, `knownTools`) was removed.

### 2026-05-23

Decision:
- In `mcp-install.nu`, run `generate-mcp.nu` from disk in a fresh Nu process (`nu -c ...`) instead of relying on imported in-session function state.

Reason:
- Prevent stale Nushell definitions from regenerating outdated Caddy/discovery outputs.

Consequences:
- Install runs are deterministic across long-lived shell sessions.
- Troubleshooting guidance now favors explicit fresh-process invocation when drift is suspected.

### 2026-06-08

Decision:
- Split GitHub MCP service into two explicit services in `mcp.toml`: `mcp.github-personal` and `mcp.github-opensockets`, each with its own 1Password token reference and endpoint.

Reason:
- Support separate account/org contexts without token swapping and keep endpoint intent explicit.

Consequences:
- New endpoints are `/github-personal/mcp` and `/github-opensockets/mcp`.
- Generated launchd services are `dev.mcp.github-personal` and `dev.mcp.github-opensockets`.

### 2026-06-08

Decision:
- In `generate-mcp.nu`, clear stale managed `dev.*.plist` files from `generated/launchd` before generating new plist artifacts.

Reason:
- `mcp-install.nu` stale cleanup compares LaunchAgents against files present in `generated/launchd`; stale generated files prevented legacy services from being recognized as stale.

Consequences:
- Removed/renamed MCP services no longer persist due to leftover generated plist files.
- `mcp-install.nu` stale removal now works end-to-end as intended.