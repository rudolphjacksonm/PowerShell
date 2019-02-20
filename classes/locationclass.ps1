class Location {
  # Properties
  [Array]$Coordinates       = @(0, 0, 0)
  [String]$Name             = "Default"
  [String]$Description      = "Default"
  [String]$AltDescription   = "AltDefault"
  [Boolean]$Visited         = $false
  [String]$Enemy

  # Parameterless constructor
  Location () {}

  Location ([String]$Name) {
    $this.Name = $Name
  }
  
  # Standard constructor
  Location ([Array]$Coordinates, [String]$Name, [String]$Description, [String]$AltDescription) {
    $this.Coordinates       = $Coordinates
    $this.Name              = $Name
    $this.Description       = $Description
    $this.AltDescription    = $AltDescription
  }

  # With enemy
  Location ([Array]$Coordinates, [String]$Name, [String]$Description, [String]$AltDescription, [String]$Enemy) {
    $this.Coordinates       = $Coordinates
    $this.Name              = $Name
    $this.Description       = $Description
    $this.AltDescription    = $AltDescription
    $this.Enemy             = $Enemy
  }
}