#!/usr/bin/env bash
# Python Quality Gate — PostToolUse hook for Claude Code
# Runs ruff (lint) and ty (type check) on Python files after Edit/Write.
#
# Setup: Add to settings.json:
# {
#   "hooks": {
#     "PostToolUse": [{
#       "matcher": "Edit|Write",
#       "hooks": [{
#         "type": "command",
#         "command": "bash /path/to/clod/hooks/python-quality-gate/python_quality_gate.sh"
#       }]
#     }]
#   }
# }

set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | python3 -c "import json,sys; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")

# Only run on Python files
[[ "$FILE_PATH" != *.py ]] && exit 0

ERRORS=""

# Lint check (ruff)
if command -v uvx &>/dev/null; then
    LINT_OUTPUT=$(uvx ruff check "$FILE_PATH" 2>&1) || ERRORS+="=== LINT (ruff) ===\n$LINT_OUTPUT\n\n"
elif command -v ruff &>/dev/null; then
    LINT_OUTPUT=$(ruff check "$FILE_PATH" 2>&1) || ERRORS+="=== LINT (ruff) ===\n$LINT_OUTPUT\n\n"
fi

# Type check (ty)
if command -v uvx &>/dev/null; then
    TYPE_OUTPUT=$(uvx ty check "$FILE_PATH" 2>&1) || ERRORS+="=== TYPE (ty) ===\n$TYPE_OUTPUT\n\n"
elif command -v ty &>/dev/null; then
    TYPE_OUTPUT=$(ty check "$FILE_PATH" 2>&1) || ERRORS+="=== TYPE (ty) ===\n$TYPE_OUTPUT\n\n"
fi

if [[ -n "$ERRORS" ]]; then
    echo -e "$ERRORS"
    exit 1
fi

exit 0
