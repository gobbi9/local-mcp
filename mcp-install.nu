use generate-mcp.nu

# Initialize MCP services
export def main [] {
    let home = $env.HOME

    let root = $"($home)/.config/mcp"
    let generated = $"($root)/generated"
    let launchagents = $"($home)/Library/LaunchAgents"

    mkdir $launchagents

    print "Generating MCP infrastructure..."
    generate-mcp

    print "Copying launchd plists and reloading services..."

    let generated_plists = (
        ls $"($generated)/launchd"
        | where type == file
    )

    $generated_plists
    | each { |it|
        cp -f $it.name $launchagents
    }

    let loaded = (
        $generated_plists
        | each { |it|
            { name: $"($launchagents)/($it.name | path basename)" }
        }
    )

    $loaded | each { |it|
        do {
            launchctl unload $it.name
        } | complete | ignore

        launchctl load $it.name
    }

    let cfg = openn $"($root)/mcp.toml"
    let mcp_cfg = ($cfg | get -o mcp | default {})
    let mcp_entries = ($mcp_cfg | transpose name value)

    let http_services = (
        $mcp_entries
        | where { |it|
            let input_type_raw = ($it.value | get -o type)
            let proxy_type_raw = ($it.value | get -o supergatewayProxy)

            let input_type = ($input_type_raw | default "stdio")
            let proxy_type = ($proxy_type_raw | default $input_type)

            let has_http_binding = (($it.value | get -o port) != null) and (($it.value | get -o path) != null)
            let inferred_direct_http = (($input_type_raw == null) and ($proxy_type_raw == null) and $has_http_binding)

            let effective_type = if $inferred_direct_http {
                "streamableHttp"
            } else if $input_type != $proxy_type {
                $proxy_type
            } else {
                $input_type
            }

            $has_http_binding and ($effective_type == "streamableHttp" or $effective_type == "sse")
        }
    )

    let loaded_services = (
        $loaded
        | each { |it| $"  ($it.name | path basename)" }
        | str join "\n"
    )

    let log_commands = (
        $http_services
        | each { |it| [
            $"  tail -f /tmp/mcp-($it.name).stdout.log",
            $"  tail -f /tmp/mcp-($it.name).stderr.log"
        ] }
        | flatten
        | str join "\n"
    )

    let proxy_endpoints = (
        $http_services
        | each { |it|
            let input_type_raw = ($it.value | get -o type)
            let proxy_type_raw = ($it.value | get -o supergatewayProxy)

            let input_type = ($input_type_raw | default "stdio")
            let proxy_type = ($proxy_type_raw | default $input_type)
            let use_supergateway = ($input_type != $proxy_type)

            let base = $"http://localhost:8765($it.value.path)"

            let endpoint_suffixes = if (not $use_supergateway) {
                [""]
            } else {
                match $proxy_type {
                    "streamableHttp" => ["/mcp"]
                    "sse" => ["/sse" "/message"]
                    _ => [""]
                }
            }

            $endpoint_suffixes | each { |suffix| $"  ($base)($suffix)" }
        }
        | flatten
        | str join "\n"
    )

    print $"MCP services installed.\n\nLoaded services:\n($loaded_services)\n\nLog commands:\n($log_commands)\n\nProxy endpoints:\n($proxy_endpoints)"
}
