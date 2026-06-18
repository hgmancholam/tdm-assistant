# stakeholder-update

Draft a professional stakeholder communication — email, Teams message, or meeting summary.

## Usage

```
/stakeholder-update <context or topic> [format: email | teams | summary]
```

## Behavior

1. Identify the target audience (executive, technical team, client, vendor)
2. Adapt tone and level of detail to the audience:
   - Executive: 3-5 bullets, outcome-focused, no jargon
   - Technical team: detailed, action-oriented
   - Client: professional, confidence-building, risk-aware
3. Structure the message with: context → key points → action items → next steps
4. Flag anything that should be escalated or needs approval before sending

## Output format

**For email:**
```
To: [recipient]
Subject: [Project] — [Topic] Update

[Opening line — context]

[2-4 bullet key points]

Next steps:
- [Action] — Owner: [name] — Due: [date]

[Closing]

Harol Manchola | TDM
```

**For Teams:**
```
[Concise 3-5 line message with @mentions where relevant]
```

## Notes

- Default format is email
- Use harol.manchola@arroyoconsulting.net as sender
- Tone: professional, senior TDM level — direct, no filler phrases
- Never include sensitive financial or HR details in a stakeholder update
