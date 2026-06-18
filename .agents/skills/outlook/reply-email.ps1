param(
    [Parameter(Mandatory)]
    [string]$EntryID,

    [string]$Body     = "",
    [string]$BodyFile = "",

    [switch]$ReplyAll
)

try {
    if (-not $Body -and -not $BodyFile) {
        throw "Provide -Body or -BodyFile."
    }

    $htmlContent = if ($BodyFile) {
        Get-Content -Path $BodyFile -Raw -Encoding UTF8
    } else {
        $Body
    }

    $outlook   = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $namespace = $outlook.GetNamespace("MAPI")
    $item      = $namespace.GetItemFromID($EntryID)

    $reply = if ($ReplyAll) { $item.ReplyAll() } else { $item.Reply() }

    # Insert new HTML content before the quoted original inside <body>
    $existingHtml = $reply.HTMLBody
    $bodyMatch    = [regex]::Match($existingHtml, '<body[^>]*>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    if ($bodyMatch.Success) {
        $insertIdx    = $bodyMatch.Index + $bodyMatch.Length
        $reply.HTMLBody = $existingHtml.Insert($insertIdx, $htmlContent + "<br>")
    } else {
        $reply.HTMLBody = $htmlContent + "<br>" + $existingHtml
    }

    $reply.Send()

    @{
        success         = $true
        message         = "Respuesta enviada"
        replyAll        = $ReplyAll.IsPresent
        originalSubject = $item.Subject
    } | ConvertTo-Json
} catch {
    @{ success = $false; error = $_.Exception.Message } | ConvertTo-Json
}
