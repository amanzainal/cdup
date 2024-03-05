param (
    [int]$levels = 1
)

# Construct the backtracking string
$backtrack = "..\"
$backtrack *= $levels

# Get the current directory
$currentDir = Get-Location

# Construct the target directory
$targetDir = Join-Path -Path $currentDir -ChildPath $backtrack

# Change directory
Set-Location -Path $targetDir
