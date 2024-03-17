$services = @{
    "Spooler" = "Automatic";
    "WSearch" = "Manual";
    "BITS" = "AutomaticDelayedStart";
}

foreach ($service in $services.GetEnumerator()) {
    try {
        $svc = Get-Service -Name $service.Key -ErrorAction Continue
        # Set startup type
        $desiredStartType = $service.Value
        if ($svc.StartType -ne $desiredStartType) {
            Set-Service -Name $service.Key -StartupType $desiredStartType
        }
        # Start the service if not already running
        if ($svc.Status -ne 'Running') {
            Start-Service -Name $service.Key
        }
    } catch {
        Write-Output "Error setting startup type or starting service: $($service.Key)"
    }
}
