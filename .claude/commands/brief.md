# brief

Briefing completo del día — el primer comando que corres en la mañana. Consolida agenda, emails urgentes, estado de proyectos, recordatorios y prioridades en una vista ejecutiva.

## Usage

```
/brief
/brief quick
```

## Behavior

### Paso 1 — Cargar contexto
```
1. Leer user.profile.md → contactos VIP, preferencias de alertas
2. Leer .env → ASSISTANT_NAME, USER_NICKNAME
3. Leer reminders.json → recordatorios para hoy o vencidos
4. Leer priorities.json → prioridades actuales
```

### Paso 2 — Agenda del día
```powershell
pwsh -File ".agents/skills/outlook/get-calendar.ps1" -Days 1
```
Mostrar todas las reuniones del día con hora y duración.
Marcar con "← PREP PENDIENTE" si la reunión es en < 2h y no hay archivos en `meetings/` del proyecto en los últimos 3 días.

### Paso 3 — Emails urgentes
```powershell
pwsh -File ".agents/skills/outlook/get-inbox.ps1" -Count 50 -UnreadOnly
```

Filtrar y mostrar SOLO:
- Emails de contactos listados como VIP en `user.profile.md`
- Emails con palabras de urgencia: "urgent", "ASAP", "deadline", "critical", "action required", "bloqueado", "necesito respuesta"
- Cadenas donde el último email es del remitente (usuario no ha respondido) y tiene > 12h

Ignorar: newsletters, notificaciones automáticas, mailing lists.

### Paso 4 — Estado de proyectos

> ⚠️ **REGLA CRÍTICA**: El estado de los proyectos SIEMPRE se obtiene consultando ADO en vivo. Los logs locales son historial/contexto — NUNCA son la fuente de verdad para work items. Un work item puede cambiar de estado en minutos; el log puede tener horas de retraso.

```powershell
pwsh -File ".agents/skills/projects/list-projects.ps1" -Status "active"
```

Para cada proyecto activo con ADO configurado en `project.settings`:

**4a — Query ADO en vivo (OBLIGATORIO antes de determinar semáforo)**

Usar MCP `mcp__ado__*` o REST directo con el PAT del proyecto para obtener los work items activos del sprint actual:

```
WIQL: SELECT [System.Id], [System.Title], [System.State], [System.AssignedTo], [Microsoft.VSTS.Scheduling.StoryPoints]
      FROM WorkItems
      WHERE [System.TeamProject] = '<project>'
        AND [System.IterationPath] UNDER '<currentSprint>'
        AND [System.State] IN ('Active', 'New', 'Blocked')
      ORDER BY [System.ChangedDate] DESC
```

**4b — Leer logs locales (solo como contexto narrativo)**
```powershell
pwsh -File ".agents/skills/projects/get-project.ps1" -ProjectCode "CODE"
```

**4c — Determinar semáforo** (basado en datos ADO vivos, no en logs):
- 🟢 Sin items bloqueados o críticos en ADO, sprint progresando
- 🟡 Bloqueadores activos en ADO, o items con > 3 días sin movimiento
- 🔴 Bugs críticos ACTIVE/NEW en producción, o escalaciones abiertas

### Paso 5 — Compilar y presentar en pantalla

Mostrar en la conversación (formato Markdown para pantalla — emojis de semáforo permitidos aquí):

```
**[ASSISTANT_NAME] — Buenos días, [USER_NICKNAME]**
[Día], [fecha larga]

---
**AGENDA DE HOY**
• [HH:MM] — [Reunión] ([Xmin]) [← PREP PENDIENTE si aplica]
[Si no hay reuniones: "No meetings scheduled today."]

---
**EMAILS QUE REQUIEREN ATENCIÓN**
• [Remitente] — "[Asunto]" — hace [X]h [← VIP si aplica]
[Si no hay: "Inbox clean."]

---
**PROYECTOS**
[GREEN] [CODE] — [Nombre] — On track
[YELLOW] [CODE] — [Nombre] — [motivo]
[RED] [CODE] — [Nombre] — [motivo]

---
**RECORDATORIOS**
• [texto] — vence [fecha/hora]
[Si no hay: ninguno]

---
**PRIORIDADES**
1. [prioridad 1]
2. [prioridad 2]

---
¿Por dónde empezamos?
```

### Paso 6 — Si se solicita envío por email

> ⚠️ **FORMATO DE EMAIL — MANDATORIO**
> El email debe ser indistinguible de uno escrito manualmente en Outlook por un profesional senior.
> - Fondo blanco (`#ffffff`). Texto negro (`#1a1a1a`). Sin colores decorativos.
> - **CERO emojis** en el HTML del email.
> - Sin banners de color, sin cajas con fondo coloreado, sin badges, sin gradientes, sin `border-radius`, sin `box-shadow`.
> - Única excepción de color: las palabras `GREEN` / `YELLOW` / `RED` como texto inline en bold — solo para reportar estado de salud de un proyecto. Nunca como fondo o badge.
> - Layout con `<table>` (Outlook usa Word renderer — no flexbox ni grid).
> - Fuente: Calibri 11pt.
> - Estructura solo con bold (`<strong>`), espaciado, y líneas `border-bottom: 1px solid #cccccc`.

```html
<html>
<head><meta charset="UTF-8"></head>
<body style="font-family:Calibri,Arial,sans-serif;font-size:11pt;color:#1a1a1a;margin:0;padding:0;background:#ffffff;">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td style="padding:28px 32px;max-width:680px;">

    <p style="margin:0 0 20px;font-size:12pt;font-weight:bold;">Daily Brief — [Day], [Date]</p>

    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">AGENDA</p>
    <p style="margin:0 0 14px;">[meetings or "No meetings scheduled today."]</p>

    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">EMAILS</p>
    <p style="margin:0 0 14px;">[urgent/VIP emails or "Inbox clean."]</p>

    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">PROJECT STATUS</p>
    <!-- Health only: status word in bold, no color behind it -->
    <p style="margin:0 0 6px;"><strong>GTTH</strong> — O2E-GTTH (Deloitte) — Status: <strong>[GREEN / YELLOW / RED]</strong> — [one-line reason]</p>
    <p style="margin:0 0 14px;"><strong>UPSKILL</strong> — TDM Mentoring — Status: <strong>[GREEN / YELLOW / RED]</strong> — [one-line reason]</p>

    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">ACTION ITEMS</p>
    <ul style="margin:0 0 14px;padding-left:20px;">
      <li style="margin:4px 0;">[item]</li>
    </ul>

    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">OPEN THREADS</p>
    <ul style="margin:0 0 14px;padding-left:20px;">
      <li style="margin:4px 0;">[thread]</li>
    </ul>

    <p style="margin:22px 0 8px;font-weight:bold;border-bottom:1px solid #cccccc;padding-bottom:4px;">REMINDERS</p>
    <p style="margin:0 0 14px;">[reminders or "None."]</p>

    <p style="margin:24px 0 2px;border-top:1px solid #cccccc;padding-top:12px;">Harol Manchola</p>
    <p style="margin:0;font-size:10pt;color:#555555;">Technical Delivery Manager | Arroyo Consulting</p>

  </td></tr>
</table>
</body>
</html>
```

### Modo `quick`

Con `/brief quick`, omitir el estado de proyectos y solo mostrar agenda + emails urgentes + recordatorios vencidos.

---

## Notes

- Para análisis detallado de un proyecto: `/agile-advisor CODE`
- Para revisar el inbox completo: `/email-triage`
- Para ver la agenda extendida: `/agenda`
- El briefing también se genera automáticamente si `/tdm` se invoca sin argumentos
