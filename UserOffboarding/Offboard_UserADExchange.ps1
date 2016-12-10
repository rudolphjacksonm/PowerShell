    $Username
    $Username_Confirm
 
    
# Initialize Logstream
$global:Logstream = @()

# Check that username was entered correctly in both fields
if ($Username -ne $Username_Confirm) {
	$global:LogStream += "$(Get-Date), username check failed. Please re-run the automation policy with the correct information in both fields."
	throw $global:LogStream
}

$snappinFound = $False
# Offboard user mailbox in Exchange 2010 environment
try {
    Add-PSSnapin Microsoft.Exchange.Management.Powershell.E2010 -ErrorAction Stop

    # Verify Adding Exchange Snap-in was successful
    $ExchangeSnapIn = Get-PSSnapin -Name Microsoft.Exchange.Management.Powershell.E2010

    if ($ExchangeSnapIn) {
        $global:Logstream += "$(Get-Date), succesfully added Exchange 2010 PSSnapin"
        $snappinFound = $True
    }
}
catch {
    $global:Logstream += "$(Get-Date), could not add Exchange 2010 snap-in."

}

# Offboard user mailbox in Exchange 2013 environment
try {
    Add-PSSnapin Microsoft.Exchange.Management.Powershell.E2013 -ErrorAction Stop

    $ExchangeSnapIn = Get-PSSnapin -Name Microsoft.Exchange.Management.Powershell.E2013

    if ($ExchangeSnapIn) {
        $global:Logstream += "$(Get-Date), succesfully added Exchange 2013 PSSnapin"
        $snappinFound = $True
    }
}
catch{
    $global:Logstream += "$(Get-Date), could not add Exchange 2013 snap-in."

}

# If no snap-ins are found, throw an error and exit the script
if(!($snappinFound)) {
    throw $global:Logstream

}


function Get-InboxRuleDescriptions {
    [CmdletBinding()]
    Param
    (
        # The name of the rule from the Get-InboxRule command
        [Parameter(Mandatory=$true,
                   ValuefromPipelinebyPropertyName=$true,
                   Position=0)]
        $Name,
		
		# Description of what the rule does; parameter Description from Get-InboxRule command
        [Parameter(Mandatory=$true,
                   ValuefromPipelinebyPropertyName=$true,
                   Position=1)]
        $Description,

		# The identity of the rule from Get-InboxRule command
        [Parameter(Mandatory=$true,
                   ValuefromPipelinebyPropertyName=$true,
                   Position=2)]
        $Identity
    )
 
   
    begin {
    }
    
    process {
        
        # Logging
        $global:LogStream += "$(Get-Date), Rule Name: $Name, Rule Description: $Description"
        
        # Output
        $props = @{
            'RuleName' = $Name
            'Description' = $Description
            'Identity' = $Identity
        }

        New-Object -TypeName PSObject -Property $props

    }
    end {
    }
}
function Remove-ExchangeInboxRules {
    [CmdletBinding()]
    Param
    (
		# The identity of the rule from Get-InboxRule command
        [Parameter(Mandatory=$true,
                   ValuefromPipelinebyPropertyName=$true,
                   Position=0)]
        $Identity,
		
		# Name of the rule received from pipeline
		[Parameter(Mandatory=$true,
                   ValuefromPipelinebyPropertyName=$true,
                   Position=1)]
        $RuleName
    )
	
	begin {
    }
    process {
        # Remove rules
        try {
            Remove-InboxRule -identity $Identity -Confirm:$False -Force
            
            # Logging
            $global:Logstream += "$(Get-Date), removed rule $RuleName, rule ID: $Identity"

        }
        catch {
            $global:Logstream += "$(Get-Date), could not remove rule $RuleName, $_"
        
        }
    }
    end {
    }
}
function Remove-ActiveSyncPartnerships {
    [CmdletBinding()]
    param
    (
		# Identity of the mobile device
        [Parameter(Mandatory=$true,
                   ValuefromPipelinebyPropertyName=$true,
                   Position=0)]
        $Identity,

		# The friendly name of the device, e.g. 'Samsung G5'
        [Parameter(Mandatory=$true,
                   ValuefromPipelinebyPropertyName=$true,
                   Position=1)]
        $DeviceModel
    )

    # Remove ActiveSync devices received through pipeline
    begin {
    }
    process {
        try {
            Remove-ActiveSyncDevice -identity $Identity -Confirm:$False
                
            # Logging
            $global:LogStream += "$(Get-Date), removed device $DeviceModel"

	    }
	    catch {
		    $global:LogStream += "$(Get-Date), could not remove mobile device, $_"

        }
    }
    end {
    }
}

# Validate User Exists
$DetectUser = Get-Mailbox -identity $Username
if ($DetectUser -eq $null) {
	$global:LogStream += "$(Get-Date), user $Username not found."
	throw $global:LogStream
	
}

# Gather inbox rules, log their descriptions, then remove
$CollectRules = Get-InboxRule -mailbox $Username
if ($CollectRules -eq $null) {
	$global:LogStream += "$(Get-Date), User $Username has no Inbox rules."
	
}
else {
	$CollectRules | Get-InboxRuleDescriptions | Remove-ExchangeInboxRules
	
}

# Gather ActiveSync devices and remove
$MobileDevices = Get-ActiveSyncDevice -mailbox $Username
if ($MobileDevices) {
	$MobileDevices | Remove-ActiveSyncPartnerships
	
}
else {
	$global:LogStream += "$(Get-Date), no mobile devices found for this mailbox."
	
}

# Disable ActiveSync; Hide user from Global Address List
$CASMailbox = Get-CASMailbox -Identity $Username
if ($CasMailbox | select -ExpandProperty ActiveSyncEnabled) {
	try {
	$CASMailbox | Set-CASMailbox -ActiveSyncEnabled $False

    # Logging
    $global:LogStream += "$(Get-Date), disabled ActiveSync"

	}
	catch {
		$global:LogStream += "$(Get-Date), unable to disable ActiveSync"

	}
}
else {
	$global:LogStream += "$(Get-Date), ActiveSync already disabled for this account"
}

# Hide user from GAL
if (!($DetectUser | select -ExpandProperty HiddenFromAddressListsEnabled)) {
	try {
		Set-Mailbox -identity $Username -HiddenFromAddressListsEnabled $true
        
		# Logging
		$global:LogStream += "$(Get-Date), user hidden from GAL."
		
	}
catch {
		$global:Logstream += "$(Get-Date), unable to hide user from GAL, $_"

	}
}
else {
	$global:LogStream += "$(Get-Date), user already hidden from GAL."

}
Write-Output $global:LogStream 
