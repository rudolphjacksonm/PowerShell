# Query Appliance ID from local ApplianceConfig.xml file
function Get-ApplianceID {
    [CmdletBinding()]
    Param(
    )

    $xml = [xml](Get-Content 'C:\Program Files (x86)\N-able Technologies\Windows Agent\config\ApplianceConfig.xml')
    $ApplianceID = $xml.ApplianceConfig | select -ExpandProperty applianceid
    $FormattedApplianceID = "NOC:$ApplianceID"
    $FormattedApplianceID

}
