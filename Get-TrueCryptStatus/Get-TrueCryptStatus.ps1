Function Get-TrueCryptStatus {
    <#
        Version: 1.0
        Author(s): Jack Morris (rudolphjacksonm@gmail.com)
        
        .SYNOPSIS
        This script will query the presence of several critical TrueCrypt services/files
        on remote systems specified in a CSV file.

        .DESCRIPTION
        Get-TrueCryptStatus determines the presence of the following TrueCrypt services and
        files on a remote system:
        1. The TrueCrypt directory under C:\Program Files\TrueCrypt
        2. The TrueCrypt.exe file in the TrueCrypt directory
        3. The CurrentControLSet registry key for TrueCrypt
        4. Any .tc files present on the system, which would indicate the presence of
        volumes encrypted by TrueCrypt.

        .EXAMPLE
        Get-TrueCryptStatus -ComputerName host01.contoso.corp
        
        This will return a CSV file showing the status of TrueCrypt on the target device.

        .EXAMPLE
        Get-TrueCryptStatus -ComputerName $ComputerNames
        
        Provided $ComputerNames is an array of computer names, the script will process each one and 
        return the output for each device as a row in a CSV.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true,
                   Position = 0)]
        $ComputerName
    )
    
    # Begin testing connections to remote machines
    $global:LogStream += "$(Get-Date) : INFO : Testing connection to machines in list..."

    # Store reachable machines in new array
    $onlineComps = @()
    $ComputerNames | ForEach-Object {
        $currentComputer = $_
        if (Test-Connection $currentComputer -Count 1 -ErrorAction SilentlyContinue) {
            $onlineComps += $currentComputer

            # Logging
            $global:LogStream += "$(Get-Date) : INFO : $currentComputer -- STATUS -- ONLINE"
        
        }
        else {
            # Logging
            $global:LogStream += "$(Get-Date) : INFO : $currentComputer -- STATUS -- OFFLINE"

        }
    }

    $resultArray = @()
    $onlineComps | ForEach-Object {
        $session = New-PSSession -ComputerName $_
        $psArray = @()
        
        # Check for installation directories and any .tc files, which indicates an encrypted
        # container present on the system.
        $result = Invoke-Command -Session $session -ScriptBlock {
            $ErrorActionPreference = 'SilentlyContinue'
        
            $resultHash = New-Object System.Collections.Specialized.OrderedDictionary
            $resultHash += @{
                Hostname = $env:COMPUTERNAME
                TrueCrypt_Directory_Exists = Test-Path 'C:\Program Files\TrueCrypt'
                TrueCrypt_Executable_Exists = Test-Path 'C:\Program Files\TrueCrypt\TrueCrypt.exe'
                TrueCrypt_CCSKey_Exists = [bool](Get-Item 'HKLM:\SYSTEM\CurrentControlSet\Services\truecrypt')
                TC_Files_Present = [bool](get-childitem c:\ -Recurse -Filter *.tc)
            }
    
            $resulthash
        }

        $result = new-object -TypeName psobject -Property $result
        $resultArray += $result

    }

    $resultArray | Export-Csv C:\Temp\test.csv -nti
    $resultArray

}

# Configure global log object and log file location
$global:LogStream = @()
$datestamp = (Get-Date).ToShortDateString().Replace('/','_')
$logfileLocation = 'C:\temp\TrueCrypt' + '_' + $datestamp + '.log'

# Import CSV file containing list of computers; CSV must contain a column labeled 'hostname'
$ComputerCSV = Import-CSV 'FULL PATH TO CSV FILE'
$ComputerNames = $ComputerCSV.hostname

# Configure location of output CSV
$global:OutputCSVFile = 'C:\Temp\TrueCrypt' + '_' + $datestamp + '.log'

Get-TrueCryptStatus

# Output log file
$global:LogStream | Out-File $logfileLocation
