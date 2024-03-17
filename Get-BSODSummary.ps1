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

# Output the summary as compressed JSON
$SummaryJson = $BugCheckSummary | ConvertTo-Json -Compress
Write-Output $SummaryJson

# Note: Use the bug check codes to reference against https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/bug-check-code-reference2 for a description.
