# email-triage

Lee la bandeja de entrada y genera una tabla de triage priorizada con acciones recomendadas.

## Usage

```
/email-triage [count: 20] [unread-only]
```

## Behavior

1. Ejecutar el script de Outlook para obtener emails recientes:
   ```powershell
   pwsh -File ".agents/skills/outlook/get-inbox.ps1" -Count 30
   # Si solo no leídos: -UnreadOnly
   ```
2. Analizar cada email y clasificarlo por urgencia:
   - **🔴 Acción inmediata** — requiere respuesta hoy (cliente, escalación, deadline)
   - **🟡 Acción esta semana** — requiere respuesta pero no urgente
   - **🔵 FYI / Info** — solo informativo, no requiere acción
   - **⚪ Puede archivar** — newsletters, notificaciones automáticas, ya resuelto
3. Para emails que requieren acción: sugerir el borrador de respuesta
4. Presentar tabla ordenada por urgencia

## Output format

```
# Email Triage — [fecha]
**Bandeja revisada:** X emails  |  **No leídos:** X

## 🔴 Acción Inmediata
| De | Asunto | Recibido | Acción sugerida |
|----|--------|----------|----------------|
| ...| ...    | ...      | Responder: "..." |

## 🟡 Acción Esta Semana
| De | Asunto | Recibido | Acción sugerida |
|----|--------|----------|----------------|

## 🔵 Solo Informativo
| De | Asunto | Recibido |
|----|--------|----------|

## ⚪ Archivar / Ignorar
- X emails de newsletters/notificaciones automáticas

## Resumen
- Total revisados: X
- Requieren acción: X
- Tiempo estimado para responder todo: ~X min
```

## Notes

- Usar `pwsh` (PowerShell 7) — el script está en `skills/outlook/get-inbox.ps1`
- Outlook Desktop debe estar abierto y autenticado
- Clasificar según contexto de Harol: TDM/PM en Inspyr — priorizar clientes, gestión, escalaciones
- Si un email requiere respuesta, incluir borrador sugerido al pie

