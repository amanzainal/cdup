[CmdletBinding(DefaultParameterSetName = 'Levels')]
param(
    [Parameter(ParameterSetName = 'Levels', Position = 0)]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$Levels = 1,

    [Parameter(ParameterSetName = 'NamedAncestor', Position = 0, Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$Name,

    [Parameter(ParameterSetName = 'GitRoot', Mandatory)]
    [switch]$GitRoot,

    [Parameter(ParameterSetName = 'Root', Mandatory)]
    [switch]$Root
)

$modulePath = Join-Path -Path $PSScriptRoot -ChildPath 'cdup.psd1'
Import-Module -Name $modulePath -Force

Set-LocationUp @PSBoundParameters
