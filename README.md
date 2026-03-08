# cdup

`cdup` is a PowerShell navigation utility for moving to an ancestor directory quickly.

It starts with the obvious case, `cdup 3`, but it also handles the cases that are annoying to type repeatedly:

- Move up by level count
- Jump to an ancestor by name
- Jump straight to the current Git repository root
- Jump to the filesystem root
- Use a short alias: `up`

## Why this exists

Typing `cd ../../..` is fine once. It gets old when you are bouncing around nested repos all day.

`cdup` keeps upward navigation readable:

```powershell
cdup 3
cdup src
cdup -GitRoot
up -Root
```

## Current project status

This repository is now structured as a real PowerShell module with:

- A module manifest for PowerShell Gallery publishing
- Pester tests
- GitHub Actions CI on Windows, macOS, and Linux
- A publish workflow for tagged releases
- MIT licensing

`cdup` `0.1.1` is live on the PowerShell Gallery.

## Install

### Install from the PowerShell Gallery

```powershell
Install-Module cdup -Scope CurrentUser
Import-Module cdup
```

That gives you both `cdup` and `up`.

### Try it locally

From the repository root:

```powershell
Import-Module ./cdup.psd1 -Force
```

That gives you both `cdup` and `up` in the current session.

### Install persistently

Copy the module files into any directory on `$env:PSModulePath`, using the conventional module layout:

```powershell
$moduleBase = ($env:PSModulePath -split [IO.Path]::PathSeparator)[0]
$moduleRoot = Join-Path $moduleBase 'cdup/0.1.1'
New-Item -ItemType Directory -Path $moduleRoot -Force | Out-Null
Copy-Item -Path .\cdup.ps1, .\cdup.psm1, .\cdup.psd1, .\LICENSE -Destination $moduleRoot -Force
Import-Module cdup
```

### Maintainer publish flow

The repository includes [publish.yml](.github/workflows/publish.yml) and [publish.ps1](scripts/publish.ps1). Once you add the `PSGALLERY_API_KEY` repository secret and push a matching tag, GitHub Actions can publish future releases automatically.

```powershell
./scripts/publish.ps1
```

By default, `publish.ps1` reads the API key from `PSGALLERY_API_KEY` or a local machine path outside the repository:

```text
%LOCALAPPDATA%\cdup\psgallery_api_key.txt
```

## Usage

### Move up by level count

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

You will land in `C:\work\client\api\src`.

### Jump to the current Git repository root

```powershell
cdup -GitRoot
```

### Jump to the filesystem root

```powershell
cdup -Root
```

## Development

Run the tests locally:

```powershell
Invoke-Pester ./tests
```

The CI workflow lives at [ci.yml](.github/workflows/ci.yml).

## Road to broad adoption

If you want `cdup` to become a default tool instead of a personal script, the sequence matters:

1. Win PowerShell users first.
2. Publish and tag releases consistently.
3. Add screenshots or a short terminal GIF to the repository and release notes.
4. Submit downstream packages to Scoop, then WinGet once there is a wrapped installer or executable.
5. Expand to Bash, Zsh, and Fish once the PowerShell version is stable.

## Contributing

Issues and pull requests are welcome, especially around:

- Cross-shell ports
- Packaging for more ecosystems
- Completion scripts
- Better jump modes that save real keystrokes

## License

MIT. See [LICENSE](LICENSE).
