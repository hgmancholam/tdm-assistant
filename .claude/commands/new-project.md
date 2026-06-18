# new-project

Crea la estructura completa de un nuevo proyecto en la carpeta projects/.

## Usage

```
/new-project <nombre o descripción del proyecto>
```

## Behavior

1. Recopilar la información necesaria preguntando al usuario:
   - Nombre completo del proyecto y código corto (ej: `ALPHA`, `CLIENT-CRM`)
   - Cliente / organización
   - Tipo: `implementation` | `consulting` | `support` | `maintenance` | `internal`
   - Fase actual: `discovery` | `design` | `build` | `test` | `deploy` | `support`
   - Fecha inicio y fecha objetivo de fin
   - Proyecto ADO (org, project, área)
   - Integrantes del equipo (nombre, rol, email, organización)
   - Stakeholders (nombre, rol, email, nivel: executive/manager/operational)
   - Canal de Teams (si existe)
   - Modelo de billing: `T&M` | `fixed-price` | `retainer`
   - Cadencia de standup y status report

2. Crear la estructura de carpetas:
   ```
   projects/<CODE>/
     project.settings    ← configuración completa
     logs/               ← actividad diaria (auto-generados)
     meetings/           ← notas de reuniones
     decisions/          ← registro de decisiones
     risks/              ← registro de riesgos
     reports/            ← status reports generados
     retrospectives/     ← retros del proyecto
   ```

3. Generar `project.settings` con todos los datos recopilados

4. Registrar la actividad inicial:
   ```powershell
   pwsh -File ".agents/skills/projects/log-activity.ps1" `
     -ProjectCode "CODE" `
     -Entry "Proyecto creado. Fase: [fase]. Cliente: [cliente]." `
     -Category "general"
   ```

5. Confirmar creación con resumen del proyecto

## Output format

```
✅ Proyecto creado: [NOMBRE] ([CODE])

📁 projects/[CODE]/
   ├── project.settings
   ├── logs/
   ├── meetings/
   ├── decisions/
   ├── risks/
   ├── reports/
   └── retrospectives/

👥 Equipo: X miembros
📋 ADO: [org]/[project]
📅 Timeline: [inicio] → [fin estimado]

Usa /project-agent [CODE] para empezar a trabajar con este proyecto.
```

## Notes

- El CODE debe ser corto, sin espacios, en mayúsculas (ej: ALPHA, CRM2026, INFRA-Q3)
- Copiar el template desde `projects/_template/project.settings`
- Crear todas las subcarpetas aunque estén vacías
- Siempre pedir confirmación antes de crear si ya existe un proyecto con ese CODE

