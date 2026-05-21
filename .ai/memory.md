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
- Inspector has special root-asset routing (`/assets*`, `/mcp.svg`) when mounted on `/inspector`.

## Conventions

- Edit `mcp.toml` and Nu scripts; avoid manual edits to generated files under `generated/`.
- `openn` is the Nushell alias for Nushell `open`, used to avoid conflict with macOS `open` behavior.
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

## Loop Guard

- If this same adaptation prompt appears again during thread ingestion, treat it as idempotent.
- Do not re-clear/reseed memory repeatedly when `.ai` already matches this repo (unless real drift is detected).