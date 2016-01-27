function Get-WindowsUpdate {
	<#
        .SYNOPSIS
        
        Determines whether the specified KB is installed on either the local or remote host.
        Can also silently uninstall this patch (without reboot) if so desired.
        .EXAMPLE
        Search for a Windows Update (just like the Get-Hotfix cmdlet) on local/remote machine.
        Can handle both of the following formats for $KBNumber.
        Get-WindowsUpdate -KBNumber "3081320"
        Get-WindowsUpdate -KBNumber "KB3081320"
        Get-WindowsUpdate -KBNumber "KB3081320" -ComputerName NYCTESTPC01
        .EXAMPLE
        Remove a Windows Update from a remote host.
        Get-WindowsUpdate -KBNumber "3081320" -Computername NYCTESTPC01 -Uninstall
    #>

    [Cmdletbinding()]
	param(
	[Parameter(
	Mandatory=$True)]
	
	$KBNumber,
    [switch]$Uninstall,
    [string]$ComputerName
	)
    
    #Setting uninstall command variable
    $UninstallCommand = Invoke-Command -ScriptBlock {Cmd /c wusa.exe /uninstall /KB:$KBNumber /quiet /norestart}

    ###If $ComputerName is not provided, script will run on local machine
    if ($ComputerName -eq $Null) {
        ###If/else in this block determines if $KBNumber is entered in the format of "KB[number]" or
        ###simply the number of the KB, and handles accordingly for each scenario
        if ($KBNumber -notmatch '^KB') {
            Get-Hotfix -ID ("KB"+"$KBNumber")
        
            if($Uninstall -eq $True) {
                Write-Progress -Activity "Uninstalling $KBNumber..."
                $UninstallCommand
            }
        }
        else{
            #KB is provided in normal format of 'kb#####'
            Get-Hotfix -ID $KBNumber
            if($Uninstall -eq $True) {
                Write-Progress -Activity "Uninstalling $KBNumber..."
                $UninstallCommand
            }
        }
    }
    else{
    	###If/else in this block determines if $KBNumber is entered in the format of "KB[number]" or
        ###simply the number of the KB, and handles accordingly for each scenario
        if ($KBNumber -notmatch '^KB') {
            $cred = Get-Credential
            Get-Hotfix -ID ("KB"+"$KBNumber") -ComputerName $ComputerName -Credential $cred
        
            if($Uninstall -eq $True) {
                Write-Progress -Activity "Uninstalling $KBNumber..."
                $UninstallCommand
            }
        }
        else{
            $cred = Get-Credential
            Get-Hotfix -ID $KBNumber -ComputerName $ComputerName -Credential $cred

            if($Uninstall -eq $True) {
                Write-Progress -Activity "Uninstalling $KBNumber..."
                $UninstallCommand
            }
        }
    }
}
