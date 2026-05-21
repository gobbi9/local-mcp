# Active Context

## Current Task

- `.ai` workspace has been adapted from copied state to this `mcp` repository.
- Stale memory/decisions/failures from unrelated projects were replaced.

## Open Issues

- No blocking issues identified.
- Future memory enrichment should continue via incremental `zed-threads` processing.

## Next Steps

1. Continue using `zed-threads` sequential ingestion for historical updates.
2. Keep end-session flow as `memento -> ai-janitor -> docs`.
3. Keep `.ai/README.md` synchronized with skills/prompts/state changes.

## Recently Changed

- Removed `tests` skill.
- Updated `zed-threads` filter to `mcp`.
- Reset `zed-threads/state/nu.cursor` to `0`.
- Rebuilt `.ai/memory.md`, `.ai/decisions.md`, and `.ai/failures.md`.