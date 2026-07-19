# Active Context

## Current Task

- Added documented, namespaced Nushell commands for MCP infrastructure operations.

## Open Issues

- No current blocking issues.

## Next Steps

1. Import the public command module with `use ~/projects/mcp/mcp.nu *`.
2. Use `mcp generate` after editing `mcp.toml`; use `mcp install` to regenerate and reload managed LaunchAgents.
3. Continue using fresh Nu processes for troubleshooting to avoid stale in-memory definitions.

## Recently Changed

- Added `mcp.nu` with thin `mcp generate` and `mcp install` delegators, retaining the implementations in `generate-mcp.nu` and `mcp-install.nu`.
- Added command documentation to both exported `main` functions and updated the README with module import and usage instructions.
- Confirmed that importing `mcp.nu` with `*` exposes both commands and their Nushell help text.
