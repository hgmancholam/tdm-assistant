# automate

Gestiona las automatizaciones periódicas del asistente — registra, lista, prueba y elimina tareas en Windows Task Scheduler.

## Usage

```
/automate <acción> [PROJECT-CODE]
```

## Actions

| Acción | Descripción |
|--------|-------------|
| `list` | Lista todas las tareas registradas en Task Scheduler |
| `register CODE` | Registra las automatizaciones habilitadas de un proyecto |
| `register-all` | Registra todas las automatizaciones (proyectos + globales) |
| `unregister CODE` | Elimina las tareas de Task Scheduler de un proyecto |
| `unregister-all` | Elimina todas las tareas de PersonalAssistant |
| `run CODE task` | Ejecuta una tarea inmediatamente (para pruebas) |
| `status` | Muestra config + estado de todas las automatizaciones |
| `enable CODE task` | Habilita una automatización en project.settings |
| `disable CODE task` | Deshabilita una automatización en project.settings |

## Behavior

### `list`
```powershell
pwsh -File ".agents/skills/scheduler.ps1" -Action list
```

### `register CODE`
```powershell
pwsh -File ".agents/skills/scheduler.ps1" -Action register -ProjectCode "CODE"
```

### `register-all`
```powershell
pwsh -File ".agents/skills/scheduler.ps1" -Action register-all
```

### `unregister CODE`
```powershell
pwsh -File ".agents/skills/scheduler.ps1" -Action unregister -ProjectCode "CODE"
```

### `run CODE task` — Ejecución inmediata (testing)
```powershell
pwsh -File ".agents/skills/scheduler.ps1" -Action run -ProjectCode "CODE" -TaskName "morning-sync"
# Global:
pwsh -File ".agents/skills/scheduler.ps1" -Action run -TaskName "projects-digest" -Scope "global"
```

### `status` — Vista completa de configuración
1. Leer `automations.json` para tareas globales
2. Leer `project.settings` de cada proyecto activo para sus automatizaciones
3. Contrastar con las tareas registradas en Task Scheduler
4. Mostrar tabla completa con estado

### `enable CODE task` / `disable CODE task`
Actualiza el campo `enabled` en `project.settings`:
```powershell
pwsh -File ".agents/skills/projects/update-settings.ps1" `
  -ProjectCode "CODE" -FieldPath "automations[name=task].enabled" -Value "true"
```
Tras el cambio, sugiere re-registrar con `register CODE`.

## Output format

```
# Automatizaciones — PersonalAssistant

## Globales (automations.json)
| Nombre | Tarea | Schedule | Habilitado | En TaskSch |
|--------|-------|----------|------------|------------|
| daily-digest | projects-digest | 0 7 * * 1-5 | ✅ | ✅ |

## Por Proyecto
### ALPHA — Mi Proyecto
| Nombre | Tarea | Schedule | Habilitado | En TaskSch |
|--------|-------|----------|------------|------------|
| morning-sync | morning-sync | 0 8 * * 1-5 | ✅ | ✅ |
| weekly-report | weekly-report | 0 17 * * 5 | ❌ | ❌ |
```

## Flujo recomendado al crear un proyecto nuevo

1. Abrir `projects/CODE/project.settings` y configurar la sección `automations`
2. Cambiar `enabled: true` en las tareas deseadas
3. Ejecutar `/automate register CODE`
4. Verificar con `/automate list`

## Notes

- Task Scheduler requiere permisos de administrador para registrar tareas — ejecutar Claude Code como administrador si falla
- El runner (`runner.ps1`) necesita que `claude` CLI esté en el PATH del sistema, no solo del usuario
- Los nombres de tareas en Task Scheduler siguen el patrón: `PersonalAssistant-CODE-nombre`
- `automations.log` en la raíz del proyecto registra cada ejecución automática
