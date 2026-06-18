# retrospective

Facilitate an agile retrospective — generate discussion prompts, capture input, and produce an action plan.

## Usage

```
/retrospective [sprint name or project phase] [format: start-stop-continue | 4Ls | mad-sad-glad]
```

## Behavior

1. Default format: Start / Stop / Continue
2. If running live: prompt for team input on each category interactively
3. If given raw notes: organize them into the retro format and extract themes
4. Identify the top 3 actionable improvements
5. Generate a clean summary with assigned action items and owners

## Output format

```
# Retrospective: [Sprint/Phase]
**Date:** [today]  |  **Format:** Start / Stop / Continue

## What went well (Continue)
- ...

## What to stop doing (Stop)
- ...

## What to start doing (Start)
- ...

## Top 3 Action Items
| Action | Owner | Due | ADO Item? |
|--------|-------|-----|-----------|
| ...    | ...   | ... | Yes/No    |

## Themes identified
- ...
```

## Notes

- Keep the tone constructive — rephrase blame statements as process observations
- Suggest creating ADO work items for action items when appropriate
- Output is suitable for sharing with the team via email or Teams
