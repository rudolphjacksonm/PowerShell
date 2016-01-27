<# 
   Ver 1.0
   Written by Jack Morris and Stephen Testino
   
   .SYNOPSIS
   Stores raw output for all scheduled tasks on local machine as an object ($tasks)
   
   .EXAMPLE
   Get-ScheduledTasks | where-object {$_.name -like "google*"}
#>
function Get-ScheduledTasks {
    [cmdletbinding()]

    $schedule = New-Object -ComObject Schedule.Service
    $schedule.connect("localhost")
    $tasks = $schedule.GetFolder("\").gettasks(0)
    $tasks
}
