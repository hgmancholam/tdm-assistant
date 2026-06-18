param(
    [Parameter(Mandatory)]
    [string]$To,

    [Parameter(Mandatory)]
    [string]$Subject,

    [Parameter(Mandatory)]
    [string]$Body,

    [string]$CC  = "",
    [string]$BCC = ""
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $mail = $outlook.CreateItem(0)  # olMailItem

    $mail.To      = $To
    $mail.Subject = $Subject
    $mail.Body    = $Body
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
