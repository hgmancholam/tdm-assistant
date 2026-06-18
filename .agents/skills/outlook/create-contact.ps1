param(
    [Parameter(Mandatory)]
    [string]$FirstName,

    [string]$LastName   = "",
    [string]$Company    = "",
    [string]$JobTitle   = "",
    [string]$Email      = "",
    [string]$Phone      = "",
    [string]$Mobile     = "",
    [string]$Department = "",

    # Si se provee EntryID, actualiza el contacto existente en vez de crear uno nuevo
    [string]$EntryID = ""
)

try {
    $outlook = New-Object -ComObject Outlook.Application -ErrorAction Stop

    if ($EntryID) {
        $namespace = $outlook.GetNamespace("MAPI")
        $contact = $namespace.GetItemFromID($EntryID)
        $action = "actualizado"
    } else {
        $contact = $outlook.CreateItem(2)  # 2 = olContactItem
        $action = "creado"
    }

    $contact.FirstName              = $FirstName
    $contact.LastName               = $LastName
    $contact.CompanyName            = $Company
    $contact.JobTitle               = $JobTitle
    $contact.Email1Address          = $Email
    $contact.BusinessTelephoneNumber = $Phone
    $contact.MobileTelephoneNumber  = $Mobile
    $contact.Department             = $Department
    $contact.Save()

    @{
        success  = $true
        action   = $action
        fullName = "$FirstName $LastName".Trim()
        company  = $Company
        email    = $Email
    } | ConvertTo-Json
} catch {
    @{ success = $false; error = $_.Exception.Message } | ConvertTo-Json
}
