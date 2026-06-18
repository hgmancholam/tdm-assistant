# scheduler.ps1 — Gestiona automatizaciones en Windows Task Scheduler
#
# Uso:
#   pwsh -File scheduler.ps1 -Action list
#   pwsh -File scheduler.ps1 -Action register -ProjectCode "ALPHA"
#   pwsh -File scheduler.ps1 -Action register-all
#   pwsh -File scheduler.ps1 -Action unregister -ProjectCode "ALPHA"
#   pwsh -File scheduler.ps1 -Action unregister-all
#   pwsh -File scheduler.ps1 -Action run -ProjectCode "ALPHA" -TaskName "morning-sync"

param(
    [Parameter(Mandatory)]
    [ValidateSet("list","register","register-all","unregister","unregister-all","run")]
    [string]$Action,

    [string]$ProjectCode = "",
    [string]$TaskName    = ""
)

$projectRoot = Join-Path $PSScriptRoot "..\.."
$runnerPath  = Join-Path $projectRoot ".agents\skills\runner.ps1"
$taskPrefix  = "PersonalAssistant"

# ── Helpers ───────────────────────────────────────────────────────────────────

function Convert-CronToTrigger {
    param([string]$Cron)

    $parts     = $Cron -split '\s+'
    $minute    = [int]$parts[0]
    $hour      = [int]$parts[1]
    $dayOfWeek = $parts[4]
    $time      = "{0:D2}:{1:D2}" -f $hour, $minute

    $dayMap = @{ 0='Sunday'; 1='Monday'; 2='Tuesday'; 3='Wednesday'; 4='Thursday'; 5='Friday'; 6='Saturday' }

    switch -Regex ($dayOfWeek) {
        '^\*$'        { return New-ScheduledTaskTrigger -Daily -At $time }
        '^1-5$'       { return New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Monday,Tuesday,Wednesday,Thursday,Friday -At $time }
        '^0-6$'       { return New-ScheduledTaskTrigger -Daily -At $time }
        '^(\d)$'      { return New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek $dayMap[[int]$Matches[1]] -At $time }
        default       {
            # Multiple days: "1,3,5"
            $nums = $dayOfWeek -split ',' | ForEach-Object { [int]$_ }
            $days = $nums | ForEach-Object { $dayMap[$_] }
            return New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek $days -At $time
        }
    }
}

function Register-AutomationTask {
    param(
        [string]$Name,
        [string]$Description,
        [string]$Schedule,
        [string]$Task,
        [string]$Code   = "",
        [string]$Scope  = "project"
    )

    $taskName = if ($Code) { "$taskPrefix-$Code-$Name" } else { "$taskPrefix-GLOBAL-$Name" }

    $args = if ($Scope -eq "global") {
        "-NonInteractive -File `"$runnerPath`" -Task `"$Task`" -Scope global"
    } else {
        "-NonInteractive -File `"$runnerPath`" -Task `"$Task`" -ProjectCode `"$Code`""
    }

    $action  = New-ScheduledTaskAction -Execute "pwsh" -Argument $args -WorkingDirectory $projectRoot
    $trigger = Convert-CronToTrigger -Cron $Schedule
    $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 30) -StartWhenAvailable

    # Remove if exists to re-register cleanly
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    }

    Register-ScheduledTask `
        -TaskName    $taskName `
        -Description $Description `
        -Action      $action `
        -Trigger     $trigger `
        -Settings    $settings `
        -RunLevel    Limited | Out-Null

    [PSCustomObject]@{
        TaskName    = $taskName
        Description = $Description
        Schedule    = $Schedule
        Status      = "Registered"
    }
}

function Get-ProjectAutomations {
    param([string]$Code)
    $settingsPath = Join-Path $projectRoot "projects\$Code\project.settings"
    if (-not (Test-Path $settingsPath)) { return @() }
    $settings = Get-Content $settingsPath -Raw | ConvertFrom-Json
    if (-not $settings.automations) { return @() }
    $settings.automations | Where-Object { $_.enabled -eq $true }
}

