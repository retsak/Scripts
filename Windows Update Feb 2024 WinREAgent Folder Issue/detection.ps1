# Detection Script for C:\$WinREAgent folder existence

$folderPath = "C:\$WinREAgent"

If (Test-Path $folderPath) {
    # The folder exists, indicating the problem is present
    exit 1
} Else {
    # The folder does not exist, no need for remediation
    exit 0
}
