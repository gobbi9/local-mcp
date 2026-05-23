# Active Context

## Current Task

- Added and debugged a new GitHub MCP service (`[mcp.github]`) in `mcp.toml`.
- Service now runs `github-mcp-server` as local binary via `mise` and is exposed through Supergateway (`stdio -> streamableHttp`) at `/github` on port `10003`.
- PAT loading is wired to 1Password via `op run` with secret reference `op://Personal/gh-cli/token`.

## Open Issues

- No blocking runtime issues are currently open for GitHub MCP after fixes.
- Security follow-up completed: previously exposed PAT was revoked and replaced.

## Next Steps

1. Keep using `mcp-install` after `mcp.toml`/generator changes.
2. If needed later, add a lightweight health endpoint for easier browser/curl liveness checks.
3. Optionally evaluate `stateful` Supergateway mode if session semantics are preferred over per-request auth prompts.

## Recently Changed

- Added `GITHUB_MCP_CMD`, `"github:github/github-mcp-server" = "latest"`, and `[mcp.github]` in `mcp.toml`.
- Corrected 1Password field reference from `password` to `token`.
- Verified observed behavior: Inspector-triggered GitHub MCP requests prompt 1Password biometric auth per request in current stateless mode.
- Fixed Caddy LaunchAgent generation in `generate-mcp.nu` to run Caddy via `mise x caddy@latest -- caddy run ...`, avoiding launchd path resolution failures.
- Regenerated and reloaded services with `mcp-install`; confirmed `http://localhost:8765/github/mcp` responds to MCP initialize requests.
