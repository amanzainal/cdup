param (
    [ValidateRange(1, [int]::MaxValue)]
    [int]$levels = 1
)

# Get the current directory
$currentDir = Get-Location

# Get the number of directories in the current path
$directoryCount = ($currentDir.Path -split '\\').Count

# Determine the maximum number of levels we can traverse up
$maxLevels = $directoryCount - 1

# If the specified levels exceed the maximum levels, adjust to maximum
if ($levels -gt $maxLevels) {
    $levels = $maxLevels
}

# If we can't traverse up any further, display a message and exit
if ($levels -eq 0) {
    Write-Host "Cannot traverse up further. Already at the highest level." -ForegroundColor Yellow
    exit
}

# Construct the target directory
$targetDir = $currentDir.Path
for ($i = 1; $i -le $levels; $i++) {
    $targetDir = Split-Path $targetDir -Parent
}

# Change directory
Set-Location -Path $targetDir
