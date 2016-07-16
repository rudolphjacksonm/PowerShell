# Initiate LogStream
$global:LogStream = @()

function Set-Hibernation {
    [CmdletBinding()]
    param(
    )

    # Queries the power settings of the device via registry key
    $KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power"

    $CurrentHibernationValue = Get-ItemProperty $KeyPath | select -ExpandProperty HibernateEnabled
    
    if ($CurrentHibernationValue -eq 1) {
        try {
            cmd /c 'powercfg.exe -h off'
            
            # Logging
            $global:Logstream += "$(Get-Date), disabled hibernation on target device."

        }
        catch{
            $global:Logstream += "$(Get-Date), Could not disable hibernation on target device."

        }
    }
    else{
        $global:Logstream += "$(Get-Date), hibernation already disabled, no action taken."

    }

    $global:Logstream
}

function Get-Hibernation {
    [CmdletBinding()]
    param(
    )

    # Queries the power settings of the device via registry key
    $KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Power"

    $CurrentHibernationValue = Get-ItemProperty $KeyPath | select -ExpandProperty HibernateEnabled
    
    Write-Output $CurrentHibernationValue
}

try {
    $HibernationKeyValue = Get-Hibernation
    
    if ($HibernationKeyValue -eq 1) {
        $global:LogStream += "$(Get-Date), hibernation is currently enabled, key value: $HibernationKeyValue"

    }
    else {
        $global:LogStream += "$(Get-Date), hibernation is currently disabled, key value: $HibernationKeyValue"

    }
}
catch{
    $global:LogStream += "$(Get-Date), could not query hibernation settings."

}

$global:LogStream
