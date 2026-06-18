param(
    [Parameter(Mandatory=$true)]
    [string]$Subject,

    [Parameter(Mandatory=$true)]
    [string]$StartTime,

    [Parameter(Mandatory=$true)]
    [int]$DurationMinutes,

    # Daily | Weekly | Monthly
    [Parameter(Mandatory=$true)]
    [ValidateSet("Daily","Weekly","Monthly")]
    [string]$RecurrenceType,

    # Comma-separated days for Weekly: Mon,Tue,Wed,Thu,Fri
    [string]$DaysOfWeek = "",

    # YYYY-MM-DD — leave empty for no end date
    [string]$EndDate = "",

    [string]$Location  = "",
    [string]$Body      = "",
    [string]$Attendees = ""
)

try {
    $outlook     = New-Object -ComObject Outlook.Application
    $appointment = $outlook.CreateItem(1)  # olAppointmentItem

    $startDt = [DateTime]::Parse($StartTime)
    $endDt   = $startDt.AddMinutes($DurationMinutes)

    $appointment.Subject  = $Subject
    $appointment.Start    = $startDt
    $appointment.End      = $endDt
    $appointment.Location = $Location
    $appointment.Body     = $Body

    $pattern = $appointment.GetRecurrencePattern()

    switch ($RecurrenceType) {
        "Daily" {
            $pattern.RecurrenceType = 0  # olRecursDaily
        }
        "Weekly" {
            $pattern.RecurrenceType = 1  # olRecursWeekly

            if ($DaysOfWeek -ne "") {
                # Map day names to Outlook olDaysOfWeek bitmask values
                $dayMap = @{
                    "Sun" = 1; "Mon" = 2; "Tue" = 4; "Wed" = 8
                    "Thu" = 16; "Fri" = 32; "Sat" = 64
                }
                $dayBits = 0
                foreach ($d in ($DaysOfWeek -split ",")) {
                    $key = $d.Trim().Substring(0,3)
                    if ($dayMap.ContainsKey($key)) {
                        $dayBits = $dayBits -bor $dayMap[$key]
                    }
                }
                if ($dayBits -gt 0) {
                    $pattern.DayOfWeekMask = $dayBits
                }
            }
        }
        "Monthly" {
            $pattern.RecurrenceType = 2  # olRecursMonthly
            $pattern.DayOfMonth     = $startDt.Day
        }
    }

    if ($EndDate -ne "") {
        $pattern.PatternEndDate = [DateTime]::Parse($EndDate)
        $pattern.NoEndDate      = $false
    } else {
        $pattern.NoEndDate = $true
    }

    if ($Attendees -ne "") {
        $emailList = $Attendees -split ";"
        foreach ($email in $emailList) {
            $email = $email.Trim()
            if ($email -ne "") {
                $recipient = $appointment.Recipients.Add($email)
                $recipient.Resolve()
            }
        }
        $appointment.MeetingStatus = 1  # olMeeting
    }

    $appointment.Save()

    @{
        success         = $true
        subject         = $appointment.Subject
        start           = $startDt.ToString("yyyy-MM-dd HH:mm")
        durationMinutes = $DurationMinutes
        recurrenceType  = $RecurrenceType
        daysOfWeek      = $DaysOfWeek
        endDate         = if ($EndDate -ne "") { $EndDate } else { "no end" }
        location        = $appointment.Location
        attendees       = $Attendees
        entryId         = $appointment.EntryID
    } | ConvertTo-Json
}
catch {
    @{
        success = $false
        error   = $_.Exception.Message
    } | ConvertTo-Json
}
