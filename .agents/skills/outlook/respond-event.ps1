param(
    [Parameter(Mandatory=$true)]
    [string]$EntryID,

    # Accept | Decline | Tentative
    [Parameter(Mandatory=$true)]
    [ValidateSet("Accept","Decline","Tentative")]
    [string]$Response,

    [string]$Message = ""
)

try {
    $outlook  = New-Object -ComObject Outlook.Application
    $ns       = $outlook.GetNamespace("MAPI")
    $item     = $ns.GetItemFromID($EntryID)

    # olMeetingItem = 53
    if ($item.Class -ne 53) {
        @{
            success = $false
            error   = "Item is not a meeting invitation (class=$($item.Class)). Use the EntryID of the inbox invitation, not the calendar event."
        } | ConvertTo-Json
        exit
    }

    $responseCode = switch ($Response) {
        "Accept"    { 1 }   # olMeetingAccepted
        "Decline"   { 2 }   # olMeetingDeclined
        "Tentative" { 3 }   # olMeetingTentative
    }

    # Respond(responseCode, sendResponse)
    # sendResponse = $true sends the response email to the organizer
    $responseItem = $item.Respond($responseCode, $false)

    if ($Message -ne "" -and $null -ne $responseItem) {
        $responseItem.Body = $Message
    }

    if ($null -ne $responseItem) {
        $responseItem.Send()
    }

    @{
        success  = $true
        subject  = $item.Subject
        response = $Response
        message  = $Message
    } | ConvertTo-Json
}
catch {
    @{
        success = $false
        error   = $_.Exception.Message
    } | ConvertTo-Json
}
