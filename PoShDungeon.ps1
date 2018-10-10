# Import classes
Get-ChildItem $PSScriptRoot/classes | Foreach-Object {
  . $_.FullName
}
Get-ChildItem $PSScriptRoot/helpers | ForEach-Object {
  . $_.FullName
}
#. $PSScriptRoot/classes/*classes.ps1

# Set background color
$HOST.UI.RawUI.BackgroundColor = "Black"

# Begin Game
Write-Host @"

:::::::::   ::::::::   ::::::::  :::    :::  :::::::::  :::    ::: ::::    :::  ::::::::  :::::::::: ::::::::  ::::    :::
:+:    :+: :+:    :+: :+:    :+: :+:    :+:  :+:    :+: :+:    :+: :+:+:   :+: :+:    :+: :+:       :+:    :+: :+:+:   :+:
+:+    +:+ +:+    +:+ +:+        +:+    +:+  +:+    +:+ +:+    +:+ :+:+:+  +:+ +:+        +:+       +:+    +:+ :+:+:+  +:+
+#++:++#+  +#+    +:+ +#++:++#++ +#++:++#++  +#+    +:+ +#+    +:+ +#+ +:+ +#+ :#:        +#++:++#  +#+    +:+ +#+ +:+ +#+
+#+        +#+    +#+        +#+ +#+    +#+  +#+    +#+ +#+    +#+ +#+  +#+#+# +#+   +#+# +#+       +#+    +#+ +#+  +#+#+#
#+#        #+#    #+# #+#    #+# #+#    #+#  #+#    #+# #+#    #+# #+#   #+#+# #+#    #+# #+#       #+#    #+# #+#   #+#+#
###         ########   ########  ###    ###  #########   ########  ###    ####  ########  ########## ########  ###    ####

"@ -ForegroundColor Red -BackgroundColor Black

$name = Read-Host "What is your name?"
$startingWeapon = Get-Weapon 'brokenshortsword'
$startingArmor = Get-Armor 'Cloth_Sack'
$global:Hero = [Hero]::new($name, $startingWeapon, $startingArmor)

#Equip-Armor $(Get-Armor -Armor $Hero.armor)


Write-Host "You're on the first floor of the dungeon."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "You see a wooden staircase in the distance. Shafts of sunlight coming through the ceiling are mottled with dust."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "The staircase spirals down at a sickening angle. You can't quite make out what is at the bottom."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "As you make your descent, you hear footsteps below you. You aren't sure how far away they are."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")

Write-Host "A skeleton leaps out of the shadows!"

$skeleton = [skeleton]::new('Skeleton')

Battle -Attacker $Skeleton -Defender $Hero

if ($Hero.Status -match 'Dead') {
  Write-Host "GAME OVER" -ForegroundColor Red
  Start-Sleep -10 seconds
  Exit
}

Write-Host "You're on the second floor of the dungeon."
Write-Host "To the East and West are damp stone walls. To the North is a long corridor with a chamber at the end."
Write-Host "What do you want to do next?"

# Bring up prompt here with options: [I] for inventory, [M] for map, [Q] for quit, [L] for look

