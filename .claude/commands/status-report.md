# status-report

Generate a professional HTML project status report for stakeholder distribution via email.

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
   - **Email**: invoke `/email-send` flow with the generated HTML — subject must be plain ASCII
   - **File**: save to `projects/<CODE>/reports/status-<date>.html`

## HTML Report Template

Generate this exact HTML structure. Table-based, Outlook-compatible — no flexbox, grid, or border-radius.

```html
<html>
<head><meta charset="UTF-8"></head>
<body style="font-family:Calibri,Arial,sans-serif;font-size:11pt;color:#1a1a1a;margin:0;padding:0;background:#ffffff;">

<!-- HEADER -->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="background:#003366;color:#ffffff;padding:14px 22px;">
    <span style="font-size:14pt;font-weight:bold;">[PROJECT NAME] - Project Status</span><br>
    <span style="font-size:9pt;color:#c8d8e8;">
      [Period] &nbsp;|&nbsp; Prepared by Harol Manchola, Technical Delivery Manager
    </span>
  </td></tr>
</table>

<!-- BODY -->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="padding:20px 22px;">

    <!-- SPRINT -->
    <p style="margin:0 0 6px;font-size:10pt;font-weight:bold;text-transform:uppercase;color:#003366;border-bottom:1px solid #d0d7de;padding-bottom:4px;">Sprint</p>
    <p style="margin:0 0 14px;">[Sprint name] &nbsp;|&nbsp; [Start] &#8211; [End] &nbsp;|&nbsp; Day [N] of [Total] ([%] elapsed)</p>

    <!-- OVERALL STATUS -->
    <p style="margin:0 0 6px;font-size:10pt;font-weight:bold;text-transform:uppercase;color:#003366;border-bottom:1px solid #d0d7de;padding-bottom:4px;">Overall Status</p>
    <p style="margin:0 0 14px;">
      <!-- Use one badge -->
      <span style="background:#1a7a1a;color:#ffffff;padding:3px 10px;font-size:9pt;font-weight:bold;">GREEN</span>
      <!-- or -->
      <span style="background:#e67700;color:#ffffff;padding:3px 10px;font-size:9pt;font-weight:bold;">YELLOW</span>
      <!-- or -->
      <span style="background:#cc0000;color:#ffffff;padding:3px 10px;font-size:9pt;font-weight:bold;">RED</span>
      &nbsp; [One-line justification]
    </p>

    <!-- METRICS -->
    <p style="margin:0 0 6px;font-size:10pt;font-weight:bold;text-transform:uppercase;color:#003366;border-bottom:1px solid #d0d7de;padding-bottom:4px;">Sprint Metrics</p>
    <table cellpadding="0" cellspacing="6" border="0" style="margin:6px 0 14px;">
      <tr>
        <td style="background:#eef2f7;padding:10px 16px;text-align:center;min-width:70px;">
          <div style="font-size:18pt;font-weight:bold;color:#003366;">[N]</div>
          <div style="font-size:8pt;color:#777777;">Total Items</div>
        </td>
        <td style="background:#eef2f7;padding:10px 16px;text-align:center;min-width:70px;">
          <div style="font-size:18pt;font-weight:bold;color:#1a7a1a;">[N]</div>
          <div style="font-size:8pt;color:#777777;">Closed ([%])</div>
        </td>
        <td style="background:#eef2f7;padding:10px 16px;text-align:center;min-width:70px;">
          <div style="font-size:18pt;font-weight:bold;color:#e67700;">[N]</div>
          <div style="font-size:8pt;color:#777777;">In Progress ([%])</div>
        </td>
        <td style="background:#eef2f7;padding:10px 16px;text-align:center;min-width:70px;">
          <div style="font-size:18pt;font-weight:bold;color:#999999;">[N]</div>
          <div style="font-size:8pt;color:#777777;">Not Started ([%])</div>
        </td>
      </tr>
    </table>

    <!-- ACCOMPLISHMENTS -->
    <p style="margin:0 0 6px;font-size:10pt;font-weight:bold;text-transform:uppercase;color:#003366;border-bottom:1px solid #d0d7de;padding-bottom:4px;">Accomplishments</p>
    <ul style="margin:4px 0 14px;padding-left:20px;">
      <li style="margin:4px 0;">&#10003; [Item]</li>
    </ul>

    <!-- ACTIVE ITEMS -->
    <p style="margin:0 0 6px;font-size:10pt;font-weight:bold;text-transform:uppercase;color:#003366;border-bottom:1px solid #d0d7de;padding-bottom:4px;">Active Items</p>
    <table width="100%" cellpadding="6" cellspacing="0" border="0" style="border-collapse:collapse;margin:6px 0 14px;">
      <tr style="background:#003366;color:#ffffff;">
        <th style="padding:7px 10px;text-align:left;font-size:9pt;font-weight:bold;">ID</th>
        <th style="padding:7px 10px;text-align:left;font-size:9pt;font-weight:bold;">Title</th>
        <th style="padding:7px 10px;text-align:left;font-size:9pt;font-weight:bold;">Owner</th>
      </tr>
      <tr style="background:#f4f6f9;">
        <td style="padding:6px 10px;font-size:10pt;border-bottom:1px solid #e0e0e0;">#[ID]</td>
        <td style="padding:6px 10px;font-size:10pt;border-bottom:1px solid #e0e0e0;">[Title]</td>
        <td style="padding:6px 10px;font-size:10pt;border-bottom:1px solid #e0e0e0;">[Name]</td>
      </tr>
    </table>

    <!-- RISKS & ISSUES -->
    <p style="margin:0 0 6px;font-size:10pt;font-weight:bold;text-transform:uppercase;color:#003366;border-bottom:1px solid #d0d7de;padding-bottom:4px;">Risks &amp; Issues</p>
    <p style="margin:4px 0;"><span style="color:#cc0000;font-weight:bold;">&#9888; HIGH:</span> [Risk description] &#8594; [Action/Owner]</p>
    <p style="margin:4px 0 14px;"><span style="color:#e67700;font-weight:bold;">&#9888; MEDIUM:</span> [Risk description] &#8594; [Action/Owner]</p>

    <!-- NEXT STEPS -->
    <p style="margin:0 0 6px;font-size:10pt;font-weight:bold;text-transform:uppercase;color:#003366;border-bottom:1px solid #d0d7de;padding-bottom:4px;">Next Steps</p>
    <ul style="margin:4px 0 14px;padding-left:20px;">
      <li style="margin:4px 0;">&#8594; [Action — Owner — Target date]</li>
    </ul>

    <!-- ADO LINK (optional) -->
    <p style="margin:14px 0 0;font-size:9pt;color:#777777;">
      Azure DevOps: <a href="[ADO URL]" style="color:#003366;">[ADO Project URL]</a>
    </p>

  </td></tr>
</table>

<!-- FOOTER -->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="background:#f4f6f9;padding:10px 22px;border-top:2px solid #003366;">
    <span style="font-size:9pt;color:#555555;">Harol Manchola &nbsp;|&nbsp; Technical Delivery Manager &nbsp;|&nbsp; Arroyo Consulting &nbsp;|&nbsp; harol.manchola@arroyoconsulting.net</span>
  </td></tr>
</table>

</body>
</html>
```

## Formatting rules — MANDATORY

- **No emojis** — use HTML entities: `&#10003;` (✓), `&#9888;` (⚠), `&#8594;` (→), `&#8211;` (–)
- **Email subject**: plain ASCII only — e.g., `GTTH Project Status - Touch Point | June 18, 2026`
- **Colors**: `#003366` header/accent, `#1a7a1a` closed/done, `#e67700` in-progress/medium, `#cc0000` high-risk
- **Table-based ONLY** — Outlook desktop uses Word renderer; no CSS grid, flexbox, or border-radius
- Red status always requires an escalation path in the Risks section

## Notes

- Default period is current week unless specified
- Keep accomplishments to the most impactful 3-5 items
- Active items table should show only in-progress work items, not the full backlog
- Tone: professional, senior TDM level — results-first, no filler
