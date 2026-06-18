# status-report

Generate a professional project status report for stakeholder distribution.

## Usage

```
/status-report <project name> [period: weekly | biweekly | monthly]
```

## Behavior

1. Pull context from ADO (current sprint, open/closed items) if available
2. Ask for any manual updates not in ADO (blockers, decisions, escalations)
3. Generate a concise status report covering:
   - Overall status (Green / Yellow / Red) with one-line justification
   - Accomplishments this period
   - Planned work next period
   - Risks and issues
   - Decisions needed from stakeholders
4. Format for email or document distribution

## Output format

```
# Project Status Report — [Project Name]
**Period:** [date range]  |  **Status:** 🟢 Green / 🟡 Yellow / 🔴 Red
**Prepared by:** Harol Manchola

## Summary
[2-3 sentence executive summary]

## Accomplishments
- ...

## Next Period Plan
- ...

## Risks & Issues
| Item | Severity | Action | Owner |
|------|----------|--------|-------|

## Decisions Needed
- ...
```

## Notes

- Default period is current week unless specified
- Keep executive summary under 3 sentences
- Red status always requires an escalation path in the Risks section
- Tone: professional, senior TDM level
