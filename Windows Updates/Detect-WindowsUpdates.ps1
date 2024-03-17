#Reference: https://learn.microsoft.com/en-us/windows/win32/wua_sdk/searching--downloading--and-installing-updates

# Define the server selection and service ID
$serverSelection = 3
$serviceId = "855E8A7C-ECB4-4CA3-B045-1DFA50104289"

# Create the Update Session and Searcher objects
$updateSession = New-Object -ComObject Microsoft.Update.Session
$updateSearcher = $updateSession.CreateUpdateSearcher()

# Set Server Selection and Service ID
$updateSearcher.ServerSelection = $serverSelection
$updateSearcher.ServiceID = $serviceId

# Search for updates
try {
    # Configuration and search setup omitted for brevity

    # Search for updates
    $searchResult = $updateSearcher.Search("IsInstalled=0")

    # Interpret search result
    if ($searchResult.Updates.Count -eq 0) {
        Write-Output "No updates available."
        exit 0
    } else {
        Write-Output "Updates found."
        exit 1
    }
} catch [System.Exception] {
    $errorCode = $_.Exception.HResult
    $errorMessage = switch ($errorCode) {
        0x8024001E { "Operation did not complete because the service or system was being shut down." }
        0x80240024 { "There are no updates." }
        0x8024402F { "There were errors during the download process but it completed successfully anyway." }
        default { "An unexpected error occurred: $_" }
    }
    Write-Output $errorMessage
    exit 1
}
