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
