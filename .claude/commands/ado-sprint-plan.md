# ado-sprint-plan

Plan or review the current sprint — capacity, committed work, and sprint goal alignment.

## Usage

```
/ado-sprint-plan [action: review | plan | close] [sprint: current | next | <sprint name>]
```

## Behavior

1. Fetch the target sprint's work items, capacity, and taskboard state from ADO
2. Based on action:
   - **review**: show sprint progress — completed vs remaining, blockers, and burndown trend
   - **plan**: validate that committed items fit within team capacity; flag over/under-commitment
   - **close**: summarize completed items, unfinished work, and recommend what to carry over or re-estimate
3. Flag work items that have no remaining work estimate or are past their sprint
4. Suggest a sprint goal if one is not set

## Output format

```
# Sprint Plan: [Sprint Name]
**Dates:** [start] → [end]  |  **Team capacity:** X days

## Sprint Goal
[Goal statement or "⚠️ No sprint goal defined"]

## Commitment Summary
| State      | Count | Story Points |
|------------|-------|--------------|
| Done       | X     | X            |
| In Progress| X     | X            |
| Not Started| X     | X            |
| **Total**  | X     | X            |

## Capacity vs Commitment
- Team capacity: X pts  |  Committed: X pts  |  Variance: ±X pts

## Blockers & Risks
- [Work item #] — [blocker description]

## Carry-over Candidates (for close action)
- [Work item #] — [title] — [reason]
```

## Notes

- Uses $ADO_ORG, $ADO_PROJECT; default sprint = current active iteration
- Always flag items in progress with no update in 2+ days
- Tone: factual and sprint-focused — PMs need signal, not noise
