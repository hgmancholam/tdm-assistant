# time-estimate

Generate realistic time estimates for tasks or project phases using structured estimation techniques.

## Usage

```
/time-estimate <task or feature description>
```

## Behavior

1. Break the input into sub-tasks if it's a large feature or phase
2. Apply three-point estimation for each sub-task:
   - Optimistic (O): best case
   - Most Likely (M): realistic case
   - Pessimistic (P): worst case
   - Expected = (O + 4M + P) / 6
3. Sum expected estimates and add a contingency buffer (15% default)
4. Flag any task with P/O ratio > 3× as high-uncertainty
5. Recommend parallelizable tasks when applicable

## Output format

```
# Time Estimate: [Task/Feature]

| Task | Optimistic | Most Likely | Pessimistic | Expected |
|------|-----------|-------------|-------------|----------|
| ...  | Xd        | Yd          | Zd          | ~Wd      |

**Total (no buffer):** X days
**Recommended estimate (15% buffer):** Y days
**Target completion:** [date from today]

## Uncertainty flags
- [Task]: high variance — clarify requirements before committing
```

## Notes

- Use days (d) as the unit unless hours are specified
- Default working days: 5/week, 8h/day
- Always call out assumptions that could invalidate the estimate
