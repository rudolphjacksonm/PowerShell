# Pre-requisite function to create EventID Source for logging.
function New-EventLogSource {
    [CmdletBinding()]
    param(
    )

    # check if the eventSourceName exists for the application log
    $eventSourceName = 'N-Central Appliance ID'
    $eventSourceExists = [bool](Get-WmiObject win32_nteventlogfile -Filter "logfilename='Application'" | Where-Object {$_.Sources -like $eventSourceName})

    if(!($eventSourceExists)){
        New-EventLog -LogName 'Application' -Source $eventSourceName
        
        # Logging
        $global:LogStream += "$(Get-Date), created event log source 'N-Central Appliance ID.'"
    }
}

# Creates Event Log entry
function New-NCentralPresenceLog {
    [CmdletBinding()]
    Param 
    (
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ValuefromPipelinebyPropertyName = $true)]
        $eventMessage,

        [Parameter(Mandatory = $true,
                   Position = 1,
                   ValuefromPipelinebyPropertyName = $true)]
        $eventID,

        [Parameter(Mandatory = $true,
                   Position = 2,
                   ValuefromPipelinebyPropertyName = $true)]
        $EventEntryType
    )

    # Run this function first to verify event log source exists
    New-EventLogSource

    $eventlogprops = @{
        'EventID' = $eventID
        'EntryType' = $EventEntryType
        'Message' = $eventMessage
        'Source' = 'N-Central Appliance ID'
        'LogName' = 'Application'
        
    }

    Write-EventLog @eventlogprops -ErrorAction Stop

}

