# email-reply

Busca un email, redacta la respuesta en HTML profesional y la envía vía Outlook Desktop.

## Usage

```
/email-reply <descripción del email o asunto a responder>
```

## Examples

```
/email-reply responde el email de Sarah sobre el cronograma del proyecto
/email-reply dile a Mike que ya revisé el PR y que puede hacer merge
/email-reply acepta la invitación de reunión de mañana con el cliente
```

## Behavior

1. Buscar el email relevante en el inbox:
   ```powershell
   pwsh -File ".agents/skills/outlook/search-emails.ps1" -Query "término" -Count 5
   ```
2. Si hay varios candidatos, mostrar la lista y pedir confirmación
3. Leer el email completo para tener contexto:
   ```powershell
   pwsh -File ".agents/skills/outlook/read-email.ps1" -EntryID "XXXX"
   ```
4. Redactar la respuesta como HTML profesional (ver reglas de formato abajo)
5. Mostrar el borrador para revisión
6. Al confirmar, escribir HTML a archivo temporal y ejecutar el script:
   ```powershell
   $html | Set-Content -Path "$env:TEMP\reply_draft.html" -Encoding UTF8
   pwsh -File ".agents/skills/outlook/reply-email.ps1" `
     -EntryID "XXXX" `
     -BodyFile "$env:TEMP\reply_draft.html"
   # Si responder a todos: añadir -ReplyAll
   ```

## HTML Reply Format

Replies use a simpler template than full status reports — clean, professional, no heavy header.

```html
<html>
<head><meta charset="UTF-8"></head>
<body style="font-family:Calibri,Arial,sans-serif;font-size:11pt;color:#1a1a1a;margin:0;padding:0;">

  <p style="margin:0 0 12px;">Hi [Name],</p>

  <p style="margin:0 0 12px;">[Opening paragraph or direct answer]</p>

  <!-- If listing items -->
  <ul style="margin:4px 0 12px;padding-left:20px;">
    <li style="margin:4px 0;">Item 1</li>
    <li style="margin:4px 0;">Item 2</li>
  </ul>

  <p style="margin:0 0 12px;">[Closing line / next step]</p>

  <p style="margin:16px 0 4px;">Best regards,</p>
  <p style="margin:0;font-weight:bold;">Harol Manchola</p>
  <p style="margin:0;font-size:9pt;color:#555555;">Technical Delivery Manager &nbsp;|&nbsp; Arroyo Consulting</p>

</body>
</html>
```

### Formatting rules — MANDATORY

- **No emojis** anywhere in the reply — use plain text labels or HTML entities (`&#9888;` ⚠, `&#10003;` ✓, `&#8594;` →)
- **Font**: Calibri 11pt — matches Outlook default, no visual mismatch with quoted thread
- **Table-based layout only** if structured content is needed (Outlook Word renderer)
- **`<meta charset="UTF-8">`** always present to prevent character corruption
- Tone: professional, direct — adapt if client vs internal colleague

## Draft preview format

```
Respondiendo a: [Remitente] — "[Asunto]"
──────────────────────────────────────
[Markdown representation of reply content]
──────────────────────────────────────
¿Enviar? [s / n / reply-all / editar]
```

## Output

```
Respuesta enviada a [remitente]
Asunto: [asunto]
```

## Notes

- Detectar automáticamente si aplica ReplyAll (emails con CC relevantes múltiples)
- SIEMPRE mostrar borrador y pedir confirmación antes de enviar
- Outlook Desktop debe estar abierto
