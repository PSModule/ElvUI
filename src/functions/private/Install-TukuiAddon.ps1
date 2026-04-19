function Install-TukuiAddon {
    <#
        .SYNOPSIS
        Downloads and installs a Tukui addon to the WoW AddOns folder.

        .DESCRIPTION
        Downloads the ZIP archive from the Tukui API, extracts it, removes old addon
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

    $tempDir = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "Tukui_$($Addon.Slug)_Update_$([guid]::NewGuid().ToString('N'))"
    try {
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force
        }
        $null = New-Item -ItemType Directory -Path $tempDir

        # Download
        $zipPath = Join-Path -Path $tempDir -ChildPath "$($Addon.Slug)-$($Addon.Version).zip"
        Write-Verbose "Downloading $($Addon.Name) $($Addon.Version) ..."
        Invoke-WebRequest -Uri $Addon.DownloadUrl -OutFile $zipPath

        # Extract
        $extractPath = Join-Path -Path $tempDir -ChildPath 'extracted'
        Write-Verbose 'Extracting...'
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

        # Remove old addon folders matching the known directory names
        foreach ($dir in $Addon.Directories) {
            $oldPath = Join-Path -Path $AddOnsPath -ChildPath $dir
            if (Test-Path $oldPath) {
                Write-Verbose "  Removing $dir"
                Remove-Item $oldPath -Recurse -Force
            }
        }

        # Copy new folders
        $extractedFolders = Get-ChildItem -Path $extractPath -Directory
        foreach ($folder in $extractedFolders) {
            $destination = Join-Path -Path $AddOnsPath -ChildPath $folder.Name
            Write-Verbose "  Installing $($folder.Name)"
            Copy-Item -Path $folder.FullName -Destination $destination -Recurse -Force
        }

        Write-Verbose "$($Addon.Name) $($Addon.Version) installed successfully!"
    } finally {
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force
        }
    }
}
