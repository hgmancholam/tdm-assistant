param(
    [int]$Days       = 7,
    [string]$StartDate = ""
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $namespace = $outlook.GetNamespace("MAPI")
    $calendar = $namespace.GetDefaultFolder(9)  # olFolderCalendar
    $items = $calendar.Items
    $items.IncludeRecurrences = $true
    $items.Sort("[Start]")

    $start = if ($StartDate) { [DateTime]::Parse($StartDate) } else { (Get-Date).Date }
    $end   = $start.AddDays($Days)

    $filter = "[Start] >= '$($start.ToString("MM/dd/yyyy HH:mm"))' AND [Start] <= '$($end.ToString("MM/dd/yyyy HH:mm"))'"
    $filtered = $items.Restrict($filter)

    $results = @()
    foreach ($item in $filtered) {
        $bodyPreview = ""
        if ($item.Body -and $item.Body.Length -gt 0) {
            $bodyPreview = if ($item.Body.Length -gt 400) { $item.Body.Substring(0, 400) + "..." } else { $item.Body }
        }

        $attendees = @()
        foreach ($rec in $item.Recipients) {
            $attendees += $rec.Address
        }

        $results += [PSCustomObject]@{
            EntryID    = $item.EntryID
            Subject    = $item.Subject
            Start      = $item.Start.ToString("yyyy-MM-dd HH:mm")
            End        = $item.End.ToString("yyyy-MM-dd HH:mm")
            DurationMin = [int]($item.Duration)
            Location   = $item.Location
            Organizer  = $item.Organizer
            Attendees  = $attendees
            IsOnline   = $item.IsOnlineMeeting
            MeetingURL = if ($item.IsOnlineMeeting) { $item.OnlineMeetingURL } else { "" }
            Notes      = $bodyPreview
        }
    }

    $results | ConvertTo-Json -Depth 4
} catch {
    @{ error = $_.Exception.Message } | ConvertTo-Json
}
