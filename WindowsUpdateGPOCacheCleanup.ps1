$GPCacheListofAllowedValues = @('(Default)', 'AllowOptionalContent', 'ManagePreviewBuilds')

$cacheSets = Get-Item -Path registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UpdatePolicy\GPCache\CacheSet*"
$cacheSets | ForEach-Object {
    $cacheSetName = $_.Name + '\WindowsUpdate'
    Get-Item -Path registry::"$cacheSetName" | ForEach-Object {
        $cacheSet = $_
        Get-ItemProperty -Path $cacheSet.PSPath | ForEach-Object {
            $propertyNames = $_ | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
            foreach ($propertyName in $propertyNames) {            
                if ($propertyName -notin $GPCacheListofAllowedValues -and $propertyName -inotlike 'PS*') {
                    #$cacheSet.DeleteValue($propertyName)
                    Write-Host "Deleted $propertyName from $cacheSetName"
                }
            }
        }
    }
}

#Copilot
$allowedGPCacheValues = @('(Default)', 'AllowOptionalContent', 'ManagePreviewBuilds')

$windowsUpdateCacheSets = Get-Item -Path registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UpdatePolicy\GPCache\CacheSet*"

foreach ($cacheSet in $windowsUpdateCacheSets) {
    $cacheSetName = $cacheSet.Name + '\WindowsUpdate'
    $windowsUpdateCacheSet = Get-Item -Path registry::"$cacheSetName"
    
    if ($windowsUpdateCacheSet) {
        $properties = Get-ItemProperty -Path $windowsUpdateCacheSet.PSPath
        $propertyNames = $properties | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name

        foreach ($propertyName in $propertyNames) {
            if ($propertyName -notin $allowedGPCacheValues -and $propertyName -inotlike 'PS*') {
                $confirmation = Read-Host "Are you sure you want to delete $propertyName from $cacheSetName? (yes/no)"
                if ($confirmation -eq 'yes') {
                    $windowsUpdateCacheSet.DeleteValue($propertyName)
                    Write-Host "Deleted $propertyName from $cacheSetName"
                }
            }
        }
    }
}

#Gemini
# Import necessary modules
Import-Module Registry

# List of allowed values for the Windows Update GPO Cache
$GPCacheListofAllowedValues = @('(Default)', 'AllowOptionalContent', 'ManagePreviewBuilds')

# Get all the cache sets under the registry key
$cacheSets = Get-Item -Path registry::"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UpdatePolicy\GPCache\CacheSet*"

# Loop through each cache set
$cacheSets | ForEach-Object {
    # Get the name of the cache set 
    $cacheSetName = $_.Name + '\WindowsUpdate'

    # Get all the values under the cache set registry key
    Get-Item -Path registry::"$cacheSetName" |  ForEach-Object {
        # Get the cache set object
        $cacheSet = $_

        # Get all the properties of the cache set object
        Get-ItemProperty -Path $cacheSet.PSPath | ForEach-Object {
            # Get the names of the properties
            $propertyNames = $_ | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name

             # Loop through each property name
            foreach ($propertyName in $propertyNames) {            
                # Check if the property name is not in the list of allowed values and not a PowerShell property
                if ($propertyName -notin $GPCacheListofAllowedValues -and $propertyName -inotlike 'PS*') {
                    # Attempt to delete the property
                    try {
                        Remove-ItemProperty -Path $cacheSet.PSPath -Name $propertyName
                        Write-Host "Deleted $propertyName from $cacheSetName"
                    }
                    catch {
                        # Handle errors gracefully and log the error
                        Write-Error "Error deleting property $propertyName from $cacheSetName: $_"
                    }
                }
            }
        }
    }
}
