# Playwright Skill Comparison: webapp-testing vs playwright-skill

## Skill 1: webapp-testing

**Source**: Anthropic official skills repo (`anthropics/skills`)
**License**: Apache-2.0
**Language**: Python (Playwright for Python)
**Total size**: ~310 lines across 5 files

### Files
| File | Lines | Purpose |
|------|-------|---------|
| SKILL.md | 96 | Main instructions |
| scripts/with_server.py | 106 | Server lifecycle manager |
| examples/console_logging.py | 35 | Console log capture pattern |
| examples/element_discovery.py | 40 | DOM element discovery pattern |
| examples/static_html_automation.py | 33 | Static HTML file:// automation |

### Capabilities
- Navigate and interact with web pages using Python Playwright (`sync_playwright`)
- Start and manage dev server processes (single or multiple) via `with_server.py`
- Discover DOM elements (buttons, links, inputs) on rendered pages
- Capture browser console logs
- Automate static HTML files via `file://` URLs
- Take full-page screenshots

### Methodology
- **Decision tree** for choosing approach (static HTML vs dynamic, server running vs not)
- **Reconnaissance-then-action** pattern: wait for networkidle, inspect DOM/screenshot, identify selectors, then act
- **Black-box scripts**: explicitly tells the LLM NOT to read helper scripts into context -- use `--help` instead
- Always waits for `networkidle` before inspecting dynamic apps
- Synchronous API (`sync_playwright`) only

### Quality of Instructions
- Concise and well-structured (96 lines for the main SKILL.md)
- Clear decision tree for choosing approach -- very helpful for LLM reasoning
- Good "common pitfall" callout about `networkidle`
- Lean: does not bloat context with API reference material
- Minor typo: "abslutely" in SKILL.md line 14
- Examples are minimal and focused -- each demonstrates one pattern

---

## Skill 2: playwright-skill

**Source**: Community (`lackeyjb/playwright-skill`)
**License**: MIT
**Language**: JavaScript/Node.js (Playwright for Node)
**Total size**: ~1,801 lines across 5 code/doc files

### Files
| File | Lines | Purpose |
|------|-------|---------|
| SKILL.md | 453 | Main instructions with extensive examples |
| API_REFERENCE.md | 653 | Comprehensive Playwright API reference |
| run.js | 228 | Universal executor (file, inline, stdin) |
| lib/helpers.js | 441 | Utility functions library |
| package.json | 26 | Node.js package manifest |

### Capabilities
- Navigate and interact with web pages using Node.js Playwright
- **Auto-detect running dev servers** by scanning common ports (3000, 3001, 5173, 8080, etc.)
- Universal executor (`run.js`) supporting three input modes: file, inline code, stdin
- Auto-installs Playwright + Chromium if missing
- Code wrapping: automatically wraps snippet-level code into full async IIFE with imports
- **Visible browser by default** (`headless: false`) for debugging
- Custom HTTP header injection via environment variables (`PW_HEADER_NAME`, `PW_EXTRA_HEADERS`)
- Helper functions: safeClick (with retry), safeType, extractTexts, takeScreenshot (timestamped), authenticate, scrollPage, extractTableData, handleCookieBanner, retryWithBackoff, createContext
- Inline execution for quick one-off tasks
- Responsive design testing (multiple viewport patterns)
- Login flow testing
- Broken link checking
- Form submission
- Error handling patterns (try-catch wrappers)
- Comprehensive API reference covering: selectors/locators, network interception, API mocking, Page Object Model, visual regression testing, mobile device emulation, accessibility testing (axe), parallel execution, data-driven testing, CI/CD integration (GitHub Actions), debugging techniques

### Methodology
- **Detect-first workflow**: always scan ports for running dev servers before writing test code
- **Write to /tmp**: never pollute user's project or skill directory with test files
- **Parameterize URLs**: put detected/provided URL in a `TARGET_URL` constant
- **Progressive disclosure**: API_REFERENCE.md only loaded when advanced features needed
- **Visible browser default**: opposite of webapp-testing's headless-first approach
- Async API (Node.js async/await) only

