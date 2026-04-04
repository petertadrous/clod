# Remaining Work Plan

## What's Done (Phase 1 + adjustments)

### Skills installed (13):
- `security/fullstack-guardian` — jeffallan, MIT
- `security/security-review` — OneRedOak, MIT
- `security/supply-chain-risk-auditor` — Trail of Bits, CC-BY-SA-4.0
- `testing/webapp-testing` — Anthropic, Apache-2.0
- `testing/coding-principles` — shinpr, MIT
- `testing/testing-principles` — shinpr, MIT
- `commands/pragmatic-code-review` — OneRedOak, MIT (slash command → code-reviewer agent)
- `commands/refactor-clean` — wshobson, MIT
- `commands/tdd/tdd-red` — wshobson, MIT
- `commands/tdd/tdd-green` — wshobson, MIT
- `commands/tdd/tdd-refactor` — wshobson, MIT
- `commands/tdd/tdd-cycle` — wshobson, MIT
- `review/self-review` — our composition, MIT

### Agents installed (6):
- `prd-writer` — iannuttall, MIT
- `project-task-planner` — iannuttall, MIT
- `code-reviewer` — our composition (OneRedOak framework), MIT
- `design-reviewer` — our composition, MIT
- `security-auditor` — our composition, MIT
- `debugger` — our composition, MIT

### Hooks installed (1):
- `python-quality-gate` — written from scratch, MIT

### Removed after review:
- `incident-response` (not needed)
- `semgrep-rule-creator` (not needed)
- `static-analysis` (not needed)
- `playwright-skill` (JS-only, user uses Python)

---

## Phase 2: Stack-Specific Skills + Combined Builds

### Fetch from repos (9 items):

| # | Skill | Source | License | Destination |
|---|-------|--------|---------|-------------|
| 1 | python-pro | jeffallan/claude-skills | MIT | `skills/python/python-pro/` |
| 2 | api-designer | jeffallan/claude-skills | MIT | `skills/architecture/api-designer/` |
| 3 | microservices-architect | jeffallan/claude-skills | MIT | `skills/architecture/microservices-architect/` |
| 4 | sql-pro | jeffallan/claude-skills | MIT | `skills/architecture/sql-pro/` |
| 5 | canvas-design | anthropics/skills | Apache-2.0 | `skills/documents/canvas-design/` |
| 6 | frontend-design | anthropics/skills | Apache-2.0 | `skills/frontend/frontend-design/` |

### Non-redistributable README pointers (5 items):

| # | Skill | Destination | Points to |
|---|-------|-------------|-----------|
| 7 | pdf | `skills/documents/pdf/` | github.com/anthropics/skills/tree/main/pdf |
| 8 | docx | `skills/documents/docx/` | github.com/anthropics/skills/tree/main/docx |
| 9 | pptx | `skills/documents/pptx/` | github.com/anthropics/skills/tree/main/pptx |
| 10 | xlsx | `skills/documents/xlsx/` | github.com/anthropics/skills/tree/main/xlsx |
| 11 | doc-coauthoring | `skills/documents/doc-coauthoring/` | github.com/anthropics/skills/tree/main/doc-coauthoring |

### Build combined items (4 items):

| # | Combined | Sources | License | Destination | Effort |
|---|---------|---------|---------|-------------|--------|
| 12 | security-audit | Trail of Bits base + jeffallan tools + OneRedOak filtering | CC-BY-SA-4.0 | `skills/security/security-audit/` | Medium (1-2h) |
| 13 | debugging-skill | jeffallan refs + catlog22 Iron Law + shinpr verification | MIT | `skills/debugging/debugging-skill/` | Medium (1-2h) |
| 14 | Enhanced frontend-design | Anthropic base + catlog22 anti-patterns (if extractable) | Apache-2.0 | `skills/frontend/frontend-design/` | Low (30min) |
| 15 | Enhanced design-review | OneRedOak base + catlog22 OKLCH specs (if extractable) | MIT | `skills/review/design-review/` | Low (30min) |

### Phase 2 commit sequence:
1. Commit: `feat: add jeffallan architecture + python skills` (items 1-4)
2. Commit: `feat: add Anthropic canvas-design and frontend-design` (items 5-6)
3. Commit: `docs: add README pointers for proprietary Anthropic skills` (items 7-11)
4. Commit: `feat: build security-audit combined skill` (item 12)
5. Commit: `feat: build debugging-skill combined skill` (item 13)
6. Commit: `feat: enhance frontend-design with anti-patterns` (item 14)
7. Commit: `feat: enhance design-review with OKLCH a11y specs` (item 15)

