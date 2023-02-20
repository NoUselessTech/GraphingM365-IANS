Using Module ..\Classes\Nodes.psm1
Using Module ..\Classes\Edges.psm1

Function Get-UserToCaEdges() {
    Param(
        $CaPolicies,
        $Users
    )
    $Return = @()
    $Count = 0
    ForEach($CaPolicy in $CaPolicies) {
        $Count+=1
        Write-Progress `
            -Id 1 `
            -Activity "Connecting users to policies" `
            -Status $CaPolicy.DisplayName `
            -PercentComplete ($Count*100 / $CaPolicies.Count)

        If (    $CaPolicy.Conditions.Users.IncludeUsers.count -gt 0 -or 
                $CaPolicy.Conditions.Users.ExcludeUsers.count -gt 0 ) {

            ForEach($Included in $CaPolicy.Conditions.Users.IncludeUsers) {
                if ($Included -eq "All") {
                    ForEach($User in $Users) {
                        $Edge = [BasicEdge]::new(
                            "Enforces",
                            $CaPolicy.Id,
                            $User.Id
                        )
                        $Return += $Edge
                    }
                } else {
                    $Edge = [BasicEdge]::new(
                        "Enforces",
                        $CaPolicy.Id,
                        $Included
                    )
                    $Return += $Edge
                }
            }

            ForEach($Excluded in $CaPolicy.Conditions.Users.ExcludeUsers) {
                if ($Excluded -eq "All") {
                    ForEach($User in $Users) {
                        $Edge = [BasicEdge]::new(
                            "NotEnforces",
                            $CaPolicy.Id,
                            $User.Id
                        )
                        $Return += $Edge
                    }
                } else {
                    $Edge = [BasicEdge]::new(
                        "NotEnforces",
                        $CaPolicy.Id,
                        $Excluded
                    )
                    $Return += $Edge
                }
            }
            
        }
    }

    Write-Progress `
        -Id 1 `
        -Activity "Connecting users to policies." `
        -Status "Complete" `
        -Completed

    return $Return
}

Function Get-GroupToCaEdges() {
    Param(
        $CaPolicies,
        $Groups
    )
    $Return = @()
    $Count = 0
    ForEach($CaPolicy in $CaPolicies) {
        $Count+=1
        Write-Progress `
            -Id 1 `
            -Activity "Connecting groups to policies" `
            -Status $CaPolicy.DisplayName `
            -PercentComplete ($Count*100 / $CaPolicies.Count)

        If (    $CaPolicy.Conditions.Users.IncludeGroups.count -gt 0 -or 
                $CaPolicy.Conditions.Users.ExcludeGroups.count -gt 0 ) {

            ForEach($Included in $CaPolicy.Conditions.Users.IncludeGroups) {
                $Edge = [BasicEdge]::new(
                    "Enforces",
                    $CaPolicy.Id,
                    $Included
                )
                $Return += $Edge
            }

            ForEach($Excluded in $CaPolicy.Conditions.Users.ExcludeGroups) {
                $Edge = [BasicEdge]::new(
                    "NotEnforces",
                    $CaPolicy.Id,
                    $Excluded
                )

                $Return += $Edge
            }  
        }
    }

    Write-Progress `
        -Id 1 `
        -Activity "Connecting groups to policies." `
        -Status "Complete" `
        -Completed

    return $Return
}

Function Get-RoleToCaEdges() {
    Param(
        $CaPolicies,
        $Roles
    )
    $Return = @()
    $Count = 0
    ForEach($CaPolicy in $CaPolicies) {
        $Count+=1
        Write-Progress `
            -Id 1 `
            -Activity "Connecting groups to policies" `
            -Status $CaPolicy.DisplayName `
            -PercentComplete ($Count*100 / $CaPolicies.Count)

        If (    $CaPolicy.Conditions.Users.IncludeRoles.count -gt 0 -or 
                $CaPolicy.Conditions.Users.ExcludeRoles.count -gt 0 ) {

            ForEach($Included in $CaPolicy.Conditions.Users.IncludeRoles) {
                $Edge = [BasicEdge]::new(
                    "Enforces",
                    $CaPolicy.Id,
                    $Included
                )
                $Return += $Edge
            }

            ForEach($Excluded in $CaPolicy.Conditions.Users.ExcludeRoles) {
                $Edge = [BasicEdge]::new(
                    "NotEnforces",
                    $CaPolicy.Id,
                    $Excluded
                )

                $Return += $Edge
            }  
        }
    }

    Write-Progress `
        -Id 1 `
        -Activity "Connecting groups to policies." `
        -Status "Complete" `
        -Completed

    return $Return
}

