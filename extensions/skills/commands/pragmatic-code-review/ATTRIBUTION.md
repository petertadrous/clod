## Attribution

This skill is derived from the [claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) repository by [OneRedOak](https://github.com/OneRedOak).

- **Source file**: `code-review/pragmatic-code-review-slash-command.md`
- **License**: MIT
- **Original author**: Patrick Ellis
- **Modifications**: Converted from standalone slash command to a thin orchestrator that gathers git context via shell interpolation and delegates to the `code-reviewer` agent using `context: fork`. Renamed slash command from `pragmatic-code-review` to `code-review`. The review framework itself now lives in the agent definition.
