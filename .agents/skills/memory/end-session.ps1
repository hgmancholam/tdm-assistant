# end-session.ps1
# Invocado automaticamente por el Stop hook de Claude Code al cerrar la sesion.
# Guarda un snapshot de estado (prioridades, recordatorios, timestamp) en last-session.md.

$root    = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$memPy   = Join-Path $root ".agents\skills\memory\memory.py"
$ts      = Get-Date -Format "yyyy-MM-dd HH:mm"
$weekday = (Get-Date).ToString("dddd")

# --- Prioridades activas ---
try {
    $priRaw = python $memPy --op read --type priorities 2>$null | ConvertFrom-Json
    $items  = $priRaw.items
    if ($items -and $items.Count -gt 0) {
        $priorityLines = ($items | ForEach-Object { "  $($_.rank). $($_.text)" }) -join "`n"
    } else {
        $priorityLines = "  (ninguna configurada)"
    }
} catch {
    $priorityLines = "  (error al leer priorities.json)"
}

# --- Recordatorios pendientes ---
try {
    $remRaw  = python $memPy --op read --type reminders 2>$null | ConvertFrom-Json
    $pending = @($remRaw.reminders | Where-Object { $_.status -eq "pending" })
    $remCount = $pending.Count
    if ($remCount -gt 0) {
        $remLines = ($pending | ForEach-Object { "  - $($_.text) (vence: $($_.dueDate))" }) -join "`n"
    } else {
        $remLines = "  (ninguno pendiente)"
    }
} catch {
    $remCount = "?"
    $remLines = "  (error al leer reminders.json)"
}

# --- Proyectos activos ---
try {
    $projDir   = Join-Path $root "projects"
    $projCodes = Get-ChildItem $projDir -Directory |
                 Where-Object { $_.Name -ne "_template" } |
                 ForEach-Object { $_.Name }
    $projList  = if ($projCodes) { ($projCodes | ForEach-Object { "  - $_" }) -join "`n" } else { "  (ninguno)" }
} catch {
    $projList = "  (error al listar proyectos)"
}

# --- Construir entrada ---
$entry = @"
---
## Cierre automatico de sesion — $ts ($weekday)

**Prioridades al cerrar:**
$priorityLines

**Recordatorios pendientes ($remCount):**
$remLines

**Proyectos en el repo:**
$projList

> Nota: si trabajaste en algo importante, guarda el resumen antes de la proxima sesion ejecutando:
> python .agents/skills/memory/memory.py --op write --type session --content "..."
---
"@

python $memPy --op append --type session --entry $entry
