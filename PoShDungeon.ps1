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
$global:Hero = [Hero]::new($name, $startingWeapon, $startingArmor, @(0,0,0))

# Tutorial level
# Start
Show-Room $Hero.Coordinates
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Set-Room -Coordinates @(1,0,0)
# Hallway
Show-Room $Hero.Coordinates
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "A skeleton leaps out of the shadows!"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
# $skeleton = [skeleton]::new('Skeleton')
$room = Get-Room -Coordinates $Hero.Coordinates
$enemy = New-Object -Typename $Room.Enemy
cls
Battle -Attacker $enemy -Defender $Hero
if ($Hero.Status -match 'Dead') {
  Write-Host "GAME OVER" -ForegroundColor Red
  Start-Sleep -10 seconds
  Exit
}
# Staircase
Set-Room -Coordinates @(2,0,0)
Show-Room $Hero.Coordinates
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
# Staircase B1
Set-Room -Coordinates @(2,0,1)
Show-Room -Coordinates @(3,0,1)
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
# While you are not at the 'credits' room and you are still alive, proceed through dungeon
while (([String]$Hero.Coordinates -notmatch '10, 10, 10') -and ($Hero.Status -match 'Alive')) {
  # Display location
  Show-Room -Coordinates $Hero.Coordinates
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
  cls
  # Display Choice Menu - prompt with options:
  # [N] - North [W] - West [E] - East [S] - South
  # Get-Menu

}
