#Reference: https://learn.microsoft.com/en-us/windows/win32/wua_sdk/searching--downloading--and-installing-updates

# Define the server selection and service ID
$serverSelection = 3
$serviceId = "855E8A7C-ECB4-4CA3-B045-1DFA50104289"

# Create the Update Session, Searcher, and Downloader objects
$updateSession = New-Object -ComObject Microsoft.Update.Session
$updateSearcher = $updateSession.CreateUpdateSearcher()
$updateDownloader = $updateSession.CreateUpdateDownloader()

# Set Server Selection and Service ID
$updateSearcher.ServerSelection = $serverSelection
$updateSearcher.ServiceID = $serviceId

# Search for updates
$searchResult = $updateSearcher.Search("IsInstalled=0")

# Initialize the collection of updates to download
$updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
foreach ($update in $searchResult.Updates) {
    $updatesToDownload.Add($update) | Out-Null
}

# Download updates
$updateDownloader.Updates = $updatesToDownload
$downloadResult = $updateDownloader.Download()

# Initialize the installer and the collection of updates to install
$updateInstaller = $updateSession.CreateUpdateInstaller()
$updateInstaller.Updates = $updatesToDownload

# Install the updates
try {
    # Configuration, search, and download setup omitted for brevity

    # Install the updates
    $installationResult = $updateInstaller.Install()

    # Interpret installation result
    if ($installationResult.ResultCode -ne 2) {
        Write-Output "Installation failed."
        exit 1
    } else {
        Write-Output "All updates were successfully installed."
    }
} catch [System.Exception] {
    $errorCode = $_.Exception.HResult
    $errorMessage = switch ($errorCode) {
        0x8024001E { "Operation did not complete because the service or system was being shut down." }
        0x80240024 { "There are no updates." }
        0x8024402F { "There were errors during the installation process but it completed successfully anyway." }
        default { "An unexpected error occurred: $_" }
    }
    Write-Output $errorMessage
    exit 1
}
