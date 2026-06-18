---
name: skill-builder
description: Meta-skill que crea nuevas capacidades bajo demanda. Analiza lo que el usuario necesita, escribe los scripts (PowerShell o Python) y los archivos de comando siguiendo exactamente las convenciones del proyecto, actualiza los registros y ejecuta una prueba. El asistente evoluciona naturalmente con cada nuevo skill creado.
---

# Skill Builder

Eres el motor de auto-evolución del sistema. Cuando el usuario necesita una capacidad que no existe, la creas. Cuando una capacidad existente no es suficiente, la amplías. El sistema nunca dice "eso no puedo hacerlo" — lo aprende.

---

## Cuándo usar este skill

- "necesito un script que haga X"
- "crea un skill para Y"
- "quiero poder pedirle al asistente que haga Z"
- "agrega la capacidad de W al sistema"
- "el comando X no soporta Y, agrégalo"
- "necesito un nuevo tipo de reporte"
- "automatiza este proceso que hago manualmente"

---

## PASO 1 — Entender la necesidad

Antes de escribir una sola línea de código, hacer las preguntas mínimas necesarias:

1. **¿Qué hace esto exactamente?** — Describir en una oración
2. **¿Qué datos de entrada necesita?** — ¿Qué le das? (proyecto, fechas, texto, etc.)
3. **¿Qué produce como salida?** — ¿Qué esperas recibir? (JSON, archivo, email, etc.)
4. **¿Con qué frecuencia se usa?** — ¿Una vez? ¿Periódicamente? ¿En cada briefing?
5. **¿Hay algo parecido ya?** — Verificar contra el catálogo de skills existentes

Si el usuario dio suficiente contexto, no hacer más preguntas — proceder directamente.

---

## PASO 2 — Verificar catálogo existente

Leer `CLAUDE.md` para obtener el catálogo completo de skills y comandos.

Verificar:
- ¿Existe algo igual o muy parecido?
- ¿Es una extensión de algo que ya existe?
- ¿Hay algún script que pueda reutilizarse?

Si ya existe → explicarlo al usuario y preguntar si quiere extender lo existente en lugar de crear algo nuevo.

---

## PASO 3 — Decidir la arquitectura

### ¿Qué tipo de skill crear?

| Caso | Tecnología | Dónde |
|------|-----------|-------|
| Automatización de Outlook (email, calendario, contactos) | PowerShell + COM | `.agents/skills/outlook/` |
| Lectura/escritura de archivos del proyecto | PowerShell | `.agents/skills/projects/` |
| Análisis de datos, gráficas, reportes Excel/PDF | Python | `.agents/skills/analytics/` |
| Llamadas a la API de Anthropic | Python | `.agents/skills/analytics/runner_api.py` |
| Nuevo skill de orquestación / comando complejo | SKILL.md + comando | `.agents/skills/<nombre>/` + `.claude/commands/` |
| Integración con una API externa | PowerShell o Python | `.agents/skills/<nombre>/` |
| Extensión de un comando existente | Editar el .md existente | `.claude/commands/` |

### ¿Necesita un comando de Claude Code?

- **Sí** → también crear `.claude/commands/<nombre>.md`
- **No** → solo el script; el agente lo invoca internamente

---

## PASO 4 — Escribir el skill

### Convenciones PowerShell (obligatorias)

```powershell
# Siempre:
# - param() al inicio con tipos y valores default
# - try/catch completo
# - Output siempre como JSON (@{...} | ConvertTo-Json)
# - Incluir "success": true/false en toda respuesta
# - Comentario de una línea describiendo el script al inicio

param(
    [Parameter(Mandatory=$true)]
    [string]$RequiredParam,

    [string]$OptionalParam = "default"
)

try {
    # ... lógica ...
    @{
        success = $true
        result  = "valor"
    } | ConvertTo-Json
}
catch {
    @{
        success = $false
        error   = $_.Exception.Message
    } | ConvertTo-Json
}
```

### Convenciones Python (obligatorias)

```python
"""
nombre_script.py — Una línea describiendo qué hace.

Input (stdin JSON o argumentos):
  { "campo": "valor" }

Output: JSON a stdout
"""

import sys, json, argparse
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--param", required=True)
    args = parser.parse_args()

    raw  = sys.stdin.read().strip()
    data = json.loads(raw) if raw else {}

    try:
        # ... lógica ...
        print(json.dumps({"success": True, "result": "valor"}, indent=2))
    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}, indent=2))
        sys.exit(1)


if __name__ == "__main__":
    main()
```

### Convenciones para archivos de comando (.md)

```markdown
# nombre-comando

[Una línea describiendo qué hace]

## Usage
\`\`\`
/nombre-comando [parámetros]
\`\`\`

## Examples
\`\`\`
/nombre-comando ejemplo 1
/nombre-comando ejemplo 2
\`\`\`

## Behavior

### Paso 1 — [título]
[descripción]

\`\`\`powershell o python
[comando a ejecutar]
\`\`\`

### Paso 2 — [título]
[descripción]

## Output format
\`\`\`
[ejemplo del output que se muestra al usuario]
\`\`\`

## Notes
- [notas importantes]
```

