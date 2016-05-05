# Appends the device Appliance ID in the Description field for the computer object
function Update-ApplianceID {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ValuefromPipelinebyPropertyName = $true)]
        $ApplianceID
    )
    
    # Prepare Active Directory search objects
    $objDomain = New-Object System.DirectoryServices.DirectoryEntry

    # Create and prepare our DirectorySearcher Object
    $objSearcher= New-Object System.DirectoryServices.DirectorySearcher
    $objSearcher.SearchRoot = $DomainObj
    $objSearcher.PageSize = 1000
    $objSearcher.SearchScope = "Subtree"
    $objSearcher.PropertiesToLoad.Add("name")

    # Optional variable for filtering results down to a certain category, department, or object
    $filter = "(&(objectCategory=Computer)(name=$env:COMPUTERNAME))"

    # Add filter to DirectorySearcher object
    $objSearcher.Filter = $filter

    # Gather all objects in scope of search
    $colResults = $objSearcher.FindAll()

    # For each result returned in $colResults, return the properties we are looking for in PropertiesToLoad
    # In this case we only want the name of the object; we don't need the description field in this object.
    foreach ($objResult in $colResults) {
        $objItem = $objResult.properties
    
    }

    # Convert our ResultPropertyCollection object to a DirectoryEntry object
    $ComputerObject = [ADSI]"$($objItem.adspath)"
    $CurrentDescription = $ComputerObject.Description.ToString()

    if ($CurrentDescription -ne $ApplianceID) {
        try {
            $ComputerObject.Description = $ApplianceID
            $ComputerObject.psbase.CommitChanges()

            # Logging
            $global:LogStream += "$(Get-Date), updated description field with N-Central Appliance ID: $ApplianceID"
            $eventMessage = $global:LogStream | Out-String
            $eventID = '9000'
            $eventEntryType = 'Information'

            New-NCentralPresenceLog -eventMessage $eventMessage -eventID $eventID -eventEntryType $eventEntryType

        }
        catch {
            $global:LogStream += "$(Get-Date), could not update description field in Active Directory with Appliance ID: $ApplianceID, $_"

            # Logging
            $eventMessage = $global:LogStream | Out-String
            $eventID = '9001'
            $eventEntryType = 'Error'

            New-NCentralPresenceLog -eventMessage $eventMessage -eventID $eventID -eventEntryType $eventEntryType

        }
    }
    else {
        $global:LogStream += "$(Get-Date), description field in Active Directory already matches Appliance ID: $ApplianceID. No changes made."

        # Logging
        $eventMessage = $global:LogStream | Out-String
        $eventID = '9002'
        $eventEntryType = 'Information'

        New-NCentralPresenceLog -eventMessage $eventMessage -eventID $eventID -eventEntryType $eventEntryType

    }
}
