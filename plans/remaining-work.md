# Plan: Execute Phases 2 and 3 of clod Repository

## Context
Phase 1 of the clod repo is complete (13 skills, 6 agents, 1 hook). Phases 2 and 3 remain — fetching skills from source repos, building combined skills, and creating non-redistributable pointers. This plan addresses gaps found when comparing the remaining-work plan against the original build plan.

## Prerequisites (carried forward from build plan)

### Licensing Rules
| License | Items | Action |
|---------|-------|--------|
| **MIT** | jeffallan, iannuttall, wshobson, OneRedOak, shinpr, Lum1104, CodyLunders | Copy + MIT LICENSE.txt + ATTRIBUTION.md |
| **CC-BY-SA-4.0** | Trail of Bits (supply-chain-risk-auditor, smart-contract-workflow) | Copy + CC-BY-SA-4.0 LICENSE.txt + ATTRIBUTION.md |
| **Apache-2.0** | Anthropic (canvas-design, skill-creator, webapp-testing, frontend-design) | Copy + Apache-2.0 LICENSE.txt + NOTICE file |
| **Proprietary** | Anthropic (pdf, docx, pptx, xlsx) | README pointer to source only |
| **No license** | Anthropic (doc-coauthoring) | README pointer to source only |

### Per-Folder Convention
Every folder with sourced content gets:
1. `LICENSE.txt` — Full license text
2. `ATTRIBUTION.md` — Credit block (for humans, not loaded by Claude):
   ```
   ## Attribution
   Based on [name](url) by [Author]. Licensed under [LICENSE].
   Modifications: [description or "None — used as-is"]
   ```
3. Non-redistributable folders get only `README.md` pointing to the source

### Frontmatter Rules
All newly fetched SKILL.md files must be audited for unsupported frontmatter. Supported fields for skills: `name`, `description`, `argument-hint`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `model`, `effort`, `context`, `agent`, `hooks`, `paths`, `shell`. Strip everything else (commonly: `license`, `metadata`, `author`, `version`, `domain`, `triggers`). Descriptions must be under 250 characters.

---

## Phase 2: Stack-Specific Skills + Combined Builds

### Step 1: Fetch jeffallan skills (4 items)
| Skill | Destination | License |
|-------|-------------|---------|
| python-pro | `extensions/skills/python/python-pro/` | MIT |
| api-designer | `extensions/skills/architecture/api-designer/` | MIT |
| sql-pro | `extensions/skills/architecture/sql-pro/` | MIT |

Source: github.com/Jeffallan/claude-skills — fetch SKILL.md + reference files
Post-fetch: strip unsupported frontmatter, add LICENSE.txt + ATTRIBUTION.md
Commit: `feat: add jeffallan architecture and python skills`

### Step 2: Fetch Anthropic redistributable skills (2 items)
| Skill | Destination | License |
|-------|-------------|---------|
| canvas-design | `extensions/skills/documents/canvas-design/` | Apache-2.0 |
| frontend-design | `extensions/skills/frontend/frontend-design/` | Apache-2.0 |

Source: github.com/anthropics/skills — fetch SKILL.md + supporting files
Post-fetch: strip unsupported frontmatter, add Apache-2.0 LICENSE.txt + ATTRIBUTION.md
Commit: `feat: add Anthropic canvas-design and frontend-design`

### Step 3: Create non-redistributable README pointers (5 items)
| Skill | Destination | Points to |
|-------|-------------|-----------|
| pdf | `extensions/skills/documents/pdf/` | github.com/anthropics/skills — pdf |
| docx | `extensions/skills/documents/docx/` | github.com/anthropics/skills — docx |
| pptx | `extensions/skills/documents/pptx/` | github.com/anthropics/skills — pptx |
| xlsx | `extensions/skills/documents/xlsx/` | github.com/anthropics/skills — xlsx |
| doc-coauthoring | `extensions/skills/documents/doc-coauthoring/` | github.com/anthropics/skills — doc-coauthoring |

These are README.md files only — no copied content.
Commit: `docs: add README pointers for proprietary Anthropic skills`

### Step 4: Build Combined A — security-audit (1 item)
| Source | What to take | License |
|--------|-------------|---------|
| Trail of Bits static-analysis (not in repo — fetch methodology only) | CodeQL + Semgrep workflow, SARIF parsing | CC-BY-SA-4.0 |
| jeffallan security-reviewer (fetch) | Tool commands (Semgrep, Bandit, gitleaks, npm audit, Trivy, gosec), CVSS/CWE format | MIT |
| OneRedOak security-review (already in repo) | False-positive exclusion rules, confidence threshold | MIT |

Combined license: CC-BY-SA-4.0 (inherits from Trail of Bits material)
Destination: `extensions/skills/security/security-audit/`
Commit: `feat: build security-audit combined skill`

### Step 5: Build Combined B — debugging-skill (1 item)
| Source | What to take | License |
|--------|-------------|---------|
| jeffallan debugging-wizard (fetch) | 5 reference files (systematic-debugging, strategies, patterns, quick-fixes, tools) | MIT |
| catlog22 investigate (fetch methodology) | Iron Law, 3-strike escalation, completion status protocol | MIT |
| shinpr recipe-diagnose (fetch methodology) | ACH + Devil's Advocate verification, tiered model | MIT |

Combined license: MIT
Destination: `extensions/skills/debugging/debugging-skill/`
Commit: `feat: build debugging-skill combined skill`

### Step 6: Build Combined E — Enhanced frontend-design (1 item)
Anthropic frontend-design (from Step 2) + catlog22 team-ui-polish anti-patterns (fetch if extractable from CCW).
If CCW extraction unrealistic: skip enhancement, keep base as-is.
Destination: `extensions/skills/frontend/frontend-design/` (enhance in-place)
Commit: `feat: enhance frontend-design with anti-patterns` (or skip if not extractable)

