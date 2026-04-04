# Python Quality Gate

PostToolUse hook that runs ruff (lint) and ty (type check) on every Python file Claude edits or creates.

## Setup

Add to your `~/.claude/settings.json` or `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash /path/to/clod/hooks/python-quality-gate/python_quality_gate.sh"
          }
        ]
      }
    ]
  }
}
```

## Requirements

- `uvx` (from uv) for running ruff and ty without global install, OR
- `ruff` and `ty` installed globally

## Behavior

- Only runs on `.py` files
- Runs ruff lint check, then ty type check
- Reports findings inline
- Gracefully skips if tools aren't installed
