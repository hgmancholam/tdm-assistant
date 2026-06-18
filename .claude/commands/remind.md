# remind

Crea, lista y gestiona recordatorios personales. El asistente los revisa en cada `/brief` y `/tdm` y te alerta cuando vencen.

## Usage

```
/remind [texto] [para cuándo]
/remind list
/remind done [número o texto]
/remind clear done
```

## Examples

```
/remind llamar a Sarah sobre el contrato mañana a las 10am
/remind revisar la propuesta de scope change antes del viernes
/remind seguimiento al cliente ALPHA en 2 días
/remind list
/remind done 3
/remind done "llamar a Sarah"
/remind clear done
```

## Behavior

### Crear recordatorio

Cuando el usuario dice "recuérdame X para Y" o usa `/remind [texto] [cuándo]`:

1. Extraer del input:
   - `text`: qué recordar
   - `dueDate`: cuándo (convertir expresiones relativas a fecha absoluta — hoy = `$currentDate`)
   - `dueTime`: hora específica si se menciona
   - `project`: código de proyecto si se menciona

2. Leer `reminders.json`

3. Generar ID: `rem-YYYYMMDD-NNN` (NNN = número secuencial del día)

4. Añadir el recordatorio:
```json
{
  "id": "rem-20260617-001",
  "text": "Llamar a Sarah sobre el contrato",
  "dueDate": "2026-06-18",
  "dueTime": "10:00",
  "project": null,
  "priority": "medium",
  "created": "2026-06-17T09:30:00",
  "status": "pending"
}
```

5. Escribir `reminders.json` actualizado

6. Confirmar:
```
⏰ Listo. Te recuerdo "[texto]" el [día, fecha] a las [hora si aplica].
```

---

### `/remind list` — Ver todos los recordatorios

Leer `reminders.json` y mostrar agrupados:

```
**Recordatorios**

⚠️ **VENCIDOS**
• rem-001 · [texto] — venció el [fecha] [· PROYECTO si aplica]

📅 **HOY**
• rem-002 · [texto] — a las [hora]

📆 **PRÓXIMOS**
• rem-003 · [texto] — [fecha]
• rem-004 · [texto] — [fecha]

✅ **COMPLETADOS (últimos 7 días)**
• rem-005 · [texto] — completado el [fecha]

Completar un recordatorio: /remind done [número o texto]
```

Si no hay recordatorios: "No tienes recordatorios pendientes."

---

### `/remind done [N]` — Marcar como completado

1. Leer `reminders.json`
2. Encontrar por número de lista o texto (búsqueda parcial)
3. Cambiar `status` a `"completed"`, añadir `completedAt`
4. Escribir actualizado
5. Confirmar: "✅ Marcado como completado: [texto]"

---

### `/remind clear done` — Limpiar completados

Elimina de `reminders.json` todos los recordatorios con `status: "completed"`.
Pedir confirmación antes de proceder.

---

## Alertas automáticas

El asistente revisa `reminders.json` en cada `/tdm` y `/brief` y alerta:
- 🔴 Recordatorios vencidos (dueDate < hoy, status = pending)
- ⏰ Recordatorios para hoy (dueDate = hoy, status = pending)

---

## Expresiones de tiempo soportadas

| Expresión | Interpreta como |
|-----------|----------------|
| "mañana" / "tomorrow" | fecha de mañana |
| "el viernes" / "on Friday" | próximo viernes |
| "en 2 días" / "in 2 days" | hoy + 2 días |
| "la próxima semana" / "next week" | lunes de la próxima semana |
| "antes del mediodía" | dueTime = 12:00 |
| "a las 3pm" | dueTime = 15:00 |
| "al final del día" / "EOD" | dueTime = 18:00 |
| "esta tarde" | dueTime = 15:00 |

---

## Notes

- Los recordatorios se persisten en `reminders.json` en la raíz del proyecto
- No se envían notificaciones automáticas — el asistente los revisa cada vez que se invoca
- Para recordatorios que requieren notificación automática (sin abrir Claude Code), usar `/automate`
- Máximo recomendado: 10 recordatorios activos (más genera ruido)
