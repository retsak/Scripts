# Connect to the directory
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Retrieve all groups
$groups = Get-MgGroup -All

# Iterate over each group
foreach ($group in $groups) {
    # Retrieve the group's dynamic membership rule
    $rule = Get-MgGroupSettingTemplate -GroupId $group.Id

    # Check if the rule contains 'deviceOS' and '10.0.22*'
    if ($rule.Value -like "*deviceOS*" -and $rule.Value -like "*10.0.22*") {
        # Output the group
        $group | Format-Table -Property Id, DisplayName, Description
    }
}
