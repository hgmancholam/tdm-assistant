# email-reply

Busca un email, redacta la respuesta HTML profesional y la envía vía Outlook Desktop.

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

Replies must look like a human wrote them — clean, formal, no design elements.
No icons. No colored sections. No badges. Just well-structured text.

```html
<html>
<head><meta charset="UTF-8"></head>
<body style="font-family:Calibri,Arial,sans-serif;font-size:11pt;color:#1a1a1a;margin:0;padding:0;background:#ffffff;">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="padding:0 0 16px;">

    <p style="margin:0 0 14px;">Hi [Name],</p>

    <p style="margin:0 0 14px;">[Main response or direct answer.]</p>

    <!-- Use a bullet list only when listing multiple items -->
    <ul style="margin:0 0 14px;padding-left:20px;">
      <li style="margin:4px 0;">[item]</li>
    </ul>

    <p style="margin:0 0 14px;">[Closing line or next step.]</p>

    <p style="margin:20px 0 2px;">Harol Manchola</p>
    <p style="margin:0;font-size:10pt;color:#555555;">Technical Delivery Manager | Arroyo Consulting</p>

  </td></tr>
</table>
</body>
</html>
```

### Formatting rules — MANDATORY

- **No icons, no emojis, no color, no banners** — plain formatted text only
- Use **bold** (`<strong>`) sparingly — only for a key term, a name, or a status word
- If listing structured data, use a simple table: black bottom border on header, thin grey on rows, no fills
- Font Calibri 11pt — looks native to Outlook, indistinguishable from a manually typed email
- `<meta charset="UTF-8">` always present
- Tone: professional, direct — adapt if client vs. internal colleague

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
