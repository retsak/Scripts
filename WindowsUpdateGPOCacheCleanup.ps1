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