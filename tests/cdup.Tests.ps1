BeforeAll {
    $modulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\cdup.psd1'
    Import-Module -Name $modulePath -Force

    function Get-RootPath {
        param(
            [Parameter(Mandatory)]
            [string]$Path
        )

        $item = Get-Item -LiteralPath $Path

        while ($null -ne $item.Parent) {
            $item = $item.Parent
        }

        return $item.FullName
    }
}

Describe 'Set-LocationUp' {
    BeforeEach {
        Push-Location

        $repoRoot = Join-Path $TestDrive 'repo'
        $orphanRoot = Join-Path $TestDrive 'orphan'
        $srcRoot = Join-Path $repoRoot 'src'
        $appRoot = Join-Path $srcRoot 'app'
        $handlersRoot = Join-Path $appRoot 'handlers'
        $standaloneRoot = Join-Path $orphanRoot 'standalone'

        New-Item -ItemType Directory -Path $handlersRoot -Force | Out-Null
        New-Item -ItemType Directory -Path $standaloneRoot -Force | Out-Null
        New-Item -ItemType Directory -Path (Join-Path $repoRoot '.git') -Force | Out-Null

        Set-Location -LiteralPath $handlersRoot
    }

    AfterEach {
        Pop-Location
    }

    It 'moves up one level by default' {
        cdup

        (Get-Location).Path | Should -Be (Join-Path (Join-Path (Join-Path $TestDrive 'repo') 'src') 'app')
    }

    It 'moves up the requested number of levels' {
        cdup 3

        (Get-Location).Path | Should -Be (Join-Path $TestDrive 'repo')
    }

    It 'caps traversal at the filesystem root' {
        cdup 100

        (Get-Location).Path | Should -Be (Get-RootPath -Path (Join-Path (Join-Path (Join-Path (Join-Path $TestDrive 'repo') 'src') 'app') 'handlers'))
    }

    It 'jumps to a named ancestor' {
        cdup src

        (Get-Location).Path | Should -Be (Join-Path (Join-Path $TestDrive 'repo') 'src')
    }

    It 'jumps to the git root' {
        cdup -GitRoot

        (Get-Location).Path | Should -Be (Join-Path $TestDrive 'repo')
    }

    It 'jumps to the filesystem root' {
        cdup -Root

        (Get-Location).Path | Should -Be (Get-RootPath -Path (Join-Path (Join-Path (Join-Path (Join-Path $TestDrive 'repo') 'src') 'app') 'handlers'))
    }

    It 'exports the short alias' {
        (Get-Alias up).Definition | Should -Be 'Set-LocationUp'
    }

    It 'throws when the named ancestor does not exist' {
        { cdup does-not-exist } | Should -Throw '*No matching ancestor*'
    }

    It 'throws when no git root exists' {
        Set-Location -LiteralPath (Join-Path (Join-Path $TestDrive 'orphan') 'standalone')

        { cdup -GitRoot } | Should -Throw '*No Git repository root*'
    }

    It 'throws outside the filesystem provider' {
        Set-Location -Path Variable:

        { cdup } | Should -Throw '*FileSystem*'
    }
}
