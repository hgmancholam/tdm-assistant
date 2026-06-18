param(
    [Parameter(Mandatory=$true)]
    [string]$Subject,

    [Parameter(Mandatory=$true)]
    [string]$StartTime,

    [Parameter(Mandatory=$true)]
    [string]$EndTime,

    [string]$Location = "",
    [string]$Body = "",
    [string]$Attendees = ""
)

try {
    $outlook = New-Object -ComObject Outlook.Application
    $appointment = $outlook.CreateItem(1)  # olAppointmentItem = 1

    $appointment.Subject  = $Subject
    $appointment.Start    = [DateTime]::Parse($StartTime)
    $appointment.End      = [DateTime]::Parse($EndTime)
    $appointment.Location = $Location
    $appointment.Body     = $Body

    if ($Attendees -ne "") {
        $emailList = $Attendees -split ";"
        foreach ($email in $emailList) {
            $email = $email.Trim()
            if ($email -ne "") {
                $recipient = $appointment.Recipients.Add($email)
                $recipient.Resolve()
            }
        }
        $appointment.MeetingStatus = 1  # olMeeting = 1 — converts to meeting invite
    }

    $appointment.Save()

    @{
        success   = $true
        subject   = $appointment.Subject
        start     = $appointment.Start.ToString("yyyy-MM-dd HH:mm")
        end       = $appointment.End.ToString("yyyy-MM-dd HH:mm")
        location  = $appointment.Location
        attendees = $Attendees
        entryId   = $appointment.EntryID
    } | ConvertTo-Json
}
catch {
    @{
        success = $false
        error   = $_.Exception.Message
    } | ConvertTo-Json
}
