param(
    [string]$Query    = "",
    [string]$From     = "",
    [string]$Subject  = "",
    [int]$Count       = 15,
    [int]$DaysBack    = 30
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $namespace = $outlook.GetNamespace("MAPI")
    $inbox = $namespace.GetDefaultFolder(6)
    $items = $inbox.Items
    $items.Sort("[ReceivedTime]", $true)

    $cutoff = (Get-Date).AddDays(-$DaysBack)
    $results = @()

    foreach ($item in $items) {
        if ($results.Count -ge $Count) { break }
        if ($item.ReceivedTime -lt $cutoff) { break }

        $match = $false
        if ($Query   -and ($item.Subject -match $Query   -or $item.Body -match $Query   -or $item.SenderName -match $Query))   { $match = $true }
        if ($From    -and ($item.SenderEmailAddress -match $From -or $item.SenderName -match $From)) { $match = $true }
        if ($Subject -and ($item.Subject -match $Subject)) { $match = $true }
        if (-not $Query -and -not $From -and -not $Subject) { $match = $true }

        if ($match) {
            $preview = if ($item.Body.Length -gt 300) { $item.Body.Substring(0, 300) + "..." } else { $item.Body }
            $results += [PSCustomObject]@{
                EntryID      = $item.EntryID
                Subject      = $item.Subject
                From         = $item.SenderName
                FromAddress  = $item.SenderEmailAddress
                ReceivedTime = $item.ReceivedTime.ToString("yyyy-MM-dd HH:mm")
                IsUnread     = $item.UnRead
                Preview      = $preview
            }
        }
    }

    $results | ConvertTo-Json -Depth 3
} catch {
    @{ error = $_.Exception.Message } | ConvertTo-Json
}
