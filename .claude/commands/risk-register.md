# risk-register

Identify, assess, and document project risks in a structured risk register.

## Usage

```
/risk-register <project name or context>
```

## Behavior

1. Prompt for project context if not provided
2. Generate a risk register with:
   - Risk identification (what could go wrong)
   - Probability (Low / Medium / High)
   - Impact (Low / Medium / High)
   - Risk score (Probability × Impact)
   - Mitigation strategy
   - Owner and target resolution date
3. Sort risks by score descending (highest priority first)
4. Highlight any risks rated High × High as critical

## Output format

```
# Risk Register: [Project Name]
**Date:** [today]

| # | Risk | Probability | Impact | Score | Mitigation | Owner | Due |
|---|------|-------------|--------|-------|-----------|-------|-----|
| 1 | ...  | High        | High   | 9     | ...        | ...   | ... |
```

## Notes

- Use standard 3×3 risk matrix (1=Low, 2=Med, 3=High; Score = P × I)
- If ADO work items are available, suggest creating tasks for mitigation actions
- Tone: direct and factual — risk language should be unambiguous
