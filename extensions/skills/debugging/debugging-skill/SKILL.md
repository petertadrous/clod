---
name: debugging-skill
description: Structured debugging methodology with tiered approach from quick fixes to deep diagnosis using systematic investigation, competing hypotheses, and evidence-based root cause analysis.
---

# Debugging Skill

Structured debugging methodology combining systematic investigation with tiered escalation. Every fix must trace back to a confirmed root cause.

## Tiered Debugging Methodology

### Tier 1: Quick Debug

For obvious issues that match known patterns. Try this first before escalating.

1. **Read the error message thoroughly** -- not just the first line, but the full stack trace
2. **Check recent changes** -- `git log --oneline -10` and `git diff` on the failing area
3. **Match against common patterns** -- consult `references/common-patterns.md` and `references/quick-fixes.md`
4. **Apply the fix and verify** -- if the pattern match is clear, fix it and add a regression test

If Tier 1 resolves the issue within a few minutes, you are done. If not, escalate.

### Tier 2: Structured Investigation

**The Iron Law: no fix without confirmed root cause.**

Jumping to fixes without understanding causes creates more bugs. Systematic debugging prevents the "fix one thing, break two more" cycle.

Follow these phases in order:

1. **Reproduce** -- Establish consistent reproduction steps. Document exact steps that trigger the bug 100% of the time. If you cannot reproduce, gather more information before proceeding.

2. **Isolate** -- Narrow down to the smallest failing case.
   - Use binary search: disable half the code, test, repeat (see `references/strategies.md`)
   - Trace data flow backward from the error to its origin
   - Find similar working implementations and document all differences

3. **Hypothesize** -- Form a specific, written hypothesis.
   - State what you believe the root cause is
   - Predict what change will fix it
   - Write it down before touching any code

4. **Verify** -- Test with minimal, isolated changes.
   - Change only one thing at a time
   - Prove the hypothesis with evidence (logs, debugger output, test results)
   - If disproved, return to step 3 with a new hypothesis

5. **Fix** -- Implement the minimal correct fix.
   - Create a failing test case first
   - Implement a single fix addressing the confirmed root cause
   - Verify no new breakage across the test suite

6. **Prevent** -- Add safeguards against regression.
   - The failing test from the previous step serves as the regression test
   - Remove all diagnostic instrumentation before committing
   - Document the root cause for future reference

### Tier 3: Deep Diagnosis

For complex, intermittent, or multi-system bugs that resist Tier 2 investigation.

**Analysis of Competing Hypotheses (ACH):**
- List all plausible root causes simultaneously
- For each hypothesis, identify what evidence would confirm or refute it
- Gather evidence and score each hypothesis
- Eliminate hypotheses that conflict with the evidence
- The surviving hypothesis with the strongest evidence support is your root cause

**Devil's Advocate Verification:**
Before committing to a fix at this tier, argue against your own conclusion:
- What evidence would disprove your root cause?
- Is there an alternative explanation that fits the same evidence?
- Could there be multiple interacting causes?

**Documentation Trail:**
At Tier 3, document everything:
- Each hypothesis considered and why it was accepted or eliminated
- All evidence gathered and what it implies
- The final root cause determination and supporting proof
- The fix and its verification

## Escalation Protocol

**The 3-Strike Rule:** If blocked after 3 attempts at the same approach, you must either escalate or try a fundamentally different angle.

Three failures in different locations signals architectural problems, not isolated bugs.

```
Attempt 1: Fix in location A -> new error in B
Attempt 2: Fix in location B -> new error in C
Attempt 3: Fix in location C -> original error returns
           -> STOP. Question the architecture.
```

At the threshold:
1. Stop fixing symptoms
2. Document the pattern of failures
3. Identify architectural assumptions being violated
4. Propose a structural change rather than a patch
5. Discuss with the team before proceeding

## Rules

- **Never guess.** Follow the evidence.
- **A fix without a failing test is incomplete.**
- **One variable at a time.** Never make multiple changes simultaneously.
- **Reproduce first.** No investigation without confirmed reproduction steps.
- **Remove debug code.** No console.log, debugger statements, or diagnostic prints in committed code.

## Red Flags Requiring Process Reset

If you notice any of these, stop and restart from Tier 1:

| Red Flag | Why It Is Wrong |
|----------|-----------------|
| Proposing solutions before tracing data flow | Guessing, not debugging |
| Making multiple simultaneous changes | Cannot identify which change worked |
| Skipping test creation | Bug will recur |
| "Let's try this and see if it works" | Shotgun debugging |
| Fixing without understanding the cause | Band-aid, not cure |

## Reference Guide

Load detailed guidance based on context:

| Topic | Reference | Load When |
|-------|-----------|-----------|
| Systematic Debugging | `references/systematic-debugging.md` | Complex bugs, multiple failed fixes, root cause analysis |
| Strategies | `references/strategies.md` | Binary search, git bisect, time travel debugging |
| Common Patterns | `references/common-patterns.md` | Recognizing bug patterns by symptom |
| Quick Fixes | `references/quick-fixes.md` | Common error messages and their solutions |
| Debugging Tools | `references/debugging-tools.md` | Setting up debuggers by language |

## Output Template

When reporting a debugging result, provide:

1. **Root Cause**: What specifically caused the issue
2. **Evidence**: Stack trace, logs, or test that proves it
3. **Fix**: Code change that resolves it
4. **Prevention**: Test or safeguard to prevent recurrence
