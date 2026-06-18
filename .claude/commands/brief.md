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
```powershell
pwsh -File ".agents/skills/projects/list-projects.ps1" -Status "active"
```

Para cada proyecto activo:
```powershell
pwsh -File ".agents/skills/projects/get-project.ps1" -ProjectCode "CODE"
```

Determinar semáforo leyendo logs de los últimos 3 días:
- 🟢 Sin issues reportados, actividad reciente
- 🟡 Bloqueadores mencionados, o sin actividad 2 días
- 🔴 Sin actividad > 3 días, o escalación en logs

### Paso 5 — Compilar y presentar

```
**[ASSISTANT_NAME] — Buenos días, [USER_NICKNAME]**
📅 [Día], [fecha larga]

---
📅 **AGENDA DE HOY**
• [HH:MM] — [Reunión] ([Xmin]) [← PREP PENDIENTE si aplica]
• [HH:MM] — [Reunión] ([Xmin])
[Si no hay reuniones: "Día sin reuniones agendadas ✅"]

---
📧 **EMAILS QUE REQUIEREN ATENCIÓN**
• [Remitente] — "[Asunto]" — hace [X]h [← VIP si aplica]
• [Remitente] — "[Asunto]" — URGENT
[Si no hay: "Inbox limpio ✅"]

---
📋 **PROYECTOS**
🟢 [CODE] — [Nombre] — On track
🟡 [CODE] — [Nombre] — [motivo]
🔴 [CODE] — [Nombre] — [motivo]
[Si no hay proyectos activos: "Sin proyectos activos configurados"]

---
⏰ **RECORDATORIOS**
• [texto] — vence [fecha/hora]
[Si no hay: ninguno]

---
🎯 **PRIORIDADES**
1. [prioridad 1]
2. [prioridad 2]
[Si no hay prioridades: "Sin prioridades configuradas — usa /priorities para añadir"]

---
¿Por dónde empezamos?
```

### Modo `quick`

Con `/brief quick`, omitir el estado de proyectos y solo mostrar agenda + emails urgentes + recordatorios vencidos.

---

## Notes

- Para análisis detallado de un proyecto: `/agile-advisor CODE`
- Para revisar el inbox completo: `/email-triage`
- Para ver la agenda extendida: `/agenda`
- El briefing también se genera automáticamente si `/tdm` se invoca sin argumentos
