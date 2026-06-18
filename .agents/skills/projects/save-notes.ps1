param(
    [Parameter(Mandatory)]
    [string]$ProjectCode,

    [Parameter(Mandatory)]
    [string]$Title,

    [Parameter(Mandatory)]
    [string]$Content,

    [string]$Type     = "meeting",   # meeting | decision | risk | action | retrospective
    [string]$Attendees = "",
    [string]$Date     = ""
)

$projectsRoot = Join-Path $PSScriptRoot "..\..\projects"
$typeFolder   = switch ($Type) {
    "meeting"       { "meetings" }
    "decision"      { "decisions" }
    "risk"          { "risks" }
    "retrospective" { "retrospectives" }
    default         { "notes" }
}

$targetDir = Join-Path $projectsRoot "$ProjectCode\$typeFolder"
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$fileDate  = if ($Date) { $Date } else { Get-Date -Format "yyyy-MM-dd" }
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$slug      = ($Title -replace '[^\w\s-]', '' -replace '\s+', '-').ToLower()
$fileName  = "$fileDate-$slug.md"
$filePath  = Join-Path $targetDir $fileName

$header = @"
# $Title
**Tipo:** $Type  |  **Fecha:** $fileDate  |  **Registrado:** $timestamp
**Proyecto:** $ProjectCode
"@

if ($Attendees) {
    $header += "`n**Asistentes:** $Attendees"
}

$fileContent = "$header`n`n---`n`n$Content"
$fileContent | Set-Content -Path $filePath -Encoding UTF8

@{
    success   = $true
    filePath  = $filePath
    fileName  = $fileName
    type      = $Type
    timestamp = $timestamp
} | ConvertTo-Json

