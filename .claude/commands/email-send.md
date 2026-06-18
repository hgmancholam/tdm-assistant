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
2. Generar siempre HTML profesional — nunca texto plano (ver template y reglas abajo)
3. Mostrar el borrador renderizado como Markdown para revisión
4. Solo al confirmar, escribir el HTML a un archivo temporal y ejecutar el script
5. Confirmar éxito con el resultado del script

## HTML Email Template

The goal is a clean, formal document — the kind a senior consultant would write.
NO icons. NO colored banners. NO badges. NO emojis. Minimal color.
Structure comes from bold text, spacing, and simple ruled lines only.

```html
<html>
<head><meta charset="UTF-8"></head>
<body style="font-family:Calibri,Arial,sans-serif;font-size:11pt;color:#1a1a1a;margin:0;padding:0;background:#ffffff;">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="padding:28px 32px;max-width:680px;">

    <!-- Opening salutation -->
    <p style="margin:0 0 14px;">Hi [Name / team],</p>

    <!-- Opening paragraph -->
    <p style="margin:0 0 14px;">[Main message or context.]</p>

    <!-- Section header: bold + subtle underline rule -->
    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">SECTION TITLE</p>

    <!-- Bullet list -->
    <ul style="margin:0 0 14px;padding-left:20px;">
      <li style="margin:4px 0;">[item]</li>
    </ul>

    <!-- Inline data points (sprint info, dates, etc.) -->
    <p style="margin:0 0 6px;"><strong>Sprint:</strong> [name] | [start] &#8211; [end] | Day [N] of [total] ([%] elapsed)</p>
    <p style="margin:0 0 14px;"><strong>Status:</strong> [GREEN / YELLOW / RED] &#8212; [one-line justification]</p>

    <!-- Simple table (active items, risks, decisions) -->
    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;margin:0 0 14px;">
      <tr style="border-bottom:2px solid #1a1a1a;">
        <th style="text-align:left;padding:6px 10px;font-size:10pt;font-weight:bold;">Column A</th>
        <th style="text-align:left;padding:6px 10px;font-size:10pt;font-weight:bold;">Column B</th>
        <th style="text-align:left;padding:6px 10px;font-size:10pt;font-weight:bold;">Column C</th>
      </tr>
      <tr style="border-bottom:1px solid #d8d8d8;">
        <td style="padding:5px 10px;font-size:10pt;">[value]</td>
        <td style="padding:5px 10px;font-size:10pt;">[value]</td>
        <td style="padding:5px 10px;font-size:10pt;">[value]</td>
      </tr>
    </table>

    <!-- Closing line -->
    <p style="margin:20px 0 0;">[Closing sentence — next steps, call to action, or pleasantry.]</p>

    <!-- Signature -->
    <p style="margin:24px 0 2px;border-top:1px solid #cccccc;padding-top:12px;">Harol Manchola</p>
    <p style="margin:0;font-size:10pt;color:#555555;">Technical Delivery Manager | Arroyo Consulting</p>

  </td></tr>
</table>
</body>
</html>
```

### Formatting rules — MANDATORY

- **No icons, no emojis, no colored banners, no badges** — none, ever
- **No inline color** except `#555555` for the signature subtitle — body text is always `#1a1a1a`
- **Subject line**: plain ASCII text only — e.g., `GTTH Project Status - Touch Point | June 18, 2026`
- **Structure via bold + ruled lines only** — section headers are `<strong>` or bold `<p>` with a bottom border
- **Status (GREEN/YELLOW/RED)**: written as plain bold text inline — `<strong>Status: YELLOW</strong>` — no color behind it
- **Tables**: black bottom border on header row, thin grey on data rows — no background fills, no colored headers
- **Font**: Calibri 11pt — matches Outlook default, looks hand-authored
- **Layout**: table-based (Outlook desktop uses Word renderer — no flexbox, grid, or border-radius)
- **`<meta charset="UTF-8">`** always present to prevent character corruption

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

Show the draft as formatted Markdown before sending:

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
