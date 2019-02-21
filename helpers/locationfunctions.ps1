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

Function Move-Location {
  [CmdletBinding()]
  Param(
    [Array]$Coordinates,
    [String]$Direction
  )
  switch ($Direction) {
    'North' {
      $Hero.Coordinates[1] += 1
    }
    'East' {
      $Hero.Coordinates[0] += 1
    }
    'South' {
      $Hero.Coordinates[1] = +- 1
    }
    'West' {
      $Hero.Coordinates[0] +- 1
    }
  }
}