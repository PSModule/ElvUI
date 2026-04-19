function Install-TukuiAddon {
    <#
        .SYNOPSIS
        Downloads and installs a Tukui addon to the WoW AddOns folder.

        .DESCRIPTION
        Downloads the zip from the Tukui API, extracts it, removes old addon
        folders, and copies the new ones into place. Uses a temporary directory
        that is cleaned up automatically.

        .EXAMPLE
        $addon = Get-TukuiAddon -Name elvui
        Install-TukuiAddon -AddOnsPath 'C:\...\AddOns' -Addon $addon

        Downloads and installs ElvUI to the specified AddOns directory.
    #>
    [CmdletBinding()]
    param(
        # The full path to the WoW AddOns directory.
        [Parameter(Mandatory)]
        [string] $AddOnsPath,

        # The addon object returned by Get-TukuiAddon containing metadata and download URL.
        [Parameter(Mandatory)]
        [PSCustomObject] $Addon
    )

    $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) "Tukui_$($Addon.Slug)_Update"
    try {
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $tempDir | Out-Null

        # Download
        $zipPath = Join-Path $tempDir "$($Addon.Slug)-$($Addon.Version).zip"
        Write-Host "Downloading $($Addon.Name) $($Addon.Version) ..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $Addon.DownloadUrl -OutFile $zipPath -UseBasicParsing

        # Extract
        $extractPath = Join-Path $tempDir 'extracted'
        Write-Host 'Extracting...' -ForegroundColor Cyan
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

        # Remove old addon folders matching the known directory names
        foreach ($dir in $Addon.Directories) {
            $oldPath = Join-Path $AddOnsPath $dir
            if (Test-Path $oldPath) {
                Write-Host "  Removing $dir" -ForegroundColor Yellow
                Remove-Item $oldPath -Recurse -Force
            }
        }

        # Copy new folders
        $extractedFolders = Get-ChildItem -Path $extractPath -Directory
        foreach ($folder in $extractedFolders) {
            $destination = Join-Path $AddOnsPath $folder.Name
            Write-Host "  Installing $($folder.Name)" -ForegroundColor Cyan
            Copy-Item -Path $folder.FullName -Destination $destination -Recurse -Force
        }

        Write-Host "$($Addon.Name) $($Addon.Version) installed successfully!" -ForegroundColor Green
    } finally {
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force
        }
    }
}
