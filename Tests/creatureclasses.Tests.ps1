# Tweaked pathfinding so Invoke-Pester looks in the proper directory; removed $sut variable
$here = 'C:\Scripts\Game\Classes'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Hero Class" {
    Context "Instantiate Hero" {
        It "Creates a hero for the player to inhabit" {
            $name = 'Jack'
            $hero = [Hero]::new($name) | Should Not BeNullOrEmpty
        }

    }

}

Describe "Creature Classes" {
    Context "Instantiate Creatures" {

        It "Creates (Base Class) Creature" {
            $creature = [creature]::new() | Should Not BeNullOrEmpty

        }

        It "Creates Orcs" {
            $orc = [Orc]::new() | Should not BeNullOrEmpty

        }

        It "Creates Humans" {
            $human = [Human]::new() | Should not BeNullOrEmpty

        }

        It "Creates Skeletons" {
            $orc = [Skeleton]::new() | Should not BeNullOrEmpty

        }

    }

    Context "Kill Creatures" {

        It "Can kill a creature" {
            $creature = [creature]::new()
            $creature.hit(100)
            $creature.Status | Should Be 'Dead'

        }
    }

    Context "Heal Creatures" {

        It "Can heal a creature" {
            $creature = [creature]::new()
            $creature.Health = 100
            $creature.heal(10)
            $creature.Health | Should Be 110

        }
    }
}