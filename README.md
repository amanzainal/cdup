# cdup

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/cdup)](https://www.powershellgallery.com/packages/cdup)
[![CI](https://github.com/amanzainal/cdup/actions/workflows/ci.yml/badge.svg)](https://github.com/amanzainal/cdup/actions/workflows/ci.yml)
[![License](https://img.shields.io/github/license/amanzainal/cdup)](LICENSE)

`cdup` is a PowerShell command for moving up directory trees quickly.

Instead of repeating `cd ..`, `cdup` moves your current session directly to the parent directory you want.

It supports:

- Move up by level count
- Jump to an ancestor by name
- Jump straight to the current Git repository root
- Jump to the filesystem root
- Use a short alias: `up`

## Install

```powershell
Install-Module cdup -Scope CurrentUser
Import-Module cdup
```

To load `cdup` automatically in new sessions, add `Import-Module cdup` to your PowerShell profile.

`cdup` supports Windows PowerShell 5.1 and PowerShell 7+.

## Usage

### Move up by number of levels

```powershell
cdup
cdup 2
up 4
```

### Jump to a named ancestor

If your current path is `C:\work\client\api\src\handlers`:

```powershell
cdup src
```

This moves directly to `C:\work\client\api\src`.

### Jump to the current Git repository root

```powershell
cdup -GitRoot
```

### Jump to the filesystem root

```powershell
cdup -Root
```

## Examples

```powershell
PS C:\work\client\api\src\handlers> cdup 3
PS C:\work\client> cdup src
PS C:\work\client\api\src\handlers> cdup -GitRoot
PS C:\work\client\api> up -Root
```

## Command Reference

| Command | Result |
| --- | --- |
| `cdup` | Move up one directory |
| `cdup 3` | Move up three directories |
| `cdup src` | Jump to the nearest ancestor named `src` |
| `cdup -GitRoot` | Jump to the nearest Git repository root |
| `cdup -Root` | Jump to the filesystem root |
| `up 2` | Same as `cdup 2` |

## Notes

- `cdup` changes the current PowerShell session location, so it should be imported as a command, not launched in a separate shell process.
- `cdup` operates on FileSystem locations.

## License

MIT. See [LICENSE](LICENSE).
