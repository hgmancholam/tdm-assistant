param(
    [string]$Query   = "",
    [string]$Company = "",
    [int]$Count      = 20
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop
    $namespace = $outlook.GetNamespace("MAPI")
    $contacts = $namespace.GetDefaultFolder(10)  # olFolderContacts
    $items = $contacts.Items
    $items.Sort("[LastName]")

    $results = @()

    foreach ($item in $items) {
        if ($results.Count -ge $Count) { break }
        if ($item.Class -ne 40) { continue }  # 40 = olContact

        $match = $false
        if ($Query) {
            $fullName = "$($item.FirstName) $($item.LastName) $($item.CompanyName) $($item.Email1Address)"
            if ($fullName -match $Query) { $match = $true }
        }
        if ($Company -and $item.CompanyName -match $Company) { $match = $true }
        if (-not $Query -and -not $Company) { $match = $true }

        if ($match) {
            $results += [PSCustomObject]@{
                EntryID     = $item.EntryID
                FullName    = $item.FullName
                FirstName   = $item.FirstName
                LastName    = $item.LastName
                Company     = $item.CompanyName
                JobTitle    = $item.JobTitle
                Email       = $item.Email1Address
                Email2      = $item.Email2Address
                Phone       = $item.BusinessTelephoneNumber
                Mobile      = $item.MobileTelephoneNumber
                Department  = $item.Department
            }
        }
    }

    $results | ConvertTo-Json -Depth 3
} catch {
    @{ error = $_.Exception.Message } | ConvertTo-Json
}
