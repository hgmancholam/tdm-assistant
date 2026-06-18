# quick-draft

Redacta cualquier comunicación rápidamente — emails, mensajes, status updates, escalaciones, anuncios — usando el contexto del proyecto y el perfil del usuario.

## Usage

```
/quick-draft [tipo] [contexto]
```

## Examples

```
/quick-draft email al cliente sobre el retraso en el sprint
/quick-draft status update de ALPHA para los ejecutivos
/quick-draft escala el bloqueador del equipo de infraestructura
/quick-draft agenda para la reunión de sprint review de ALPHA
/quick-draft mensaje a John explicando el cambio de scope
/quick-draft respuesta al email de Sarah sobre el presupuesto
/quick-draft
```

## Tipos de draft soportados

| Tipo | Descripción | Canal |
|------|-------------|-------|
| `email` | Email formal o informal | Outlook |
| `status update` | Update de estado del proyecto | Email / Teams |
| `escalation` | Escalación de riesgo o bloqueador | Email a ejecutivos |
| `announcement` | Anuncio de decisión o cambio | Email / Teams |
| `meeting agenda` | Agenda para una reunión | Email |
| `message` | Mensaje informal (Teams, chat) | Teams |
| `exec summary` | Resumen ejecutivo (1 párrafo) | Doc / Email |
| `follow-up` | Follow-up de una reunión o conversación | Email |
| `decline` | Rechazar o renegociar un compromiso | Email |

## Behavior

### Paso 1 — Entender el contexto

Si el usuario da poco contexto, hacer máximo 2 preguntas:
1. ¿Para quién es? (destinatario / audiencia)
2. ¿Cuál es el mensaje principal? (una oración)

Si el tipo no está especificado, inferirlo del contexto.

### Paso 2 — Cargar contexto relevante

**Perfil del usuario:**
Leer `user.profile.md` para:
- Estilo de comunicación con esa audiencia
- Historial de relación con el destinatario

**Contexto del proyecto (si aplica):**
```powershell
pwsh -File ".agents/skills/projects/get-project.ps1" -ProjectCode "CODE"
```

**Email anterior (si es una respuesta o follow-up):**
```powershell
pwsh -File ".agents/skills/outlook/search-emails.ps1" -From "[remitente]" -Count 3
```

### Paso 3 — Redactar

Reglas de redacción:
- **Siempre en inglés** salvo instrucción explícita del usuario
- Tono calibrado al destinatario (formal con clientes/ejecutivos, directo con equipo)
- Executive summary first — el mensaje clave en la primera oración
- Conciso — sin relleno ni redundancias
- Orientado a acción — si hay un CTA, debe ser específico y al final

### Paso 4 — Presentar y confirmar

```
**Draft — [Tipo]**
**Para:** [destinatario]
**Asunto:** [asunto si aplica]
**Canal:** [Email / Teams / Otro]

---
[borrador completo]

---
✏️ **Ajustes opcionales:**
- Tono más formal / más casual
- Más corto / más detallado
- Añadir contexto de [tema específico]

¿Listo para enviar, o ajustamos algo?
```

### Paso 5 — Enviar (si es email y el usuario confirma)

```powershell
pwsh -File ".agents/skills/outlook/send-email.ps1" `
  -To "[destinatario]" `
  -Subject "[asunto]" `
  -Body "[cuerpo]" `
  -CC "[cc si aplica]"
```

---

## Guías de tono por audiencia

| Audiencia | Tono | Largo |
|-----------|------|-------|
| Cliente ejecutivo | Formal, directo, orientado a acción | < 150 palabras |
| Sponsor del proyecto | Ejecutivo, proactivo, sin sorpresas | < 200 palabras |
| Equipo técnico | Directo, técnico cuando aplica | Sin límite |
| Ejecutivo interno | Executive summary first, bullets | < 1 página |
| Stakeholder genérico | Profesional, claro | < 200 palabras |

---

## Templates frecuentes

### Escalación de bloqueador
```
Subject: [PROJECT] — Blocker Escalation: [título del bloqueador]

[ASSISTANT_NAME] summary:
- Blocker: [descripción]
- Impact: [qué está bloqueando]
- Time blocked: [días]
- Action needed from you: [qué necesita el ejecutivo/stakeholder]
- Proposed resolution: [si aplica]
```

### Status update para ejecutivos
```
Subject: [PROJECT] — Status Update [semana/fecha]

Executive Summary: [1 oración — verde/amarillo/rojo + razón principal]

Progress:
• Completed: [items clave]
• In Progress: [items actuales]
• At Risk: [si aplica]

Next milestone: [fecha + qué se entrega]
Action needed: [si aplica, clarísimo]
```

### Follow-up de reunión
```
Subject: Follow-up — [nombre de la reunión] — [fecha]

Hi [nombre],

Thanks for the time today. Summary of what we agreed:

Decisions made:
• [decisión 1]

Action items:
• [persona] — [acción] — due [fecha]

Next step: [próximo touchpoint]
```

---

## Notes

- El draft no se envía automáticamente — siempre confirmar antes
- Si hay historial de emails con el destinatario, se usa para calibrar el tono
- Para responder directamente un email específico, usar `/email-reply`
- Los drafts no se guardan — si necesitas preservar uno, dilo y se registra como nota del proyecto
