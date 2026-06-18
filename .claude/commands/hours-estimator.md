# hours-estimator

Expert man-hour estimation using industry-proven techniques (PERT, Bottom-Up, Story Points, FPA, Monte Carlo). Returns effort ranges with confidence levels, risk-adjusted buffers, and explicit assumptions — never a single number.

## Usage

```
/hours-estimator <task, feature, or project description>
/hours-estimator review CODE          # Review actual vs estimated for a project
/hours-estimator calibrate CODE       # Calculate team's estimation accuracy factor
```

## Behavior

1. Read the task description and classify by estimation context:
   - Scope clarity: known / partial / unknown
   - Technology familiarity: high / medium / low / new
   - Team history: has velocity data / no history

2. Select the appropriate technique(s) from the Hours Estimator skill:
   - Load `.agents/skills/hours-estimator/SKILL.md` and follow it exactly

3. Decompose the work into sub-tasks if the input is a large feature or project phase

4. Apply Three-Point Estimation (PERT) as the baseline technique:
   - Expected = (O + 4M + P) / 6
   - Include non-coding activities: testing, review, meetings, DevOps, documentation

5. Apply complexity multipliers based on technology and requirement clarity

6. Calculate buffer using the risk profile (10-50% depending on uncertainty)

7. If the project has history, pull velocity data:
   ```
   /ado-metrics CODE
   ```

8. Deliver the estimate with ranges at P50 / P80 / P90 confidence levels

## Output format

```
# Estimation: [Task or Feature]
Technique: [PERT / Bottom-Up / etc.]

| Task | Optimistic | Most Likely | Pessimistic | Expected | SD |
|------|-----------|-------------|-------------|----------|----|
| ...  | Xh        | Yh          | Zh          | ~Wh      | ±V |

## Summary
| Scenario    | Hours | Days  | Confidence |
|-------------|-------|-------|-----------|
| Optimistic  | Xh    | Xd    | ~20%      |
| Expected    | Yh    | Yd    | ~50%      |
| With buffer | Zh    | Zd    | ~80%      |
| Conservative| Wh    | Wd    | ~90%      |

Recommendation: Commit to [X] hours (~[N] days) with [Y]% buffer.

## Included in estimate
✅ Implementation (~X%)  ✅ Testing (~X%)
✅ Code review (~X%)     ✅ Meetings (~X%)
✅ DevOps/CI-CD (~X%)    ❌ [Excluded — reason]

## Key assumptions
- [Assumption 1]: if invalid → adds ~Xh
- [Assumption 2]: if invalid → adds ~Yh

## Uncertainty flags
- 🔴 [Task]: P/O = Nx — consider a spike first
- 🟡 [Task]: [reason] — covered in buffer
```

## Notes

- Default unit: hours (h). Use days (d) if hours are specified
- Default: 5 working days/week, 8h/day
- Always document assumptions that could invalidate the estimate
- For fixed-price contracts, recommend committing to the P80 scenario minimum
- If task P/O ratio > 4×, flag it as structurally uncertain before committing
