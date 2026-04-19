# ElvUI

A PowerShell module for installing and updating the [ElvUI](https://www.tukui.org/elvui) addon
for [World of Warcraft](https://worldofwarcraft.blizzard.com/).

## Prerequisites

- Windows PowerShell 5.1 or PowerShell 7+
- A World of Warcraft installation
- The [PSModule framework](https://github.com/PSModule/Process-PSModule) for building, testing and publishing the module.

## Installation

To install the module from the PowerShell Gallery:

```powershell
Install-PSResource -Name ElvUI
Import-Module -Name ElvUI
```

## Usage

### Update ElvUI to the latest version

```powershell
Update-ElvUI
```

### Force reinstall even if already up to date

```powershell
Update-ElvUI -Force
```

### Install ElvUI fresh

```powershell
Install-ElvUI
```

### Target a different WoW installation or flavor

```powershell
Update-ElvUI -WoWPath 'D:\Games\World of Warcraft' -Flavor '_classic_'
```

### Find more examples

To find more examples of how to use the module, please refer to the [examples](examples) folder.

You can also use `Get-Command -Module ElvUI` to list available commands,
and `Get-Help -Examples <CommandName>` to see usage examples for each.

## Contributing

Coder or not, you can contribute to the project! We welcome all contributions.

### For Users

If you don't code, you still sit on valuable information that can make this project even better. If you experience that the
product does unexpected things, throw errors or is missing functionality, you can help by submitting bugs and feature requests.
Please see the issues tab on this project and submit a new issue that matches your needs.

### For Developers

If you do code, we'd love to have your contributions. Please read the [Contribution guidelines](CONTRIBUTING.md) for more information.
You can either help by picking up an existing issue or submit a new one if you have an idea for a new feature or improvement.
