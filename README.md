# clod

A curated collection of Claude Code skills, agents, and hooks — sourced from the best community and official repositories, with proper licensing and attribution.

## Structure

```
extensions/                Content to install into ~/.claude/ or .claude/
  skills/                  Skills (SKILL.md) — knowledge and methodology
    commands/              Slash-command skills (disable-model-invocation: true)
  agents/                  Agents (AGENT.md) — isolated execution contexts
  hooks/                   Hook scripts referenced from settings.json
  settings/                Example hook configurations

plans/                     Build plans and decision history
references/                Documentation references
```

## Architecture

**Skills** contain methodology — what to check, what patterns to follow. Claude loads them inline or agents preload them.

**Agents** are thin runners that compose skills with specific tool restrictions, model selection, and isolated context. Review agents are read-only. The debugger agent has full tool access.

| Agent | Preloaded Skills | Tools |
|-------|-----------------|-------|
| code-reviewer | pragmatic-code-review, design-review, security-review, coding-principles | Read-only |
| design-reviewer | design-review, frontend-design | Read-only + Playwright |
| security-auditor | security-review, security-audit, supply-chain-risk-auditor | Read-only + trivy, gh |
| debugger | debugging-skill, testing-principles | Full access |

## Installation

Symlink or copy from `extensions/` into your `~/.claude/` or project `.claude/` directory:

```bash
# Example: install all skills globally
ln -s /path/to/clod/extensions/skills ~/.claude/skills

# Example: install a single agent to a project
cp -r /path/to/clod/extensions/agents/code-reviewer .claude/agents/
```

## Licensing

Items are sourced from multiple repositories under different licenses. Every folder contains a `LICENSE.txt` and `ATTRIBUTION.md`. See the root [ATTRIBUTION.md](ATTRIBUTION.md) for a full list.

| License | Items |
|---------|-------|
| MIT | jeffallan, iannuttall, wshobson, OneRedOak, shinpr, lackeyjb, Lum1104, CodyLunders, our compositions |
| CC-BY-SA-4.0 | Trail of Bits security skills (derivatives must use same license) |
| Apache-2.0 | Select Anthropic skills (canvas-design, frontend-design, webapp-testing, skill-creator) |
| Proprietary | Anthropic document skills (pdf, docx, pptx, xlsx) — not redistributed, README pointers only |
