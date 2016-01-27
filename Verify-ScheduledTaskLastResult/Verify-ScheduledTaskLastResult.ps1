. .\helpers\Get-ScheduledTasks.ps1

function Verify-ScheduledTaskLastResult {
    <#
    Ver. 0.9
    Written by Jack Morris and Stephen Testino
    .SYNOPSIS
    Verifies that the tasks specified in the pipeline ran correctly.
    
    .EXAMPLE
    Get-ScheduledTasks | where-object {$_.name -like "google*"} | Verify-ScheduledTaskLastResult
    
    Output displays the following:
    TaskName        TaskResult
    --------        ----------
    Task 1              False
    Task 2               True
    Task 3               True
    
    Tasks that ran successfully display "True," otherwise will display "False."
#>
    param (
    [CmdletBinding()]
    
    [Parameter(
        Mandatory=$true,
        ValuefromPipelineByPropertyName = $true)]
        $Name,

    [Parameter(
            Mandatory=$true,
            ValuefromPipelineByPropertyName = $true)]
            $LastTaskResult
    )

    begin{

    }
    process{

        #Create $Verify object which stores each task's name as a property
        #Create $BooleanValue which evaulates to true/false
        
        $Verify = New-Object -TypeName PSObject
        $verify | Add-Member -MemberType NoteProperty -Name TaskName -Value $Name
        $BooleanValue = [Bool]

        #If statement checks whether task result is equal to "0," which is the success code
       
        if ($LastTaskResult -ne 0){
            $BooleanValue = $false

        }
        else {
            $BooleanValue = $true

        }
        
        
        #Creates property for whether it succeeded or failed, and outputs this along with the taskname property
        $verify | Add-Member -MemberType NoteProperty -Name TaskResult -Value $BooleanValue
        $verify
    }

    end{
    }    
}

