# email-move

Mueve un email a una carpeta de Outlook.

## Usage

```
/email-move <descripción del email> <carpeta destino>
```

## Examples

```
/email-move el email de Sarah sobre el presupuesto → carpeta "ALPHA"
/email-move newsletters recientes → carpeta "Newsletters"
/email-move el reporte de John → carpeta "Reports"
```

## Behavior

1. Buscar el email si no se tiene el EntryID:
   ```powershell
   pwsh -File ".agents/skills/outlook/search-emails.ps1" -Query "<término>" -Count 5
   ```
2. Confirmar cuál es el email correcto si hay varios candidatos
3. Ejecutar el movimiento:
   ```powershell
   pwsh -File ".agents/skills/outlook/move-email.ps1" -EntryID "<id>" -FolderName "<carpeta>"
   ```
4. Si la carpeta no existe, informar las carpetas disponibles y pedir que elija

## Output format

```
✅ Email movido
De: [remitente]
Asunto: [asunto]
Carpeta destino: [nombre]
```

```
❌ Carpeta no encontrada
Carpetas disponibles en Inbox: [lista]
```

## Notes

- Solo mueve dentro de subcarpetas del Inbox — no a carpetas raíz de Outlook
- Outlook Desktop debe estar abierto