Function Get-ApplicationToCaEdges() {
    Param(
        $CaPolicies,
        $Apps
    )
    $Return = @()
    $Count = 0
    ForEach($CaPolicy in $CaPolicies) {
        $Count+=1
        Write-Progress `
            -Id 1 `
            -Activity "Connecting apps to policies" `
            -Status $CaPolicy.DisplayName `
            -PercentComplete ($Count*100 / $CaPolicies.Count)

        If (    $CaPolicy.Conditions.Applications.IncludeApplications.count -gt 0 -or 
                $CaPolicy.Conditions.Applications.ExcludeApplications.count -gt 0 ) {

            ForEach($Included in $CaPolicy.Conditions.Applications.IncludeApplications) {
                if ($Included -eq "All") {
                    ForEach($App in $Apps) {
                        $Edge = [BasicEdge]::new(
                            "Protects",
                            $CaPolicy.Id,
                            $App.Id
                        )
                        $Return += $Edge
                    }
                } else {
                    $Edge = [BasicEdge]::new(
                        "Protects",
                        $CaPolicy.Id,
                        $Included
                    )
                    $Return += $Edge
                }
            }

            ForEach($Excluded in $CaPolicy.Conditions.Applications.ExcludeApplications) {
                if ($Excluded -eq "All") {
                    ForEach($App in $Apps) {
                        $Edge = [BasicEdge]::new(
                            "NotProtects",
                            $CaPolicy.Id,
                            $App.Id
                        )
                        $Return += $Edge
                    }
                } else {
                    $Edge = [BasicEdge]::new(
                        "NotProtects",
                        $CaPolicy.Id,
                        $Excluded
                    )
                    $Return += $Edge
                }
            }
            
        }
    }

    Write-Progress `
        -Id 1 `
        -Activity "Connecting apps to policies." `
        -Status "Complete" `
        -Completed

    return $Return
}

Function Get-RoleToAllEdges() {
    Param(
        $Roles
    )
    $Return = @()
    $Count = 0
    ForEach($Role in $Roles) {
        $Count+=1
        Write-Progress `
            -Id 1 `
            -Activity "Connecting Roles to Nodes" `
            -Status $Role.DisplayName `
            -PercentComplete ($Count*100 / $Roles.Count)

        $RoleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $Role.Id

        ForEach($RoleMember in $RoleMembers) {
            $Edge = [BasicEdge]::new(
                "Assigned",
                $Role.Id,
                $RoleMember.Id
            )
            $Return += $Edge
        }
    }

    Write-Progress `
        -Id 1 `
        -Activity "Connecting Roles to Nodes." `
        -Status "Complete" `
        -Completed

    return $Return
}

Function Get-GroupToAllEdges() {
    Param(
        $Groups
    )
    $Return = @()
    $Count = 0
    ForEach($Group in $Groups) {
        $Count+=1
        Write-Progress `
            -Id 1 `
            -Activity "Connecting Group to Nodes" `
            -Status $Group.DisplayName `
            -PercentComplete ($Count*100 / $Groups.Count)

        $GroupMembers = Get-MgGroupMember -GroupId $Group.Id

        ForEach($GroupMember in $GroupMembers) {
            $Edge = [BasicEdge]::new(
                "MemberOf", # I don't like this...but it's pretty drilled in.
                $GroupMember.Id,
                $Group.Id
            )
            $Return += $Edge
        }
    }

    Write-Progress `
        -Id 1 `
        -Activity "Connecting Group to Nodes." `
        -Status "Complete" `
        -Completed

    return $Return
}

Function Get-RoleToActionEdge() {
    Param(
    )
    $Return = @()
    $Count = 0
    $Roles = Get-MgRoleManagementDirectoryRoleDefinition
    ForEach($Role in $Roles) {
        $Count+=1
        Write-Progress `
            -Id 1 `
            -Activity "Connecting Roles to Actions" `
            -Status $Role.DisplayName `
            -PercentComplete ($Count*100 / $Roles.Count)

        $Actions = $Role.RolePermissions.AllowedResourceActions

        ForEach($Action in $Actions) { 
            $Edge = [BasicEdge]::new(
                "Entitles",
                $Action,
                $Role.DisplayName
            )
            $Return += $Edge
        }
    }

    Write-Progress `
        -Id 1 `
        -Activity "Connecting Roles to Nodes." `
        -Status "Complete" `
        -Completed

    return $Return
}