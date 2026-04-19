function Get-TukuiInstalledVersion {
    <#
        .SYNOPSIS
        Gets the currently installed version of a Tukui addon from its .toc file.

        .DESCRIPTION
        Reads the .toc file for the specified addon in the AddOns folder and
        extracts the version string. Returns $null if the addon is not installed.

        .EXAMPLE
        Get-TukuiInstalledVersion -AddOnsPath 'C:\...\AddOns' -Name elvui

        Returns the installed ElvUI version string, or $null if not found.

        .OUTPUTS
        System.String or $null if not installed.
    #>
    [CmdletBinding()]
    param(
        # The full path to the WoW AddOns directory.
        [Parameter(Mandatory)]
        [string] $AddOnsPath,

        # The slug name of the addon to check.
        [Parameter(Mandatory)]
        [ValidateSet('elvui', 'tukui')]
        [string] $Name
    )

    $addonFolder = switch ($Name) {
        'elvui' { 'ElvUI' }
        'tukui' { 'Tukui' }
    }

    $tocCandidates = @(
        (Join-Path -Path $AddOnsPath -ChildPath $addonFolder | Join-Path -ChildPath "${addonFolder}_Mainline.toc")
        (Join-Path -Path $AddOnsPath -ChildPath $addonFolder | Join-Path -ChildPath "$addonFolder.toc")
    )

    $tocPath = $tocCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (-not $tocPath) {
        return $null
    }

    $tocContent = Get-Content -Path $tocPath -Raw
    if ($tocContent -match '(?m)^## Version:\s*(.+)$') {
        return $Matches[1].Trim().TrimStart('v')
    }
    return $null
}
