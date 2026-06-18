param(
    [Parameter(Mandatory)]
    [string]$To,

    [Parameter(Mandatory)]
    [string]$Subject,

    [string]$Body     = "",
    [string]$BodyFile = "",

    [string]$CC  = "",
    [string]$BCC = ""
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

    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $mail    = $outlook.CreateItem(0)  # olMailItem

    $mail.To       = $To
    $mail.Subject  = $Subject
    $mail.HTMLBody = $htmlContent
    if ($CC)  { $mail.CC  = $CC  }
    if ($BCC) { $mail.BCC = $BCC }

    $mail.Send()

    @{
        success = $true
        message = "Email enviado a: $To"
        subject = $Subject
    } | ConvertTo-Json
} catch {
    @{ success = $false; error = $_.Exception.Message } | ConvertTo-Json
}
