# new-skill

Crea una nueva capacidad para el asistente bajo demanda. Analiza la necesidad, elige la tecnología correcta (PowerShell o Python), escribe el script siguiendo las convenciones del proyecto, lo prueba, y actualiza el registro del sistema. El asistente evoluciona con cada skill que creas.

## Usage

```
/new-skill [descripción de lo que necesitas]
/new-skill extend [nombre-skill-existente] — [qué agregar]
```

## Examples

```
/new-skill un script que descargue todos los adjuntos de un email y los guarde en el proyecto
/new-skill reporte de horas trabajadas por sprint para ALPHA en Excel
/new-skill integración con Jira para sincronizar work items
/new-skill script que analice el sentimiento de los emails del cliente y me dé una alerta si hay frustración
/new-skill gráfica de burndown para cualquier proyecto
/new-skill extend email-triage — que detecte emails con contratos o documentos adjuntos
/new-skill automatización que revise cada lunes si algún proyecto no tuvo actividad la semana pasada
```

## Behavior

Seguir el flujo completo definido en `.agents/skills/skill-builder/SKILL.md`:

### Paso 1 — Entender la necesidad

Analizar el input del usuario. Si falta información crítica, hacer máximo 2 preguntas antes de proceder:
- ¿Qué produce como salida? (si no está claro)
- ¿De dónde vienen los datos de entrada? (si no está claro)

### Paso 2 — Verificar el catálogo

```
1. Leer CLAUDE.md → sección de Slash Commands y Agent Design Principles
2. Leer skill-registry.json → lista de todos los skills existentes
3. Verificar si ya existe algo similar
```

Si existe algo similar → explicarlo y preguntar si quiere extenderlo o crear algo nuevo.

### Paso 3 — Diseñar la arquitectura

Determinar:
- ¿PowerShell o Python? (ver tabla de decisión en SKILL.md)
- ¿Dónde va el script? (outlook/, projects/, analytics/, u otra carpeta nueva)
- ¿Necesita comando Claude Code (.md)?
- ¿Necesita actualizar settings.json?

Mostrar el plan al usuario antes de escribir:
```
📐 **Plan:**
- Tipo: [PowerShell / Python]
- Archivo: [ruta]
- Comando: [/nombre o "solo script interno"]
- Actualizaciones: [settings.json / CLAUDE.md / skill-registry.json]

¿Procedo?
```

### Paso 4 — Escribir el skill

Crear los archivos siguiendo exactamente las convenciones del proyecto (ver SKILL.md).

Para PowerShell:
- param() con tipos, try/catch, output JSON, success/error
- Guardar en `.agents/skills/[carpeta]/[nombre].ps1`

Para Python:
- Docstring completo, argparse, stdin JSON, output JSON
- Guardar en `.agents/skills/analytics/[nombre].py` o nueva carpeta si justificado

Para comando Claude Code:
- Estructura estándar: Usage, Examples, Behavior (pasos numerados), Output format, Notes
- Guardar en `.claude/commands/[nombre].md`

### Paso 5 — Actualizar registros

1. Añadir entrada en `skill-registry.json`
2. Añadir el comando en la tabla correspondiente de `CLAUDE.md`
3. Si el script está en nueva carpeta, añadir permiso en `.claude/settings.json`

### Paso 6 — Probar

Ejecutar el script con datos de prueba y mostrar el resultado al usuario.

```powershell
pwsh -File ".agents/skills/[carpeta]/[script].ps1" -Param "test"
# o
python .agents/skills/analytics/[script].py --param "test"
```

### Paso 7 — Confirmar

```
✅ **Nuevo skill: [nombre]**

**Qué hace:** [descripción]

**Archivos creados:**
- [archivo 1]
- [archivo 2]

**Cómo usarlo:**
[instrucción o comando]

**Prueba:** [resultado]

Registrado en skill-registry.json y CLAUDE.md.
```

---

## Tipos de skills que puedes crear

| Tipo | Ejemplos |
|------|---------|
| Integración Outlook | Descargar adjuntos, filtros avanzados, reglas de carpetas |
| Análisis de datos | Gráficas personalizadas, reportes especiales, KPIs |
| Integraciones externas | APIs REST, webhooks, servicios cloud |
| Automatizaciones | Tareas periódicas, alertas, sincronizaciones |
| Comandos de orquestación | Workflows multi-step, asistentes especializados |
| Generación de documentos | PDFs, PowerPoints, Word, Excel personalizados |
| Procesamiento de texto | Análisis de emails, resúmenes automáticos, detección de patrones |

---

## Notes

- El skill-builder sigue las convenciones exactas del proyecto — el output siempre es JSON
- Los skills nuevos aparecen inmediatamente disponibles para el asistente
- Para instalar dependencias Python nuevas, añadir a `.agents/skills/analytics/requirements.txt`
- Ver referencia completa en `.agents/skills/skill-builder/SKILL.md`
- El skill-registry.json es el inventario de todo lo que el asistente puede hacer
