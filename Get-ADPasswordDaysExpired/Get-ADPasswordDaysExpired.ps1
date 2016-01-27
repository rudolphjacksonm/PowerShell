#Import AD module in to Powershell
Import-Module ActiveDirectory

function Get-PasswordDaysExpired {
    [CmdletBinding()]
    param(
    [parameter(
    Mandatory = $true,
    ValuefromPipelinebypropertyname = $true)]
    $SamAccountName,

    [parameter(
    Mandatory = $true,
    ValuefromPipelinebypropertyname = $true)]
    ${msds-userpasswordexpirytimecomputed}
   
    )

    begin{
    }
    process{
    
        $ExpiryDate = [datetime]::FromFileTime(${msds-userpasswordexpirytimecomputed})
        $DaysSincePasswordExpired = (Get-Date).DayofYear - ($ExpiryDate).DayOfYear
   
        if ($DaysSincePasswordExpired -ge 0) {

            $UserAccountStatus = New-Object -TypeName PSObject -Property @{AccountName=$SamAccountName; DaysExpired=$DaysSincePasswordExpired}
            }

        $UserAccountStatus
    }
    end{
    }
}
