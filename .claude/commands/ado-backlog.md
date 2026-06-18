# ado-backlog

Review, refine, and manage the Azure DevOps backlog — Epics, Features, and Stories/PBIs.

## Usage

```
/ado-backlog [level: epic | feature | story] [action: review | refine | prioritize | groom]
```

## Behavior

1. Pull current backlog items from ADO using the configured org/project
2. Based on action:
   - **review**: list all items at the specified level with status, priority, and parent linkage
   - **refine**: flag items missing acceptance criteria, estimates, or parent links
   - **prioritize**: reorder suggestions based on business value and dependencies
   - **groom**: identify stale items (no update in 30+ days), items without estimates, and orphaned stories
3. Highlight items that are blocked or have unresolved dependencies
4. Output a groomed backlog summary with recommended actions

## Output format

```
# Backlog Review — [Level] | [Date]
**Project:** $ADO_PROJECT

## Items Requiring Attention
| ID | Title | Issue | Recommended Action |
|----|-------|-------|--------------------|
| #  | ...   | Missing AC / No estimate / Orphaned | ... |

## Prioritized Backlog (top 10)
| Priority | ID | Title | State | Story Points | Parent Feature |
|----------|----|-------|-------|--------------|----------------|

## Grooming Notes
- X items have no estimates
- X items haven't been updated in 30+ days
- X stories are not linked to a Feature
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT env vars — never hardcode credentials
- Default level is `story` (User Story / PBI)
- Stale threshold: 30 days with no field update
- Tone: actionable, concise — flag problems, don't just list items
