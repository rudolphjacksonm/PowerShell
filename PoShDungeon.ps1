# Import classes
. .\classes.ps1

# Set background color
$HOST.UI.RawUI.BackgroundColor = "Black"
cmd /c cls

# Import helper functions
. .\helpers\battlefunctions.ps1

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
$Hero = [human]::new($name)

Write-Host "You're on the first floor of the dungeon."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "You see a wooden staircase in the distance. Shafts of sunlight coming through the ceiling are mottled with dust."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "The staircase spirals down at a sickening angle. You can't quite make out what is at the bottom."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
Write-Host "As you make your decent, you hear footsteps below you. You aren't sure how far away they are."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")

Write-Host "A skeleton leaps out of the shadows!"

$skeleton = [skeleton]::new('Skeleton')

Battle -Attacker $Hero -Defender $skeleton