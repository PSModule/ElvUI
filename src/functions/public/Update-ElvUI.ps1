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
    [CmdletBinding(SupportsShouldProcess)]
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
        Write-Verbose "Installed version: $installedVersion"
    } else {
        Write-Verbose 'No existing ElvUI installation detected. Installing fresh.'
    }

    $addon = Get-TukuiAddon -Name elvui
    Write-Verbose "Latest ElvUI version: $($addon.Version)"

    # Compare versions to prevent unintentional downgrades
    $installedVer = $null
    $latestVer = $null
    $canCompareVersions = $installedVersion -and
        [version]::TryParse($installedVersion, [ref]$installedVer) -and
        [version]::TryParse($addon.Version, [ref]$latestVer)

    if ($canCompareVersions -and $installedVer -gt $latestVer -and -not $Force) {
        Write-Verbose "Installed version ($installedVersion) is newer than the latest available ($($addon.Version)). Use -Force to reinstall."
        return
    }

    if ($installedVersion -eq $addon.Version -and -not $Force) {
        Write-Verbose 'ElvUI is already up to date. Use -Force to reinstall.'
        return
    }

    if ($installedVersion -eq $addon.Version) {
        Write-Verbose "Forcing reinstall of $($addon.Version) ..."
    } elseif ($canCompareVersions -and $installedVer -gt $latestVer) {
        Write-Verbose "Forcing reinstall — installed version ($installedVersion) is newer than latest available ($($addon.Version))."
    } elseif ($installedVersion) {
        Write-Verbose "Updating from $installedVersion to $($addon.Version) ..."
    }

    if ($PSCmdlet.ShouldProcess($addOnsPath, "Install $($addon.Name) $($addon.Version)")) {
        Install-TukuiAddon -AddOnsPath $addOnsPath -Addon $addon
    }
}
