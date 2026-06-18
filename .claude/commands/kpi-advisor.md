# kpi-advisor

Expert KPI design and quantitative project health measurement. Defines the right indicators for this specific project — with exact formulas, data sources, RAG thresholds, and early-warning combos. Diagnoses project health with numbers, not perceptions.

## Usage

```
/kpi-advisor define CODE              # Design a KPI framework for a project
/kpi-advisor health CODE              # Quantitative health diagnosis with current data
/kpi-advisor alert CODE               # Check if any early-warning combos are active
/kpi-advisor okr CODE [objective]     # Translate a project objective into OKR format
```

## Behavior

1. Load the KPI Advisor skill:
   - Read `.agents/skills/kpi-advisor/SKILL.md` and follow it exactly

2. For `define`:
   - Read `projects/CODE/project.settings` to understand project type, team, stakeholders
   - Ask the user for the business objective if not already stated
   - Select KPIs across 6 categories: Delivery, Quality, Flow, DORA, Stakeholder, Team Health
   - Prioritize into Tier 1 (executive), Tier 2 (TDM), Tier 3 (internal)
   - Identify gaps: which KPIs cannot be measured yet and why

3. For `health`:
   - Collect current data:
     ```
     /ado-metrics CODE
     /ado-board CODE
     /budget-review CODE
     ```
   - Calculate each KPI value vs benchmark
   - Detect active early-warning combos (Cliff Sprint, Tech Debt Bomb, etc.)
   - Produce the full quantitative health report

4. For `alert`:
   - Run a fast check on the 5 early-warning combos
   - Report active alerts only — no noise if all is green

5. For `okr`:
   - Map the stated objective to 3 measurable Key Results
   - Each KR has current value, target value, and due date

## Output format

### define
```
# KPI Framework — [Project] ([CODE])

## Business alignment
[Objective → KPI cascade]

## Tier 1 — Executive KPIs
| # | KPI | Formula | Source | Freq | 🟢 | 🟡 | 🔴 | Current |
...

## Tier 2 — Delivery KPIs (TDM)
...

## Tier 3 — Team Health (internal)
...

## Leading indicators active
- [KPI]: [why it predicts risk] — alert at [value]

## Measurement gaps
- ❌ [KPI]: [action to enable it]
```

### health
```
# Health Diagnosis — [Project] ([CODE])

## Executive scorecard
| Category           | Status  | Trend | Critical KPI | Value |
| Delivery           | 🟢/🟡/🔴 | ↑/→/↓ | [KPI]       | [val] |
...

Overall health: 🟢/🟡/🔴 — [2-sentence verdict]

## Active alerts
| Priority | KPI | Current | Benchmark | Risk combo |
...

## Recommendations
1. [Action] — based on [KPI value] — improves: [KPI]
```

## Notes

- Maximum 5-6 KPIs in Tier 1 — more metrics is noise, not value
- Every red KPI must have an associated action, not just an observation
- Benchmarks are references, not absolutes — always contextualize to project type and phase
- DORA metrics apply to projects with active CI/CD; adapt to "releases" for consulting projects
