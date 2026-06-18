# memory

Acceso directo al servicio de memoria del asistente — lee, escribe y busca en todas las capas de contexto. Útil para inspeccionar qué sabe el asistente, buscar algo en el historial, o forzar la actualización de un contexto.

## Usage

```
/memory status
/memory read [tipo] [proyecto]
/memory search [consulta]
/memory sync-context [proyecto]
/memory weekly
/memory sessions
```

## Examples

```
/memory status
/memory read session
/memory read context ALPHA
/memory search "bloqueador de infraestructura"
/memory search "Sarah" ALPHA
/memory sync-context ALPHA
/memory sync-context all
/memory weekly
/memory sessions
```

## Behavior

---

### `status` — Vista completa del estado de la memoria

Mostrar:
1. Perfil configurado: sí/no, última actualización
2. Sesión anterior: fecha, resumen de 1 línea
3. Por cada proyecto activo: ¿tiene context.md? ¿cuándo fue actualizado?
4. Síntesis semanal actual: ¿existe? ¿cuándo fue generada?
5. Recordatorios activos: conteo
6. Prioridades activas: conteo
7. Backend de memoria configurado

```
**Estado de la Memoria — [ASSISTANT_NAME]**

📋 Perfil: ✅ Configurado (actualizado: [fecha])
💬 Última sesión: [fecha] — "[resumen 1 línea]"
📊 Backend: file (local)

**Proyectos:**
| Proyecto | context.md | Última actualización | Logs (días) |
|----------|-----------|---------------------|-------------|
| ALPHA    | ✅        | hace 3 días          | 45          |
| BETA     | ❌        | —                    | 12          |

**Síntesis semanal:** Semana [WW] — [fecha] ✅
**Recordatorios activos:** [N]
**Prioridades activas:** [N]
```

---

### `read [tipo] [proyecto]` — Leer una capa de memoria

```python
# tipo: session | profile | context | weekly | reminders | priorities
python .agents/skills/memory/memory.py --op read --type session
python .agents/skills/memory/memory.py --op read --type project-context --project "PROYECTO"
python .agents/skills/memory/memory.py --op read --type weekly
```

Mostrar el contenido tal cual, indicando cuándo fue actualizado.

---

### `search [consulta] [proyecto?]` — Buscar en toda la memoria

```python
python .agents/skills/memory/memory.py --op search --query "[consulta]"
# Con filtro de proyecto:
python .agents/skills/memory/memory.py --op search --query "[consulta]" --project "[CODE]"
```

Mostrar resultados agrupados por tipo y proyecto, con contexto de 2 líneas alrededor de cada match.

---

### `sync-context [proyecto | all]` — Generar/actualizar context.md

Este es el proceso de **compresión de memoria** para un proyecto:

1. Leer todos los datos del proyecto:
```powershell
pwsh -File ".agents/skills/projects/get-project.ps1" -ProjectCode "CODE"
```

2. Leer logs de los últimos 30 días:
```python
python .agents/skills/memory/memory.py --op list --type logs --project "CODE"
# Luego leer los últimos 20 archivos
```

3. Leer notes recientes (meetings/, decisions/, risks/):
   - Últimas 5 reuniones
   - Últimas 3 decisiones
   - Risk register más reciente

4. **Sintetizar** toda esa información en un `context.md` comprimido siguiendo el formato definido en el SKILL.md de memory:
   - Estado actual (semáforo, sprint, fase)
   - Resumen del sprint
   - Top 3 riesgos abiertos
   - Decisiones clave (últimos 30 días)
   - Action items abiertos
   - Notas de equipo

5. Escribir el resultado:
```python
python .agents/skills/memory/memory.py --op write --type project-context \
  --project "CODE" --content "[contexto generado]"
```

6. Confirmar: "context.md de [PROYECTO] actualizado — [N] días de logs comprimidos."

Si se especifica `all`, ejecutar el proceso para todos los proyectos activos.

---

### `weekly` — Generar síntesis semanal

Genera el resumen semanal de todos los proyectos.

1. Listar proyectos activos:
```powershell
pwsh -File ".agents/skills/projects/list-projects.ps1" -Status "active"
```

2. Para cada proyecto, leer su `context.md` (o generarlo si no existe).

3. Leer los logs de la semana actual de cada proyecto.

4. Leer la sesión anterior (`last-session.md`).

5. **Sintetizar** la semana en formato `weekly-YYYY-WW.md`:
   - Resumen ejecutivo de la semana
   - Estado por proyecto
   - Comunicaciones / emails importantes (leer inbox si Outlook disponible)
   - Decisiones tomadas
   - Para la próxima semana

6. Guardar:
```python
python .agents/skills/memory/memory.py --op write --type weekly \
  --week "[semana actual]" --content "[síntesis]"
```

7. Preguntar: "¿Quieres que te envíe el resumen semanal por email?"

---

### `sessions` — Ver historial de sesiones

```python
python .agents/skills/memory/memory.py --op list --type sessions
```

Mostrar tabla de sesiones archivadas con fecha y opción de leer cualquiera.

---

## Cuándo el asistente actualiza la memoria automáticamente

| Evento | Actualización |
|--------|--------------|
| Inicio de sesión `/tdm` | Lee capa 1 (profile), capa 2 (context), capa 4 (last-session) |
| Fin de sesión productiva | Escribe `last-session.md` con resumen |
| Sprint completado | Genera `context.md` del proyecto |
| Cada viernes (automático) | Genera `weekly-YYYY-WW.md` si está configurado |
| `/priorities set` | Escribe `priorities.json` vía memory service |
| `/remind [algo]` | Escribe `reminders.json` vía memory service |
| `/project-agent CODE log` | Hace append en `logs/YYYY-MM-DD.md` |

---

## Notes

- La búsqueda está limitada a los últimos 30 logs por proyecto para eficiencia
- `sync-context all` puede tomar varios minutos si hay muchos proyectos
- El backend actual es `file` — cambiar con `MEMORY_BACKEND` en `.env`
- Para migrar a una base de datos, ver guía en `.agents/skills/memory/SKILL.md`
- Los archivos de sesión archivados están en `memory/sessions/`
