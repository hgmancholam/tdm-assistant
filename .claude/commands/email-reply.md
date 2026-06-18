# email-reply

Busca un email, redacta la respuesta apropiada y la envía vía Outlook Desktop.

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
2. Si hay varios candidatos, mostrar la lista y pedir que confirme cuál
3. Leer el email completo para tener el contexto:
   ```powershell
   pwsh -File ".agents/skills/outlook/read-email.ps1" -EntryID "XXXX"
   ```
4. Redactar la respuesta con el tono apropiado según el remitente y contexto
5. Mostrar el borrador para revisión antes de enviar
6. Al confirmar, ejecutar:
   ```powershell
   pwsh -File ".agents/skills/outlook/reply-email.ps1" -EntryID "XXXX" -Body "respuesta"
   # Si responder a todos: añadir -ReplyAll
   ```

## Output format

```
📧 Respondiendo a: [Remitente] — "[Asunto]"

Borrador:
───────────────
[cuerpo de la respuesta]
───────────────
¿Enviar? [s/n / reply-all / editar]
```

```
✅ Respuesta enviada a [remitente]
```

## Notes

- Detectar automáticamente si aplica ReplyAll (ej: emails con varios CC relevantes)
- Tono: profesional, directo — adaptar si es cliente vs colega interno
- SIEMPRE mostrar borrador y pedir confirmación antes de enviar
- Outlook Desktop debe estar abierto

