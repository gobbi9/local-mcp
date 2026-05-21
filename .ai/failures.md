# Failures and Dead Ends

### 2026-05-18

Attempted:
- A Mermaid dependency diagram variant that failed to parse/render in GitHub.

Why it failed:
- Mermaid node naming/formatting produced parser incompatibility.

What was learned:
- Keep Mermaid IDs simple and avoid reserved/conflicting identifiers for GitHub-safe diagrams.

## Baseline Status

- No additional project-specific failed implementation attempts are currently recorded in this refreshed baseline.

## Loop Guard

- If zed-thread ingestion replays the same `.ai` adaptation prompt, do not repeatedly reset or duplicate memory entries.
- Treat repeats as historical duplicates unless current `.ai` state has drifted.