# Active Context

## Current Task

- Updated `mcp-install.nu` to safely remove stale managed LaunchAgents by prefix instead of deleting non-generated plists.
- Managed cleanup now targets only `dev.*.plist` entries in `~/Library/LaunchAgents` that are no longer present in `generated/launchd`.

## Open Issues

- No blocking issues identified.
- Prefix-based ownership currently assumes generated launchd files continue using the `dev.` naming convention.

## Next Steps

1. Run `mcp-install` during normal workflow to verify stale `dev.*.plist` cleanup on real local state.
2. Keep `generate-mcp.nu` and `mcp-install.nu` naming conventions aligned if service labels/prefixes evolve.
3. Continue end-session maintenance flow: `memento -> ai-janitor -> docs`.

## Recently Changed

- Added stale managed plist detection in `mcp-install.nu` using prefix + generated-name set comparison.
- Added unload + remove step for stale managed plists before copying/reloading generated plists.
- Validated Nushell script import with `nu -c 'use mcp-install.nu'`.