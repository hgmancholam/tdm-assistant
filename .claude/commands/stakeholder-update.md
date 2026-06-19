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

**For email — HTML (MANDATORY format rules):**

- White background (`#ffffff`). Black text (`#1a1a1a`). No decorative colors.
- **Zero emojis** in the HTML.
- No colored banners, no colored boxes, no badges, no `border-radius`, no `box-shadow`.
- Health status only exception: words `GREEN` / `YELLOW` / `RED` as inline bold text — never as background or badge.
- Layout via `<table>`, Calibri 11pt, sections with `<strong>` + `border-bottom: 1px solid #cccccc`.
- Use the same template as `/email-send`.

Draft preview:
```
To: [recipient]
Subject: [Project] — [Topic] Update
──────────────────────────────────────
[Markdown preview of content]
──────────────────────────────────────
Send? [y / n / edit]
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
- Always show draft and ask for confirmation before sending
