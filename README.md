# cdup

`cdup` is a simple utility for quickly traversing up directories in your command-line environment.

## Installation

To use `cdup`, follow these steps:

1. Download the `cdup.ps1` script from this repository.
2. Place the `cdup.ps1` script in a directory that is included in your system's PATH environment variable.

## Usage

To use `cdup`, open a PowerShell session and run the `cdup` script with the desired number of directories to move up as an argument. For example:

```
cdup 3
```

This will move you up three directories from your current location.

## Why Use cdup?

`cdup` is useful for navigating quickly through directory structures, especially when working with deeply nested directories. Instead of typing multiple `cd ..` commands to move up directories one by one, `cdup` allows you to traverse up multiple directories with a single command.

## Contributing

Contributions to `cdup` are welcome! If you encounter any bugs or have ideas for improvements, please feel free to open an issue or submit a pull request. 

## Disclaimer

Currently, this only supports PowerShell. Due to the way the Windows Command Prompt architecture is structured, this is not possible on CMD. I have not yet tested a similar approach on *nix systems, but this should theoretically work in bash. I would highly appreciate any contributions!
