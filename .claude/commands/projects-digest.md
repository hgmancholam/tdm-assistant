# projects-digest

Genera un resumen consolidado de todos los proyectos activos. Diseñado para ejecutarse automáticamente cada mañana o bajo demanda.

## Usage

```
/projects-digest [scope: active | all]
```

## Behavior

1. Listar todos los proyectos activos:
   ```powershell
   pwsh -File ".agents/skills/projects/list-projects.ps1" -Status "active"
   ```

2. Para cada proyecto, obtener su contexto:
   ```powershell
   pwsh -File ".agents/skills/projects/get-project.ps1" -ProjectCode "CODE"
   ```

3. Por cada proyecto compilar:
   - Estado general (semáforo 🟢🟡🔴 basado en logs recientes y ADO)
   - Bloqueadores activos
   - Reuniones del día
   - Emails pendientes de atención relacionados al proyecto

4. Revisar el calendario del día completo:
   ```powershell
   pwsh -File ".agents/skills/outlook/get-calendar.ps1" -Days 1
   ```

5. Buscar emails urgentes de cualquier proyecto:
   ```powershell
   pwsh -File ".agents/skills/outlook/get-inbox.ps1" -Count 30 -UnreadOnly
   ```

6. Compilar el digest completo y enviarlo a Harol por email usando HTML profesional B&W (ver reglas abajo).

## Output format (pantalla)

```
Daily Digest — [fecha]
Projects active: X

[CODE] Project Name — GREEN / YELLOW / RED
Sprint: X% complete | Blockers: 0
Today: [meetings]
Email pending: none

[CODE] Other Project — YELLOW
Sprint: X% complete | Blockers: 2
Today: [meetings]
Email pending: Email from [client] unanswered (18h ago)

---
AGENDA
[full meeting list]

URGENT EMAILS
[emails requiring attention today]
```

## Email format — MANDATORY

El email enviado debe seguir las mismas reglas que `/email-send`:

- Fondo blanco (`#ffffff`). Texto negro (`#1a1a1a`). Sin colores decorativos.
- **CERO emojis** en el HTML.
- Sin banners, sin cajas con fondo de color, sin badges, sin `border-radius`.
- Estado de salud se escribe como texto inline bold: `Status: GREEN`, `Status: YELLOW`, `Status: RED` — nunca como fondo o badge coloreado.
- Layout `<table>`, fuente Calibri 11pt, secciones con `<strong>` + `border-bottom: 1px solid #cccccc`.
- Subject: `Daily Digest — [fecha]` (ASCII puro, sin emojis).

## Notes

- Se ejecuta automáticamente según `automations.json` → `daily-digest`
- Si se ejecuta sin Outlook abierto, omite el envío de email y solo muestra el digest en pantalla
- Semáforo: GREEN = sin bloqueadores, sprint en tiempo | YELLOW = bloqueadores o sprint retrasado | RED = escalación requerida
