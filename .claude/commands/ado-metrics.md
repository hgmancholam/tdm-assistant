# ado-metrics

Calculate and report velocity, cycle time, lead time, and flow metrics from ADO data.

## Usage

```
/ado-metrics [team: <team name>] [period: last-3-sprints | last-6-sprints | month | quarter]
```

## Behavior

1. Pull completed work items for the specified team and period from ADO
2. Calculate:
   - **Velocity**: story points (or item count) completed per sprint
   - **Cycle time**: avg days from "In Progress" → "Done" per item type
   - **Lead time**: avg days from "New/Created" → "Done"
   - **Throughput**: items completed per sprint
   - **Bug ratio**: bugs closed / total items closed
   - **Spillover rate**: % of committed items not completed in sprint
3. Detect trends (improving / stable / degrading) across the period
4. Recommend capacity target for next sprint based on velocity trend

## Output format

```
# Flow Metrics — [Team] | [Period]
**Generated:** [today]

## Velocity (Story Points)
Sprint N-2: XX pts
Sprint N-1: XX pts
Sprint N:   XX pts
Avg: XX pts  |  Trend: ↑ Improving / → Stable / ↓ Degrading

## Cycle Time (avg days, by type)
| Type    | Avg Cycle Time | Target | Status |
|---------|---------------|--------|--------|
| Story   | X days        | 5d     | 🟢     |
| Bug     | X days        | 3d     | 🔴     |
| Task    | X days        | 2d     | 🟡     |

## Lead Time Avg: X days
## Throughput Avg: X items/sprint
## Spillover Rate: X%  |  Bug Ratio: X%

## Capacity Recommendation for Next Sprint
**Commit target:** XX story points (based on 3-sprint avg × 0.85 buffer)
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT env vars
- Cycle time requires "Activated Date" and "Closed Date" fields on work items
- Spillover = items assigned to sprint but moved out or closed after sprint end
- Trend = compare last sprint to 3-sprint average
