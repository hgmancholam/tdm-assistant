# Outlook COM Automation — Guía de Setup

Integración de Outlook email, calendario y contactos con Claude Code vía **Windows COM Automation**.

**No requiere:** Azure app registration, OAuth, cuentas adicionales, ni permisos de IT.
**Requiere:** Outlook Desktop instalado y abierto con tu sesión activa.

---

## Cómo funciona

```
Claude Code → PowerShell → Outlook COM Object → tu buzón de Exchange
```

Outlook Desktop expone una API local (COM) que permite leer, enviar y organizar emails, revisar el calendario y gestionar contactos usando tu sesión ya autenticada.

---

## Prerequisitos

- Windows 10/11
- Microsoft Outlook Desktop instalado (parte de Microsoft 365)
- PowerShell 7+ (`pwsh`) instalado
- Outlook abierto y con tu cuenta activa al momento de usar los comandos

### Verificar PowerShell 7

```powershell
pwsh --version
# Debe mostrar: PowerShell 7.x.x
```

Si no está instalado:
```powershell
winget install Microsoft.PowerShell
```

---

## Scripts disponibles

Todos los scripts están en `.agents/skills/outlook/` y aceptan parámetros. Todos devuelven JSON.

| Script | Parámetros principales | Qué hace |
|--------|----------------------|----------|
| `get-inbox.ps1` | `-Count 20`, `-UnreadOnly` | Lista emails del inbox |
| `search-emails.ps1` | `-Query`, `-From`, `-Subject`, `-Count`, `-DaysBack` | Busca emails |
| `read-email.ps1` | `-EntryID` (obligatorio) | Lee el cuerpo completo de un email |
| `send-email.ps1` | `-To`, `-Subject`, `-Body`, `-CC`, `-BCC` | Envía un email |
| `reply-email.ps1` | `-EntryID`, `-Body`, `-ReplyAll` | Responde a un email |
| `move-email.ps1` | `-EntryID`, `-FolderName` | Mueve un email a una carpeta |
| `get-calendar.ps1` | `-Days 7`, `-StartDate` | Lista eventos del calendario |
| `get-contacts.ps1` | `-Query`, `-Company`, `-Count` | Busca contactos |
| `create-contact.ps1` | `-FirstName`, `-Email`, `-Company`, etc. | Crea o actualiza un contacto |

---

## Prueba rápida

Para verificar que todo funciona, ejecuta desde la raíz del proyecto:

```powershell
# Ver los últimos 5 emails
pwsh -File ".agents/skills/outlook/get-inbox.ps1" -Count 5

# Ver reuniones de hoy
pwsh -File ".agents/skills/outlook/get-calendar.ps1" -Days 1

# Buscar un contacto
pwsh -File ".agents/skills/outlook/get-contacts.ps1" -Query "John"
```

Si Outlook está abierto y autenticado, verás JSON con los resultados.

---

## Comandos slash en Claude Code

| Comando | Acción |
|---------|--------|
| `/email-triage` | Revisa inbox y clasifica por urgencia |
| `/email-search <término>` | Busca emails |
| `/email-send <descripción>` | Redacta y envía un email |
| `/email-reply <descripción>` | Busca y responde un email |
| `/email-move <email> <carpeta>` | Mueve un email a una carpeta |
| `/agenda [today\|week]` | Briefing del día/semana con prep de reuniones |
| `/contacts <búsqueda>` | Busca o gestiona contactos |

---

## Permisos en Claude Code

El archivo `.claude/settings.json` ya incluye los permisos necesarios para que Claude pueda ejecutar los scripts sin prompts adicionales:

```json
{
  "permissions": {
    "allow": [
      "Bash(pwsh -File .agents/skills/outlook/*.ps1)",
      "Bash(pwsh -File .agents/skills/projects/*.ps1)"
    ]
  }
}
```

---

## Solución de problemas

### Error: "Unable to cast COM object"
Outlook no está abierto. Abre Outlook Desktop e intenta de nuevo.

### Error: "Access denied" o "Operation not permitted"
Ejecuta PowerShell como el mismo usuario con el que está abierto Outlook (no como administrador).

### El script devuelve JSON vacío `[]`
Normal si el inbox está vacío o no hay eventos en el rango especificado. Intenta aumentar `-Count` o `-DaysBack`.

### EntryID no encontrado
Los EntryIDs de Outlook son específicos de la sesión. Si Outlook se reinició, vuelve a buscar el email para obtener un EntryID fresco.

---

## Limitaciones conocidas

| Limitación | Detalles |
|------------|---------|
| Requiere Outlook abierto | El proceso de Outlook debe estar activo en Windows |
| Solo buzón principal | No accede a buzones compartidos o delegados sin configuración adicional |
| Adjuntos | Los adjuntos se pueden listar pero no leer el contenido directamente desde los scripts actuales |
| Carpetas | `move-email.ps1` solo mueve dentro de subcarpetas del Inbox |

---

## Referencias

- [Outlook Object Model Reference](https://learn.microsoft.com/en-us/office/vba/api/overview/outlook/object-model)
- [PowerShell COM Automation](https://learn.microsoft.com/en-us/powershell/scripting/samples/working-with-objects)

