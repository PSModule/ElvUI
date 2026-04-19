function Update-ElvUI {
    <#
        .SYNOPSIS
        Updates the ElvUI addon to the latest version.

        .DESCRIPTION
        Checks the installed ElvUI version against the latest available version from the
        Tukui API. If an update is available (or -Force is used), downloads and installs
        the new version. If ElvUI is not installed, performs a fresh install.

        .EXAMPLE
        Update-ElvUI

        Updates ElvUI in the default retail WoW installation.

        .EXAMPLE
        Update-ElvUI -WoWPath 'D:\Games\World of Warcraft'

        Updates ElvUI using a custom WoW installation path.

        .EXAMPLE
        Update-ElvUI -Flavor '_classic_'

        Updates ElvUI in the Classic WoW AddOns folder.

        .EXAMPLE
        Update-ElvUI -Force

        Reinstalls ElvUI even if the installed version matches the latest.
    #>
    [CmdletBinding()]
    param(
        # Path to the World of Warcraft installation folder.
        [Parameter()]
        [string] $WoWPath = 'C:\Program Files (x86)\World of Warcraft',

        # WoW game flavor to target.
        [Parameter()]
        [ValidateSet('_retail_', '_classic_', '_classic_era_')]
        [string] $Flavor = '_retail_',

        # Force reinstall even if the installed version matches the latest.
        [Parameter()]
        [switch] $Force
    )

    $addOnsPath = Get-WoWAddOnsPath -WoWPath $WoWPath -Flavor $Flavor
    $installedVersion = Get-TukuiInstalledVersion -AddOnsPath $addOnsPath -Name elvui

    if ($installedVersion) {
        Write-Host "Installed version: $installedVersion" -ForegroundColor Cyan
    } else {
        Write-Host 'No existing ElvUI installation detected. Installing fresh.' -ForegroundColor Yellow
    }

    $addon = Get-TukuiAddon -Name elvui
    Write-Host "Latest ElvUI version: $($addon.Version)" -ForegroundColor Green

    if ($installedVersion -eq $addon.Version -and -not $Force) {
        Write-Host 'ElvUI is already up to date. Use -Force to reinstall.' -ForegroundColor Green
        return
    }

    if ($installedVersion -eq $addon.Version) {
        Write-Host "Forcing reinstall of $($addon.Version) ..." -ForegroundColor Yellow
    } elseif ($installedVersion) {
        Write-Host "Updating from $installedVersion to $($addon.Version) ..." -ForegroundColor Yellow
    }

    Install-TukuiAddon -AddOnsPath $addOnsPath -Addon $addon
}
