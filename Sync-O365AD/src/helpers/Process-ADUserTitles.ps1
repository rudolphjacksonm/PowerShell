function Process-ADUserTitles {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true,
                   ValuefromPipelinebyPropertyName = $true,
                   Position = 0)]
        $SamAccountName,

        [Parameter(Mandatory = $false,
                   ValuefromPipelinebyPropertyName = $true,
                   Position = 1)]
        $title
    )

    process {
        
        switch ($title) {

            Director {
                
                # Verify user is not already member of group
                $GroupName = 'Directors'
                [bool]$VerifyMembership = Get-ADPrincipalGroupMembership -Identity $SamAccountName | Where-Object {$_.name -match $GroupName}

                if (!($VerifyMembership)) {
                    try {
                        Add-ADPrincipalGroupMembership -identity $SamAccountName -MemberOf $GroupName -ErrorAction Stop

                        # Log changes made to account
                        $global:LogStream += "$(Get-Date), added user $SamAccountName to AD Group: $GroupName"

                        $props = @{
                            'Username' = $SamAccountName
                            'Title' = $title
                            'GroupName' = 'Director'
                            'Action' = 'Added'
                        }
                    }
                    catch {
                        $global:LogStream += "$(Get-Date), could not add $SamAccountName to $GroupName, $_"

                    }
                }
                else {
                    # No changes need to be made.
                    # Logging
                    $global:LogStream += "$(Get-Date), user $SamAccountName already a member of AD Group: $GroupName"
                    $props = @{
                        'Username' = $SamAccountName
                        'Title' = $title
                        'GroupName' = 'Director'
                        'Action' = 'No Change'

                    }
                }   
            }
            
            "Managing Director" {

                # Verify user is not already member of group
                $GroupName = 'Managing Directors'
                [bool]$VerifyMembership = Get-ADPrincipalGroupMembership -Identity $SamAccountName | Where-Object {$_.name -match $GroupName}

                if (!($VerifyMembership)) {
                    try {
                        Add-ADPrincipalGroupMembership -identity $SamAccountName -MemberOf $GroupName -ErrorAction Stop

                        # Log changes made to account
                        $global:LogStream += "$(Get-Date), added user $SamAccountName to AD Group: $GroupName"

                        $props = @{
                            'Username' = $SamAccountName
                            'Title' = $title
                            'GroupName' = 'Managing Director'
                            'Action' = 'Added'
                        }
                    }
                    catch {
                        $global:LogStream += "$(Get-Date), could not add $SamAccountName to $GroupName, $_"

                    }
                }
                else {
                    # No changes need to be made.
                    # Logging
                    $global:LogStream += "$(Get-Date), user $SamAccountName already a member of AD Group: $GroupName"
                    $props = @{
                        'Username' = $SamAccountName
                        'Title' = $title
                        'GroupName' = 'Managing Director'
                        'Action' = 'No Change'

                    }
                }
            }
            
            default {
                $props = @{
                        'Username' = $SamAccountName
                        'Title' = $title
                        'Action' = 'No Change'
                }
            }
        }

        # Create object after running through switch block
        New-Object -TypeName PSObject -Property $props
    }
}
