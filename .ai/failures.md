# Failures and Dead Ends

### 2026-05-18

Attempted:
- A Mermaid dependency diagram variant that failed to parse/render in GitHub.

Why it failed:
- Mermaid node naming/formatting produced parser incompatibility.

What was learned:
- Keep Mermaid IDs simple and avoid reserved/conflicting identifiers for GitHub-safe diagrams.

### 2026-05-23

Attempted:
- Configure GitHub MCP PAT reference as `op://Personal/gh-cli/password`.

Why it failed:
- The 1Password item field is named `token`, not `password`; `op run` failed and child process exited.

What was learned:
- Verify 1Password field labels before wiring secret references.

### 2026-05-23

Attempted:
- Generate Caddy LaunchAgent with direct binary path resolved from Nu (`which caddy | get path | first`).

Why it failed:
- In this environment, lookup yielded an empty program path in plist, and launchd failed (`EX_CONFIG` / exit code 78).

What was learned:
- For launchd reliability, use deterministic invocation through `mise` rather than brittle path inference.

### 2026-05-23

Attempted:
- Inspect 1Password data during debugging with an unsafe command that surfaced secret content in terminal output.

Why it failed:
- Secret value exposure occurred in command output.

What was learned:
- Never print secret values during diagnostics; inspect only field metadata and rotate compromised credentials immediately.

## Baseline Status

- Historical baseline retained; new entries above capture current session failures and lessons.

## Loop Guard

- If zed-thread ingestion replays the same `.ai` adaptation prompt, do not repeatedly reset or duplicate memory entries.
- Treat repeats as historical duplicates unless current `.ai` state has drifted.