---

## Phase 3: Niche/Conditional Skills

### Fetch from repos (10 items):

| # | Skill | Source | License | Destination | Condition |
|---|-------|--------|---------|-------------|-----------|
| 1 | django-expert | jeffallan/claude-skills | MIT | `skills/python/django-expert/` | Only if using Django |
| 2 | nextjs-developer | jeffallan/claude-skills | MIT | `skills/frontend/nextjs-developer/` | Only if using Next.js |
| 3 | vue-expert | jeffallan/claude-skills | MIT | `skills/frontend/vue-expert/` | Only if using Vue |
| 4 | angular-architect | jeffallan/claude-skills | MIT | `skills/frontend/angular-architect/` | Only if using Angular |
| 5 | kubernetes-specialist | jeffallan/claude-skills | MIT | `skills/infrastructure/kubernetes-specialist/` | Only if using K8s |
| 6 | terraform-engineer | jeffallan/claude-skills | MIT | `skills/infrastructure/terraform-engineer/` | Only if using Terraform |
| 7 | smart-contract-workflow | trailofbits/skills | CC-BY-SA-4.0 | `skills/security/smart-contract-workflow/` | Only if writing Solidity |
| 8 | langchain-architecture | wshobson/agents | MIT | `skills/ai-ml/langchain-architecture/` | Only if building LangChain apps |
| 9 | ml-pipeline | wshobson/commands | MIT | `skills/commands/ml-pipeline/` | Only if doing traditional ML |
| 10 | understand-anything | Lum1104/Understand-Anything | MIT | `skills/meta/understand-anything/` | Only if onboarding unfamiliar codebases |

### Fetch from Anthropic (1 item):
| # | Skill | License | Destination | Condition |
|---|-------|---------|-------------|-----------|
| 11 | skill-creator | Apache-2.0 | `skills/meta/skill-creator/` | Only if authoring skills |

### Hook (1 item):
| # | Hook | Source | License | Destination | Condition |
|---|------|--------|---------|-------------|-----------|
| 12 | auto-format-js | CodyLunders | MIT | `hooks/auto-format-js/` | Only if using JS/TS |

### Phase 3 commit sequence:
1. Commit: `feat: add jeffallan framework skills (django, nextjs, vue, angular)` (items 1-4)
2. Commit: `feat: add jeffallan infrastructure skills (k8s, terraform)` (items 5-6)
3. Commit: `feat: add Trail of Bits smart-contract-workflow` (item 7)
4. Commit: `feat: add wshobson AI/ML skills (langchain, ml-pipeline)` (items 8-9)
5. Commit: `feat: add understand-anything and skill-creator` (items 10-11)
6. Commit: `feat: add auto-format-js hook` (item 12)

---

## Verification Checklist (run after each phase)

```bash
# Every content folder has a LICENSE.txt
for d in $(find extensions -name "SKILL.md" -o -name "AGENT.md" | xargs -I{} dirname {}); do
  [ ! -f "$d/LICENSE.txt" ] && echo "MISSING LICENSE: $d"
done

# Every sourced folder has ATTRIBUTION.md
for d in $(find extensions -name "SKILL.md" -o -name "AGENT.md" | xargs -I{} dirname {}); do
  [ ! -f "$d/ATTRIBUTION.md" ] && [ ! -f "$d/README.md" ] && echo "MISSING ATTRIBUTION: $d"
done

# Frontmatter validation — no unsupported fields
grep -r "^license:" extensions/skills/ extensions/agents/ && echo "UNSUPPORTED: license field found"
grep -r "^metadata:" extensions/skills/ extensions/agents/ && echo "UNSUPPORTED: metadata field found"

# Slash commands have disable-model-invocation
for f in $(find extensions/skills/commands -name "SKILL.md"); do
  grep -q "disable-model-invocation: true" "$f" || echo "MISSING disable-model-invocation: $f"
done

# File counts
echo "Skills: $(find extensions/skills -name 'SKILL.md' | wc -l)"
echo "Agents: $(find extensions/agents -name 'AGENT.md' | wc -l)"
echo "Hooks:  $(find extensions/hooks -name '*.sh' | wc -l)"
```
