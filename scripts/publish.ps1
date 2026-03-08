[CmdletBinding()]
param(
    [string]$ApiKeyPath,
    [string]$EnvFilePath = (Join-Path (Split-Path -Path $PSScriptRoot -Parent) '.env')
)

$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$manifestPath = Join-Path -Path $projectRoot -ChildPath 'cdup.psd1'
$manifest = Import-PowerShellDataFile -Path $manifestPath
$stageScriptPath = Join-Path -Path $PSScriptRoot -ChildPath 'stage-module.ps1'
$apiKey = $env:PSGALLERY_API_KEY

if (-not $apiKey -and (Test-Path -LiteralPath $EnvFilePath)) {
    $line = Get-Content -LiteralPath $EnvFilePath | Where-Object {
        $_ -match '^\s*PSGALLERY_API_KEY\s*='
    } | Select-Object -First 1

    if ($line) {
        $apiKey = ($line -split '=', 2)[1].Trim().Trim("'`"")
    }
}

if (-not $ApiKeyPath) {
    if ($IsWindows) {
        $ApiKeyPath = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'cdup\psgallery_api_key.txt'
    }
    else {
        $ApiKeyPath = Join-Path $HOME '.config/cdup/psgallery_api_key.txt'
    }
}

if (-not $apiKey -and (Test-Path -LiteralPath $ApiKeyPath)) {
    $apiKey = (Get-Content -LiteralPath $ApiKeyPath -Raw).Trim()
}

if (-not $apiKey) {
    throw "PowerShell Gallery API key not found. Set PSGALLERY_API_KEY, add it to '$EnvFilePath', or create '$ApiKeyPath'."
}

if (-not (Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue)) {
    Register-PSRepository `
        -Name PSGallery `
        -SourceLocation 'https://www.powershellgallery.com/api/v2' `
        -PublishLocation 'https://www.powershellgallery.com/api/v2/package/' `
        -ScriptSourceLocation 'https://www.powershellgallery.com/api/v2/items/psscript' `
        -ScriptPublishLocation 'https://www.powershellgallery.com/api/v2/package/' `
        -InstallationPolicy Trusted
}

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

$publishedModule = Find-Module -Name 'cdup' -Repository PSGallery -ErrorAction SilentlyContinue

if ($publishedModule -and ([version]$publishedModule.Version -ge [version]$manifest.ModuleVersion)) {
    throw "PowerShell Gallery already has cdup version $($publishedModule.Version). Bump ModuleVersion in cdup.psd1 first."
}

$stageRoot = & $stageScriptPath

Write-Verbose "Publishing staged module from '$stageRoot'."
Publish-Module -Path $stageRoot -NuGetApiKey $apiKey
