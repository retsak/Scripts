$services = @{
    "Spooler" = "Automatic";
    "WSearch" = "Manual";
    "BITS" = "AutomaticDelayedStart";
}

$issueDetected = $false

foreach ($service in $services.GetEnumerator()) {
    try {
        $svc = Get-Service -Name $service.Key -ErrorAction Stop
        if ($svc.StartType -ne $service.Value -or $svc.Status -ne 'Running') {
            $issueDetected = $true
            break
        }
    } catch {
        $issueDetected = $true
        break
    }
}

if ($issueDetected) {
    exit 1
} else {
    exit 0
}
