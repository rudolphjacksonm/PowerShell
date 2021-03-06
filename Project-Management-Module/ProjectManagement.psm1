# Moves src code to stable and excludes Pester unit testing file
# Further code (to be added) will run unit tests and, if 
# successful, continue with copy the code to stable.

function Copy-SrcToStable {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false,
                   Position = 0)]
        $Location

    )

    # Verify project directories exist within current working directory

    $VerifySrc = Test-Path 'src'
    $VerifyStable = Test-Path 'stable'

    if ($VerifySrc -and $VerifyStable) {
        # Get src directory
        $SourceDir = Get-ChildItem 'src'
        
        # Flat files at root of directory; exclude Pester test file when moving to stable
        $SourceDir | Where-Object {$_.psiscontainer -eq $false -and $_.Name -notlike '*Tests.ps1'} | select -ExpandProperty FullName | Copy-Item -Destination Stable -Force

        # Subfolders, resursively copied
        $sourcedir | Where-Object {$_.psiscontainer -eq $true -and $_.Name -notlike '*_flatscript*'} | Select -exp FullName | Copy-Item -Recurse -Destination stable -Force

    }
    else {
        Write-Output "No src or stable folder in current working directory: $pwd"

    }
}

<# 
# Creates project folder structure
# If neither name nor path are specified, creates project tree in
# current directory.
#>

function New-ProjectTree {
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $false,
        Position = 0)]
        [string]$Name,

        [Parameter(Mandatory = $false,
                   Position = 1)]
        [string]$Path


    )

    # If path is specified, check to see if directory specified at path exists.
    # If directory does not exist, create it.

    if ($Path) {
        $VerifyDirectory = Test-Path $Path
        Write-Verbose "Verifying directory specified at $path exists..."

        if ($VerifyDirectory) {
            Write-Verbose "Creating project tree at $path..."
            
            # Create src directory
            try {
                New-Item -ItemType Directory ($Path + '\src')
                New-Item -ItemType Directory ($Path + '\stable')
                New-Item -ItemType Directory ($Path + '\src\helpers')
                New-Item -ItemType Directory ($Path + '\_flatscript')

            }
            catch {
            }
        }
        else {
            # Prompt user to create non-existent directory
            $PrompToCreate = Read-Host -Prompt "The directory $Path does not exist. Create it? [Y/N]"

            if ($PrompToCreate -match 'Y') {
                
                try {
                    New-Item -ItemType Directory $Path
                    New-Item -ItemType Directory ($Path + '\src')
                    New-Item -ItemType Directory ($Path + '\stable')
                    New-Item -ItemType Directory ($Path + '\src\helpers')
                    New-Item -ItemType Directory ($Path + '\_flatscript')

                }
                catch {

                }
            }
            elseif ($PrompToCreate -match 'N') {
                Break

            }
            else {
                Write-Output "Invalid input, please specify Yes [Y] or No [N]."
                
            }
        }
    }
    else {
        if ($Name) {
            New-Item -ItemType Directory $Name
            New-Item -ItemType Directory $Name\src
            New-Item -ItemType Directory $Name\stable
            New-Item -ItemType Directory $Name\src\helpers
            New-Item -ItemType Directory $Name\_flatscript

        }
        else {
            # Create project directory in current working directory
            New-Item -ItemType Directory src
            New-Item -ItemType Directory stable
            New-Item -ItemType Directory src\helpers
            New-Item -ItemType Directory _flatscript

        }
    }
}

# Flatten project directory in to runscript and drop in _flatscript folder

function Compile-Project {
    [CmdletBinding()]
    Param
    (
    )

    # Get Scripts from current (working) project directory
    try { 
        $mainScriptFile = Get-Item .\stable\*.ps1 -ErrorAction Stop
    
    }
    catch {
        Write-Output "No stable folder detected in current working directory: $pwd."
        Write-Output "Switch to a project directory and run Compile-Project."

    }

	$parameters = Get-ScriptParameters -FullName $mainScriptFile.Fullname

	$scriptBody = Get-ScriptBody -FullName $mainScriptFile.Fullname

	$flatScriptFile = @()
	$flatScriptFile += $parameters 
	$flatScriptFile += ' ' 
	$flatScriptFile += $scriptBody

	# Output the final script
	$flatScriptOutput = "$pwd\_flatscript\$($mainScriptFile.Name)" -replace '(.*).ps1','$1_flatScript.ps1'
	$flatScriptFile | Out-File $flatScriptOutput

}

<# Below are 'helper' functions that handle flattening of files in to one
## runscript file. Runscript files are used for N-Central AMPs (Automation
## Policies)
## 
## Below written by Stephen Testino
#>

function Get-ScriptParameters {
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $FullName
    )

    $paramEnd = Get-Content $FullName | Select-String '^[)]$' | Select-Object -ExpandProperty LineNumber

    $parameters = (Get-Content $FullName)[0..$paramEnd] -match '(^(?!.*=\$)).*[$]' -replace '[[].*[]]','' -replace ',',''

    $parameters
}

function Get-ScriptBody {
    param(
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $FullName
    )

    $paramEnd = Get-Content $FullName | Select-String '^[)]$' | Select-Object -ExpandProperty LineNumber

    $scriptEnd = Get-Content $FullName | Measure-Object | Select-Object -ExpandProperty Count

    $scriptBody = (Get-Content $FullName)[$paramEnd..$scriptEnd] 

  

    $script = @()
    $scriptBody |  ForEach-Object { 
        if($_ -notmatch 'Import[-]Module\s'){
            $script += $_

        }
        else{
            $nestedScript = Get-Content ($_ -replace 'Import[-]Module\s[$]global[:]ScriptRoot\\','stable\')

            $nestedScript |  ForEach-Object { 
                    $nestedScript = Get-Content ($_ -replace '[.] [.]\\','stable\\').trimstart()

                    $script += $nestedScript

                }
            }
        }
    }
