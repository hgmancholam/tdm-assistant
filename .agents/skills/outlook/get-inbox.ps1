param(
    [int]$Count = 20,
    [switch]$UnreadOnly
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $namespace = $outlook.GetNamespace("MAPI")
    $inbox = $namespace.GetDefaultFolder(6)  # olFolderInbox
    $items = $inbox.Items
    $items.Sort("[ReceivedTime]", $true)

    $results = @()
    $processed = 0

    foreach ($item in $items) {
        if ($processed -ge $Count) { break }
        if ($UnreadOnly -and $item.UnRead -eq $false) { continue }

        $preview = ""
        if ($item.Body -and $item.Body.Length -gt 0) {
            $preview = if ($item.Body.Length -gt 250) { $item.Body.Substring(0, 250) + "..." } else { $item.Body }
        }

        $results += [PSCustomObject]@{
            EntryID        = $item.EntryID
            Subject        = $item.Subject
            From           = $item.SenderName
            FromAddress    = $item.SenderEmailAddress
            ReceivedTime   = $item.ReceivedTime.ToString("yyyy-MM-dd HH:mm")
            IsUnread       = $item.UnRead
            HasAttachments = ($item.Attachments.Count -gt 0)
            Preview        = $preview
        }
        $processed++
    }

    $results | ConvertTo-Json -Depth 3
} catch {
    @{ error = $_.Exception.Message } | ConvertTo-Json
}
