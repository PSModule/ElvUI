function Get-WoWAddOnsPath {
    <#
        .SYNOPSIS
        Resolves the WoW AddOns folder path for a given flavor.

        .DESCRIPTION
        Constructs and validates the full path to the World of Warcraft AddOns directory
        based on the installation path and game flavor.

        .EXAMPLE
        Get-WoWAddOnsPath

        Returns the default retail AddOns path: C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns

        .EXAMPLE
        Get-WoWAddOnsPath -WoWPath 'D:\Games\World of Warcraft' -Flavor '_classic_'

        Returns the classic AddOns path under a custom installation directory.

        .OUTPUTS
        System.String
    #>
    [CmdletBinding()]
    param(
        # Path to the World of Warcraft installation folder.
        [Parameter()]
        [string] $WoWPath = 'C:\Program Files (x86)\World of Warcraft',

        # WoW game flavor to target.
        [Parameter()]
        [ValidateSet('_retail_', '_classic_', '_classic_era_')]
        [string] $Flavor = '_retail_'
    )

    $addOnsPath = Join-Path $WoWPath $Flavor 'Interface' 'AddOns'
    if (-not (Test-Path $addOnsPath)) {
        throw "AddOns folder not found: $addOnsPath"
    }
    $addOnsPath
}
