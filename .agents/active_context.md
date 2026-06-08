# Active Context

## Current Task

- Session closed after splitting GitHub MCP into personal and opensockets services and fixing stale generated launchd artifact cleanup.

## Open Issues

- No current blocking issues.

## Next Steps

1. Keep using `mcp.toml` as source of truth for MCP service definitions.
2. If service entries are removed/renamed again, run `nu mcp-install.nu` and verify `generated/launchd` + `~/Library/LaunchAgents` match.
3. Continue using fresh Nu processes for troubleshooting to avoid stale in-memory definitions.

## Recently Changed

- Renamed `mcp.github` to `mcp.github-personal` and added `mcp.github-opensockets`.
- Added separate env commands for GitHub MCP startup with distinct 1Password token refs (`Personal` and `Opensockets`).
- Updated proxy/discovery endpoints to `/github-personal/mcp` and `/github-opensockets/mcp`.
- Fixed `generate-mcp.nu` to remove stale managed `dev.*.plist` files in `generated/launchd` before regeneration.
- Verified `mcp-install.nu` now removes legacy `dev.mcp.github.plist` end-to-end.
