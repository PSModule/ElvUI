<#
    .SYNOPSIS
    Examples of how to use the ElvUI module.
#>

# Import the module
Import-Module -Name ElvUI

# Update ElvUI to the latest version
Update-ElvUI

# Force reinstall even if already up to date
Update-ElvUI -Force

# Install ElvUI fresh
Install-ElvUI

# Target a specific WoW installation and game flavor
Update-ElvUI -WoWPath 'D:\Games\World of Warcraft' -Flavor '_classic_'
