# Main Script Start
[CmdletBinding()]
Param(
     [Parameter(Mandatory=$True,
			    Position=0)]
     $UserName
)

# Initiate Log Stream
$global:LogStream = @()

# Import Active Directory Module
try{
	Import-Module ActiveDirectory

}
catch{
	$global:LogStream += "$(Get-Date), could not import Active Directory module, $_"
	$global:LogStream
	exit
}

. .\helpers\Disable-UserAccount.ps1
. .\helpers\Process-ADGroups.ps1


<##########
Main Script Start
###########>

$UserProperties = @{
        'UserName' = $UserName
    }

$UserObject = New-Object -TypeName PSObject -Property $UserProperties

$UserObject | Disable-UserAccount
$UserObject | Process-ADGroups 


# Return logging steps
Write-Output $global:LogStream
