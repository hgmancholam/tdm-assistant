param(
    [Parameter(Mandatory)]
    [string]$ProjectCode,

    [Parameter(Mandatory)]
    [string]$FieldPath,    # Dot notation: "project.status" | "ado.project" | "cadence.standupTime"

    [Parameter(Mandatory)]
    [string]$Value
)

$projectsRoot = Join-Path $PSScriptRoot "..\..\projects"
$settingsPath = Join-Path $projectsRoot "$ProjectCode\project.settings"

if (-not (Test-Path $settingsPath)) {
    @{ success = $false; error = "Proyecto '$ProjectCode' no encontrado" } | ConvertTo-Json
    return
}

try {
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

    # Navigate dot-notation path and update value
    $parts = $FieldPath.Split(".")
    $target = $settings
    for ($i = 0; $i -lt $parts.Count - 1; $i++) {
        $target = $target.($parts[$i])
    }
    $target.($parts[-1]) = $Value

    # Update lastUpdated timestamp
    $settings.metadata.lastUpdated = (Get-Date -Format "yyyy-MM-dd HH:mm")

    $settings | ConvertTo-Json -Depth 5 | Set-Content $settingsPath -Encoding UTF8

    @{
        success    = $true
        field      = $FieldPath
        newValue   = $Value
        updated    = $settings.metadata.lastUpdated
    } | ConvertTo-Json
} catch {
    @{ success = $false; error = $_.Exception.Message } | ConvertTo-Json
}

