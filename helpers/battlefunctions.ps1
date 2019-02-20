function Get-BattleWindow {
  Param(
    $Attacker,
    $Defender,
    [int]$Turn
  )
  cls
  Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" -BackgroundColor DarkRed -ForegroundColor Gray
  Write-Host "Turn: $Turn                                                     " -BackgroundColor DarkRed -ForegroundColor Gray
  Write-Host "Attacker: $($Attacker.Name) Status: $($Attacker.Status) Health: $($Attacker.Health)" -BackgroundColor DarkRed -ForegroundColor Gray
  Write-Host "Defender: $($Defender.Name) Status: $($Defender.Status) Health: $($Defender.Health)" -BackgroundColor DarkRed -ForegroundColor Gray
  Write-Host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" -BackgroundColor DarkRed -ForegroundColor Gray
  if ($Defender.Status -match 'Dead') {
    # Final clear screen if battle is over
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
    cls
  }
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
    Write-Output "ERROR: Cannot fight, one of these creatures is already dead!"
    Write-Output "[BATTLE END]"

  }

  # If Attacker is not a hero type object, it's an Ambush and the enemy goes first.
  if ($checkAttacker -notmatch 'Hero') {
    # Set turn to 1
    $turn = 1

    Write-Host "~[BATTLE START]~" -ForegroundColor Black -BackgroundColor DarkYellow
    Write-Host "AMBUSH! Enemy goes first." -ForegroundColor Black -BackgroundColor DarkYellow

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
              $Attacker.Heal(2)
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
            $HeroDmg = Get-HeroDamage
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
            $HeroDmg = Get-HeroDamage
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
  <#
    .SYNOPSIS
    Determines the damage output of an enemy creature.

    .DESCRIPTION
    Different creature types output different amounts of damage. Skeletons
    are fairly weak and thus output a consistent but fairly weak amount
    of damage. Orcs are strong but slightly unpredictable so their damage is variable.
  #>
  Param(
    $character
  )


  switch ($character.GetType().Name) {
    Orc {
      $damage = Get-Random -Minimum 1 -Maximum 26

    }
    Skeleton {
      $damage = Get-Random -Minimum 1 -Maximum 3

    }
  }

  $damage
}

Function Get-Heal {
  <#
    .SYNOPSIS
    Returns a random integer value of hitpoints healed
    between 2 and 7.
  #>
  $healpoints = Get-Random -Minimum 2 -Maximum 7
  $healpoints

}

Function Get-HeroDamage {
  <# 
    .SYNOPSIS
    Returns a random integer value from the range of the Hero's
    minimum and maximum damage.
  #>
  [CmdletBinding()]
  Param(
  )

  $maxDamage = $Hero.Weapon.maxDamage
  $minDamage = $Hero.Weapon.minDamage
  Write-Verbose "Hero weapon: $($Hero.Weapon)  Value: $($Hero.Weapon.Value__)"
  Write-Verbose "Hero is dealing damage between $minDamage and $maxDamage"

  Get-Random -Minimum $minDamage -Maximum $maxDamage

}