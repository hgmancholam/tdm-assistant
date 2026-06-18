# runner.ps1 — Ejecuta una tarea automatizada via Claude CLI
# Invocado por Windows Task Scheduler para cada automatización configurada.
#
# Uso:
#   pwsh -File runner.ps1 -Task "morning-sync" -ProjectCode "ALPHA"
#   pwsh -File runner.ps1 -Task "projects-digest" -Scope "global"

param(
    [Parameter(Mandatory)]
    [string]$Task,

    [string]$ProjectCode = "",   # Vacío si es tarea global
    [string]$Scope       = "project"  # "project" | "global"
)

# ── Paths ─────────────────────────────────────────────────────────────────────
$projectRoot = Join-Path $PSScriptRoot "..\.."
$logFile     = Join-Path $projectRoot "automations.log"

# ── Logging ───────────────────────────────────────────────────────────────────
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] [$Level] $Message"
    Add-Content -Path $logFile -Value $line -Encoding UTF8
    Write-Host $line
}

# ── Validación ────────────────────────────────────────────────────────────────
if ($Scope -eq "project" -and -not $ProjectCode) {
    Write-Log "ERROR: -ProjectCode es obligatorio para tareas de proyecto." "ERROR"
    exit 1
}

# Verificar que claude CLI está disponible
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Log "ERROR: 'claude' CLI no encontrado en PATH. Instala Claude Code." "ERROR"
    exit 1
}

# ── Construir prompt ──────────────────────────────────────────────────────────
$prompt = if ($Scope -eq "global") {
    "/$Task"
} else {
    "/project-agent $ProjectCode $Task"
}

# ── Ejecutar ──────────────────────────────────────────────────────────────────
Write-Log "Iniciando tarea: $prompt"

Set-Location $projectRoot

try {
    $output = claude -p $prompt 2>&1
    Write-Log "Tarea completada: $prompt"

    # Guardar output en log del proyecto si aplica
    if ($ProjectCode) {
        $projectLogDir = Join-Path $projectRoot "projects\$ProjectCode\logs"
        if (Test-Path $projectLogDir) {
            $today   = Get-Date -Format "yyyy-MM-dd"
            $logEntry = "- **[$(Get-Date -Format 'HH:mm')]** ``[automation]`` Tarea automatizada ejecutada: $Task"
            Add-Content -Path "$projectLogDir\$today.md" -Value $logEntry -Encoding UTF8
        }
    }

    # Mostrar output completo en el log global
    $output | ForEach-Object { Add-Content -Path $logFile -Value "  $_" -Encoding UTF8 }

    exit 0
} catch {
    Write-Log "ERROR ejecutando '$prompt': $($_.Exception.Message)" "ERROR"
    exit 1
}
