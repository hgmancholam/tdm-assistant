param(
    [Parameter(Mandatory)]
    [string]$ProjectCode
)

$projectsRoot = Join-Path $PSScriptRoot "..\..\projects"
$projectDir = Join-Path $projectsRoot $ProjectCode
$settingsPath = Join-Path $projectDir "project.settings"

if (-not (Test-Path $settingsPath)) {
    @{ error = "Proyecto '$ProjectCode' no encontrado en $projectsRoot" } | ConvertTo-Json
    return
}

try {
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

    # Enrich with file system context
    $logsDir    = Join-Path $projectDir "logs"
    $meetingsDir = Join-Path $projectDir "meetings"
    $reportsDir  = Join-Path $projectDir "reports"

    $lastLog = $null
    if (Test-Path $logsDir) {
        $lastLog = Get-ChildItem $logsDir -Filter "*.md" | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty Name
    }

    $settings | Add-Member -NotePropertyName "_meta" -NotePropertyValue @{
        folderPath   = $projectDir
        lastLogFile  = $lastLog
        meetingCount = if (Test-Path $meetingsDir) { (Get-ChildItem $meetingsDir -Filter "*.md").Count } else { 0 }
        reportCount  = if (Test-Path $reportsDir)  { (Get-ChildItem $reportsDir  -Filter "*.md").Count } else { 0 }
    }

    $settings | ConvertTo-Json -Depth 5
} catch {
    @{ error = $_.Exception.Message } | ConvertTo-Json
}

