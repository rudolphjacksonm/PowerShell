$Computername = read-host "Enter computername"
Invoke-Command -ScriptBlock {
$Session = New-Object -ComObject Microsoft.Update.Session            
$Searcher = $Session.CreateUpdateSearcher()         
$HistoryCount = $Searcher.GetTotalHistoryCount()                  
$Searcher.QueryHistory(0,$HistoryCount) | ForEach-Object -Process {            
    # I can't seem to find any reason as to why this is in here. All KB's are structured the same, and any
    # KB that has a $Title would, by default, go through this loop.
    $Title = $null            
    if($_.Title -match "\(KB\d{6,7}\)") {            
        # Split returns an array of strings            
        $Title = ($_.Title -split '.*\((KB\d{6,7})\)')[1]            
    } 
    else{            
        $Title = $_.Title            
    }  

    $Result = $null            
    Switch ($_.ResultCode) {            
        0 { $Result = 'NotStarted'}            
        1 { $Result = 'InProgress' }            
        2 { $Result = 'Succeeded' }            
        3 { $Result = 'SucceededWithErrors' }            
        4 { $Result = 'Failed' }            
        5 { $Result = 'Aborted' }            
        default { $Result = $_ }            
    }
    
    New-Object -TypeName PSObject -Property @{            
        ComputerName = $Computername;
        InstalledOn = Get-Date -Date $_.Date;            
        KBArticle = $Title;            
        Name = $_.Title;            
        Status = $Result            
    }            
} | Sort-Object -Descending:$true -Property InstalledOn | Select -First 1
