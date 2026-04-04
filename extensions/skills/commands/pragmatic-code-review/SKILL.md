---
name: code-review
description: Conduct a comprehensive code review of the pending changes on the current branch. Gathers git context and delegates to the code-reviewer agent using the Pragmatic Quality framework.
disable-model-invocation: true
context: fork
agent: code-reviewer
---

Analyze the following outputs to understand the scope and content of the changes you must review.

GIT STATUS:

```
!`git status`
```

FILES MODIFIED:

```
!`git diff --name-only origin/HEAD...`
```

COMMITS:

```
!`git log --no-decorate origin/HEAD...`
```

DIFF CONTENT:

```
!`git diff --merge-base origin/HEAD`
```

OBJECTIVE:
Comprehensively review the complete diff above using the Pragmatic Quality framework. Apply the full 7-tier hierarchical review checklist: Architectural Design, Functionality & Correctness, Security, Maintainability, Testing, Performance, and Dependencies.

Produce a structured markdown report with findings categorized as Critical/Blocker, Improvement, or Nit. Include file paths and line numbers for each finding.

Your final reply must contain the markdown report and nothing else.
