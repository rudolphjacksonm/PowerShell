# Enumerator for valid states
Enum State {
    Dead
    Alive
    Undead

}

class Creature {

    # Properties
    [int]$Health
    [string]$Name
    [State]$Status
    
    # Hidden Properties
    hidden [string] $Weakness

    # Parameterless Constructor
    Creature () {
    }

    # Hit creature method
    [void] Hit ([int]$Health) {
        $this.health -= $health

        if ($this.Health -le 0){
            $this.SetStatus('Dead')
        }

    }

    # Heal creature method
    [void] Heal ([int]$Heal) {
        $this.health += $Heal

    }

    # Set status method
    [void] SetStatus ([string] $Status) {
        $this.status = $Status

    }
}

class Orc : Creature {

    # Properties for Orc class
    [int]$Health = 100
    [State]$Status = 'Alive'

    # Hidden properties
    hidden [string] $Weakness = 'Fire'

    # Parameterless constructor
    Orc (){}

    # Constructor w/ name of Orc
    Orc ([string]$name) {
        $this.Name = $Name

    }

    # Constructor w/ name, health of Orc
    Orc ([string]$name,$health) {
        $this.Name = $Name
        $this.Health = $Health

    }

}

class Human : Creature {
    
    # Properties for Human class
    [int]$Health = 80
    [State]$Status = 'Alive'

    # Hidden properties for Human class
    hidden [string] $Weakness = 'Dark'

    Human(){}

    Human ([string]$Name) {
        $this.Name = $Name

    }

    Human ([string]$Name, $Health) {
        $this.Name = $Name
        $this.Health = $Health

    }

}

class Skeleton : Creature {

    # Properties
    [int]$Health = 50
    [state]$Status = 'Undead'

    Skeleton(){}

    Skeleton ([string] $Name) {
        $this.Name = $Name

    }

}