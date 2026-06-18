param(
    [Parameter(Mandatory)]
    [string]$ProjectCode,

    [Parameter(Mandatory)]
    [string]$Entry,

    [string]$Category = "general",   # general | ado | email | meeting | risk | decision | blocker
    [string]$Author   = "harol.manchola@arroyoconsulting.net"
)

$projectsRoot = Join-Path $PSScriptRoot "..\..\projects"
$logsDir = Join-Path $projectsRoot "$ProjectCode\logs"

if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
}

$today    = Get-Date -Format "yyyy-MM-dd"
$logFile  = Join-Path $logsDir "$today.md"
$timestamp = Get-Date -Format "HH:mm"

$logLine = "- **[$timestamp]** ``[$Category]`` $Entry"

if (-not (Test-Path $logFile)) {
    "# Log — $today`n" | Set-Content $logFile -Encoding UTF8
}

Add-Content -Path $logFile -Value $logLine -Encoding UTF8

@{
    success    = $true
    logFile    = $logFile
    entry      = $logLine
    timestamp  = "$today $timestamp"
} | ConvertTo-Json

