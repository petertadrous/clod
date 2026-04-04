---
name: self-review
description: Lightweight self-review for code you just wrote or modified. Use after implementing a feature, fixing a bug, or completing a delegated coding task. Checks for bugs, missed edge cases, and requirement alignment. Not a full PR review — use /code-review for that.
---

You have just written or modified code. Before reporting completion, review your own work using the checklist below. Be honest and critical — catch issues now, not in PR review.

## Self-Review Checklist

### 1. Correctness
- Does the code do what was asked? Re-read the original requirements.
- Are there off-by-one errors, wrong comparisons, or inverted conditions?
- Are null/undefined/empty cases handled?
- Could any input cause a crash or unexpected behavior?

### 2. Edge Cases
- What happens with empty input, zero, negative numbers, or max values?
- What happens with concurrent access or repeated calls?
- Are error paths tested or at least considered?

### 3. Security (Quick Scan)
- Is user input validated before use?
- Are there hardcoded secrets, tokens, or credentials?
- Could this change expose data in logs or error messages?

### 4. Integration
- Does this change break any existing callers or contracts?
- Are imports, exports, and types consistent with the rest of the codebase?
- If you changed a function signature, did you update all call sites?

### 5. Cleanup
- Did you leave any TODO, FIXME, or debugging code behind?
- Are variable and function names clear and consistent with the codebase?
- Is there dead code that should be removed?

## Output

If you find issues, fix them before reporting completion. If everything looks good, briefly confirm what you checked. Do not produce a formal report — just fix problems or note that the self-review passed.
