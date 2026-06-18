param(
    [Parameter(Mandatory)]
    [string]$EntryID,

    [Parameter(Mandatory)]
    [string]$FolderName
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $namespace = $outlook.GetNamespace("MAPI")
    $item = $namespace.GetItemFromID($EntryID)
    $inbox = $namespace.GetDefaultFolder(6)

    $targetFolder = $null
    foreach ($folder in $inbox.Folders) {
        if ($folder.Name -ieq $FolderName) {
            $targetFolder = $folder
            break
        }
    }

    if (-not $targetFolder) {
        @{ success = $false; error = "Carpeta '$FolderName' no encontrada en Inbox. Carpetas disponibles: $(($inbox.Folders | ForEach-Object { $_.Name }) -join ', ')" } | ConvertTo-Json
        return
    }

    $item.Move($targetFolder) | Out-Null
    @{ success = $true; message = "Email movido a '$FolderName'" } | ConvertTo-Json
} catch {
    @{ success = $false; error = $_.Exception.Message } | ConvertTo-Json
}
