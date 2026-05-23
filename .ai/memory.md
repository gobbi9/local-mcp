# Project Memory

## Project Overview

- `mcp` is a local MCP infrastructure repository for macOS.
- The canonical source of truth is `mcp.toml` (env, tools, and MCP services).
- Nushell automation generates and installs local runtime infrastructure:
  - `generate-mcp.nu` builds derived configs.
  - `mcp-install.nu` installs/reloads generated LaunchAgents.

## Architecture

- `mcp.toml` defines:
  - shared env vars and tool versions,
  - per-service command, port, path,
  - optional `type` and `supergatewayProxy` transport fields.
- Transport resolution in generation logic:
  - `type != supergatewayProxy` -> wrap service with Supergateway.
  - `type == supergatewayProxy` -> run service directly.
  - both omitted + `port`/`path` present -> infer direct `streamableHttp`.
- Generated artifacts include:
  - `~/.config/mise/config.mcp.toml`
  - `generated/Caddyfile`
  - `generated/launchd/*.plist`
- Caddy reverse-proxies all local endpoints on `localhost:8765`.
- `dev.caddy` launchd generation runs Caddy via `mise x caddy@latest -- caddy run ...` for deterministic startup in launchd context.
- Inspector has special root-asset routing (`/assets*`, `/mcp.svg`) when mounted on `/inspector`.
- GitHub MCP is configured as `stdio -> streamableHttp` via Supergateway and exposed at `/github` on port `10003`.
- GitHub MCP binary provisioning is handled by `mise` using the GitHub backend (`"github:github/github-mcp-server" = "latest"`), so release asset selection (including Darwin arm64) is automatic.
- GitHub PAT is sourced from 1Password at process start via `op run` + secret reference (`op://Personal/gh-cli/token`), avoiding hardcoded tokens in config.

## Conventions

- Edit `mcp.toml` and Nu scripts; avoid manual edits to generated files under `generated/`.
- `openn` is the Nushell alias for Nushell `open`, used to avoid conflict with macOS `open` behavior.
- LaunchAgent management in `mcp-install.nu` is prefix-scoped: only `dev.*.plist` files are considered managed/stale cleanup candidates.
- End-session `.ai` workflow: `memento -> ai-janitor -> docs`.
- Zed-thread ingestion is sequential and cursor-driven via `.ai/skills/zed-threads/state/nu.cursor`.

## Current Priorities

- Keep generator behavior aligned with transport rules in `mcp.toml`.
- Keep `.ai` prompts/skills/docs synchronized after workflow changes.
- Maintain clear, local-first MCP operations through Caddy + launchd.

## Historical Thread Digest (seeded via zed-threads)

- Processed `mcp` thread records sequentially (7 records from baseline cursor window).
- Main themes: MCP generation workflow, Supergateway/Inspector behavior, Mermaid README rendering constraints, and `.ai` workspace adaptation.
- Repeated copies of the same adaptation prompt were observed in history and treated as one logical event.

## Security Notes

- 2026-05-23: A GitHub PAT was exposed in terminal output during troubleshooting. Token was revoked/rotated immediately.
- 2026-05-23: PAT was regenerated via GitHub Web UI and updated in 1Password item `Personal/gh-cli` field `token`.
- Observed behavior: using MCP Inspector triggers 1Password biometric auth on each GitHub MCP tool request (desired), consistent with stateless stdio→streamableHttp proxy behavior.
- Never run commands that print secret values (or raw secret-bearing environment variables) to stdout/stderr.
- When inspecting 1Password items, list only metadata (field labels/types), never field values.

## Loop Guard

- If this same adaptation prompt appears again during thread ingestion, treat it as idempotent.
- Do not re-clear/reseed memory repeatedly when `.ai` already matches this repo (unless real drift is detected).