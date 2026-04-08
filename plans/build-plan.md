# Plan: Create `clod` Repository

## Context
Peter completed a multi-phase evaluation of the Claude Code ecosystem. The final install list (`~/code-repos/claude-experiments/final-install-list.md`) contains 42 items across 3 priority tiers. He wants a new repo at `~/code-repos/clod` that aggregates redistributable items with proper licensing and attribution.

## Key Decisions from Q&A

1. **License files**: `LICENSE.txt` (standard convention, not .md)
2. **No `config/` directory**: security-review and design-review are skills, not a separate concept
3. **No `commands/` directory**: Custom commands are now skills with `disable-model-invocation: true` in frontmatter
4. **No `combined/` directory**: Combined items are skills/hooks and live in their concept folder
5. **Attribution**: `ATTRIBUTION.md` per folder for humans/legal. Claude only loads SKILL.md, so no token cost.
6. **doc-coauthoring**: Non-redistributable (no license). Gets a README pointer like pdf/docx/pptx/xlsx.
7. **Hooks**: Defined in `settings.json`, not as standalone files. Hook *scripts* can live in `hooks/` but the definition is JSON config.

## Licensing Rules

| License | Items | Can Redistribute? | Action |
|---------|-------|-------------------|--------|
| **MIT** | jeffallan, iannuttall, wshobson, OneRedOak, shinpr, lackeyjb, Lum1104, CodyLunders | Yes | Copy + MIT LICENSE.txt + ATTRIBUTION.md |
| **CC-BY-SA-4.0** | Trail of Bits (4 skills) | Yes, ShareAlike | Copy + CC-BY-SA-4.0 LICENSE.txt + ATTRIBUTION.md |
| **Apache-2.0** | Anthropic (canvas-design, skill-creator, webapp-testing, frontend-design) | Yes | Copy + Apache-2.0 LICENSE.txt + NOTICE file |
| **Proprietary** | Anthropic (pdf, docx, pptx, xlsx) | **NO** | README pointer to source only |
| **No license** | Anthropic (doc-coauthoring), disler (hooks) | **NO** | Write from scratch or README pointer |

## Architecture: Skills as Methodology, Agents as Runners

**Skills** contain knowledge and methodology — what to check, what patterns to follow, what rules apply. Claude loads them inline when relevant, or agents preload them for isolated tasks.

**Agents** are thin execution contexts that compose skills. They define: which model, which tools are allowed, which skills to preload, and a short system prompt for the role. Agents run in isolated context.

This means review-oriented skills (pragmatic-code-review, design-review, security-review, etc.) stay as skills but also get preloaded into dedicated runner agents (code-reviewer, design-reviewer, security-auditor). The skill is always the single source of truth.

| Pattern | Example |
|---------|---------|
| User is coding, Claude applies knowledge inline | Claude loads `design-review` skill while editing React components |
| User asks for a standalone review | Claude delegates to `design-reviewer` agent (isolated, read-only, Playwright) |
| User asks for a full code review | Claude delegates to `code-reviewer` agent (preloads code-review + design-review + security-review) |

## Repo Structure

Everything is a skill, agent, or hook. Skills that are slash-command-only get `disable-model-invocation: true`. Runner agents are thin composition files that preload skills.

