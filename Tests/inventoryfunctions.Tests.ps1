# Tweaked pathfinding so Invoke-Pester looks in the proper directory; removed $sut variable
$here = 'C:\Scripts\Game\helpers'
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Hero Inventory" {
    Context "Displaying Items" {
        It "Shows a hero's current inventory" {
            [hero]

        }
    }

}