# ai-architect

Experto en arquitectura de sistemas de IA y soluciones agénticas. Evalúa arquitecturas existentes, diseña nuevas soluciones, valida decisiones técnicas y genera ADRs — siempre consultando fuentes de autoridad de la industria antes de recomendar.

## Usage

```
/ai-architect [action] [topic]
```

## Actions

| Action | Descripción |
|--------|------------|
| `evaluate` | Evalúa una arquitectura de IA existente y entrega diagnóstico con recomendaciones |
| `design` | Diseña una nueva arquitectura agéntica o de IA para un caso de uso específico |
| `decide` | Ayuda a tomar una decisión técnica específica con ADR documentado |
| `compare` | Compara dos o más opciones técnicas (modelos, frameworks, patrones) |
| `review` | Revisa el stack de IA actual del proyecto activo o de un sistema descrito |
| `evals` | Diseña un plan de evaluación (evals) para un sistema de IA |
| `security` | Audita la postura de seguridad y AI governance de un sistema |

## Examples

```
/ai-architect evaluate "Tenemos RAG con GPT-4, Pinecone y LangChain en producción, latencia alta"
/ai-architect design "Agente de soporte que responde tickets consultando nuestra base de conocimiento"
/ai-architect decide "¿RAG o fine-tuning para nuestro dominio legal?"
/ai-architect compare "LangGraph vs AutoGen para un sistema multi-agente de análisis financiero"
/ai-architect evals "Sistema de clasificación de contratos con Claude"
/ai-architect review
```

## Behavior

### Paso 1 — Consulta de fuentes de autoridad

Antes de emitir cualquier recomendación, buscar en fuentes primarias:

```
WebSearch: "[tema] best practices site:docs.anthropic.com OR site:python.langchain.com"
WebSearch: "[framework A] vs [framework B] production 2024 2025"
WebSearch: "[patrón] limitations trade-offs enterprise"
```

Fuentes de autoridad que siempre consultar cuando sea relevante:
- **Anthropic**: docs.anthropic.com (agent patterns, tool use, prompting)
- **Google / DeepMind**: ai.google.dev, research.google
- **Microsoft Research**: microsoft.com/research (AutoGen, Semantic Kernel)
- **LangChain**: python.langchain.com, blog.langchain.dev
- **LlamaIndex**: docs.llamaindex.ai
- **Papers**: arxiv.org (cs.AI, cs.CL), paperswithcode.com
- **MLOps**: mlflow.org, wandb.ai, arize.com
- **AI Governance**: nist.gov/ai, eur-lex.europa.eu (EU AI Act)

### Paso 2 — Análisis con el framework de AI Architect

Aplicar el marco completo del SKILL.md:

1. **Fit del modelo/LLM** — selección correcta, latencia, costo, privacy
2. **Diseño agéntico** — patrón correcto (chain, ReAct, multi-agent, stateful)
3. **RAG / Retrieval** — chunking, embedding, reranking, hallucination detection
4. **Memoria y estado** — tipo de memoria, persistencia, gestión de contexto
5. **Evaluación (Evals)** — métricas, golden dataset, LLM-as-judge, safety
6. **Producción y MLOps** — observabilidad, costo, fallbacks, versioning
7. **AI Governance** — audit trail, PII, compliance, responsible AI

### Paso 3 — Entrega del análisis

Para **evaluate / review**: diagnóstico por dimensión con semáforo, recomendaciones priorizadas (🔴/🟡/🟢), ADR si hay decisión clave.

Para **design**: arquitectura propuesta con stack, diagrama de componentes, decisiones y trade-offs, plan de implementación por fases.

Para **decide / compare**: tabla de trade-offs con fuentes, recomendación clara con justificación, ADR completo.

Para **evals**: plan de evaluación por nivel (unit, integration, behavioral, safety), métricas concretas, herramientas recomendadas, golden dataset approach.

---

## Output format

Ver formato completo en `.agents/skills/ai-architect/SKILL.md`.

Estructura de salida según el action:
```
evaluate / review:
  # AI Architecture Review — [Sistema]
  ## Veredicto Ejecutivo (🟢/🟡/🔴)
  ## Análisis por Dimensión (7 áreas)
  ## Recomendaciones (🔴 Crítico / 🟡 Alta / 🟢 Mejora)
  ## ADR si aplica
  ## Una cosa que cambiaría hoy

design:
  # AI Architecture Design — [Nombre]
  ## Problema y restricciones
  ## Arquitectura propuesta (componentes + stack)
  ## Decisiones clave y trade-offs
  ## Plan de implementación (MVP → Producción → Optimización)
  ## Plan de evaluación
  ## Fuentes consultadas

decide / compare:
  # Decisión técnica: [Pregunta]
  ## Fuentes consultadas
  ## Análisis comparativo (tabla de trade-offs)
  ## Recomendación con justificación
  ## ADR completo
```

---

## Anti-patrones que detectar

- God Agent, Infinite Loop Risk, Tool Overload
- RAG sin reranking, Fine-tuning prematuro
- Sin evals en CI/CD, Sin circuit breaker
- PII en prompts sin anonimizar, Sin audit trail
- Prompt engineering sin medición de regresiones

---

## Notes

- Siempre consultar fuentes de autoridad antes de recomendar — citar las fuentes en la respuesta
- Si el tema es un modelo o framework específico, buscar su documentación oficial primero
- Los benchmarks deben ser recientes (preferir fuentes < 12 meses)
- Si hay incertidumbre, decirlo explícitamente — no inventar capacidades o benchmarks
- Guardar análisis importantes como nota del proyecto si se solicita:
  ```powershell
  pwsh -File ".agents/skills/projects/save-notes.ps1" `
    -ProjectCode "CODE" -Type "notes" `
    -Title "AI Architecture Review [fecha]" -Content "[análisis completo]"
  ```
