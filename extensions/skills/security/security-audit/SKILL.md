---
name: security-audit
description: Active security scanning using SAST tools, secret detection, and dependency analysis. Complements security-review (passive code review) with automated tool-based scanning.
allowed-tools: Read, Grep, Glob, Bash
---

# Security Audit

Active security scanner that runs SAST tools, secret detectors, and dependency analyzers against a codebase. Produces structured findings with CVSS scores and CWE classifications.

## When to Use

- Run automated SAST scans across an entire codebase
- Detect hardcoded secrets and credentials in code and git history
- Audit dependencies for known vulnerabilities
- Scan container images and filesystem for security issues
- Generate a comprehensive security audit report with prioritized findings

## When NOT to Use

- **Code review of a PR or branch diff** -- use `security-review` instead (passive, reads diffs)
- **Supply-chain or dependency-license risk** -- use `supply-chain-risk-auditor` instead
- **Penetration testing or active exploitation** -- out of scope for automated scanning
- **Infrastructure/cloud security posture** -- out of scope (no cloud API access)

## SAST Scanning

Run language-appropriate static analysis. Always start with Semgrep for broad coverage, then add language-specific tools.

### Multi-language (Semgrep)

```bash
# Broad auto-detection scan
semgrep --config=auto .

# Security-focused rulesets
semgrep --config=p/security-audit .
semgrep --config=p/owasp-top-ten .

# JSON output for structured processing
semgrep --config=auto --json -o semgrep-report.json .
```

### Python (Bandit)

```bash
# Full scan with JSON output
bandit -r . -f json -o bandit-report.json

# High-severity only
bandit -r . -ll
```

### Go (gosec)

```bash
# Full scan
gosec ./...

# JSON output
gosec -fmt=json -out=gosec-report.json ./...
```

### JavaScript/TypeScript

```bash
# Dependency vulnerabilities
npm audit
npm audit --json > npm-audit.json

# ESLint security plugin
npx eslint --ext .js,.ts . --plugin security
```

## Secret Detection

### Gitleaks

```bash
# Scan working directory
gitleaks detect --source . --verbose

# Scan with JSON report
gitleaks detect --source . -f json -r gitleaks-report.json

# Scan full git history
gitleaks detect --source . --log-opts="--all"

# Use baseline to suppress known results
gitleaks detect --baseline-path .gitleaks-baseline.json
```

### TruffleHog

```bash
# Filesystem scan
trufflehog filesystem .

# Git history scan (recent)
trufflehog git file://. --since-commit HEAD~100

# JSON output
trufflehog filesystem . --json > trufflehog-report.json
```

### Manual Pattern Checks

When tools are unavailable, grep for common secret patterns:

| Type | Pattern | Example |
|------|---------|---------|
| AWS Access Key | `AKIA[0-9A-Z]{16}` | AKIAIOSFODNN7EXAMPLE |
| GitHub Token | `ghp_[A-Za-z0-9]{36}` | ghp_xxxxxxxxxxxx |
| Slack Token | `xox[baprs]-` | xoxb-xxx-xxx |
| Stripe Key | `sk_live_[A-Za-z0-9]{24}` | sk_live_xxxx |
| Private Key | `-----BEGIN.*PRIVATE KEY-----` | RSA/EC keys |
| JWT | `eyJ[A-Za-z0-9_-]*\.eyJ` | Encoded tokens |

## Dependency Scanning

### npm audit

```bash
npm audit --audit-level=moderate
npm audit --json > npm-audit.json
```

### Trivy (filesystem and container)

```bash
# Filesystem scan (dependencies + secrets + misconfig)
trivy fs .
trivy fs --security-checks vuln,secret,config .

# Container image scan
trivy image myapp:latest

# JSON output
trivy fs --format json -o trivy-report.json .
```

### Python (Safety)

```bash
safety check
safety check -r requirements.txt --json > safety-report.json
```

### Go (govulncheck)

```bash
govulncheck ./...
```

## Analysis Methodology

Adapt from a three-phase approach to produce high-signal findings from tool output.

### Phase 1: Repository Context

Before running scans, understand the codebase:

- Identify languages, frameworks, and package managers in use
- Look for existing security tooling (CI configs, pre-commit hooks, `.semgrepignore`)
- Note the project's security model: authentication mechanisms, data handling patterns, trust boundaries

This context determines which tools to run and how to interpret results.

### Phase 2: Scan and Correlate

Run the appropriate tools from the sections above. Cross-reference results:

- Findings flagged by multiple tools are higher confidence
- A Semgrep finding in a file that also has a gitleaks hit is especially urgent
- Dependency vulnerabilities that match code-level vulnerability patterns (e.g., a known-vulnerable deserialization library actually used in an unsafe way) should be escalated

### Phase 3: Triage and Validate

For each finding, assess real-world exploitability:

- Trace data flow from untrusted input to the flagged sink
- Check whether the framework or existing middleware already mitigates the issue
- Confirm the finding is reachable in production code (not just tests or dead code)

