<#
    Work in Progress
#>

#Initial variables
$ServerName = Get-Content env:computername
$OperatingSystemSourcePath = "\\$ServerName\path-to-your-wim-file(s)"
$OperatingSystemFileName = "OperatingSystemFileName.wim"

Function Create-DeploymentShare {
    [CmdletBinding()]
    param(
    )
    
    try {
        #Add necessary Snap-In and Module
        Add-PSSnapin Microsoft.BDD.PSSnapin
        Import-Module "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
        
        #Attempt to create share and map persistent PSDrive
        New-Item -Path "C:\DeploymentShare" -ItemType directory
        new-PSDrive -Name "DS002" -PSProvider "MDTProvider" -Root "C:\DeploymentShare" -Description "MDT Deployment Share" -NetworkPath "\\$ServerName\DeploymentShare$" -Verbose | add-MDTPersistentDrive -Verbose
        New-PSDrive -Name "DS002" -PSProvider MDTProvider -Root "C:\DeploymentShare"

        #Import Operating System
        import-mdtoperatingsystem -path "DS002:\Operating Systems" -SourcePath "$OperatingSystemPath" -DestinationFolder "Windows 7 x64" -Verbose

        #Building out Task Sequence
        import-mdttasksequence -path "DS002:\Task Sequences" -Name "Windows 7 Image" -Template "Client.xml" -Comments "Task Sequence created via Windows Powershell" -ID "dep7" -Version "1.0" -OperatingSystemPath "DS001:\Operating Systems\$OperatingSystemFileName" -FullName "Windows User" -OrgName "Contoso" -HomePage "https://www.google.com" -AdminPassword "pass@word1" -Verbose
    }
    catch{
        $ResultCode = $_
        $ResulteCode.Exception
    }
    else{
        Write-Output "Unexpected error encountered."
    }
}

Create-DeploymentShare
