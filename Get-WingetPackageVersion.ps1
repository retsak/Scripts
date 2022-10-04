$package = 'Notepad++.Notepad++'
$res = winget list $package --accept-source-agreements
if ($res -eq 'No installed package found matching input criteria.') {
    Write-Output $res
}
else {
    $ressplit = $res[4].Split(' ')
    $total = $ressplit.count
    for ($n = 0; $n -le $total; $n++) {
        $test = $ressplit[$total - $n]
        if ($test -eq $package) {
            break
        }
        if ($test -match "\." -and ($null -eq $availableVersion)) {
            $availableVersion = [System.Version]$test
        }
        elseif ($test -match "\.") {
            $installedVersion = [System.Version]$test
        }
    }

    if ($null -eq $installedVersion) {
        $installedVersion = $availableVersion
    }

    Write-Output "Installed version $installedVersion"
    Write-Output "Available version $availableVersion"
}