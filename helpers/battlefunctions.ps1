function Get-BattleWindow {
    Param(
        $Attacker,
        $Defender,
        [int]$Turn
    )
    
$window = @"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Turn: $Turn
Attacker: $($Attacker.Name) Status: $($Attacker.Status) Health: $($Attacker.Health)
Defender: $($Defender.Name) Status: $($Defender.Status) Health: $($Defender.Health)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"@

$window
    
}

function Battle {
    Param(
        $Attacker,
        $Defender

    )

    # Set turn to 1
    $turn = 1

    Write-Output "~[BATTLE START]~"
    Get-BattleWindow -Attacker $Attacker -Defender $Defender -Turn 0

    # Quick health check on both creatures
    if (($Attacker.Health -eq 0) -or ($Defender.Health -eq 0)) {
        Write-Output "Cannot fight, one of these creatures is already dead."
        Write-Output "[BATTLE END]"

    }

    :battle while (($Attacker.Health -gt 0) -and ($Defender.Health -gt 0)) {
$AttackerAction = Read-Host @"
Select an action:
1. Attack
2. Heal
3. Run!

"@

        switch ($AttackerAction) {
            1 {
                # Hit the defender
                $Defender.Hit(50)
                Write-Output "$($Defender.Name) was hit!"

            }

            2 {
                $Attacker.Heal(5)
                Write-Output "$($Attacker.Name) healed for x health."

            }

            3 {
                Write-Output "You decided to flee from battle."
                Break battle

            }

            Default {
                Write-Output "Please select a valid option."
            
            }

        }

        # Defender action
        $DefenderAction = Get-Random -Minimum 1 -Maximum 3

        switch ($DefenderAction) {
            1 {
                $Attacker.Hit(20)
                Write-Output "$($Defender.Name) attacked!"
            
            }

            2 {
                $Defender.Heal(5)
                Write-Output "$($Defender.Name) healed for x health!"

            }           
        }
        $turn += 1
        Get-BattleWindow -Attacker $Attacker -Defender $Defender -Turn $turn


    } 
}