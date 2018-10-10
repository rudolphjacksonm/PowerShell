function Get-Armor {
  Param(
    $ArmorName
  )

  switch ($ArmorName) {
    Cloth_Sack {
      $ArmorObj = @{
          Name = 'Cloth_Sack'
          minDamage = 1
          maxDamage = 4
          Description = @"
  |A rusty sword hilt with 
  |a few inches of steel still protruding.
  |It has some jagged edges that
  | might scratch someone.
"@
      }
    }

    Ragged_Leather_Coat {
      $ArmorObj = @{
          Name = 'Ragged_Leather_Coat'
          minDamage = 3
          maxDamage = 9
          Description = @"              
  |A short blade with a sturdy iron hilt. The pommel is decorated with
  |a crescent surrounding a small skull.
"@
      }
    }

    Rusty_Chainmail {
      $ArmorObj = @{
        Name = 'Rusty_Chainmail'
        minDamage = 5
        maxDamage = 7
        Description = @"

  |A wedge of honed iron attached to a polished wood pole.
  |It's not the most refined Armor but it will do.
"@
      }
    }

    Dented_Breastplate {
      $ArmorObj = @{
        Name = 'Dented_Breastplate'
        minDamage = 8
        maxDamage = 14
        Description = @"

  |A long, steel blade in a steel hilt. It's been polished to a 
  |mirrored reflection and reaches quite far.
"@
      }
    }

    Default {
        Write-Output 'Not a valid Armor.'
      }
    }
    
  # Spit out hash table
  $ArmorObj
}

function Equip-Armor {
  Param(
    [hashtable]$Armor
  )

    $Hero.Armor = $Armor.Name
    $Hero.ArmorStats = $Armor

}

function Equip-Armor {
  Param(
    [hashtable]$Armor
  )
  $Hero.Armor = $Armor.Name
  $Hero.ArmorStats = $Armor
}