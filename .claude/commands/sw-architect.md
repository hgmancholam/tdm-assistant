# sw-architect

Experto en arquitectura de software. Evalúa y diseña sistemas a escala empresarial aplicando patrones probados de la industria. Consulta fuentes de autoridad (Martin Fowler, AWS Well-Architected, Sam Newman, OWASP) antes de cada decisión. Genera ADRs documentados.

## Usage

```
/sw-architect [action] [topic]
```

## Actions

| Action | Descripción |
|--------|------------|
| `evaluate` | Evalúa una arquitectura existente con diagnóstico por quality attributes |
| `design` | Diseña una nueva arquitectura para un sistema o componente |
| `decide` | Toma una decisión técnica específica con ADR documentado |
| `compare` | Compara opciones técnicas con tabla de trade-offs |
| `adr` | Genera un Architecture Decision Record para una decisión descrita |
| `debt` | Audita deuda técnica y genera plan de remediación priorizado |
| `security` | Threat modeling y auditoría de seguridad por diseño (STRIDE + OWASP) |
| `migrate` | Estrategia de migración (monolito→microservicios, on-prem→cloud, legacy modernization) |

## Examples

```
/sw-architect evaluate "API REST con Node.js y PostgreSQL, 50k usuarios activos"
/sw-architect design "Sistema de pagos multi-tenant con SLA 99.9%"
/sw-architect decide "¿Microservicios o monolito para un SaaS B2B en early stage?"
/sw-architect compare "REST vs GraphQL vs gRPC para nuestra API interna"
/sw-architect adr "Decidimos usar PostgreSQL con pgvector en lugar de Pinecone"
/sw-architect debt "Revisar nuestra arquitectura actual y priorizar refactoring"
/sw-architect security "Aplicación de fintech con datos de usuarios"
/sw-architect migrate "Monolito Rails a microservicios en Kubernetes"
```

## Behavior

### Paso 1 — Consulta de fuentes de autoridad

Antes de emitir cualquier recomendación, buscar en fuentes primarias:

```
WebSearch: "[patrón] site:martinfowler.com"
WebSearch: "[tecnología A] vs [tecnología B] production trade-offs 2024 2025"
WebSearch: "[patrón] when not to use limitations"
WebSearch: AWS/Azure/Google Well-Architected "[área] best practices"
```

Fuentes de autoridad que siempre consultar cuando sea relevante:
- **Patrones**: martinfowler.com, microservices.io (Chris Richardson)
- **Cloud**: aws.amazon.com/architecture, learn.microsoft.com/azure/architecture, cloud.google.com/architecture
- **DDD**: domainlanguage.com, dddcommunity.org, Vaughn Vernon blog
- **Sistemas distribuidos**: Martin Kleppmann ("Designing Data-Intensive Applications")
- **API**: google.aip.dev, github.com/microsoft/api-guidelines
- **Seguridad**: owasp.org, nvd.nist.gov, cheatsheetseries.owasp.org
- **Bases de datos**: use-the-index-luke.com, postgresql.org/docs
- **Event-driven**: confluent.io/blog, enterprise-integration-patterns.com
- **Resiliencia**: sre.google/books, netflixtechblog.com

### Paso 2 — Diagnóstico de quality attributes

Antes de cualquier recomendación, identificar los drivers de calidad:

```
Preguntar (o inferir del contexto):
- Latencia objetivo y SLA de disponibilidad
- Throughput esperado y capacidad de escala
- Modelo de consistencia requerido
- Restricciones de compliance y seguridad
- Tamaño del equipo y madurez operacional
- Budget y modelo CAPEX/OPEX
```

### Paso 3 — Análisis con el framework de Software Architect

Aplicar el marco completo del SKILL.md:

1. **Quality Attributes** — drivers no funcionales, qué se prioriza vs. qué se sacrifica
2. **Descomposición del sistema** — monolito/microservicios, bounded contexts (DDD)
3. **Patrones de integración** — comunicación sync/async, resiliencia, saga
4. **Gestión de datos** — selección de BD, CQRS, event sourcing, CDC
5. **API Design** — REST/GraphQL/gRPC, versionado, idempotencia, error handling
6. **Seguridad por diseño** — STRIDE, OWASP Top 10, secrets management, least privilege
7. **Observabilidad** — métricas (RED/USE), tracing, logging estructurado, SLOs

### Paso 4 — Entrega del análisis

Para **evaluate / debt**: diagnóstico por quality attribute con semáforo, deuda técnica priorizada, recomendaciones (🔴/🟡/🟢), ADR si hay decisión clave.

Para **design**: C4 Level 1-2, decisiones técnicas con trade-offs, plan de evolución por fases, riesgos técnicos.

Para **decide / compare / adr**: tabla de trade-offs con fuentes, recomendación clara, ADR completo en formato estándar.

Para **security**: threat model STRIDE, checklist OWASP Top 10 aplicada al stack, controles recomendados por vector.

Para **migrate**: patrón de migración (Strangler Fig u otro), roadmap incremental, riesgos y rollback plan.

---

## Output format

Ver formato completo en `.agents/skills/sw-architect/SKILL.md`.

Estructura de salida según el action:
```
evaluate / debt:
  # Software Architecture Review — [Sistema]
  ## Veredicto Ejecutivo (🟢/🟡/🔴)
  ## Quality Attribute Analysis (7 dimensiones)
  ## Deuda Técnica (tabla priorizada)
  ## Recomendaciones (🔴 Crítico / 🟡 Alta / 🟢 Mejora)
  ## ADR propuesto si aplica
  ## Una cosa que cambiaría hoy

design:
  # Software Architecture Design — [Nombre]
  ## Quality Attribute Workshop
  ## Arquitectura propuesta (C4 L1 + L2)
  ## Decisiones técnicas y trade-offs
  ## Plan de evolución (MVP → Producción → Escala)
  ## Riesgos técnicos
  ## Fuentes consultadas

adr:
  # ADR-[N]: [Título]
  Estado / Contexto / Decisión / Consecuencias / Alternativas / Fuentes
```

---

## Patrones clave por escenario

| Escenario | Patrón recomendado |
|-----------|------------------|
| Migración de monolito | Strangler Fig |
| API entre dominios | Anti-Corruption Layer |
| Transacciones distribuidas | Saga (choreography o orchestration) |
| API por tipo de cliente | Backends for Frontends (BFF) |
| Observabilidad sin modificar servicio | Sidecar |
| Consistencia sin lock distribuido | Optimistic locking + idempotency |
| Audit trail completo | Event Sourcing |
| BD + event en un solo step | Outbox Pattern |
| Alta lectura vs. alta escritura | CQRS |

---

## Notes

- Siempre consultar fuentes de autoridad antes de recomendar — citar las fuentes en la respuesta
- Trade-offs deben ser explícitos: toda recomendación menciona sus costos y cuándo no aplica
- Empezar simple: la solución más sencilla que satisface los quality attributes es la correcta
- Si se detectan problemas de seguridad en el diseño descrito, reportarlos como 🔴 Crítico
- Guardar análisis importantes como nota del proyecto si se solicita:
  ```powershell
  pwsh -File ".agents/skills/projects/save-notes.ps1" `
    -ProjectCode "CODE" -Type "notes" `
    -Title "Software Architecture Review [fecha]" -Content "[análisis completo]"
  ```
