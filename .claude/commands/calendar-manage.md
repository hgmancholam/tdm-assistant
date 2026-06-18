# calendar-manage

Crea eventos, reuniones y responde invitaciones en Outlook Calendar vía COM Automation.

## Usage

```
/calendar-manage create [detalles del evento]
/calendar-manage recurring [detalles del evento recurrente]
/calendar-manage respond [accept|decline|tentative] [descripción del evento]
/calendar-manage cancel [descripción del evento]
```

## Examples

```
/calendar-manage create "Sprint Review ALPHA" el viernes 3pm-4pm con John y Sarah
/calendar-manage create "1:1 con el equipo" hoy a las 2pm por 30 minutos
/calendar-manage recurring "Daily Standup ALPHA" todos los días hábiles a las 9am 30 minutos
/calendar-manage recurring "Status Report semanal" cada viernes a las 4pm
/calendar-manage respond accept "Sprint Planning del martes"
/calendar-manage respond decline "Reunión de alineación del jueves" — tengo conflicto
/calendar-manage respond tentative "All-hands del lunes"
```

## Behavior

---

### `create` — Crear evento único

1. Extraer del input:
   - Título del evento
   - Fecha y hora de inicio
   - Duración o hora de fin
   - Ubicación (si se menciona)
   - Asistentes (si se mencionan)
   - Descripción / agenda (opcional)

2. Si falta información crítica (título, fecha/hora), preguntar antes de continuar.

3. Crear el evento:
```powershell
pwsh -File ".agents/skills/outlook/create-event.ps1" `
  -Subject "[título]" `
  -StartTime "[YYYY-MM-DD HH:MM]" `
  -EndTime "[YYYY-MM-DD HH:MM]" `
  -Location "[ubicación o vacío]" `
  -Body "[descripción o vacío]" `
  -Attendees "[email1;email2 o vacío]"
```

4. Confirmar: "Evento creado: [título] el [fecha] de [hora inicio] a [hora fin]."

---

### `recurring` — Crear evento recurrente

1. Extraer del input:
   - Título
   - Hora de inicio y duración
   - Tipo de recurrencia: daily / weekly / monthly
   - Días específicos si es semanal (ej: lunes a viernes, solo martes)
   - Fecha de fin o "sin fecha de fin"

2. Crear el evento recurrente:
```powershell
pwsh -File ".agents/skills/outlook/create-recurring-event.ps1" `
  -Subject "[título]" `
  -StartTime "[YYYY-MM-DD HH:MM]" `
  -DurationMinutes [minutos] `
  -RecurrenceType "[Daily|Weekly|Monthly]" `
  -DaysOfWeek "[Mon,Tue,Wed,Thu,Fri o vacío]" `
  -EndDate "[YYYY-MM-DD o vacío para sin fin]" `
  -Location "[ubicación o vacío]" `
  -Body "[descripción o vacío]" `
  -Attendees "[email1;email2 o vacío]"
```

3. Confirmar: "Evento recurrente creado: [título] — [frecuencia] a las [hora]."

---

### `respond` — Responder invitación de reunión

1. Buscar la invitación en el inbox:
```powershell
pwsh -File ".agents/skills/outlook/search-emails.ps1" -Subject "[descripción]" -Count 5
```

2. Si se encuentran múltiples coincidencias, mostrar las opciones y pedir que el usuario especifique.

3. Responder:
```powershell
pwsh -File ".agents/skills/outlook/respond-event.ps1" `
  -EntryID "[ID de la invitación]" `
  -Response "[Accept|Decline|Tentative]" `
  -Message "[mensaje opcional]"
```

4. Confirmar: "Invitación [aceptada/rechazada/tentativa]: [título de la reunión]."

---

## Formatos de fecha/hora soportados

| Expresión | Interpreta como |
|-----------|----------------|
| "hoy a las 2pm" | hoy a las 14:00 |
| "mañana a las 9am" | mañana a las 09:00 |
| "el viernes a las 3pm" | próximo viernes 15:00 |
| "por 30 minutos" | duración = 30 min |
| "de 2pm a 3pm" | inicio 14:00, fin 15:00 |
| "todos los días hábiles" | RecurrenceType=Weekly, Days=Mon,Tue,Wed,Thu,Fri |
| "cada lunes" | RecurrenceType=Weekly, Days=Mon |
| "cada 2 semanas" | RecurrenceType=Weekly, Interval=2 |

---

## Notes

- Outlook Desktop debe estar abierto y autenticado
- Para eventos con asistentes externos, Outlook envía las invitaciones automáticamente
- Para ver la agenda actual: `/agenda`
- Para ver qué hay en el calendario esta semana: `/agenda week`