## False Positive Filtering

Only report findings where confidence of actual exploitability exceeds 80%. Apply these hard exclusion rules to all tool output:

### Hard Exclusions -- Do Not Report

1. Denial of Service or resource exhaustion
2. Secrets stored on disk that are otherwise secured (e.g., encrypted at rest)
3. Rate limiting or service overload concerns
4. Missing hardening measures without a concrete vulnerability
5. Input validation gaps on non-security-critical fields without proven impact
6. Race conditions or timing attacks that are theoretical only
7. Outdated library versions without a concrete exploit path in this codebase
8. Memory safety issues in memory-safe language code (Rust safe code, Go, C#)
9. Findings only in test files or test fixtures
10. Log spoofing -- unsanitized user input in logs is not a vulnerability
11. SSRF that only controls path (not host or protocol)
12. Regex injection unless used in authorization or access control logic
13. Insecure patterns in documentation or markdown files

### Confidence Scoring

- **0.9-1.0**: Certain exploit path, tool confirms with high-signal rule
- **0.8-0.9**: Clear vulnerability pattern with known exploitation methods
- **0.7-0.8**: Suspicious pattern requiring specific conditions -- investigate but may not report
- **Below 0.7**: Discard (too speculative for an audit report)

### Precedents

- Environment variables and CLI flags are trusted input unless in multi-tenant CI/CD
- UUIDs are assumed unguessable
- React/Angular auto-escape XSS unless `dangerouslySetInnerHTML` or `bypassSecurityTrustHtml` is used
- Logging URLs is safe; logging high-value secrets in plaintext is a vulnerability

## Output Format

Structure the audit report as follows.

### Executive Summary

| Field | Value |
|-------|-------|
| **Project** | [Project name] |
| **Scan Date** | [YYYY-MM-DD] |
| **Scope** | [Directories/images scanned] |
| **Overall Risk** | [Critical / High / Medium / Low] |
| **Tools Used** | [List of tools run] |

### Findings Summary

| Severity | Count | Status |
|----------|-------|--------|
| Critical | X | Requires immediate fix |
| High | X | Fix before deployment |
| Medium | X | Fix in next sprint |
| Low | X | Backlog |

### Detailed Findings

Each finding uses this structure:

```
ID: SEC-001
Severity: High (CVSS 8.1)
Title: SQL Injection in user search endpoint
CWE: CWE-89
File: src/api/users.py, line 42
Tool: Semgrep (rule: python.lang.security.audit.raw-query)
Description: User-supplied input concatenated into SQL query without parameterization.
Impact: Attacker can read, modify, or delete database contents.
Remediation: Use parameterized queries. Replace string concatenation with
             cursor.execute("SELECT * FROM users WHERE name=%s", (name,)).
Confidence: 0.95
```

### Recommendations

Prioritize by severity and effort:

1. **Immediate** -- Critical/High findings with low fix effort
2. **Short-term** -- High/Medium findings, next sprint
3. **Long-term** -- Systemic improvements (add SAST to CI/CD, secret scanning pre-commit hooks)

## Severity Guidelines

| Severity | CVSS | Exploitability | Impact | Response |
|----------|------|----------------|--------|----------|
| Critical | 9.0-10.0 | Easy, remote | Full compromise, RCE, admin takeover | Immediate |
| High | 7.0-8.9 | Moderate | Auth bypass, privilege escalation, data breach | 24-48 hours |
| Medium | 4.0-6.9 | Requires conditions | Limited access, information disclosure | 1-2 weeks |
| Low | 0.1-3.9 | Difficult | Minimal impact, defense-in-depth | Next release |

### OWASP Top 10 Mapping

| OWASP Category | What to Look For |
|----------------|-----------------|
| A01 Broken Access Control | IDOR, path traversal, missing authorization |
| A02 Cryptographic Failures | Weak algorithms, plaintext storage, poor key management |
| A03 Injection | SQL, XSS, command, template injection |
| A04 Insecure Design | Missing auth flows, broken trust boundaries |
| A05 Security Misconfiguration | Debug mode, default credentials, open admin panels |
| A06 Vulnerable Components | Outdated dependencies with known CVEs |
| A07 Auth Failures | Weak passwords, session fixation, JWT issues |
| A08 Data Integrity | Insecure deserialization, unsigned updates |
| A09 Logging Failures | Missing audit logs, sensitive data in logs |
| A10 SSRF | Unvalidated URLs allowing internal network access |

## Reference Files

Load detailed guidance as needed:

| Topic | Reference | When to Load |
|-------|-----------|-------------|
| SAST tool commands and CI/CD integration | `references/sast-tools.md` | Setting up or running automated scans |
| Common vulnerability patterns with secure/insecure code examples | `references/vulnerability-patterns.md` | Validating findings, understanding exploit patterns |
| Secret scanning tools and remediation | `references/secret-scanning.md` | Running secret detection, handling exposed credentials |
| Report template with full example | `references/report-template.md` | Writing the final audit report |
