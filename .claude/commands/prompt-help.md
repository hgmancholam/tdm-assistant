# prompt-help

Experto en prompt engineering. Toma cualquier tarea que quieras pedirle al asistente (o a cualquier LLM) y te devuelve el prompt maestro optimizado — claro, específico, estructurado, y listo para usar.

## Usage

```
/prompt-help [descripción de la tarea]
/prompt-help improve [prompt existente]
/prompt-help [tarea] for [audiencia o sistema]
```

## Examples

```
/prompt-help write a status report for the ALPHA steering committee
/prompt-help analyze the delivery health of a project
/prompt-help improve "make my email better"
/prompt-help draft a delay notification for a client
/prompt-help ask the assistant to do a full risk analysis
/prompt-help I want to ask about sprint velocity but I don't know how to phrase it
/prompt-help create a prompt for generating weekly EVM reports
```

## Behavior

### Paso 1 — Leer la guía de referencia

Leer `.agents/skills/prompt-engineer/SKILL.md` para cargar el framework completo de prompt engineering (CRATE, tipos de prompt, patrones TDM, anti-patrones).

### Paso 2 — Entender la tarea

**Modo A — Prompt desde cero** (`/prompt-help [tarea]`):

Analizar el input:
- ¿Qué tipo de tarea es? (Instructional / Analytical / Generative / Transformational)
- ¿Qué output se espera? (formato, extensión, tono)
- ¿Hay contexto suficiente?

Si falta información crítica, hacer **máximo 2 preguntas** antes de continuar:
1. ¿Qué formato/estructura necesitas en el output?
2. ¿Para quién es (audiencia o sistema)?

Si el usuario dio suficiente contexto, ir directamente a Paso 3.

**Modo B — Mejorar un prompt existente** (`/prompt-help improve [prompt]`):

Analizar el prompt existente con la checklist de anti-patrones del SKILL.md:
- ¿Tiene rol definido?
- ¿Especifica el output esperado?
- ¿El verbo de acción es fuerte y específico?
- ¿Tiene restricciones o el modelo puede divagar?
- ¿Especifica idioma si el contenido es exportable?
- ¿Termina con preguntas en lugar de instrucciones?

### Paso 3 — Construir el prompt maestro

Aplicar el framework CRATE del SKILL.md:
- **C**ontext — qué sabe el modelo sobre la situación
- **R**ole — qué experto debe adoptar
- **A**ction — verbo fuerte y específico
- **T**arget output — formato, extensión, estructura, tono
- **E**xclusions — qué no hacer

Si la tarea es de tipo TDM/PM, usar el patrón correspondiente de la "Biblioteca de patrones TDM" del SKILL.md.

### Paso 4 — Entregar el prompt maestro

Formato de entrega:

```
## Master Prompt — [título de la tarea]

**Best used for:** [1 línea]
**Type:** [tipo]
**Technique:** [técnicas aplicadas]

---

[PROMPT COMPLETO — copy-paste ready]

---

**How to adapt it:**
- [instrucción de personalización 1]
- [instrucción de personalización 2]

**Why this works:**
[2-3 líneas explicando las decisiones de diseño]
```

### Paso 5 — Ofrecer variaciones

Al final, ofrecer:
```
**Variaciones disponibles:**
- Versión más corta → [decirle al usuario qué remover]
- Versión más formal → [ajuste de tono]
- Versión para otro sistema (GPT-4, Gemini, etc.) → [ajuste si aplica]

¿Quieres que lo ejecute ahora con tu contexto específico?
```

---

## Output format

```
## Master Prompt — [Título]

**Best used for:** [cuándo usar este prompt]
**Type:** Generative | Analytical | Instructional | Transformational
**Technique:** Role prompting + Output specification + Constraints

---

You are [role]. [Strong action verb] [object].

Context: [placeholder — describe your situation]
[Other CRATE elements as needed]

Output format: [exact specification]
Language: [English / as needed]
[Constraints if applicable]

---

**How to adapt it:**
- Replace `[PLACEHOLDER]` with [descripción específica]
- For [variación], change [parte] to [alternativa]

**Why this works:**
[Explicación de las decisiones de diseño en 2-3 líneas]
```

---

## Quick patterns reference

Para tareas frecuentes en el día a día TDM, el skill reconoce estos tipos y aplica el patrón correcto automáticamente:

| Si pides... | Patrón aplicado |
|-------------|----------------|
| Email / communication draft | Generative + audience + tone + length constraint |
| Project analysis | Analytical + dimensions + benchmark + verdict format |
| Risk evaluation | Risk management pattern + scoring + mitigation options |
| Decision support | Decision framework + options + direct recommendation |
| Status report | Executive communication pattern + summary-first structure |
| Sprint / ADO analysis | Delivery health pattern + metric-by-metric format |
| Retrospective | Retrospective pattern + evidence-based + actionable output |
| Escalation | Escalation pattern + impact + specific ask |

---

## Notes

- El prompt maestro siempre es **copy-paste ready** — no necesita edición para funcionar
- Si el usuario ya tiene un prompt pero no está obteniendo buenos resultados, `/prompt-help improve [prompt]` diagnostica y arregla el problema
- Para tareas del sistema TDM, el skill conoce los patrones específicos del dominio (delivery management, ADO, Outlook, reportes)
- Ver el framework completo en `.agents/skills/prompt-engineer/SKILL.md`
