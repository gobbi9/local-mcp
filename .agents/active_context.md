# Active Context

## Current Task

- Improve MCP endpoint discoverability for agents at `http://localhost:8765` while keeping config-driven generation.
- Ensure discovery metadata is generated from `mcp.toml` and served reliably via Caddy root (`GET /`).
- Reduce noisy/unused discovery fields and keep only practical protocol + client-hint guidance.

## Open Issues

- No current blocking issues after the latest regeneration/install verification.
- Operational caveat: stale Nushell session-loaded functions can still confuse manual runs if users invoke old in-memory definitions.

## Next Steps

1. Continue running generation/install via fresh Nu process when debugging drift:
   - `nu -c 'source ~/projects/mcp/generate-mcp.nu; main'`
   - `nu -c 'source ~/projects/mcp/mcp-install.nu; main'`
2. Keep discovery structure minimal and driven by `[discovery]` in `mcp.toml`.
3. If agent behavior still over-requests, tune only `discovery.clientHints` (not service-level hint clutter).

## Recently Changed

- Added generated discovery manifest output: `~/projects/mcp/generated/discovery.json`.
- Added Caddy root route generation so `GET http://localhost:8765` serves `discovery.json`.
- Added `[discovery]`, `[discovery.protocol]`, and `[discovery.clientHints]` metadata in `mcp.toml` and wired generator to emit it.
- Removed service-level discovery clutter (`intentKeywords`, `examples`, `preferredForIntents`, `defaultTool`, `knownTools`) from both `mcp.toml` and generated output.
- Simplified generator to treat `clientHints` as source-of-truth from `mcp.toml` (no duplicated hardcoded structure).
- Hardened `mcp-install.nu` to execute `generate-mcp.nu` from disk in a fresh Nu process each run.
