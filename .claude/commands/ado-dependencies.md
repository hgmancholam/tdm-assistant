# ado-dependencies

Identify, visualize, and manage cross-team or cross-item dependencies in Azure DevOps.

## Usage

```
/ado-dependencies [scope: sprint | feature | project] [feature-id: <ID>]
```

## Behavior

1. Query ADO for items with Predecessor/Successor links within the specified scope
2. Build a dependency map showing:
   - Blocking items (items that must complete before others can start)
   - Blocked items (items waiting on others)
   - Cross-team dependencies (items owned by different teams)
3. Flag critical path dependencies that risk the sprint/release
4. Suggest mitigation for unresolved blocking dependencies
5. Output in text format suitable for Delivery Plan or status report

## Output format

```
# Dependency Map — [Scope]
**Date:** [today]  |  **Project:** $ADO_PROJECT

## Critical Dependencies (blocking sprint/release)
| Blocked Item | Title | Blocked By | Owner | Due | Risk |
|--------------|-------|-----------|-------|-----|------|
| #XXX         | ...   | #YYY      | ...   | ... | 🔴 High |

## Cross-Team Dependencies
| Consumer Team | Item # | Depends On | Provider Team | Status |
|---------------|--------|------------|---------------|--------|

## Resolved This Period
| Item # | Title | Resolved Date |
|--------|-------|---------------|

## Recommendations
- [Item #]: escalate to [team] — blocking 3 downstream items
- [Item #]: consider decoupling — dependency chain is 4 levels deep
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT env vars
- Default scope = current sprint
- Tag-based queries: also surface items tagged `dependency` or `blocked`
- Cross-team = items in different Area Paths
