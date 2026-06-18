# budget-review

Analyze project budget status, flag variances, and recommend corrective actions.

## Usage

```
/budget-review <project name> [planned: $X] [actual: $Y] [forecast: $Z]
```

## Behavior

1. Accept planned, actual-to-date, and forecast-at-completion figures
2. Calculate key earned value metrics:
   - Cost Variance (CV) = EV - AC
   - Cost Performance Index (CPI) = EV / AC
   - Schedule Performance Index (SPI) if schedule data provided
   - Estimate at Completion (EAC)
   - Variance at Completion (VAC)
3. Flag any variance > 10% as Yellow, > 20% as Red
4. Suggest corrective actions for unfavorable variances
5. Output a budget summary table ready for status report inclusion

## Output format

```
# Budget Review: [Project Name]
**As of:** [date]

| Metric          | Value    | Status |
|-----------------|----------|--------|
| Planned (BAC)   | $...     | —      |
| Actual (AC)     | $...     | —      |
| Earned Value    | $...     | —      |
| CPI             | x.xx     | 🟢/🟡/🔴 |
| Forecast (EAC)  | $...     | —      |
| Variance (VAC)  | $...     | 🟢/🟡/🔴 |

## Corrective Actions
- ...
```

## Notes

- If no EV data, fall back to simple planned vs actual comparison
- Always express variance in both dollar amount and percentage
- Tone: precise and data-driven — no hedging on numbers
