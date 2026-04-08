## Attribution

This skill is a combined work derived from two sources:

### jeffallan security-reviewer
- **Source**: https://github.com/Jeffallan/claude-skills
- **Path**: `skills/security-reviewer/`
- **License**: MIT
- **Original author**: Jeff Allan
- **What was taken**: SAST tool commands (Semgrep, Bandit, gitleaks, npm audit, Trivy, gosec), CVSS/CWE output format, vulnerability patterns, report template

### OneRedOak security-review
- **Source**: https://github.com/OneRedOak/claude-code-workflows
- **Path**: `security-review/`
- **License**: MIT
- **Original author**: Patrick Ellis
- **What was taken**: False-positive exclusion rules, confidence threshold methodology, 3-phase analysis approach, severity guidelines

**Combined license**: MIT
**Modifications**: Composed into a unified active-scanning skill that complements the passive security-review skill.
