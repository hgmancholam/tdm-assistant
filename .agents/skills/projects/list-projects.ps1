param(
    [string]$Status = ""   # "active" | "on-hold" | "closed" | "" (todos)
)

$projectsRoot = Join-Path $PSScriptRoot "..\..\projects"
$results = @()

foreach ($dir in Get-ChildItem -Path $projectsRoot -Directory) {
    if ($dir.Name -eq "_template") { continue }

    $settingsPath = Join-Path $dir.FullName "project.settings"
    if (-not (Test-Path $settingsPath)) { continue }

    try {
        $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
        $projectStatus = $settings.project.status

        if ($Status -and $projectStatus -ne $Status) { continue }

        $results += [PSCustomObject]@{
            Code        = $settings.project.code
            Name        = $settings.project.name
            Client      = $settings.project.client
            Type        = $settings.project.type
            Status      = $projectStatus
            Phase       = $settings.project.phase
            EndDate     = $settings.project.targetEndDate
            ADOProject  = $settings.ado.project
            FolderPath  = $dir.FullName
            LastUpdated = $settings.metadata.lastUpdated
        }
    } catch {
        $results += [PSCustomObject]@{
            Name       = $dir.Name
            Status     = "error"
            Error      = $_.Exception.Message
            FolderPath = $dir.FullName
        }
    }
}

$results | ConvertTo-Json -Depth 3

