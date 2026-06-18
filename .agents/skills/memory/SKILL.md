---
name: memory
description: Servicio centralizado de memoria del TDM Assistant. Capa de abstracción para todas las operaciones de lectura y escritura de contexto — perfil de usuario, sesiones, estado de proyectos, síntesis semanales, recordatorios y prioridades. Backend actual: archivos locales. Diseñado para migrar a base de datos sin cambiar el resto del sistema.
---

# Memory Service

El servicio de memoria es la **única puerta de entrada** a todos los datos de contexto del asistente. Ningún otro skill o comando lee ni escribe archivos de memoria directamente — todo pasa por aquí.

---

## Por qué existe esta capa

Hoy la memoria vive en archivos locales. Mañana puede vivir en SQLite, PostgreSQL, MongoDB, o una base de datos vectorial para búsqueda semántica. Para migrar, solo se cambia el backend de este servicio — el resto del sistema no sabe ni le importa dónde están los datos.

---

## Las 4 capas de memoria

```
Capa 1 — Hechos permanentes      (se leen siempre al arrancar)
  user.profile.md                 → quién eres, cómo trabajas, SLAs, alertas

Capa 2 — Estado comprimido        (resumen de la semana / del proyecto)
  projects/CODE/context.md        → estado actual del proyecto (sprint, riesgos, decisiones)
  memory/weekly/weekly-YYYY-WW.md → síntesis semanal de todos los proyectos

Capa 3 — Eventos recientes        (últimos 7 días)
  projects/CODE/logs/YYYY-MM-DD.md → actividad diaria del proyecto
  reminders.json / priorities.json → estado operativo actual

Capa 4 — Contexto de sesión       (lo que hablamos ayer)
  memory/last-session.md           → qué se trató, acciones, pendientes, contexto para retomar
  memory/sessions/session-*.md     → archivo histórico de sesiones
```

**Estrategia de lectura del agente al arrancar:**
1. Capa 1 siempre completa
2. Capa 2 siempre (context.md por proyecto + último weekly)
3. Capa 4 siempre (last-session.md)
4. Capa 3 solo últimos 3-5 días (no todos los logs históricos)

---

## Interfaz de operaciones

### READ — leer memoria

```python
# Perfil del usuario
python .agents/skills/memory/memory.py --op read --type profile

# Sesión anterior (qué hablamos ayer)
python .agents/skills/memory/memory.py --op read --type session

# Estado comprimido de un proyecto
python .agents/skills/memory/memory.py --op read --type project-context --project ALPHA

# Síntesis semanal (week = YYYY-WW, default = semana actual)
python .agents/skills/memory/memory.py --op read --type weekly --week 2026-25

# Recordatorios (devuelve el JSON parseado)
python .agents/skills/memory/memory.py --op read --type reminders

# Prioridades
python .agents/skills/memory/memory.py --op read --type priorities
```

---

### WRITE — escribir memoria

```python
# Guardar perfil actualizado
python .agents/skills/memory/memory.py --op write --type profile \
  --content "# User Profile ..."

# Guardar sesión (archiva la anterior automáticamente)
python .agents/skills/memory/memory.py --op write --type session \
  --content "# Session Memory — 2026-06-17 ..."

# Guardar estado comprimido de proyecto
python .agents/skills/memory/memory.py --op write --type project-context \
  --project ALPHA --content "# Project Context — ALPHA ..."

# Síntesis semanal
python .agents/skills/memory/memory.py --op write --type weekly \
  --week 2026-25 --content "# Weekly Synthesis ..."

# Reminders (JSON completo)
python .agents/skills/memory/memory.py --op write --type reminders \
  --content '{"reminders": [...]}'

# Priorities
python .agents/skills/memory/memory.py --op write --type priorities \
  --content '{"lastUpdated": "2026-06-17", "items": [...]}'
```

---

### APPEND — añadir sin reemplazar

```python
# Añadir entrada al log del día del proyecto
python .agents/skills/memory/memory.py --op append --type log \
  --project ALPHA --entry "Sprint review completado, cliente satisfecho"

# Añadir follow-up a la sesión actual
python .agents/skills/memory/memory.py --op append --type session \
  --entry "Pendiente: revisar propuesta de John"
```

---

### SEARCH — buscar en toda la memoria

```python
# Búsqueda global
python .agents/skills/memory/memory.py --op search --query "sprint velocity"

# Buscar solo en logs de un proyecto
python .agents/skills/memory/memory.py --op search --query "bloqueador" \
  --project ALPHA --type log

# Buscar en contextos de proyecto
python .agents/skills/memory/memory.py --op search --query "presupuesto" \
  --type project-context
```

---

### LIST — inventario de archivos de memoria

```python
# Listar sesiones archivadas
python .agents/skills/memory/memory.py --op list --type sessions

# Listar síntesis semanales
python .agents/skills/memory/memory.py --op list --type weekly

# Listar logs de un proyecto
python .agents/skills/memory/memory.py --op list --type logs --project ALPHA
```

---

## Formato de respuesta

Toda operación devuelve JSON:

