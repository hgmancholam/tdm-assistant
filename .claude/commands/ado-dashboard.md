# ado-dashboard

Generate a text-based dashboard summary from ADO data — sprint health, velocity, and team metrics.

## Usage

```
/ado-dashboard [scope: team | program | leadership] [period: sprint | month | quarter]
```

## Behavior

1. Pull data from ADO: active sprint, recent velocity, open/closed items, PR status, pipeline runs
2. Compose a dashboard summary tailored to the scope:
   - **team**: sprint burndown, WIP, blockers, daily focus
   - **program**: cross-team progress, feature completion rate, dependency status
   - **leadership**: delivery health, strategic KPIs, risk radar
3. Calculate key metrics inline (no external BI tool needed)
4. Flag anything in Red status for immediate attention

## Output format

```
# ADO Dashboard — [Scope] | [Period]
**Generated:** [today]  |  **Project:** $ADO_PROJECT

## 🟢 Health Overview
| Area          | Status | Signal |
|---------------|--------|--------|
| Sprint progress | 🟢    | 68% complete, on track |
| Open blockers   | 🔴    | 3 blockers unresolved |
| PR pipeline     | 🟡    | 5 PRs open > 2 days   |
| Velocity trend  | 🟢    | 42 pts avg (last 3 sprints) |

## Sprint Burndown (text)
Day 1 ████████████████████ 100%
Day 5 ████████████░░░░░░░░  62%
Today ██████████░░░░░░░░░░  48% ← on track

## Top Blockers
| # | Title | Owner | Days Blocked |
|---|-------|-------|--------------|

## Metrics
- Velocity (last 3 sprints): X / X / X pts — trend: ↑/→/↓
- Cycle time avg: X days
- Lead time avg: X days
- Bug open/close ratio: X/X
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT env vars
- Default scope = team; default period = current sprint
- This is a text dashboard — no external tooling required
- Suitable for pasting into standup, email, or Teams channel
