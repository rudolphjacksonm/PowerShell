# Main Script #

# Initiate LogStream
$global:LogStream = @()

# Import helper files
. .\helpers\Get-ApplianceID.ps1
. .\helpers\Update-ApplianceID.ps1
. .\helpers\New-NRCEventLog.ps1

# Query Appliance ID from local ApplianceConfig.xml file
$ApplianceID = Get-ApplianceID

# Prepare Active Directory search objects
Update-ApplianceID -ApplianceID $ApplianceID
