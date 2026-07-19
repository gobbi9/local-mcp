# Local MCP infrastructure commands.
#
# Import this module with `use ~/projects/mcp/mcp.nu *` to run `mcp generate` and `mcp install`.
use ./generate-mcp.nu
use ./mcp-install.nu

# Generate local MCP runtime configuration from `mcp.toml`.
export def "mcp generate" [] {
    generate-mcp
}

# Generate and install the local MCP LaunchAgents.
export def "mcp install" [] {
    mcp-install
}
