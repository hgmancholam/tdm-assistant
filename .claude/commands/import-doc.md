# import-doc

Importa un documento a un proyecto: extrae el contenido sin IA, lo convierte a Markdown estructurado y lo categoriza dentro de la carpeta del proyecto.

## Usage

```
/import-doc CODE --file "ruta/al/documento"
/import-doc CODE --file "ruta/al/documento" --category meetings
/import-doc CODE --file "ruta/al/documento" --title "Título personalizado"
/import-doc list CODE
```

## Formatos soportados

| Formato | Extensión | Notas |
|---------|-----------|-------|
| PDF | .pdf | Extrae texto y tablas. PDFs escaneados (imágenes) no tienen texto extraíble — el script lo indica |
| Word | .docx | Extrae texto, headings y tablas. `.doc` antiguo no soportado |
| Excel | .xlsx | Extrae todas las hojas como tablas Markdown |
| PowerPoint | .pptx | Extrae texto de cada slide + notas. `.ppt` antiguo no soportado |
| CSV | .csv | Convierte a tabla Markdown |
| Texto | .txt, .md | Importa como está |

## Categorías disponibles

| Categoría | Carpeta en el proyecto | Keywords que activan auto-detección |
|-----------|------------------------|-------------------------------------|
| `meetings` | `projects/CODE/meetings/` | meeting, minutes, agenda, standup, sync, kickoff, call, weekly, daily |
| `decisions` | `projects/CODE/decisions/` | decision, adr, approved, resolution, record |
| `risks` | `projects/CODE/risks/` | risk, issue, blocker, impediment, mitigation |
| `retrospectives` | `projects/CODE/retrospectives/` | retro, retrospective, lessons, postmortem |
| `reports` | `projects/CODE/reports/` | report, status, summary, update, dashboard (default) |

## Behavior

### Paso 1 — Verificar proyecto

Si el proyecto CODE no existe en `projects/`:
```
El proyecto CODE no existe. Créalo primero con /new-project.
```

### Paso 2 — Importar y convertir el documento

```python
python .agents/skills/projects/doc-import.py import \
  --file "[ruta]" \
  --project "CODE" \
  --category "[auto o categoría específica]" \
  --title "[si el usuario especificó un título]"
```

El script extrae todo el contenido estructuralmente **sin usar IA**.  
La IA solo debe invocarse si el resultado indica `"scanned_pdf": true` — en ese caso, ofrecer al usuario procesar el contenido con AI como segundo paso.

### Paso 3 — Reportar resultado

Si `success: true`:
```
✅ Documento importado

📄 [title]
   Fuente:     [nombre del archivo original]
   Categoría:  [meetings|decisions|risks|reports|retrospectives]
   Guardado:   projects/CODE/[categoría]/YYYY-MM-DD-[slug].md
   Formato:    [pdf|docx|xlsx|pptx|csv]
```

Si `scanned_pdf: true`:
```
⚠️  El PDF no tiene texto extraíble (parece ser escaneado o basado en imágenes).
¿Quieres que intente extraer el contenido con IA?
```

Si `success: false`:
```
❌ Error al importar: [mensaje del error]
[instrucción de corrección si aplica]
```

### Paso 4 — Registrar en el log del proyecto

```python
python .agents/skills/memory/memory.py --op append --type log \
  --project CODE \
  --entry "Documento importado: [title] → [categoría]/[archivo].md (fuente: [nombre original])"
```

### Si el usuario no proporciona archivo

Preguntar:
```
¿Qué archivo quieres importar al proyecto [CODE]?
Proporciona la ruta completa al documento.

Formatos soportados: PDF, Word (.docx), Excel (.xlsx), PowerPoint (.pptx), CSV, texto
```

### Listar documentos importados

Si el usuario dice "listar docs de CODE" o "qué documentos tiene CODE":

```python
python .agents/skills/projects/doc-import.py list --project CODE
```

Mostrar organizado por categoría:
```
📁 Documentos importados — [CODE]

📅 meetings (N)
   • YYYY-MM-DD-archivo.md

📊 reports (N)
   • YYYY-MM-DD-archivo.md

[categorías sin documentos se omiten]
```

## Notes

- El archivo original **no se mueve ni se elimina** — solo se crea el Markdown en el proyecto
- Los nombres de archivo de salida siguen el patrón `YYYY-MM-DD-[slug].md`
- Si ya existe un archivo con el mismo nombre, se añade un sufijo numérico (`-1`, `-2`, etc.)
- Para Excel con muchas hojas, todas se incluyen. El usuario puede editar el Markdown para eliminar hojas irrelevantes
- Word con imágenes: solo se extrae texto; las imágenes no se incluyen
- El contenido extraído es íntegro — no se filtra ni resume automáticamente. Si el usuario necesita un resumen, pedirlo como segundo paso
