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

Write-Host $window -ForegroundColor Gray
    
}

function Battle {
  Param(
    $Attacker,
    $Defender,
    [bool]$Ambush

  )

  # Determine if attacker is the Hero character or an enemy
  $checkAttacker = $Attacker.GetType().name

  # Quick health check on both creatures
  if (($Attacker.Health -eq 0) -or ($Defender.Health -eq 0)) {
    Write-Output "Cannot fight, one of these creatures is already dead."
    Write-Output "[BATTLE END]"

  }

  # If Attacker is not a hero type object, it's an Ambush and the enemy goes first.
  if ($checkAttacker -notmatch 'Hero') {
        # Set turn to 1
        $turn = 1

        Write-Output "~[BATTLE START]~"
        Write-Output "AMBUSH! Enemy goes first."

        :battle while (($Attacker.Health -gt 0) -and ($Defender.Health -gt 0)) {
            
            # Attacker action
            if ($Attacker.Health -le 0) {
                break
            }

            $AttackerAction = Get-Random -Minimum 1 -Maximum 3

            switch ($AttackerAction) {
                1 {
                    $damage = Get-Damage -character $Attacker
                    $Defender.Hit($damage)
                    Write-Output "$($Attacker.Name) attacked for $damage damage!"
                
                }

                2 {
                    $healpoints = Get-Heal
                    $Attacker.Heal(5)
                    Write-Output "$($Attacker.Name) healed for $healpoints health!"

                }           
            }
            Write-Output ""
            Get-BattleWindow -Attacker $Attacker -Defender $Defender -Turn $turn

            if ($Defender.Health -le 0) {
                break
                
            }
$DefenderAction = Read-Host @"
Select an action:
1. Attack
2. Heal
3. Run!

"@

          switch ($DefenderAction) {
              1 {
                  # Hit the Attacker
                  $HeroDmg = Get-HeroDamage $global:Hero
                  $Attacker.Hit($HeroDmg)
                  Write-Output "$($Attacker.Name) was hit!"

              }

              2 {
                  # Heal yourself
                  $healpoints = Get-Heal
                  $Defender.Heal($healpoints)
                  Write-Output "$($Defender.Name) healed for $healpoints health."

              }

              3 {
                  Write-Output "You decided to flee from battle."
                  Break battle

              }

              Default {
                  Write-Output "Please select a valid option."
              
              }

          }
          $turn += 1
          Get-BattleWindow -Attacker $Attacker -Defender $Defender -Turn $turn

      }
  }
  else {
    # Set turn to 1
    $turn = 1

    Write-Output "~[BATTLE START]~"
    Get-BattleWindow -Attacker $Attacker -Defender $Defender -Turn $turn

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
                    $HeroDmg = Get-HeroDamage $global:Hero
                    $Defender.Hit($HeroDmg)
                    Write-Output "$($Defender.Name) was hit!"

                }

                2 {
                    $healpoints = Get-Heal
                    $Attacker.Heal($healpoints)
                    Write-Output "$($Attacker.Name) healed for $healpoints health."

                }

                3 {
                    Write-Output "You decided to flee from battle."
                    Break battle

                }

                Default {
                    Write-Output "Please select a valid option."
                
                }

            }

            Get-BattleWindow -Attacker $Attacker -Defender $Defender -Turn $turn

            # Defender action
            if ($Defender.Health -le 0) {
                break
            }
            
            $DefenderAction = Get-Random -Minimum 1 -Maximum 3

            switch ($DefenderAction) {
                1 {
                    $damage = Get-Damage -character $Defender
                    $Attacker.Hit($damage)
                    Write-Output "$($Defender.Name) attacked for $damage damage!"
                
                }

                2 {
                    $healpoints = Get-Heal
                    $Defender.Heal($healpoints)
                    Write-Output "$($Defender.Name) healed for $healpoints health!"

                }           
            }
            $turn += 1
            Get-BattleWindow -Attacker $Attacker -Defender $Defender -Turn $turn
        }
    }
}

Function Get-Damage {
  Param(
    $character
  )


  switch ($character.GetType().Name) {
    Orc {
      $damage = Get-Random -Minimum 3 -Maximum 26

    }
    Skeleton {
      $damage = Get-Random -Minimum 2 -Maximum 16

    }
  }

  $damage
}

Function Get-Heal {
  $healpoints = Get-Random -Minimum 2 -Maximum 7
  $healpoints

}

Function Get-HeroDamage {
  [CmdletBinding()]
  Param(
    [Hero]$Hero
  )

  if ($Hero.Weapon.Value__ -le 7) {
    $maxDamage = ($Hero.Weapon.Value__ + 1)
    $minDamage = 1
    Write-Verbose "Hero is dealing damage between $minDamage and $maxDamage"

  }
  else {
    $maxDamage = ($Hero.Weapon.Value__ + 1)
    $minDamage = ([math]::round($Hero.Weapon.Value__ / 5) - 1)
    Write-Verbose "Hero is dealing damage between $minDamage and $maxDamage"
  }

  Get-Random -Minimum $minDamage -Maximum $maxDamage

}