[CmdletBinding()]
param(
    [string]$OutputRoot = (Join-Path $PSScriptRoot '..\.artifacts\publish')
)

$projectRoot = Split-Path -Path $PSScriptRoot -Parent
$manifestPath = Join-Path -Path $projectRoot -ChildPath 'cdup.psd1'
$manifest = Import-PowerShellDataFile -Path $manifestPath
$moduleName = 'cdup'
$moduleVersion = [string]$manifest.ModuleVersion
$stageRoot = Join-Path -Path $OutputRoot -ChildPath "$moduleName\$moduleVersion"
$filesToStage = @(
    'cdup.ps1',
    'cdup.psd1',
    'cdup.psm1',
    'LICENSE',
    'README.md'
)

if (Test-Path -LiteralPath $stageRoot) {
    Remove-Item -LiteralPath $stageRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $stageRoot -Force | Out-Null
$stageRoot = (Get-Item -LiteralPath $stageRoot).FullName

foreach ($file in $filesToStage) {
    Copy-Item -LiteralPath (Join-Path $projectRoot $file) -Destination (Join-Path $stageRoot $file) -Force
}

$stagedFiles = Get-ChildItem -LiteralPath $stageRoot -Recurse -File | ForEach-Object {
    $_.FullName.Substring($stageRoot.Length + 1)
}

$expectedFiles = $filesToStage | Sort-Object
$fileDiff = Compare-Object -ReferenceObject $expectedFiles -DifferenceObject ($stagedFiles | Sort-Object)

if ($fileDiff) {
    throw "Staged file list mismatch. Expected: $($expectedFiles -join ', '). Actual: $($stagedFiles -join ', ')."
}

return $stageRoot
