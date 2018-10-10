function Get-Weapon {
  Param(
    $WeaponName
  )

  switch ($WeaponName) {
    BrokenShortsword {
      $weaponObj = @{
          Name = 'Broken_Shortsword'
          minDamage = 1
          maxDamage = 6
          Description = @"

  |A rusty sword hilt with 
  |a few inches of steel still protruding.
  |It has some jagged edges that
  | might scratch someone.
"@
      }
    }

    ShortSword {
      $weaponObj = @{
          Name = 'Short_Sword'
          minDamage = 3
          maxDamage = 9
          Description = @"
                    
  |A short blade with a sturdy iron hilt. The pommel is decorated with
  |a crescent surrounding a small skull.
"@
      }
    }

    Hatchet {
      $weaponObj = @{
        Name = 'Hatchet'
        minDamage = 5
        maxDamage = 7
        Description = @"

  |A wedge of honed iron attached to a polished wood pole.
  |It's not the most refined weapon but it will do.
"@
      }
    }

    Longsword {
      $weaponObj = @{
        Name = 'Long_Sword'
        minDamage = 8
        maxDamage = 14
        Description = @"

  |A long, steel blade in a steel hilt. It's been polished to a 
  |mirrored reflection and reaches quite far.
"@
      }
    }

    Zweihander {
      $weaponObj = @{
        Name = 'Zweihander'
        minDamage = 9
        maxDamage = 20
        Description = @"

  |A heavy steel blade that requires two hands to weild.
  |Can easily cleave through bone.
"@
      }
    }

    Default {
        Write-Output 'Not a valid weapon.'
      }
    }
    
  # Spit out hash table
  $weaponObj
}

function Equip-Weapon {
  Param(
    [hashtable]$Weapon
  )

    $Hero.Weapon = $Weapon.Name
    $Hero.WeaponStats = $Weapon

}

function Equip-Armor {
  Param(
    [hashtable]$Armor
  )
  $Hero.Armor = $Armor.Name
  $Hero.ArmorStats = $Armor
}