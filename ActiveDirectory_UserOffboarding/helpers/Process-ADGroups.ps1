function Process-ADGroups {
    [CmdletBinding()]
    Param
    (
        # UserName
        [Parameter(Mandatory=$True,
				   ValueFromPipelinebyPropertyName=$True,
                   Position=0)]
        $UserName
    )
	
    # Gather Group Membership
    $UserGroupMembership = Get-ADUser -Identity $UserName -Properties memberof | Select-Object -ExpandProperty memberof

    $ADGroups = $UserGroupMembership | ForEach-Object {
        Get-ADGroup $_

    }

    try {
            if ($ADGroups -ne $null) {
                # Remove user from all groups
                $ADGroups | ForEach-Object {

                    $global:LogStream += "$(Get-Date), $username is a member of: $_"
                    Remove-ADGroupMember -Identity $_ -Members $UserName -Confirm:$false
            
                    # Logging
                    $global:LogStream += "$(get-date), removed $username from group $_"

                }
            }
            else{
                $global:LogStream += "$(get-date), $username is not a member of any groups, no changes made."

            }

    }
    catch{
        $global:LogStream += "$(Get-Date), could not remove user from group $Group, $_"

    }
}
