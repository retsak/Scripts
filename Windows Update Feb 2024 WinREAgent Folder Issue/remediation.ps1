# Remediation Script to delete C:\$WinREAgent folder

$folderPath = "C:\$WinREAgent"

Try {
    If (Test-Path $folderPath) {
        # Attempt to remove the folder
        Remove-Item -Path $folderPath -Recurse -Force
        Write-Output "C:\$WinREAgent folder has been successfully deleted."
    } Else {
        Write-Output "C:\$WinREAgent folder does not exist. No action required."
    }
} Catch {
    Write-Output "An error occurred while attempting to delete C:\$WinREAgent folder. Error: $_"
    exit 1 # Exit with error code indicating failure
}
