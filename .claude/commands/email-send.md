# email-send

Redacta y envía un email en nombre de Harol vía Outlook Desktop.

## Usage

```
/email-send <descripción de lo que quieres enviar>
```

## Examples

```
/email-send avisa al equipo que el standup de mañana se cancela
/email-send responde a John que la demo queda para el viernes a las 2pm
/email-send manda el status report semanal a stakeholders
```

## Behavior

1. Si falta información (destinatario, asunto, contexto), preguntar antes de redactar
2. Redactar el email con tono profesional — senior TDM/PM, directo y sin relleno
3. Mostrar el borrador al usuario para revisión:
   ```
   Para: ...
   Asunto: ...
   ───────────────
   [cuerpo del email]
   ───────────────
   ¿Enviar? [s/n] o sugiere cambios
   ```
4. Solo al confirmar, ejecutar:
   ```powershell
   pwsh -File ".agents/skills/outlook/send-email.ps1" `
     -To "destinatario@ejemplo.com" `
     -Subject "Asunto" `
     -Body "Cuerpo del email"
   ```
5. Confirmar éxito con el resultado del script

## Output format

```
✅ Email enviado
Para: [destinatario]
Asunto: [asunto]
Hora: [timestamp]
```

## Notes

- Remitente siempre es harol.manchola@arroyoconsulting.net (la cuenta de Outlook activa)
- Tono: profesional, conciso — senior TDM en firma de consultoría
- SIEMPRE mostrar el borrador y pedir confirmación antes de enviar
- Para múltiples destinatarios separar con punto y coma: "a@b.com; c@d.com"
- Outlook Desktop debe estar abierto

