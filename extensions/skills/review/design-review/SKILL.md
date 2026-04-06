---
name: design-review
description: Multi-phase UI/UX design review covering interaction flows, responsiveness, visual polish, accessibility (WCAG 2.1 AA), robustness, code health, and content quality.
---

Conduct a world-class design review following the rigorous standards of top Silicon Valley companies like Stripe, Airbnb, and Linear.

**Core Methodology:**
Strictly adhere to the "Live Environment First" principle -- always assess the interactive experience before diving into static analysis or code. Prioritize the actual user experience over theoretical perfection.

**Review Process:**

Systematically execute a comprehensive design review following these phases:

## Phase 0: Preparation
- Analyze the PR description to understand motivation, changes, and testing notes (or the description of the work to review in the user's message if no PR supplied)
- Review the code diff to understand implementation scope
- Set up the live preview environment using Playwright
- Configure initial viewport (1440x900 for desktop)

## Phase 1: Interaction and User Flow
- Execute the primary user flow following testing notes
- Test all interactive states (hover, active, disabled)
- Verify destructive action confirmations
- Assess perceived performance and responsiveness

## Phase 2: Responsiveness Testing
- Test desktop viewport (1440px) -- capture screenshot
- Test tablet viewport (768px) -- verify layout adaptation
- Test mobile viewport (375px) -- ensure touch optimization
- Verify no horizontal scrolling or element overlap

## Phase 3: Visual Polish
- Assess layout alignment and spacing consistency
- Verify typography hierarchy and legibility
- Check color palette consistency and image quality
- Ensure visual hierarchy guides user attention

## Phase 4: Accessibility (WCAG 2.1 AA)
- Test complete keyboard navigation (Tab order)
- Verify visible focus states on all interactive elements
- Confirm keyboard operability (Enter/Space activation)
- Validate semantic HTML usage
- Check form labels and associations
- Verify image alt text
- Test color contrast ratios (4.5:1 minimum)

## Phase 5: Robustness Testing
- Test form validation with invalid inputs
- Stress test with content overflow scenarios
- Verify loading, empty, and error states
- Check edge case handling

## Phase 6: Code Health
- Verify component reuse over duplication
- Check for design token usage (no magic numbers)
- Ensure adherence to established patterns

## Phase 7: Content and Console
- Review grammar and clarity of all text
- Check browser console for errors/warnings

## Communication Principles

1. **Problems Over Prescriptions**: Describe problems and their impact, not technical solutions. Example: Instead of "Change margin to 16px", say "The spacing feels inconsistent with adjacent elements, creating visual clutter."

2. **Triage Matrix**: Categorize every issue:
   - **[Blocker]**: Critical failures requiring immediate fix
   - **[High-Priority]**: Significant issues to fix before merge
   - **[Medium-Priority]**: Improvements for follow-up
   - **[Nitpick]**: Minor aesthetic details (prefix with "Nit:")

3. **Evidence-Based Feedback**: Provide screenshots for visual issues and always start with positive acknowledgment of what works well.

## Report Structure

```markdown
### Design Review Summary
[Positive opening and overall assessment]

### Findings

#### Blockers
- [Problem + Screenshot]

#### High-Priority
- [Problem + Screenshot]

#### Medium-Priority / Suggestions
- [Problem]

#### Nitpicks
- Nit: [Problem]
```

## Technical Requirements

Use the Playwright MCP toolset for automated testing:
- `mcp__playwright__browser_navigate` for navigation
- `mcp__playwright__browser_click/type/select_option` for interactions
- `mcp__playwright__browser_take_screenshot` for visual evidence
- `mcp__playwright__browser_resize` for viewport testing
- `mcp__playwright__browser_snapshot` for DOM analysis
- `mcp__playwright__browser_console_messages` for error checking

Maintain objectivity while being constructive, always assuming good intent from the implementer. The goal is to ensure the highest quality user experience while balancing perfectionism with practical delivery timelines.

## Additional Resources

- `references/design-principles-example.md` -- an S-Tier SaaS Dashboard Design Checklist covering color, typography, spacing, components, layout, interaction design, and accessibility. Load this file when you need a detailed design principles reference or checklist to evaluate against.
