Function Get-Room {
  [CmdletBinding()]
  Param(
    [Parameter(
      Mandatory = $true,
      Position = 0
    )]
    [Array]$Coordinates
  )
  # helper for retrieving coordinates and looking up the corresponding location

  # Look up the lcation based on coords
  $loc = $rooms | Where-Object {[String]$_.Coordinates -match [String]$Coordinates}
  $loc
}

Function Set-Room {
  [CmdletBinding()]
  Param(
    [Parameter(
      Mandatory = $true
    )]
    [Array]$Coordinates
  )
  # helper for setting player coordinates
  $newRoom = $rooms | Where-Object {[String]$_.Coordinates -match [String]$Coordinates}
  # Set player's coordinates
  $Hero.Coordinates = $newRoom.Coordinates
}

Function Show-Room {
  [CmdletBinding()]
  Param(
    [Array]$Coordinates
  )
  $room = $rooms | Where-Object {[String]$_.Coordinates -match [String]$Coordinates}
  Write-Output $room.Description
}