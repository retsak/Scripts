
# Service Configuration Remediation Script

This repository contains PowerShell scripts designed for Microsoft Intune Remediations to ensure specific Windows services are running and set to the correct startup types. 

## Overview

The package consists of a detection script and a remediation script. The detection script checks if the specified services are running and have their startup types set as desired. If any service does not meet the criteria, the remediation script will adjust the startup type and start the service accordingly.

### Services Configuration

The scripts are configured for the following services and startup types:

- `Spooler` service should have a startup type of `Automatic`
- `WSearch` service should have a startup type of `Manual`
- `BITS` service should have a startup type of `AutomaticDelayedStart`

## Detection Script

This PowerShell script checks the specified services against the desired states.

```powershell
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
```

## Remediation Script

This script adjusts the startup types and starts the services if necessary.

```powershell
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
```

## Deployment Instructions

1. **Testing and Validation**: Test the scripts in a controlled environment before broad deployment.
2. **Error Handling**: The remediation script includes basic error handling. Expand as necessary.
3. **Customization**: Modify the `$services` hashtable as per your environment's requirements.
4. **Deployment**: Use Microsoft Intune Remediations for deployment. Ensure the execution context has appropriate permissions.

### Notes

- Ensure scripts run with the necessary permissions to modify service configurations and start services.
- Customize the service list and startup types according to your needs.
