# scope-change

Evaluate, document, and communicate a scope change request with impact analysis.

## Usage

```
/scope-change <description of requested change>
```

## Behavior

1. Document the change request clearly
2. Analyze impact across:
   - Schedule: estimated additional days
   - Budget: estimated additional cost
   - Resources: who is affected
   - Dependencies: what other items are impacted
3. Assign a risk level (Low / Medium / High) to the change
4. Recommend: Approve / Reject / Defer with justification
5. Generate a Change Request document ready for stakeholder sign-off

## Output format

```
# Change Request #[auto-number]
**Date:** [today]  |  **Requestor:** [name]  |  **Project:** [name]

## Change Description
[Clear statement of what is being added, removed, or modified]

## Impact Analysis
| Dimension  | Impact         | Detail           |
|------------|----------------|------------------|
| Schedule   | +X days        | ...              |
| Budget     | +$X / None     | ...              |
| Resources  | [names/teams]  | ...              |
| Risk       | Low/Med/High   | ...              |

## Recommendation
**[Approve / Reject / Defer]** — [1-2 sentence justification]

## Approval Required From
- [ ] [Stakeholder name / role]
```

## Notes

- Never approve scope changes without documenting the impact — even "small" ones
- Flag changes that affect contractual deliverables with a ⚠️ warning
- Tone: neutral and analytical — let the impact data speak
