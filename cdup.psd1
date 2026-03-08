@{
    RootModule = 'cdup.psm1'
    ModuleVersion = '0.1.1'
    GUID = '8304f370-3925-4d0c-a67d-09e520bead1d'
    Author = 'amanzainal'
    CompanyName = 'Community'
    Copyright = '(c) 2024 amanzainal. All rights reserved.'
    Description = 'Fast ancestor navigation for PowerShell with level, name, git-root, and filesystem-root jumps.'
    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')
    FunctionsToExport = @('Set-LocationUp')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @('cdup', 'up')
    FileList = @(
        'cdup.ps1',
        'cdup.psd1',
        'cdup.psm1',
        'LICENSE',
        'README.md'
    )
    PrivateData = @{
        PSData = @{
            Tags = @('powershell', 'navigation', 'shell', 'cli', 'productivity')
            LicenseUri = 'https://github.com/amanzainal/cdup/blob/main/LICENSE'
            ProjectUri = 'https://github.com/amanzainal/cdup'
            ReleaseNotes = 'Packaging hardening release. Publish now stages only module files to keep git metadata, secrets, tests, and docs out of the Gallery package.'
        }
    }
}
