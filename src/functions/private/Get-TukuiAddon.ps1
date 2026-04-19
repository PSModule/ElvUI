function Get-TukuiAddon {
    <#
        .SYNOPSIS
        Fetches addon info from the Tukui API.

        .DESCRIPTION
        Returns metadata for a Tukui-hosted addon including version, download URL,
        description, supported patches, and more. When called without parameters,
        returns all available addons.

        .EXAMPLE
        Get-TukuiAddon -Name elvui

        Returns metadata for ElvUI.

        .EXAMPLE
        Get-TukuiAddon

        Returns all available Tukui addons.

        .OUTPUTS
        PSCustomObject
    #>
    [CmdletBinding()]
    param(
        # The slug name of the addon to retrieve. Omit to return all addons.
        [Parameter()]
        [ValidateSet('elvui', 'tukui')]
        [string] $Name
    )

    if ($Name) {
        $url = "https://api.tukui.org/v1/addon/$Name"
    } else {
        $url = 'https://api.tukui.org/v1/addons'
    }

    $response = Invoke-RestMethod -Uri $url -UseBasicParsing

    foreach ($addon in @($response)) {
        [PSCustomObject]@{
            Id            = $addon.id
            Slug          = $addon.slug
            Name          = $addon.name
            Author        = $addon.author
            Version       = $addon.version
            DownloadUrl   = $addon.url
            ChangelogUrl  = $addon.changelog_url
            TicketUrl     = $addon.ticket_url
            GitUrl        = $addon.git_url
            Patches       = $addon.patch
            LastUpdate    = $addon.last_update
            WebUrl        = $addon.web_url
            DonateUrl     = $addon.donate_url
            Description   = $addon.small_desc
            ScreenshotUrl = $addon.screenshot_url
            GalleryUrls   = $addon.gallery_url
            LogoUrl       = $addon.logo_url
            LogoSquareUrl = $addon.logo_square_url
            Directories   = $addon.directories
        }
    }
}
