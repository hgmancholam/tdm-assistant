# email-send

Redacta y envía un email HTML profesional en nombre de Harol vía Outlook Desktop.

## Usage

```
/email-send <descripción de lo que quieres enviar>
```

## Examples

```
/email-send avisa al equipo que el standup de mañana se cancela
/email-send manda el status report semanal del proyecto GTTH a stakeholders
/email-send responde a John que la demo queda para el viernes a las 2pm
```

## Behavior

1. Si falta información (destinatario, asunto, contexto), preguntar antes de redactar
2. **Generar siempre HTML profesional** — nunca texto plano (ver template y reglas abajo)
3. Mostrar el borrador renderizado como Markdown para revisión
4. Solo al confirmar, escribir el HTML a un archivo temporal y ejecutar el script
5. Confirmar éxito con el resultado del script

## HTML Email Template

**ALWAYS generate HTML. NEVER send plain text.**

Use this exact structure (table-based, Outlook-compatible — no flexbox, no grid):

```html
<html>
<head><meta charset="UTF-8"></head>
<body style="font-family:Calibri,Arial,sans-serif;font-size:11pt;color:#1a1a1a;margin:0;padding:0;background:#ffffff;">

<!-- HEADER -->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="background:#003366;color:#ffffff;padding:14px 22px;">
    <span style="font-size:14pt;font-weight:bold;">[TITLE]</span><br>
    <span style="font-size:9pt;color:#c8d8e8;">[DATE / SUBTITLE / PREPARED BY]</span>
  </td></tr>
</table>

<!-- BODY -->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="padding:20px 22px;">

    [SECTIONS — use patterns below]

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

### Section patterns

**Section header:**
```html
<p style="margin:18px 0 6px;font-size:10pt;font-weight:bold;text-transform:uppercase;color:#003366;border-bottom:1px solid #d0d7de;padding-bottom:4px;">SECTION TITLE</p>
```

**Bullet list:**
```html
<ul style="margin:4px 0 12px;padding-left:20px;">
  <li style="margin:4px 0;">Item text</li>
</ul>
```

**Metric badges (sprint/status reports):**
```html
<table cellpadding="0" cellspacing="6" border="0" style="margin:8px 0 14px;">
  <tr>
    <td style="background:#eef2f7;padding:10px 16px;text-align:center;min-width:70px;">
      <div style="font-size:18pt;font-weight:bold;color:#003366;">30</div>
      <div style="font-size:8pt;color:#777777;">Total Items</div>
    </td>
    <td style="background:#eef2f7;padding:10px 16px;text-align:center;min-width:70px;">
      <div style="font-size:18pt;font-weight:bold;color:#1a7a1a;">18</div>
      <div style="font-size:8pt;color:#777777;">Closed (60%)</div>
    </td>
    <td style="background:#eef2f7;padding:10px 16px;text-align:center;min-width:70px;">
      <div style="font-size:18pt;font-weight:bold;color:#e67700;">7</div>
      <div style="font-size:8pt;color:#777777;">In Progress</div>
    </td>
    <td style="background:#eef2f7;padding:10px 16px;text-align:center;min-width:70px;">
      <div style="font-size:18pt;font-weight:bold;color:#999999;">6</div>
      <div style="font-size:8pt;color:#777777;">Not Started</div>
    </td>
  </tr>
</table>
```

**Risk / alert inline:**
```html
<!-- High risk -->
<p style="margin:4px 0;"><span style="color:#cc0000;font-weight:bold;">&#9888; HIGH:</span> Description of risk or blocker.</p>
<!-- Medium risk -->
<p style="margin:4px 0;"><span style="color:#e67700;font-weight:bold;">&#9888; MEDIUM:</span> Description of concern.</p>
```

**Status indicator (Green / Yellow / Red):**
```html
<span style="background:#1a7a1a;color:#ffffff;padding:2px 8px;font-size:9pt;font-weight:bold;">GREEN</span>
<span style="background:#e67700;color:#ffffff;padding:2px 8px;font-size:9pt;font-weight:bold;">YELLOW</span>
<span style="background:#cc0000;color:#ffffff;padding:2px 8px;font-size:9pt;font-weight:bold;">RED</span>
```

**Inline table (risks, decisions, items):**
```html
<table width="100%" cellpadding="6" cellspacing="0" border="0" style="border-collapse:collapse;margin:8px 0 14px;">
  <tr style="background:#003366;color:#ffffff;">
    <th style="padding:7px 10px;text-align:left;font-size:9pt;">Item</th>
    <th style="padding:7px 10px;text-align:left;font-size:9pt;">Severity</th>
    <th style="padding:7px 10px;text-align:left;font-size:9pt;">Action</th>
    <th style="padding:7px 10px;text-align:left;font-size:9pt;">Owner</th>
  </tr>
  <tr style="background:#f4f6f9;">
    <td style="padding:6px 10px;font-size:10pt;border-bottom:1px solid #e0e0e0;">...</td>
    <td style="padding:6px 10px;font-size:10pt;border-bottom:1px solid #e0e0e0;color:#cc0000;font-weight:bold;">High</td>
    <td style="padding:6px 10px;font-size:10pt;border-bottom:1px solid #e0e0e0;">...</td>
    <td style="padding:6px 10px;font-size:10pt;border-bottom:1px solid #e0e0e0;">...</td>
  </tr>
</table>
```

### Formatting rules — MANDATORY

- **Subject line**: NO emojis — plain ASCII text only (e.g., `GTTH Project Status - Touch Point | June 18, 2026`)
- **No emoji characters anywhere**: use HTML entities instead — `&#9888;` (⚠), `&#10003;` (✓), `&#8594;` (→), `&#8226;` (•)
- **Colors**: header/accents `#003366`; closed/done `#1a7a1a`; in-progress `#e67700`; risk/high `#cc0000`; muted `#777777`
- **Font**: Calibri 11pt body, 14pt header title, 10pt section titles (uppercase)
- **Layout**: table-based ONLY — Outlook desktop uses Word renderer (flexbox/grid/border-radius NOT supported)
- **Encoding**: `<meta charset="UTF-8">` must be present to avoid character corruption

## Execution

Write the HTML to a temp file to avoid shell quoting issues, then send:

```powershell
$html | Set-Content -Path "$env:TEMP\email_draft.html" -Encoding UTF8
pwsh -File ".agents/skills/outlook/send-email.ps1" `
  -To "destinatario@ejemplo.com" `
  -Subject "Asunto sin emojis" `
  -BodyFile "$env:TEMP\email_draft.html" `
  [-CC "cc@ejemplo.com"]
```

## Draft preview format

Show the draft as formatted Markdown (not raw HTML) so the user can review it easily:

```
Para:    ...
CC:      ...
Asunto:  ...
──────────────────────────────────────
[Markdown representation of the email content]
──────────────────────────────────────
¿Enviar? [s / n / editar]
```

## Output

```
Email enviado
Para:    [destinatario]
Asunto:  [asunto]
```

## Notes

- Remitente siempre es harol.manchola@arroyoconsulting.net (cuenta Outlook activa)
- Outlook Desktop debe estar abierto
- SIEMPRE mostrar borrador y pedir confirmación antes de enviar
- Para múltiples destinatarios: `"a@b.com; c@d.com"`
