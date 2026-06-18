# decision-log

Document a project decision with context, options considered, rationale, and owner.

## Usage

```
/decision-log <decision description>
```

## Behavior

1. Capture the decision context and trigger (what forced a decision)
2. List the options that were considered
3. Document the selected option and the reasoning
4. Record the decision owner and date
5. Note any assumptions, constraints, or conditions under which the decision should be revisited
6. Append to a running decision log if one exists; otherwise start a new one

## Output format

```
# Decision Log Entry
**Date:** [today]  |  **Owner:** Harol Manchola  |  **Project:** [name]

## Context
[What triggered this decision — 1-2 sentences]

## Options Considered
1. [Option A] — [brief trade-off]
2. [Option B] — [brief trade-off]
3. [Option C] — [brief trade-off]

## Decision
**Selected:** Option [X]

**Rationale:** [2-3 sentences — why this option, what constraints drove it]

## Conditions for Revisit
- If [condition], this decision should be re-evaluated

## Stakeholders Informed
- [Name / role]
```

## Notes

- Every significant project decision deserves a log entry — this prevents "why did we do that?" moments later
- Link to ADO work item or PR where relevant
- Tone: factual and precise — future readers need to understand the context cold
