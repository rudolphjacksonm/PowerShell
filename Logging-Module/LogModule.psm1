function New-LogStream {
<#
    .SYNOPSIS
    Prepares Logging Environment
    
    .DESCRIPTION
    Creates a log file specified in the LogFile parameter and
    stores the project name in the Project parameter.

    .PARAMETER Project
    Specifies the name of the project. Accepts string values.
   
    .PARAMETER LogFile
    Specifies the location and name of the logfile. Must contain the FULL path to the file
    as well as the name of the file and extension (usually .txt).
    
    .Example
    New-LogStream -Project MyProject -LogFile 'C:\Scripts\log\logstream.txt'

    This command creates a new LogStream file and stores both the location to the logfile
    and the name of the project in a global variable. This is then referenced when running
    the Write-LogStream function.
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true,
                         Position = 0,
                         ValueFromPipelineByPropertyName = $true)]
        $Project,
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ValueFromPipelineByPropertyName = $true)]
        $LogFile

    )

    # Create global object containing project and logfile location
    $global:LogObject = New-Object -TypeName PSObject -Property @{
        'Project' = $Project
        'LogFile' = $LogFile

    }

    # Initialize LogFile
    New-Item -ItemType File -Path $LogFile
}

function Write-LogStream {
<#
    .SYNOPSIS
    Writes an event to logfile.
    
    .DESCRIPTION
    Writes a verbose log to a predefined logfile. Logs are written in the
    format DATE/TIME : PROJECT : LogType : LogMessage

    .PARAMETER Project
    Specifies the name of the project. Accepts string values.

    The Project parameter is optional. If it is not specified, the function
    will use the Project specified when New-LogStream was last ran. This
    is stored in the $global:LogObject global variable in the Project property.
   
    .PARAMETER LogMessage
    Specifies the message that will be written to the logfile. Accepts
    string values.

    .PARAMETER LogType
    Specifies the type of entry. Must be one of the following values:
    -DEV
    -INFO
    -WARN
    -ERROR
    -FAIL
    
    .Example
    Write-LogStream -LogType INFO -LogMessage "Successfully queried AD object."

    This command writes a new log entry with the type INFO and the message
    specified after the LogMessage parameter.

    .Example
    "Unable to connect to AD Domain Controller." | Write-LogStream -LogType FAIL

    This example shows how strings can be piped directly into Write-LogStream.

    .Example
    "Loaded AutoTask API Module." | Write-LogStream -LogType DEV -Project 'AutoTask'

    Specifying the optional Project parameter will change the project specified
    for this particular line. Any subsequent entries without -Project specified
    will return to the previous value.
#>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false,
                   Position = 0,
                   ValueFromPipelineByPropertyName = $true)]
        $Project,

        [Parameter(Mandatory = $true,
                   Position = 1,
                   ValueFromPipeline = $true)]
        [string]$LogMessage,

        [Parameter(Mandatory = $true,
                   Position = 2,
                   ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('INFO','WARN','ERROR','FAIL','DEV','PREP')]
        $LogType
    )

    # If we are working with multiple LogStreams and $Project is assigned a value
    # it should then be 
    if ($Project -eq $null) {
        $formattedProject = $global:LogObject | Select-Object -ExpandProperty Project
        $Log = "$(Get-Date) : $formattedProject : $LogType : $LogMessage"
        $Log | Out-File -Append $global:LogObject.LogFile
    
    }
    else {
        $Log = "$(Get-Date) : $Project : $LogType : $LogMessage"
        $Log | Out-File -Append $global:LogObject.LogFile

    }
}
