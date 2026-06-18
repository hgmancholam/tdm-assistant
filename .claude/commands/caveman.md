# caveman

Activa modo de comunicación ultra-comprimido para reducir consumo de tokens ~65%. Aplica para todas las respuestas del asistente durante la sesión. Las comunicaciones profesionales (emails, reportes, updates de stakeholders) siempre usan prosa completa — independiente del modo activo.

## Usage

```
/caveman [lite|full|ultra|off]
```

## Examples

```
/caveman           → activa modo full (default)
/caveman lite      → comprimido pero legible, sin fragmentos
/caveman ultra     → máxima compresión
/caveman off       → vuelve a modo normal
```

## Behavior

Leer y aplicar el skill completo definido en `.agents/skills/caveman/SKILL.md`.

El modo persiste para el resto de la sesión hasta que el usuario diga "stop caveman", "normal mode", o invoque `/caveman off`.

### Excepción obligatoria — siempre prosa profesional completa para:

- Borradores de email (cualquier comando `/email-send`, `/email-reply`, `/quick-draft` con destino email)
- Updates de stakeholders (`/stakeholder-update`)
- Status reports (`/status-report`)
- Contenido exportable a clientes o terceros

Fuera de esas excepciones, aplicar caveman a todas las respuestas del asistente.

## Notes

- Skill en: `.agents/skills/caveman/SKILL.md`
- No afecta el contenido técnico — solo el estilo de prosa del asistente
- Código, comandos, nombres de API, error strings: siempre exactos sin abreviar