```
~/code-repos/clod/
├── README.md                              # Repo overview, usage, credits
├── LICENSE.txt                            # Repo-level MIT (for our own work)
├── ATTRIBUTION.md                         # Master attribution list
│
├── skills/
│   ├── security/
│   │   ├── static-analysis/               # Trail of Bits — CC-BY-SA-4.0
│   │   │   ├── SKILL.md
│   │   │   ├── LICENSE.txt
│   │   │   └── ATTRIBUTION.md
│   │   ├── semgrep-rule-creator/          # Trail of Bits — CC-BY-SA-4.0
│   │   ├── supply-chain-risk-auditor/     # Trail of Bits — CC-BY-SA-4.0
│   │   ├── smart-contract-workflow/       # Trail of Bits — CC-BY-SA-4.0 (Tier 3)
│   │   ├── fullstack-guardian/            # jeffallan — MIT
│   │   ├── security-audit/               # COMBINED A — CC-BY-SA-4.0 (Tier 2)
│   │   └── security-review/              # OneRedOak — MIT (was "config")
│   │
│   ├── debugging/
│   │   └── debugging-skill/              # COMBINED B — MIT (Tier 2)
│   │
│   ├── testing/
│   │   ├── webapp-testing/               # Anthropic — Apache-2.0
│   │   ├── playwright-skill/             # lackeyjb — MIT
│   │   ├── testing-principles/           # shinpr — MIT
│   │   └── coding-principles/            # shinpr — MIT
│   │
│   ├── review/
│   │   └── design-review/               # OneRedOak — MIT + COMBINED F enhancements (Tier 2)
│   │
│   ├── architecture/
│   │   ├── api-designer/                 # jeffallan — MIT (Tier 2)
│   │   └── sql-pro/                      # jeffallan — MIT (Tier 2)
│   │
│   ├── python/
│   │   ├── python-pro/                   # jeffallan — MIT (Tier 2)
│   │   └── django-expert/               # jeffallan — MIT (Tier 3)
│   │
│   ├── frontend/
│   │   ├── frontend-design/             # Anthropic Apache-2.0 + COMBINED E (Tier 2)
│   │   ├── nextjs-developer/            # jeffallan — MIT (Tier 3)
│   │   ├── vue-expert/                  # jeffallan — MIT (Tier 3)
│   │   └── angular-architect/           # jeffallan — MIT (Tier 3)
│   │
│   ├── infrastructure/
│   │   ├── kubernetes-specialist/       # jeffallan — MIT (Tier 3)
│   │   └── terraform-engineer/          # jeffallan — MIT (Tier 3)
│   │
│   ├── commands/                         # All disable-model-invocation: true skills
│   │   ├── tdd/                          # wshobson — MIT
│   │   │   ├── tdd-red/
│   │   │   ├── tdd-green/
│   │   │   ├── tdd-refactor/
│   │   │   └── tdd-cycle/
│   │   ├── pragmatic-code-review/       # OneRedOak — MIT
│   │   ├── incident-response/           # wshobson — MIT
│   │   ├── refactor-clean/              # wshobson — MIT
│   │   └── ml-pipeline/                 # wshobson — MIT (Tier 3)
│   │
│   ├── documents/
│   │   ├── canvas-design/               # Anthropic — Apache-2.0 (Tier 2)
│   │   ├── pdf/                         # NOT REDISTRIBUTABLE — README pointer
│   │   │   └── README.md
│   │   ├── docx/                        # NOT REDISTRIBUTABLE — README pointer
│   │   │   └── README.md
│   │   ├── pptx/                        # NOT REDISTRIBUTABLE — README pointer
│   │   │   └── README.md
│   │   ├── xlsx/                        # NOT REDISTRIBUTABLE — README pointer
│   │   │   └── README.md
│   │   └── doc-coauthoring/             # NOT REDISTRIBUTABLE — README pointer
│   │       └── README.md
│   │
│   ├── ai-ml/
│   │   └── langchain-architecture/      # wshobson — MIT (Tier 3)
│   │
│   └── meta/
│       ├── skill-creator/               # Anthropic — Apache-2.0 (Tier 3)
│       └── understand-anything/         # Lum1104 — MIT (Tier 3)
│
├── agents/
│   ├── prd-writer/                      # iannuttall — MIT
│   │   ├── AGENT.md
│   │   ├── LICENSE.txt
│   │   └── ATTRIBUTION.md
│   ├── project-task-planner/            # iannuttall — MIT
│   │   ├── AGENT.md
│   │   ├── LICENSE.txt
│   │   └── ATTRIBUTION.md
│   ├── code-reviewer/                   # NEW — MIT (our composition)
│   │   ├── AGENT.md                     # Preloads: pragmatic-code-review, design-review,
│   │   │                                #   security-review, coding-principles
│   │   │                                # Tools: Read, Grep, Glob (read-only)
│   │   │                                # Model: opus
│   │   └── LICENSE.txt
│   ├── design-reviewer/                 # NEW — MIT (our composition)
│   │   ├── AGENT.md                     # Preloads: design-review, frontend-design
│   │   │                                # Tools: Read, Grep, Glob, Bash(npx playwright *)
│   │   │                                # Model: opus
│   │   └── LICENSE.txt
│   ├── security-auditor/                # NEW — MIT (our composition)
│   │   ├── AGENT.md                     # Preloads: security-review, static-analysis,
│   │   │                                #   security-audit, supply-chain-risk-auditor
│   │   │                                # Tools: Read, Grep, Glob, Bash(semgrep *),
│   │   │                                #   Bash(trivy *), Bash(gh *)
│   │   │                                # Model: opus
│   │   └── LICENSE.txt
│   └── debugger/                        # NEW — MIT (our composition)
│       ├── AGENT.md                     # Preloads: debugging-skill, testing-principles
│       │                                # Tools: Read, Grep, Glob, Bash, Edit, Write
│       │                                # Model: opus
│       └── LICENSE.txt
│
├── hooks/
│   ├── python-quality-gate/             # WRITTEN FROM SCRATCH — MIT (our code)
│   │   ├── python_quality_gate.py       # PostToolUse hook script
│   │   ├── LICENSE.txt
│   │   └── README.md                    # Setup instructions for settings.json
│   └── auto-format-js/                  # CodyLunders — MIT (Tier 3)
│       ├── auto_format.sh               # PostToolUse hook script
│       ├── LICENSE.txt
│       └── ATTRIBUTION.md
│
└── settings/
    └── hooks-example.json               # Example settings.json hook definitions
```

## Per-Folder Convention

