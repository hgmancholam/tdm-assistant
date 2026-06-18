# ado-query

Build and run Azure DevOps work item queries using natural language or WIQL.

## Usage

```
/ado-query <natural language question or WIQL>
```

## Examples

```
/ado-query show all open bugs assigned to me in the current sprint
/ado-query features not linked to any story in the last quarter
/ado-query all items changed in the last 7 days with no assignee
/ado-query SELECT [ID], [Title], [State] FROM WorkItems WHERE [Iteration Path] = @CurrentIteration
```

## Behavior

1. If input is natural language: translate to WIQL automatically
2. Run the query against ADO using $ADO_ORG and $ADO_PROJECT
3. Return results in a clean table
4. For large result sets (> 20 items): summarize by state/type and show top 10
5. Offer to save the query as a Shared Query in ADO if useful

## Output format

```
# Query Results
**Query:** [natural language or WIQL]
**Returned:** X items  |  **Date:** [today]

| ID | Title | Type | State | Assignee | Iteration | Updated |
|----|-------|------|-------|----------|-----------|---------|
| #  | ...   | ...  | ...   | ...      | ...       | ...     |

## Summary
- New: X  |  Active: X  |  Resolved: X  |  Closed: X
```

## Common Queries (built-in shortcuts)

| Shortcut | What it returns |
|----------|----------------|
| `my-items` | All open items assigned to me across all sprints |
| `sprint-bugs` | All open bugs in current sprint |
| `unassigned` | All active items with no assignee |
| `stale` | Items not updated in 14+ days |
| `no-estimate` | Active stories/PBIs with no story points |

## Notes

- Uses $ADO_ORG, $ADO_PROJECT, $ADO_PAT env vars
- WIQL tip: use `@Me` for current user, `@CurrentIteration` for active sprint
- Results > 50 items are paginated — ask for more if needed