### Step 7: Build Combined F — Enhanced design-review (1 item)
OneRedOak design-review (fetch base) + catlog22 team-visual-a11y OKLCH specs (fetch if extractable from CCW).
If CCW extraction unrealistic: keep OneRedOak base as-is.
Destination: `extensions/skills/review/design-review/`
Commit: `feat: add design-review skill with OKLCH a11y specs` (or just base if not extractable)

### Step 8: Verify runner agent preloaded skills
After Phase 2, these skills now exist and their runner agents should work:
- `design-review` → preloaded by design-reviewer and code-reviewer agents
- `frontend-design` → preloaded by design-reviewer agent
- `security-audit` → preloaded by security-auditor agent
- `debugging-skill` → preloaded by debugger agent

Verify: read each agent's `skills:` list and confirm every referenced skill has a SKILL.md.
Commit: none (verification only)

### Step 9: Update root ATTRIBUTION.md
Add entries for all newly added sources.
Commit: `docs: update ATTRIBUTION.md for Phase 2 additions`

---

## Phase 3: Niche/Conditional Skills

### Step 1: Fetch jeffallan framework skills (4 items)
| Skill | Destination | Condition |
|-------|-------------|-----------|
| django-expert | `extensions/skills/python/django-expert/` | Only if using Django |
| nextjs-developer | `extensions/skills/frontend/nextjs-developer/` | Only if using Next.js |
| vue-expert | `extensions/skills/frontend/vue-expert/` | Only if using Vue |
| angular-architect | `extensions/skills/frontend/angular-architect/` | Only if using Angular |

All MIT. Post-fetch: strip unsupported frontmatter.
Commit: `feat: add jeffallan framework skills (django, nextjs, vue, angular)`

### Step 2: Fetch jeffallan infrastructure skills (2 items)
| Skill | Destination | Condition |
|-------|-------------|-----------|
| kubernetes-specialist | `extensions/skills/infrastructure/kubernetes-specialist/` | Only if using K8s |
| terraform-engineer | `extensions/skills/infrastructure/terraform-engineer/` | Only if using Terraform |

All MIT. Post-fetch: strip unsupported frontmatter.
Commit: `feat: add jeffallan infrastructure skills (k8s, terraform)`

### Step 3: Fetch Trail of Bits smart-contract-workflow (1 item)
Destination: `extensions/skills/security/smart-contract-workflow/`
License: CC-BY-SA-4.0. Condition: Only if writing Solidity.
Commit: `feat: add Trail of Bits smart-contract-workflow`

### Step 4: Fetch wshobson AI/ML items (2 items)
| Skill | Source | Destination | Condition |
|-------|--------|-------------|-----------|
| langchain-architecture | wshobson/agents | `extensions/skills/ai-ml/langchain-architecture/` | Only if building LangChain apps |
| ml-pipeline | wshobson/commands | `extensions/skills/commands/ml-pipeline/` | Only if doing traditional ML |

All MIT. ml-pipeline gets `disable-model-invocation: true`.
Commit: `feat: add wshobson AI/ML skills (langchain, ml-pipeline)`

### Step 5: Fetch understand-anything and skill-creator (2 items)
| Skill | Source | Destination | License | Condition |
|-------|--------|-------------|---------|-----------|
| understand-anything | Lum1104 | `extensions/skills/meta/understand-anything/` | MIT | Only if onboarding unfamiliar codebases |
| skill-creator | anthropics/skills | `extensions/skills/meta/skill-creator/` | Apache-2.0 | Only if authoring skills |

Commit: `feat: add understand-anything and skill-creator`

### Step 6: Fetch auto-format-js hook (1 item)
Source: CodyLunders/claude-code-hooks-library. License: MIT.
Destination: `extensions/hooks/auto-format-js/`
Condition: Only if using JS/TS.
Commit: `feat: add auto-format-js hook`

### Step 7: Update root ATTRIBUTION.md + final verification
Commit: `docs: update ATTRIBUTION.md for Phase 3 additions`

---

## Verification (run after each phase)

```bash
# Missing LICENSE.txt
for d in $(find extensions -name "SKILL.md" -o -name "AGENT.md" | xargs -I{} dirname {}); do
  [ ! -f "$d/LICENSE.txt" ] && echo "MISSING LICENSE: $d"
done

# Missing ATTRIBUTION.md or README.md
for d in $(find extensions -name "SKILL.md" -o -name "AGENT.md" | xargs -I{} dirname {}); do
  [ ! -f "$d/ATTRIBUTION.md" ] && [ ! -f "$d/README.md" ] && echo "MISSING ATTRIBUTION: $d"
done

# Unsupported frontmatter
grep -r "^license:" extensions/ && echo "UNSUPPORTED: license field"
grep -r "^metadata:" extensions/ && echo "UNSUPPORTED: metadata field"

# Slash commands have disable-model-invocation
for f in $(find extensions/skills/commands -name "SKILL.md"); do
  grep -q "disable-model-invocation: true" "$f" || echo "MISSING flag: $f"
done

# Runner agent preloaded skills exist
for agent in code-reviewer design-reviewer security-auditor debugger; do
  grep "^- " extensions/agents/$agent/AGENT.md | sed 's/^- //' | while read skill; do
    find extensions/skills -path "*/$skill/SKILL.md" | grep -q . || echo "AGENT $agent references missing skill: $skill"
  done
done

# Counts
echo "Skills: $(find extensions/skills -name 'SKILL.md' | wc -l)"
echo "Agents: $(find extensions/agents -name 'AGENT.md' | wc -l)"
echo "Hooks:  $(find extensions/hooks -name '*.sh' | wc -l)"
```
