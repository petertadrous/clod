# Attribution

This repository aggregates Claude Code skills, agents, and hooks from multiple open-source projects. Each folder contains its own LICENSE.txt and ATTRIBUTION.md with specific details.

## Sources

### Trail of Bits (CC-BY-SA-4.0)
- [trailofbits/skills](https://github.com/trailofbits/skills) — Security-focused skills
  - supply-chain-risk-auditor, smart-contract-workflow

### Jeff Allan (MIT)
- [Jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) — Full-stack development skills
  - fullstack-guardian, api-designer, sql-pro, python-pro, django-expert, nextjs-developer, vue-expert, angular-architect, kubernetes-specialist, terraform-engineer

### shinpr (MIT)
- [shinpr/claude-code-workflows](https://github.com/shinpr/claude-code-workflows) — Development principles
  - coding-principles, testing-principles

### OneRedOak (MIT)
- [OneRedOak/claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) — Code review workflows
  - pragmatic-code-review, security-review, design-review

### wshobson (MIT)
- [wshobson/commands](https://github.com/wshobson/commands) — Development commands
  - refactor-clean, tdd-red, tdd-green, tdd-refactor, tdd-cycle, ml-pipeline
- [wshobson/agents](https://github.com/wshobson/agents) — Specialized agents
  - langchain-architecture

### Ian Nuttall (MIT)
- [iannuttall/claude-agents](https://github.com/iannuttall/claude-agents) — Planning agents
  - prd-writer, project-task-planner

### Anthropic (Apache-2.0 / Proprietary)
- [anthropics/skills](https://github.com/anthropics/skills) — Official skills
  - webapp-testing (Apache-2.0), canvas-design (Apache-2.0), frontend-design (Apache-2.0), skill-creator (Apache-2.0)
  - pdf, docx, pptx, xlsx, doc-coauthoring (Proprietary — not redistributed, README pointers only)

### Lum1104 (MIT)
- [Lum1104/Understand-Anything](https://github.com/Lum1104/Understand-Anything) — Codebase knowledge graphs
  - understand-anything

### CodyLunders (MIT)
- [CodyLunders/claude-code-hooks-library](https://github.com/CodyLunders/claude-code-hooks-library) — Hook scripts
  - auto-format-js

## Combined Skills

- **security-audit** — Combines jeffallan/security-reviewer (SAST tool commands, CVSS/CWE format) + OneRedOak/security-review (false-positive filtering, confidence threshold, 3-phase methodology). License: MIT.
- **debugging-skill** — Combines jeffallan/debugging-wizard (reference files) + original tiered methodology (Iron Law, ACH, 3-strike escalation). License: MIT.

## Original Work (MIT)
- Runner agents: code-reviewer, design-reviewer, security-auditor, debugger
- Python Quality Gate hook
- debugging-skill tiered methodology (Quick Debug, Structured Investigation, Deep Diagnosis)
