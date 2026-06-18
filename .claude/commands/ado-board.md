# ado-board

Audit and optimize Kanban board configuration — columns, WIP limits, swimlanes, and flow health.

## Usage

```
/ado-board [team: <team name>] [action: audit | wip-check | flow-health]
```

## Behavior

1. Pull current board configuration and active work items for the team
2. Based on action:
   - **audit**: review column setup, WIP limits, and swimlane definitions; flag missing DoD per column
   - **wip-check**: identify columns currently over WIP limit; list offending items with assignees
   - **flow-health**: analyze item age per column, flag items stuck > 3 days, and highlight bottlenecks
3. Recommend specific configuration improvements based on findings
4. Output a board health scorecard

## Output format

```
# Board Audit: [Team Name]
**Date:** [today]

## Column Configuration
| Column | WIP Limit | Current Count | Status | DoD Defined |
|--------|-----------|---------------|--------|-------------|
| ...    | X         | Y             | 🟢/🔴  | Yes/No      |

## WIP Violations
| Column | Item # | Title | Assignee | Days in Column |
|--------|--------|-------|----------|----------------|

## Bottlenecks (items stuck > 3 days)
| Item # | Title | Column | Days Stuck | Assignee |
|--------|-------|--------|------------|----------|

## Recommendations
1. ...
2. ...

## Board Health Score: X/10
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT env vars
- Default team = project default team
- A column with no WIP limit is flagged as a configuration gap
- Items stuck >5 days are escalation candidates
