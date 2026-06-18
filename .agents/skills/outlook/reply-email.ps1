param(
    [Parameter(Mandatory)]
    [string]$EntryID,

    [Parameter(Mandatory)]
    [string]$Body,

    [switch]$ReplyAll
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $namespace = $outlook.GetNamespace("MAPI")
    $item = $namespace.GetItemFromID($EntryID)

    $reply = if ($ReplyAll) { $item.ReplyAll() } else { $item.Reply() }

    # Prepend new body above the quoted original
    $reply.Body = $Body + "`r`n`r`n" + $reply.Body
    $reply.Send()

    @{
        success    = $true
        message    = "Respuesta enviada"
        replyAll   = $ReplyAll.IsPresent
        originalSubject = $item.Subject
    } | ConvertTo-Json
} catch {
    @{ success = $false; error = $_.Exception.Message } | ConvertTo-Json
}
