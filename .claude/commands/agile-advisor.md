# agile-advisor

Análisis experto de un proyecto desde la perspectiva de un Agile Coach + TDM senior con visión de IA. Entrega un diagnóstico técnico honesto con insights y recomendaciones concretas.

## Usage

```
/agile-advisor <PROJECT-CODE> [focus: delivery | team | risks | stakeholders | process | ai | full]
```

## Examples

```
/agile-advisor ALPHA
/agile-advisor ALPHA delivery
/agile-advisor ALPHA risks
/agile-advisor ALPHA "va a llegar al deadline?"
/agile-advisor ALPHA "el cliente está inconforme, qué hacemos"
```

## Behavior

### Paso 1 — Recopilación de evidencia

Antes de emitir cualquier opinión, recopilar datos reales del proyecto:

**Contexto base:**
```powershell
pwsh -File ".agents/skills/projects/get-project.ps1" -ProjectCode "$CODE"
```

**Logs recientes (últimos 14 días):**
Leer todos los archivos `.md` en `projects/$CODE/logs/` de los últimos 14 días.

**Notas de reuniones recientes:**
Leer los últimos 4-6 archivos en `projects/$CODE/meetings/`.

**Risk register:**
Leer el archivo más reciente en `projects/$CODE/risks/`.

**Decisiones:**
Leer los últimos archivos en `projects/$CODE/decisions/`.

**Métricas de ADO:**
```
→ Invocar /ado-metrics para velocity, cycle time, lead time, spillover
→ Invocar /ado-sprint-plan review para estado del sprint actual
→ Invocar /ado-dependencies para bloqueadores activos
→ Invocar /ado-backlog refine para calidad del backlog
```

**Emails del proyecto (últimas 2 semanas):**
```powershell
pwsh -File ".agents/skills/outlook/search-emails.ps1" -Query "$PROJECT_NAME" -DaysBack 14 -Count 20
```

**Reuniones próximas:**
```powershell
pwsh -File ".agents/skills/outlook/get-calendar.ps1" -Days 7
```

---

### Paso 2 — Análisis con el framework de Agile Advisor

Aplicar el framework completo del skill `agile-advisor`:

- Evaluar las 6 dimensiones: Delivery Health, Team Health, Risk Posture, Stakeholder Alignment, Process Maturity, AI-Readiness
- Detectar patrones conocidos (Velocity Death Spiral, Bus Factor, Scope Creep Silencioso, etc.)
- Comparar métricas contra benchmarks de industria
- Construir predicciones basadas en tendencias

Si se especifica un `focus`, profundizar en esa dimensión con más detalle y dar recomendaciones más granulares para ella.

---

### Paso 3 — Entrega del análisis

Seguir el formato de salida definido en el SKILL.md de `agile-advisor`:
- Diagnóstico general con semáforo global
- Análisis por dimensión con evidencia específica del proyecto
- Recomendaciones priorizadas (Crítico / Alta / Mejora Continua)
- Predicciones cuantificadas
- "Una cosa que cambiaría hoy"

---

## Modos de enfoque

| Focus | Qué profundiza |
|-------|---------------|
| `delivery` | Velocity, cycle time, commitment ratio, proyección de deadline |
| `team` | Dinámica de equipo, bloqueadores, carga de trabajo, señales de riesgo humano |
| `risks` | Risk register, bloqueadores, dependencias, single points of failure |
| `stakeholders` | Comunicación, status reports, alineación, decisiones pendientes |
| `process` | Madurez ágil, calidad del backlog, ceremonias, Definition of Done |
| `ai` | AI-readiness, governance de modelos, MLOps, criterios de aceptación de IA |
| `full` | Análisis completo de todas las dimensiones (default) |

---

## Output format

Ver formato completo en `.agents/skills/agile-advisor/SKILL.md`.

Resumen de la estructura:
```
# Agile Advisor — Análisis de [PROYECTO]

## Diagnóstico General — 🟢/🟡/🔴
## Análisis por Dimensión (6 áreas)
## Recomendaciones (Crítico / Alta / Mejora)
## Predicciones
## Una cosa que cambiaría hoy
```

---

## Notes

- Requiere que el proyecto exista en `projects/CODE/` con `project.settings`
- Cuanta más información haya en `logs/`, `meetings/`, y `risks/`, más preciso el análisis
- Sin datos de ADO el análisis de Delivery Health se basa solo en logs — aclararlo en el output
- El análisis es una **opinión técnica experta**, no un reporte automático — puede y debe contradecir percepciones del equipo si los datos lo justifican
- Guardar el análisis como nota del proyecto al terminar:
  ```powershell
  pwsh -File ".agents/skills/projects/save-notes.ps1" `
    -ProjectCode "CODE" -Type "notes" `
    -Title "Agile Advisor Analysis [fecha]" -Content "[análisis completo]"
  ```
