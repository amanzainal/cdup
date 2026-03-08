Set-StrictMode -Version Latest

function Get-CdUpCurrentDirectory {
    $location = Get-Location

    if ($location.Provider.Name -ne 'FileSystem') {
        throw "cdup only supports FileSystem locations. Current provider: '$($location.Provider.Name)'."
    }

    return Get-Item -LiteralPath $location.Path
}

function Resolve-CdUpTarget {
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

    $current = Get-CdUpCurrentDirectory

    switch ($PSCmdlet.ParameterSetName) {
        'Levels' {
            $target = $current

            for ($index = 0; $index -lt $Levels; $index++) {
                if ($null -eq $target.Parent) {
                    break
                }

                $target = $target.Parent
            }

            return $target.FullName
        }

        'NamedAncestor' {
            $candidate = $current

            while ($null -ne $candidate) {
                if ($candidate.Name -ieq $Name) {
                    return $candidate.FullName
                }

                $candidate = $candidate.Parent
            }

            throw "No matching ancestor named '$Name' was found from '$($current.FullName)'."
        }

        'GitRoot' {
            $candidate = $current

            while ($null -ne $candidate) {
                $gitPath = Join-Path -Path $candidate.FullName -ChildPath '.git'

                if (Test-Path -LiteralPath $gitPath) {
                    return $candidate.FullName
                }

                $candidate = $candidate.Parent
            }

            throw "No Git repository root was found from '$($current.FullName)'."
        }

        'Root' {
            $target = $current

            while ($null -ne $target.Parent) {
                $target = $target.Parent
            }

            return $target.FullName
        }

        default {
            throw "Unsupported parameter set '$($PSCmdlet.ParameterSetName)'."
        }
    }
}

function Set-LocationUp {
    <#
    .SYNOPSIS
    Moves to an ancestor directory quickly.

    .DESCRIPTION
    Set-LocationUp moves the current FileSystem location by level count, ancestor name,
    Git repository root, or filesystem root.

    .PARAMETER Levels
    Number of parent directories to traverse upward. This is the default mode.

    .PARAMETER Name
    The name of the current directory or an ancestor directory to jump to.

    .PARAMETER GitRoot
    Jump to the closest ancestor containing a .git marker.

    .PARAMETER Root
    Jump to the filesystem root for the current path.

    .EXAMPLE
    cdup 3

    Moves up three directory levels.

    .EXAMPLE
    cdup src

    Jumps to the nearest ancestor directory named src.

    .EXAMPLE
    cdup -GitRoot

    Jumps to the current repository root.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Levels', SupportsShouldProcess)]
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

    $target = Resolve-CdUpTarget @PSBoundParameters

    if ($PSCmdlet.ShouldProcess($target, 'Set current location')) {
        Set-Location -LiteralPath $target
    }
}

Set-Alias -Name cdup -Value Set-LocationUp
Set-Alias -Name up -Value Set-LocationUp

Export-ModuleMember -Function Set-LocationUp -Alias cdup, up
