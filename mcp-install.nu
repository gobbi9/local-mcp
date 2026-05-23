# Initialize MCP services
export def main [] {
    let home = $env.HOME

    let root = $"($home)/.config/mcp"
    let generated = $"($root)/generated"
    let launchagents = $"($home)/Library/LaunchAgents"

    mkdir $launchagents

    print "Generating MCP infrastructure..."
    let generate_script = $"($root)/generate-mcp.nu"
    ^nu -c $"source ($generate_script); main"

    print "Copying launchd plists and reloading services..."

    let managed_plist_prefix = "dev."

    let generated_plists = (
        ls $"($generated)/launchd"
        | where type == file
    )

    let generated_plist_names = (
        $generated_plists
        | get name
        | each { |name| $name | path basename }
    )

    let stale_managed_plists = (
        ls $launchagents
        | where type == file
        | where { |it|
            let basename = ($it.name | path basename)
            let is_managed = (($basename | str starts-with $managed_plist_prefix) and ($basename | str ends-with ".plist"))
            let is_current = ($generated_plist_names | any { |generated_name| $generated_name == $basename })

            $is_managed and (not $is_current)
        }
    )

    $stale_managed_plists | each { |it|
        do {
            launchctl unload $it.name
        } | complete | ignore

        rm -f $it.name
    }

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

    let cfg = (try { openn $"($root)/mcp.toml" } catch { open $"($root)/mcp.toml" })
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
