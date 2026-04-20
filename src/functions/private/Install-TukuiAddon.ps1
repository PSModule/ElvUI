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
            Remove-Item $tempDir -Recurse -Force -ErrorAction Stop
        }
        $null = New-Item -ItemType Directory -Path $tempDir -ErrorAction Stop

        # Download
        $zipPath = Join-Path -Path $tempDir -ChildPath "$($Addon.Slug)-$($Addon.Version).zip"
        Write-Verbose "Downloading $($Addon.Name) $($Addon.Version) ..."
        Invoke-WebRequest -Uri $Addon.DownloadUrl -OutFile $zipPath -ErrorAction Stop

        # Extract
        $extractPath = Join-Path -Path $tempDir -ChildPath 'extracted'
        Write-Verbose 'Extracting...'
        Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force -ErrorAction Stop

        # Remove old addon folders matching the known directory names
        $normalizedAddOnsPath = [System.IO.Path]::GetFullPath($AddOnsPath)
        $trimChars = @([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
        $normalizedAddOnsPath = $normalizedAddOnsPath.TrimEnd($trimChars) + [System.IO.Path]::DirectorySeparatorChar
        foreach ($dir in $Addon.Directories) {
            if ([string]::IsNullOrWhiteSpace($dir) -or $dir.Contains('\') -or $dir.Contains('/') -or $dir.Contains('..')) {
                throw "Invalid addon directory entry '$dir' returned by API."
            }

            $oldPath = Join-Path -Path $AddOnsPath -ChildPath $dir
            $resolvedOldPath = [System.IO.Path]::GetFullPath($oldPath)
            if (-not $resolvedOldPath.StartsWith($normalizedAddOnsPath, [System.StringComparison]::OrdinalIgnoreCase)) {
                throw "Resolved addon directory path '$resolvedOldPath' is outside the AddOns directory."
            }

            if (Test-Path -LiteralPath $resolvedOldPath) {
                Write-Verbose "  Removing $dir"
                Remove-Item -LiteralPath $resolvedOldPath -Recurse -Force -ErrorAction Stop
            }
        }

        # Copy new folders
        $extractedFolders = Get-ChildItem -LiteralPath $extractPath -Directory -ErrorAction Stop
        foreach ($folder in $extractedFolders) {
            $destination = Join-Path -Path $AddOnsPath -ChildPath $folder.Name
            Write-Verbose "  Installing $($folder.Name)"
            Copy-Item -LiteralPath $folder.FullName -Destination $destination -Recurse -Force -ErrorAction Stop
        }

        Write-Verbose "$($Addon.Name) $($Addon.Version) installed successfully!"
    } finally {
        if (Test-Path -LiteralPath $tempDir) {
            Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}
