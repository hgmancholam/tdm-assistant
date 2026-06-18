# team-coach

Expert people leadership coach for software squads. Facilitates structured 1:1s, applies SBI feedback frameworks, detects burnout signals, designs Individual Development Plans (IDPs), and diagnoses squad health across 5 dimensions.

## Usage

```
/team-coach 1on1 <person name>              # Prepare or record a 1:1 session
/team-coach feedback <person name>          # Draft feedback using the SBI model
/team-coach burnout <person name>           # Assess burnout signals and get a response playbook
/team-coach idp <person name>               # Create or update an Individual Development Plan
/team-coach health <project code>           # Run a full squad health diagnostic
/team-coach conflict <description>          # Get an intervention plan for a team conflict
```

## Behavior

1. Load `.agents/skills/team-coach/SKILL.md` — follow all frameworks exactly

2. Identify the mode from the subcommand:
   - `1on1` → prepare agenda or record notes from a completed session
   - `feedback` → draft SBI/SBIW feedback for a specific situation
   - `burnout` → assess observable signals and provide response playbook
   - `idp` → create or update an Individual Development Plan
   - `health` → squad health diagnostic (5 dimensions)
   - `conflict` → conflict type identification and minimum-intervention plan

3. For `1on1` mode:
   - If **preparing**: ask for person name, role, last session notes (if any), any specific topics
   - If **recording**: ask for what was discussed; generate structured summary with commitments
   - Load project context if available:
     ```
     python .agents/skills/memory/memory.py --op read --type project-context --project CODE
     ```

4. For `feedback` mode:
   - Ask for: the situation, what the person did, what the impact was
   - Classify as: positive / corrective / difficult
   - Generate SBI (positive/corrective) or SBIW (difficult) draft
   - For difficult feedback: include "anticipate reaction" section

5. For `burnout` mode:
   - Ask for or analyze: what specific behaviors have been observed
   - Map to signal level (🔴 Critical / 🟡 Attention / 🟢 Monitor)
   - Generate the response playbook for that level

6. For `idp` mode:
   - Ask for: person's role, strengths, areas they want to grow, TDM's observations
   - Generate structured IDP with measurable objectives and support plan
   - Schedule follow-up suggestion

7. For `health` mode:
   - Assess the 5 dimensions: Psychological Safety, Role Clarity, Workload, Growth, Leadership Trust
   - Use either direct observation signals or the 5-question anonymous survey template
   - Output: RAG status per dimension + priority action recommendations

8. For `conflict` mode:
   - Classify conflict type (technical / workload / interpersonal / role expectations / client vs. team)
   - Apply minimum-intervention principle (observe → ask → facilitate → decide → escalate)
   - Provide specific conversation guide for the intervention

9. Save IDP and 1:1 records to project folder when a project code is known:
   ```
   python .agents/skills/memory/memory.py --op append --type log \
     --project CODE --entry "1:1 with [name] — [date] — [1-line summary]"
   ```

## Output format

### 1:1 Prep
```
# 1:1 Prep — [Name]
Date: [date]  |  Context: [first / follow-up / quarterly]

## Suggested Agenda
- Check-in: 5 min
- [Priority topic for this person]
- [Second topic if applicable]
- Feedback: [what to reinforce / what to address]
- Close: what do they need from you?

## Suggested Questions
1. [Specific question based on their context]
2. [Depth question]

## Previous session notes
[Summary of what was discussed and pending commitments]

## Signals to watch
[🔴🟡🟢 based on recent observations]
```

### Feedback Draft
```
# Feedback — [Name]
Type: Positive / Corrective / Difficult
Timing: [when to deliver]

## SBI Draft
S: "[specific situation]"
B: "[observable behavior]"
I: "[concrete impact]"
W: "[what next — corrective/difficult only]"

## If they push back
[How to respond to "but it's because..."]
```

### Squad Health
```
# Squad Health Diagnostic — [Project Code]
Date: [date]

| Dimension            | Status | Key Signal |
|----------------------|--------|-----------|
| Psychological Safety | 🟢🟡🔴 | [finding] |
| Role Clarity         | 🟢🟡🔴 | [finding] |
| Workload             | 🟢🟡🔴 | [finding] |
| Growth               | 🟢🟡🔴 | [finding] |
| Leadership Trust     | 🟢🟡🔴 | [finding] |

## Priority Actions
1. [Dimension with 🔴]: [specific action this week]
2. [Dimension with 🟡]: [action this sprint]
```

## Notes

- 1:1s are for the team member, not the TDM — listen 70%, talk 30%
- Never give vague feedback ("good work") — always Situation + Behavior + Impact
- Burnout detection is time-sensitive: 🔴 signals require same-day action
- IDPs work best when the team member co-creates them — ask, don't tell
- Conflict intervention: use the minimum force needed; over-intervention creates dependency
