# email-search

Busca emails en Outlook por remitente, asunto o palabras clave.

## Usage

```
/email-search <término de búsqueda>
```

## Examples

```
/email-search emails de Sarah de esta semana
/email-search asunto: "budget review"
/email-search todo lo de John sobre el proyecto Alpha
/email-search emails no leídos de clientes
```

## Behavior

1. Interpretar el término de búsqueda y mapear a parámetros del script:
   ```powershell
   # Por remitente
   pwsh -File ".agents/skills/outlook/search-emails.ps1" -From "sarah" -Count 10

   # Por asunto
   pwsh -File ".agents/skills/outlook/search-emails.ps1" -Subject "budget review" -Count 10

   # Búsqueda general
   pwsh -File ".agents/skills/outlook/search-emails.ps1" -Query "Alpha" -Count 15 -DaysBack 30
   ```
2. Mostrar resultados en tabla clara
3. Ofrecer leer el contenido completo de cualquier resultado con su número de lista

## Output format

```
# Resultados: "[búsqueda]"
**Encontrados:** X emails en los últimos 30 días

| # | De | Asunto | Fecha | Estado |
|---|----|--------|-------|--------|
| 1 | .. | ...    | ...   | No leído |
| 2 | .. | ...    | ...   | Leído    |

¿Quieres leer alguno? Escribe el número.
```

## Notes

- Default: últimos 30 días, máx 15 resultados
- Para ampliar el rango: mencionar "últimos 60 días" o "este año"
- Outlook Desktop debe estar abierto

