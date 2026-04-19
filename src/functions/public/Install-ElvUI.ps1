function Install-ElvUI {
    <#
        .SYNOPSIS
        Downloads and installs ElvUI to the WoW AddOns folder.

        .DESCRIPTION
        Fetches the latest ElvUI release from the Tukui API, downloads the zip archive,
        and installs it to the World of Warcraft AddOns directory. Any existing ElvUI
        folders are removed before the new version is copied into place.

        .EXAMPLE
        Install-ElvUI

        Installs ElvUI to the default retail WoW AddOns folder.

        .EXAMPLE
        Install-ElvUI -WoWPath 'D:\Games\World of Warcraft'

        Installs ElvUI using a custom WoW installation path.

        .EXAMPLE
        Install-ElvUI -Flavor '_classic_'

        Installs ElvUI to the Classic WoW AddOns folder.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Path to the World of Warcraft installation folder.
        [Parameter()]
        [string] $WoWPath = 'C:\Program Files (x86)\World of Warcraft',

        # WoW game flavor to target.
        [Parameter()]
        [ValidateSet('_retail_', '_classic_', '_classic_era_')]
        [string] $Flavor = '_retail_'
    )

    $addOnsPath = Get-WoWAddOnsPath -WoWPath $WoWPath -Flavor $Flavor
    $addon = Get-TukuiAddon -Name elvui

    if ($PSCmdlet.ShouldProcess($addOnsPath, "Install $($addon.Name) $($addon.Version)")) {
        Write-Verbose "Installing $($addon.Name) $($addon.Version) ..."
        Install-TukuiAddon -AddOnsPath $addOnsPath -Addon $addon
    }
}