### Quality of Instructions
- Very thorough (453 lines SKILL.md + 653 lines API reference)
- Good conversational examples showing expected Claude-user interaction flow
- Extensive code examples for common patterns (responsive, login, forms, broken links)
- The `$SKILL_DIR` path resolution instructions are practical but add noise
- API_REFERENCE.md is essentially a Playwright tutorial/cheat sheet -- useful but could bloat context
- Risk of context window pollution given the sheer size (1,801 total lines)
- Well-organized with clear section headers

---

## Comparison

### What Overlaps Completely

| Capability | webapp-testing | playwright-skill |
|-----------|---------------|-----------------|
| Launch browser and navigate to URL | Yes (Python) | Yes (JS) |
| Take screenshots | Yes | Yes |
| Fill forms and click buttons | Yes | Yes |
| Wait for page load / networkidle | Yes | Yes |
| Element discovery / DOM inspection | Yes | Yes |
| Manage dev server lifecycle | Yes (with_server.py) | Yes (detectDevServers) |
| Console log capture | Yes (example) | Yes (API reference) |

The core workflow is identical: launch browser, navigate, wait for page ready, interact, screenshot, close. Both skills teach the same fundamental Playwright patterns, just in different languages.

### What is Unique to webapp-testing

1. **Python ecosystem** -- uses `sync_playwright` (synchronous Python API). Better if the project is Python-based or the LLM is already working in a Python context.
2. **Server lifecycle management** (`with_server.py`) -- actually STARTS servers, waits for them, runs a command, then STOPS them. This is process lifecycle management, not just detection. Supports multiple servers with different ports.
3. **Decision tree** -- explicit flowchart for "what approach should I use?" which helps LLM reasoning about when to use which pattern.
4. **Static HTML file:// pattern** -- explicit example for automating local HTML files without a server.
5. **Lean context footprint** -- 96-line SKILL.md + optional examples. Minimal context window usage.
6. **Black-box philosophy** -- explicitly tells the LLM to use scripts via `--help` rather than reading source code, preserving context window.

### What is Unique to playwright-skill

1. **JavaScript/Node.js ecosystem** -- uses async Playwright for Node. Better for JS/TS projects.
2. **Auto-detection of dev servers** -- scans 10+ common ports automatically via HTTP HEAD requests. More automated than webapp-testing's manual port specification.
3. **Universal executor** (`run.js`) -- handles file, inline, and stdin code input. Auto-wraps snippets into complete scripts. Auto-installs Playwright if missing.
4. **Rich helper library** (441 lines) -- safeClick with retry, safeType, authentication helper, cookie banner dismissal, table data extraction, scroll management, retry with exponential backoff.
5. **Custom HTTP header injection** -- environment variable-based header injection for identifying automated traffic.
6. **Visible browser by default** -- `headless: false` as the default, prioritizing debugging visibility.
7. **Comprehensive API reference** -- selectors best practices, Page Object Model, network interception, mobile emulation, accessibility testing, CI/CD integration, parallel execution, data-driven testing.
8. **Inline execution** -- quick one-off commands without creating files.
9. **Responsive testing patterns** -- explicit desktop/tablet/mobile viewport testing examples.
10. **Broken link checking** -- dedicated pattern for crawling and verifying links.

### Are They Complementary or Redundant?

**Mostly complementary, with a core of redundancy.**

The redundant core is: "here is how to use Playwright to navigate pages, interact with elements, and take screenshots." Both teach this, just in different languages.

Beyond that core, they are surprisingly complementary:

