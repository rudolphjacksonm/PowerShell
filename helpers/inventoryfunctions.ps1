function Get-InventoryWindow {
    Param (
        [hero]$hero
        
    )

    # Display inventory window
    $InventoryWindow = @"
  +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  |          Inventory          
  |Hero Name: $($global:Hero.Name)
  |Armor: $($global:Hero.Armor)
  |Weapon: $($global:Hero.Weapon)
  |--Damage: $($global:Hero.WeaponStats.MinDamage) - $($global:Hero.WeaponStats.MaxDamage)
  |Gold: 0
  |Contents of rucksack:                 
  +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Enter a choice:
  1. Swap Weapon
  2. Swap Armor
  3. Examine Rucksack
  'Q' to exit Inventory
"@

    # Display weapon window
    $WeaponWindow = @"

$($global:Hero.WeaponStats.Image)
  +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  |Weapon: $($global:Hero.Weapon)
  |Description: $($global:Hero.WeaponStats.Description)
  +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  |Enter a choice:
  |1. Back to Inventory
  |2. Back to Inventory
  +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"@

    $response = ''
    :mainLoop while ($response -notmatch 'q') {
        $InventoryWindow
        $response = Read-Host 'Enter a choice'

        :weaponWindow while ($response -eq 1) {
            # weapon window
            $WeaponWindow
            $response = Read-Host 'Enter a choice'

            if ($response -eq 1) {
                break
            }
        }
        
    }
}