function Get-GlobalAutomations {
    $globalPath = Join-Path $projectRoot "automations.json"
    if (-not (Test-Path $globalPath)) { return @() }
    $config = Get-Content $globalPath -Raw | ConvertFrom-Json
    $config.automations | Where-Object { $_.enabled -eq $true }
}

function Get-AllProjectCodes {
    Get-ChildItem (Join-Path $projectRoot "projects") -Directory |
        Where-Object { $_.Name -ne "_template" } |
        ForEach-Object { $_.Name }
}

# ── Actions ───────────────────────────────────────────────────────────────────

switch ($Action) {

    "list" {
        $registered = Get-ScheduledTask -TaskPath "\" -ErrorAction SilentlyContinue |
            Where-Object { $_.TaskName -like "$taskPrefix-*" }

        if (-not $registered) {
            Write-Host "No hay tareas de PersonalAssistant registradas en Task Scheduler."
        } else {
            $registered | ForEach-Object {
                [PSCustomObject]@{
                    Nombre  = $_.TaskName
                    Estado  = $_.State
                    Ultimo  = ($_ | Get-ScheduledTaskInfo).LastRunTime
                    Proximo = ($_ | Get-ScheduledTaskInfo).NextRunTime
                }
            } | Format-Table -AutoSize
        }
    }

    "register" {
        if (-not $ProjectCode) { Write-Error "-ProjectCode requerido para 'register'"; exit 1 }
        $automations = Get-ProjectAutomations -Code $ProjectCode
        if (-not $automations) {
            Write-Host "No hay automatizaciones habilitadas en $ProjectCode/project.settings"
        } else {
            $automations | ForEach-Object {
                $result = Register-AutomationTask -Name $_.name -Description $_.description `
                    -Schedule $_.schedule -Task $_.task -Code $ProjectCode -Scope "project"
                Write-Host "✅ $($result.TaskName) — $($result.Schedule)"
            }
        }
    }

    "register-all" {
        # Register project automations
        Get-AllProjectCodes | ForEach-Object {
            $code = $_
            $automations = Get-ProjectAutomations -Code $code
            $automations | ForEach-Object {
                $result = Register-AutomationTask -Name $_.name -Description $_.description `
                    -Schedule $_.schedule -Task $_.task -Code $code -Scope "project"
                Write-Host "✅ $($result.TaskName)"
            }
        }

        # Register global automations
        Get-GlobalAutomations | ForEach-Object {
            $result = Register-AutomationTask -Name $_.name -Description $_.description `
                -Schedule $_.schedule -Task $_.task -Scope "global"
            Write-Host "✅ $($result.TaskName)"
        }
    }

    "unregister" {
        if (-not $ProjectCode) { Write-Error "-ProjectCode requerido para 'unregister'"; exit 1 }
        Get-ScheduledTask -ErrorAction SilentlyContinue |
            Where-Object { $_.TaskName -like "$taskPrefix-$ProjectCode-*" } |
            ForEach-Object {
                Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false
                Write-Host "🗑️  Eliminada: $($_.TaskName)"
            }
    }

    "unregister-all" {
        Get-ScheduledTask -ErrorAction SilentlyContinue |
            Where-Object { $_.TaskName -like "$taskPrefix-*" } |
            ForEach-Object {
                Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false
                Write-Host "🗑️  Eliminada: $($_.TaskName)"
            }
    }

    "run" {
        if (-not $TaskName) { Write-Error "-TaskName requerido para 'run'"; exit 1 }
        $scope = if ($ProjectCode) { "project" } else { "global" }
        Write-Host "▶ Ejecutando: $TaskName (scope: $scope, project: $ProjectCode)"
        & pwsh -File $runnerPath -Task $TaskName -ProjectCode $ProjectCode -Scope $scope
    }
}
