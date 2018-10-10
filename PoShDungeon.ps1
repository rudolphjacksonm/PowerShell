# Import classes
Get-ChildItem $PSScriptRoot/classes | Foreach-Object {
  . $_.FullName
} 
#. $PSScriptRoot/classes/*classes.ps1

# Set background color
$HOST.UI.RawUI.BackgroundColor = "Black"

# Import helper functions
. $PSScriptRoot/helpers/battlefunctions.ps1
. $PSScriptRoot/helpers/inventoryfunctions.ps1

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
$global:Hero = [Hero]::new($name)

Write-Host "You're on the first floor of the dungeon."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "You see a wooden staircase in the distance. Shafts of sunlight coming through the ceiling are mottled with dust."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "The staircase spirals down at a sickening angle. You can't quite make out what is at the bottom."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "As you make your descent, you hear footsteps below you. You aren't sure how far away they are."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")

Write-Host "A skeleton leaps out of the shadows!"

$skeleton = [skeleton]::new('Skeleton', 10)

Battle -Attacker $Skeleton -Defender $Hero

if ($Hero.Status -match 'Dead') {
    Write-Host "GAME OVER" -ForegroundColor Red
    Start-Sleep -10 seconds
    Exit
}

Write-Host "You're on the second floor of the dungeon."
Write-Host "What do you want to do next?"
# Bring up prompt here with options: [I] for inventory, [M] for map, [Q] for quit, [L] for look