- **Language**: Python vs JavaScript -- different ecosystems entirely
- **Server management**: webapp-testing STARTS servers; playwright-skill DETECTS running servers. These solve different problems.
- **Philosophy**: webapp-testing is minimal and focused on teaching patterns; playwright-skill is a batteries-included toolkit with runtime infrastructure (executor, helpers, auto-install).
- **Context efficiency**: webapp-testing is designed for minimal context usage (~96 lines loaded); playwright-skill loads significantly more (~453+ lines).
- **Depth**: webapp-testing covers the basics well; playwright-skill goes deep into advanced patterns (POM, network mocking, a11y, CI/CD).

### If You Had to Pick One

**playwright-skill** -- with caveats.

Reasoning:
- It provides more functionality out of the box (auto-detection, executor, helper library, auto-install)
- The helper functions (safeClick, authenticate, handleCookieBanner, extractTableData) save significant time on real-world tasks
- The API reference is genuinely useful for advanced scenarios
- The universal executor (`run.js`) with code wrapping makes it easier for an LLM to run quick automation

However, there are real trade-offs:
- **Context window cost**: at 1,801 lines it is nearly 6x larger than webapp-testing (310 lines)
- **No server startup**: it can only DETECT servers, not start them. webapp-testing's `with_server.py` is more capable for CI or cold-start scenarios.
- **JS-only**: if you are working in a Python project, webapp-testing integrates more naturally
- **No decision tree**: the LLM gets less structured guidance on WHEN to use which approach

### Could the Best Parts Be Merged?

Yes, and this is probably the best path forward. Here is what an ideal merged skill would look like:

**Take from webapp-testing:**
1. The decision tree (static HTML vs dynamic, server running vs not) -- add to SKILL.md
2. The `with_server.py` script (or a JS equivalent) for starting servers, not just detecting them
3. The lean context philosophy -- keep SKILL.md concise, put API reference in a separate file loaded on demand
4. The static HTML `file://` pattern
5. The "black box" instruction about not reading helper source code

**Take from playwright-skill:**
1. The entire runtime infrastructure: `run.js` executor, auto-install, code wrapping
2. The `lib/helpers.js` utility library (safeClick, authenticate, handleCookieBanner, etc.)
3. Auto-detection of running dev servers
4. Custom HTTP header injection
5. The API_REFERENCE.md (kept as a separate load-on-demand file)
6. Responsive testing and broken link checking patterns
7. Inline execution support

**The result** would be a JS-based skill with:
- A concise SKILL.md (~150 lines) with a decision tree and core patterns
- A separate API_REFERENCE.md loaded only when needed
- `run.js` executor with auto-install
- `lib/helpers.js` with all utility functions
- A server manager script that can both DETECT and START servers
- Examples directory for common patterns (kept as separate files, not in SKILL.md)

This would keep context window usage low while providing comprehensive capability.

---

## Summary Table

| Dimension | webapp-testing | playwright-skill | Winner |
|-----------|---------------|-----------------|--------|
| Language | Python | JavaScript | Depends on project |
| Total size | 310 lines | 1,801 lines | webapp-testing (context efficiency) |
| SKILL.md size | 96 lines | 453 lines | webapp-testing (leaner) |
| Server management | Start + manage + stop | Detect only | webapp-testing |
| Helper utilities | None | 14 functions | playwright-skill |
| Auto-install | No | Yes | playwright-skill |
| Execution modes | Manual | File + inline + stdin | playwright-skill |
| Decision guidance | Decision tree | Workflow steps | webapp-testing |
| API depth | Basic | Comprehensive reference | playwright-skill |
| Advanced patterns | None | POM, mocking, a11y, CI/CD | playwright-skill |
| Custom headers | No | Yes | playwright-skill |
| Responsive testing | No | Yes | playwright-skill |
| Static HTML support | Yes | No | webapp-testing |
| Context efficiency | Excellent | Poor-to-moderate | webapp-testing |
| Origin | Anthropic official | Community (lackeyjb) | -- |
| License | Apache-2.0 | MIT | Both permissive |
