Function Disable-UserAccount {
    [cmdletbinding()]
    Param
    (
        # Name of User Account
	    [Parameter(Mandatory=$True,
                   ValuefromPipelinebyPropertyName=$True,
			       Position=0)]  
		$UserName
    )

    try {
        $UserInstance = Get-ADuser $UserName -ErrorAction Stop 

        # Logging
        $global:LogStream += "$(Get-Date), user exists, $_"
	 
    }
    catch {
	    $global:LogStream += "$(Get-Date), Cannot find user $UserName in AD, $_"
	    $global:LogStream
	    exit
	
    }

    # Verify SamAccountName matches Name parameter
	if ($UserInstance.samaccountname -eq $UserName) {
		
        if ($UserInstance.Enabled -eq $True){
            Disable-ADAccount $UserInstance
			
			# Edit description to show date disabled
            $Description = Get-ADUser $UserInstance -Properties * | select -ExpandProperty description
            $NewDescription = $Description + ' ' + "(Disabled on $(Get-Date))"
			Set-ADUser $UserInstance -description $NewDescription

            # Logging
	        $global:LogStream += "$(Get-Date), $UserName disabled, $_"
			$global:LogStream += "$(Get-Date), $UserName description updated."
        
        }
        else{
            $global:LogStream += "$(Get-Date), $UserName already disabled, $_"
            
        }
	}
}
