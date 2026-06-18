param(
    [Parameter(Mandatory)]
    [string]$EntryID
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $namespace = $outlook.GetNamespace("MAPI")
    $item = $namespace.GetItemFromID($EntryID)

    $attachments = @()
    foreach ($att in $item.Attachments) {
        $attachments += $att.FileName
    }

    [PSCustomObject]@{
        EntryID      = $item.EntryID
        Subject      = $item.Subject
        From         = $item.SenderName
        FromAddress  = $item.SenderEmailAddress
        To           = $item.To
        CC           = $item.CC
        ReceivedTime = $item.ReceivedTime.ToString("yyyy-MM-dd HH:mm")
        Body         = $item.Body
        Attachments  = $attachments
        ConversationID = $item.ConversationID
    } | ConvertTo-Json -Depth 3
} catch {
    @{ error = $_.Exception.Message } | ConvertTo-Json
}