Every folder with sourced content gets:
1. **LICENSE.txt** — Full license text (MIT, Apache-2.0, or CC-BY-SA-4.0)
2. **ATTRIBUTION.md** — For humans/legal only (Claude never loads this):
   ```markdown
   ## Attribution
   Based on [skill-name](https://github.com/org/repo/path) by [Author/Org].
   Licensed under [LICENSE].
   Modifications: [description or "None — used as-is"]
   ```
3. Non-redistributable folders get only a **README.md** pointing to the source.

## Execution — 3 Phases

### Phase 1: Tier 1 (20 items — broadest value, unconditional)

1. Create repo: `git init ~/code-repos/clod`, write root README.md, LICENSE.txt (MIT), ATTRIBUTION.md
2. Create full directory skeleton (all folders for all 3 tiers)
3. Fetch and install skills:
   - **Trail of Bits** (3 skills): static-analysis, semgrep-rule-creator, supply-chain-risk-auditor → CC-BY-SA-4.0
   - **jeffallan** (1 skill): fullstack-guardian → MIT
   - **shinpr** (2 skills): coding-principles, testing-principles → MIT
   - **Anthropic** (1 skill): webapp-testing → Apache-2.0
   - **lackeyjb** (1 skill): playwright-skill → MIT
   - **OneRedOak** (2 skills): pragmatic-code-review, security-review → MIT
   - **wshobson** (2 skills): incident-response, refactor-clean → MIT
   - **wshobson** (4 skills): tdd-red, tdd-green, tdd-refactor, tdd-cycle → MIT
4. Fetch and install agents:
   - **iannuttall** (2 agents): prd-writer, project-task-planner → MIT
5. Build runner agents (4 agents, our own composition → MIT):
   - **code-reviewer**: preloads pragmatic-code-review, design-review, security-review, coding-principles. Tools: Read, Grep, Glob (read-only). Model: opus.
   - **design-reviewer**: preloads design-review, frontend-design. Tools: Read, Grep, Glob, Bash(npx playwright *). Model: opus.
   - **security-auditor**: preloads security-review, static-analysis, security-audit, supply-chain-risk-auditor. Tools: Read, Grep, Glob, Bash(semgrep *), Bash(trivy *), Bash(gh *). Model: opus.
   - **debugger**: preloads debugging-skill, testing-principles. Tools: Read, Grep, Glob, Bash, Edit, Write. Model: opus.
   - Note: Some preloaded skills (design-review, frontend-design, security-audit, debugging-skill) don't exist yet — they'll be built in Phase 2. The agent files can reference them now; they'll work once the skills are added.
6. Write from scratch (1 hook): python-quality-gate → MIT (cannot copy disler's unlicensed code)
7. Add LICENSE.txt + ATTRIBUTION.md to every folder
8. Initial commit

### Phase 2: Tier 2 (18 items — stack-specific + combined builds)

9. **jeffallan** (3 skills): python-pro, api-designer, sql-pro → MIT
10. **Anthropic redistributable** (2 skills): canvas-design, frontend-design → Apache-2.0
11. **Anthropic non-redistributable** (5 items): pdf, docx, pptx, xlsx, doc-coauthoring → README pointers only
12. **Build Combined A**: security-audit skill (Trail of Bits base + jeffallan tools + OneRedOak filtering) → CC-BY-SA-4.0
13. **Build Combined B**: debugging-skill (jeffallan refs + catlog22 Iron Law methodology + shinpr verification) → MIT
14. **Build Combined E**: Enhanced frontend-design (add catlog22 anti-patterns if extractable) → Apache-2.0
15. **Build Combined F**: Enhanced design-review (add catlog22 OKLCH specs if extractable) → MIT
16. All runner agents from Phase 1 now have their preloaded skills available
17. Commit

### Phase 3: Tier 3 (12 items — niche/conditional)

18. **jeffallan** (4 framework skills): django-expert, nextjs-developer, vue-expert, angular-architect → MIT
19. **jeffallan** (2 infra skills): kubernetes-specialist, terraform-engineer → MIT
20. **Trail of Bits** (1 skill): smart-contract-workflow → CC-BY-SA-4.0
21. **wshobson** (2 items): langchain-architecture, ml-pipeline → MIT
22. **Lum1104** (1 skill): understand-anything → MIT
23. **Anthropic** (1 skill): skill-creator → Apache-2.0
24. **CodyLunders** (1 hook): auto-format-js → MIT
25. Final commit

## Verification
- Every folder with content has a LICENSE.txt
- Every sourced folder has an ATTRIBUTION.md
- Non-redistributable folders have README.md pointers only, no copied content
- Python Quality Gate hook is 100% original code
- CC-BY-SA-4.0 folders properly isolated (no license mixing)
- Root ATTRIBUTION.md lists all sources with links
- Only slash-command skills have `disable-model-invocation: true` (tdd-*, incident-response, refactor-clean, pragmatic-code-review, ml-pipeline)
- Runner agents reference only skills that exist in the repo
- Runner agents have appropriate tool restrictions (review agents are read-only)
- `find . -name "SKILL.md" | wc -l` matches expected skill count
- `find . -name "AGENT.md" | wc -l` returns 6 (2 sourced + 4 runners)
