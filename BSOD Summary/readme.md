
# BSOD Detection and Summary Script

This PowerShell script helps in detecting Blue Screen of Death (BSOD) incidents and returning the number in the last 30 days, summarized by the bug check code.

## Overview

The script leverages Windows Event Logs to find BSOD events, specifically looking for Event ID 1001 under the System log. These events include the bug check code in their description, which is crucial for identifying the specific error that caused the BSOD.

## Script

```powershell
# PowerShell script to detect BSOD events and summarize by bug check code

# Get the current date
$CurrentDate = Get-Date

# Calculate the date 30 days ago
$Date30DaysAgo = $CurrentDate.AddDays(-30)

# Query the System event log for Event ID 1001 within the last 30 days
$BSODEvents = Get-WinEvent -FilterHashtable @{
    LogName = 'System';
    ID = 1001;
    StartTime = $Date30DaysAgo;
} | Where-Object { $_.Message -like "*bugcheck*" }

# Extract bug check codes and summarize occurrences
$BugCheckSummary = @{}
foreach ($Event in $BSODEvents) {
    # Extract the bug check code from the event's message
    if ($Event.Message -match "The bugcheck was: (0x[\da-fA-F]+)") {
        $BugCheckCode = $matches[1]

        # Increment the count for this bug check code
        if ($BugCheckSummary.ContainsKey($BugCheckCode)) {
            $BugCheckSummary[$BugCheckCode] += 1
        } else {
            $BugCheckSummary[$BugCheckCode] = 1
        }
    }
}

# Output the summary
$BugCheckSummary.GetEnumerator() | ForEach-Object {
    Write-Output "$($_.Key): $($_.Value) occurrence(s)"
}

# Note: Use the bug check codes to reference against https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/bug-check-code-reference2 for a description.
```

## Instructions for Use

1. Copy the script into a PowerShell script file (e.g., `DetectBSODs.ps1`).
2. Run the script in a PowerShell session with administrative privileges to access the system event logs.
3. The script outputs the count of BSOD events in the last 30 days, summarized by the bug check code. Use the bug check codes to reference the provided Microsoft documentation for details about each type of BSOD.

## Note

This script is a starting point. Depending on your environment and the specific details available in your system's event logs, you may need to adjust the script for accurate extraction and summarization.
