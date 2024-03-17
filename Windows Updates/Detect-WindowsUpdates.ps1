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
$searchResult = $updateSearcher.Search("IsInstalled=0")

# Check if there are updates available
if ($searchResult.Updates.Count -eq 0) {
    # No updates available, exit with code 0 (no issue detected)
    exit 0
} else {
    # Updates available, exit with code 1 (issue detected)
    exit 1
}
