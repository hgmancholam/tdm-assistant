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

6. Compilar el digest completo y enviarlo a Harol por email:
   ```powershell
   pwsh -File ".agents/skills/outlook/send-email.ps1" `
     -To "harol.manchola@arroyoconsulting.net" `
     -Subject "Daily Digest — [fecha]" `
     -Body "[digest completo]"
   ```

## Output format

```
# Daily Digest — [fecha]
📋 Proyectos activos: X

## [CÓDIGO] Nombre del Proyecto — 🟢 On Track
**Sprint:** X% completado | **Bloqueadores:** 0
**Hoy:** [reuniones del día]
**Pendiente en email:** ninguno

## [CÓDIGO] Otro Proyecto — 🟡 Atención
**Sprint:** X% completado | **Bloqueadores:** 2
**Hoy:** [reuniones]
**Pendiente en email:** Email de [cliente] sin responder (hace 18h)

---
## 📅 Agenda del día
[lista completa de reuniones de todos los proyectos]

## 📧 Emails urgentes sin responder
[emails de cualquier proyecto que requieren atención hoy]
```

## Notes

- Se ejecuta automáticamente según `automations.json` → `daily-digest`
- Si se ejecuta sin Outlook abierto, omite el envío de email y solo muestra el digest en pantalla
- Semáforo: 🟢 = sin bloqueadores, sprint en tiempo | 🟡 = bloqueadores o sprint retrasado | 🔴 = escalación requerida
