# WinGet draft

This folder contains a draft WinGet manifest for `cdup`, but it is not submit-ready.

Why it is blocked:

1. `cdup` must run inside the user's PowerShell session to change the current location.
2. The WinGet community repository does not accept script-based installers in its current package rules.
3. A real submission therefore needs a supported bootstrapper or installer that configures the PowerShell environment instead of launching `cdup` in a child process.

Use these manifest files as metadata scaffolding only. Do not submit them until there is a proper installer artifact and checksum.