---

## PASO 5 — Registrar el nuevo skill

### Actualizar `CLAUDE.md`

Añadir el nuevo comando a la tabla correspondiente en la sección "Slash Commands".

Si es un skill sin comando visible, añadirlo en la sección de "Agent Design Principles".

### Actualizar `.claude/settings.json` (si aplica)

Si el nuevo script de PowerShell está en una carpeta nueva:

```json
{
  "permissions": {
    "allow": [
      "Bash(pwsh -File .agents/skills/nueva-carpeta/*.ps1)"
    ]
  }
}
```

Si está en una carpeta ya cubierta por un wildcard existente (outlook/, projects/), no es necesario actualizar.

Si es Python:
```json
"Bash(python .agents/skills/analytics/*.py)"
```

### Registrar en el skill registry

Añadir entrada al final de `skill-registry.json`:
```json
{
  "name": "nombre-skill",
  "type": "powershell|python|command",
  "path": ".agents/skills/.../script.ps1",
  "command": "/nombre-comando o null",
  "description": "qué hace en una línea",
  "createdDate": "YYYY-MM-DD",
  "createdBy": "skill-builder"
}
```

---

## PASO 6 — Probar el skill

Siempre intentar una ejecución de prueba antes de declarar el skill como completo.

### Para scripts PowerShell:
```powershell
pwsh -File ".agents/skills/[carpeta]/[script].ps1" -Param "valor_de_prueba"
```

### Para scripts Python:
```
python .agents/skills/analytics/[script].py --param "valor_de_prueba"
```

Analizar el output JSON:
- ¿`success: true`?
- ¿Los campos esperados están en la respuesta?
- ¿El manejo de errores funciona?

Si hay errores, corregirlos antes de continuar.

---

## PASO 7 — Confirmar y documentar

Al terminar, mostrar al usuario:

```
✅ **Skill creado: [nombre]**

**Qué hace:** [descripción una línea]
**Archivos creados:**
- [ruta archivo 1]
- [ruta archivo 2]

**Cómo usarlo:**
[comando o instrucción]

**Prueba ejecutada:** [resultado de la prueba]

**Registrado en:** CLAUDE.md, skill-registry.json[, settings.json si aplica]
```

---

## Casos especiales

### Extender un skill existente

1. Leer el archivo existente
2. Identificar qué añadir sin romper lo que ya funciona
3. Editar con mínimo cambio necesario (no refactorizar innecesariamente)
4. Re-probar el caso original + el nuevo caso
5. Actualizar CLAUDE.md si cambió la interfaz

### Skill que reemplaza un proceso manual

Cuando el usuario describe algo que hace manualmente:
1. Preguntar: "¿Cuánto tiempo te toma hacerlo manualmente?"
2. Describir qué va a automatizarse exactamente antes de crear
3. Crear el script más robusto posible (manejo de errores, edge cases)
4. Si es recurrente, preguntar si quiere programarlo con `/automate`

### Skill que integra una nueva fuente de datos

Si el skill necesita acceder a algo nuevo (una API, un sistema, un archivo):
1. Verificar que las credenciales/permisos existen antes de escribir el código
2. Crear el script con fallback graceful si la fuente no está disponible
3. Documentar en `docs/` si requiere configuración especial

### Skill que genera un tipo de reporte nuevo

1. Preguntar: ¿dónde se guarda? ¿qué formato? ¿se envía por email?
2. Seguir la convención: guardar en `projects/CODE/reports/` con fecha en el nombre
3. Si genera un archivo visual (PNG, Excel), también imprimir la ruta como JSON

---

## Límites de este skill

Este skill puede crear:
- Scripts de automatización (PS, Python)
- Comandos de Claude Code (.md)
- Integraciones con APIs externas (si las credenciales existen)
- Reportes y visualizaciones
- Nuevos flujos de orquestación

Este skill NO debería:
- Crear código que acceda a sistemas sin autorización del usuario
- Modificar datos en producción sin confirmación explícita
- Instalar paquetes del sistema sin advertir al usuario
- Crear scripts que eliminen datos sin confirmación

---

## Reglas de calidad

1. **El skill que creas tiene que funcionar en la primera prueba** — tómate el tiempo para hacerlo bien
2. **Sigue las convenciones exactas** — no inventes nuevos patrones
3. **El output siempre es JSON** — facilita el parsing por el agente
4. **Los errores son visibles** — todo try/catch expone el mensaje real
5. **No duplicas lo que existe** — verifica el catálogo antes de crear
6. **El usuario debe poder usarlo el día que lo creas** — no dejes pasos de setup sin documentar
