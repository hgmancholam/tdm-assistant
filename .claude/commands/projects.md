# projects

Lista y consulta el estado de todos los proyectos registrados.

## Usage

```
/projects [status: active | on-hold | closed | all]
```

## Examples

```
/projects
/projects active
/projects on-hold
```

## Behavior

1. Listar todos los proyectos desde la carpeta `projects/`:
   ```powershell
   # Todos los proyectos
   pwsh -File ".agents/skills/projects/list-projects.ps1"

   # Filtrado por estado
   pwsh -File ".agents/skills/projects/list-projects.ps1" -Status "active"
   ```
2. Mostrar tabla con estado, cliente, fecha fin y ADO project
3. Ofrecer acceso rápido: escribir el CODE de un proyecto para ver su snapshot

## Output format

```
# Proyectos — [fecha]

## Activos (X)
| CODE | Nombre | Cliente | Fase | ADO Project | Fin Estimado | Último Update |
|------|--------|---------|------|-------------|--------------|---------------|
| ...  | ...    | ...     | ...  | ...         | ...          | ...           |

## En Pausa (X)
| ... |

## Cerrados (X)
| ... |

---
Escribe el CODE de un proyecto para ver su estado detallado con /project-agent CODE status-snapshot
```

## Notes

- Default muestra solo proyectos `active`
- Para ver todos los estados: `/projects all`
- Para crear un proyecto nuevo: `/new-project`
- Para gestionar un proyecto: `/project-agent <CODE> <tarea>`