```json
// Éxito — read
{
  "success": true,
  "found": true,
  "content": "# User Profile ...",
  "path": "user.profile.md",
  "lastModified": "2026-06-17T10:30:00"
}

// Éxito — write
{
  "success": true,
  "path": "memory/last-session.md",
  "size": 1240,
  "lastModified": "2026-06-17T15:45:00"
}

// Éxito — search
{
  "success": true,
  "query": "sprint velocity",
  "count": 3,
  "results": [
    {
      "type": "log",
      "project": "ALPHA",
      "path": "projects/ALPHA/logs/2026-06-15.md",
      "line": 12,
      "match": "Sprint velocity cayó a 28 pts (estaba en 38)",
      "context": "..."
    }
  ]
}

// Error
{
  "success": false,
  "error": "descripción del error"
}
```

---

## Formatos esperados de cada tipo de memoria

### `last-session.md`

```markdown
# Session Memory — YYYY-MM-DD

## Lo que trabajamos
- [tema 1]
- [tema 2]

## Acciones tomadas
- [acción completada]

## Follow-ups para próxima sesión
- [ ] [pendiente 1]
- [ ] [pendiente 2]

## Contexto para retomar
[resumen en 2-3 líneas de la situación actual, para que el agente retome sin leer todo el historial]

## Proyectos activos en esta sesión
[códigos de proyectos]
```

### `projects/CODE/context.md`

```markdown
# Project Context — [CODE]
*Última actualización: YYYY-MM-DD | Generado por TDM Assistant*

## Estado actual
**Semáforo:** 🟢/🟡/🔴 | **Fase:** [fase] | **Sprint:** [N] (vence [fecha])

## Resumen del sprint
[2-3 líneas: % completado, velocity, bloqueadores]

## Riesgos abiertos (Top 3)
1. 🔴/🟡 [riesgo + owner]

## Decisiones clave (últimos 30 días)
- [fecha]: [decisión]

## Action items abiertos
- [owner]: [acción] (vence [fecha])

## Notas de equipo
[cualquier contexto importante sobre el equipo]
```

### `memory/weekly/weekly-YYYY-WW.md`

```markdown
# Weekly Synthesis — Semana [WW], [año]
*[Fecha inicio] → [Fecha fin]*

## Resumen ejecutivo
[2-3 líneas del estado general de todos los proyectos]

## Por proyecto
### [CODE] — 🟢/🟡/🔴
[2-3 líneas]

## Emails y comunicaciones importantes
[emails o conversaciones clave de la semana]

## Decisiones tomadas esta semana
[decisiones de cualquier proyecto]

## Para la próxima semana
[qué hay que monitorear o completar]
```

---

## Ciclo de actualización

| Memoria | Cuándo se actualiza | Quién la actualiza |
|---------|--------------------|--------------------|
| `user.profile.md` | Onboarding + cuando el usuario pide cambios | `/tdm update profile` |
| `context.md` | Semanalmente (viernes) + al cerrar un sprint | `/project-agent CODE sync-context` |
| `last-session.md` | Al terminar cada sesión TDM productiva | `/tdm` al cerrar |
| `weekly-YYYY-WW.md` | Viernes (automatización) | `/tdm weekly` o automático |
| `reminders.json` | On demand | `/remind` |
| `priorities.json` | On demand | `/priorities` |
| `logs/YYYY-MM-DD.md` | Cada vez que hay actividad | `/project-agent CODE log` |

---

## Configuración de backend

Variable de entorno: `MEMORY_BACKEND`

| Valor | Backend | Estado |
|-------|---------|--------|
| `file` (default) | Archivos locales (Markdown + JSON) | ✅ Activo |
| `sqlite` | SQLite local | 🔲 Futuro |
| `postgresql` | PostgreSQL | 🔲 Futuro |
| `mongodb` | MongoDB | 🔲 Futuro |
| `vector` | Base de datos vectorial (búsqueda semántica) | 🔲 Futuro |

---

## Guía de migración a base de datos

Cuando quieras mover la memoria a una DB:

1. **Crear la clase nueva** en `memory.py`:
   ```python
   class SQLiteMemoryStore(MemoryStore):
       def read_profile(self) -> dict:
           # SELECT content FROM memory WHERE type='profile'
           ...
   ```

2. **Registrarla** en el dict `BACKENDS`:
   ```python
   BACKENDS["sqlite"] = SQLiteMemoryStore
   ```

3. **Migrar datos** (script de migración):
   ```python
   # Leer todos los archivos existentes
   # Escribir en la nueva DB
   # Verificar integridad
   ```

4. **Cambiar el backend**:
   ```
   # En .env:
   MEMORY_BACKEND=sqlite
   ```

5. **Cero cambios** en `/tdm`, `/brief`, `/project-agent`, o cualquier otro skill. Ellos solo llaman `memory.py` — no saben dónde están los datos.

---

## Notas de implementación

- El script nunca lanza excepciones al caller — siempre devuelve `{"success": false, "error": "..."}` en caso de error
- `write_session()` archiva la sesión anterior automáticamente antes de sobrescribir
- `search()` por defecto busca en todas las capas — filtrar con `--type` y `--project` si el resultado es demasiado amplio
- Los logs en `projects/CODE/logs/` no son manejados por `write` — solo por `append` (para no borrar accidentalmente)
- La búsqueda en capa 3 está limitada a los últimos 30 archivos por proyecto para no sobrecargar en proyectos con histórico largo
