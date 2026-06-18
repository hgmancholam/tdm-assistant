# status-report

Generate a formal project status report for stakeholder distribution via email.

## Usage

```
/status-report <project name> [period: weekly | biweekly | monthly]
```

## Behavior

1. Pull context from ADO (current sprint, open/closed items) if available
2. Ask for any manual updates not in ADO (blockers, decisions, escalations)
3. Generate the HTML report (see template below)
4. Show a Markdown preview to the user for review/edits
5. On confirmation, ask: **"Send via email or save to file?"**
   - **Email**: invoke `/email-send` flow — subject must be plain ASCII, no emojis
   - **File**: save to `projects/<CODE>/reports/status-<date>.html`

## HTML Report Template

Format as a formal business document — the kind a senior consultant sends.
No icons. No colored banners. No metric badges. No decorative elements.
Structure through bold section headers, a single ruled line, and a clean table.

```html
<html>
<head><meta charset="UTF-8"></head>
<body style="font-family:Calibri,Arial,sans-serif;font-size:11pt;color:#1a1a1a;margin:0;padding:0;background:#ffffff;">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="padding:28px 32px;max-width:680px;">

    <!-- Report header (text, no banner) -->
    <p style="margin:0 0 4px;font-size:13pt;font-weight:bold;">[PROJECT NAME] &#8212; Project Status</p>
    <p style="margin:0 0 20px;font-size:10pt;color:#555555;">[Period] | Prepared by Harol Manchola, Technical Delivery Manager | Arroyo Consulting</p>

    <!-- Sprint + Status summary -->
    <p style="margin:0 0 6px;"><strong>Sprint:</strong> [Sprint name] | [Start] &#8211; [End] | Day [N] of [Total] ([%] elapsed)</p>
    <p style="margin:0 0 20px;"><strong>Status:</strong> [GREEN / YELLOW / RED] &#8212; [One-line justification]</p>

    <!-- Metrics (inline text, not badges) -->
    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">SPRINT METRICS</p>
    <p style="margin:0 0 14px;">
      Total: <strong>[N]</strong> &nbsp;&nbsp;
      Closed: <strong>[N] ([%])</strong> &nbsp;&nbsp;
      In Progress: <strong>[N] ([%])</strong> &nbsp;&nbsp;
      Not Started: <strong>[N] ([%])</strong>
    </p>

    <!-- Accomplishments -->
    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">ACCOMPLISHMENTS</p>
    <ul style="margin:0 0 14px;padding-left:20px;">
      <li style="margin:4px 0;">[item]</li>
    </ul>

    <!-- Active Items -->
    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">ACTIVE ITEMS</p>
    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;margin:0 0 14px;">
      <tr style="border-bottom:2px solid #1a1a1a;">
        <th style="text-align:left;padding:6px 10px;font-size:10pt;font-weight:bold;">ID</th>
        <th style="text-align:left;padding:6px 10px;font-size:10pt;font-weight:bold;">Title</th>
        <th style="text-align:left;padding:6px 10px;font-size:10pt;font-weight:bold;">Owner</th>
      </tr>
      <tr style="border-bottom:1px solid #d8d8d8;">
        <td style="padding:5px 10px;font-size:10pt;">#[ID]</td>
        <td style="padding:5px 10px;font-size:10pt;">[Title]</td>
        <td style="padding:5px 10px;font-size:10pt;">[Owner]</td>
      </tr>
    </table>

    <!-- Risks & Issues -->
    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">RISKS &amp; ISSUES</p>
    <ul style="margin:0 0 14px;padding-left:20px;">
      <li style="margin:4px 0;"><strong>[HIGH / MEDIUM]:</strong> [Risk description] &#8212; [Action / Owner]</li>
    </ul>

    <!-- Next Steps -->
    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">NEXT STEPS</p>
    <ul style="margin:0 0 14px;padding-left:20px;">
      <li style="margin:4px 0;">[Action &#8212; Owner &#8212; Target date]</li>
    </ul>

    <!-- ADO link (plain text, no decoration) -->
    <p style="margin:20px 0 0;font-size:10pt;color:#555555;">
      Azure DevOps: <a href="[URL]" style="color:#1a1a1a;">[Project URL]</a>
    </p>

    <!-- Signature -->
    <p style="margin:28px 0 2px;border-top:1px solid #cccccc;padding-top:12px;">Harol Manchola</p>
    <p style="margin:0;font-size:10pt;color:#555555;">Technical Delivery Manager | Arroyo Consulting | harol.manchola@arroyoconsulting.net</p>

  </td></tr>
</table>
</body>
</html>
```

## Formatting rules — MANDATORY

- **No icons, no emojis, no colored banners, no metric badges** — none, ever
- **No inline color** in the body — text is `#1a1a1a`; only the subtitle/signature use `#555555` (muted)
- **Status (GREEN/YELLOW/RED)**: plain bold text inline — no colored background or highlight behind it
- **Section headers**: bold + bottom border rule only — that is the entire design system
- **Tables**: black 2px bottom border on header row, thin grey `#d8d8d8` on data rows — no background fills
- **Subject line for email distribution**: plain ASCII — e.g., `GTTH Project Status - Touch Point | June 18, 2026`
- **Font**: Calibri 11pt — matches Outlook default
- **Layout**: table-based (Outlook desktop uses Word renderer — no flexbox, grid, or border-radius)
- `<meta charset="UTF-8">` always present

## Notes

- Default period is current week unless specified
- Keep accomplishments to the most impactful 3-5 items
- Active items: in-progress work only — not the full backlog
- Red status always requires an escalation path in Risks
- Tone: professional, senior TDM level — results first, no filler
