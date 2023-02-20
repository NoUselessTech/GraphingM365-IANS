Using Module ..\Classes\Nodes.psm1

Function Get-ServicePrincipalNodes() {
    try {
        $ServicePrincipals = Get-MgServicePrincipal
        $Return = @()
        $Count = 0
        ForEach($ServicePrincipal in $ServicePrincipals) {
            $Count += 1
            Write-Progress `
                -Id 0 `
                -Activity "Gathering Service Principals" `
                -Status $ServicePrincipal.DisplayName `
                -PercentComplete ($Count*100 / $ServicePrincipals.Count)

            $Node = [ServicePrincipalNode]::new(
                "ServicePrincipal",
                $ServicePrincipal.Id,
                $ServicePrincipal.DisplayName,
                $ServicePrincipal.AccountEnabled,
                $ServicePrincipal.Description,
                $ServicePrincipal.AppId,
                $ServicePrincipal.ServicePrincipalType,
                $ServicePrincipal.SignInAudience,
                ($ServicePrincipal.PasswordCredentials.count -gt 0),
                ($ServicePrincipal.KeyCredentials.count -gt 0)
            )
            $Return += $Node
        }

        Write-Progress `
        -Id 0 `
        -Activity "Gathering Service Principals" `
        -Status "Complete" `
        -Completed

        return $Return
    }
    catch {
        throw $_
    }
}

Function Get-UserNodes() {
    try {
        $Users = Get-MgUser
        $Return = @()
        $Count = 0
        ForEach($User in $Users) {
            $Count += 1
            Write-Progress `
                -Id 0 `
                -Activity "Gathering Users" `
                -Status $User.DisplayName `
                -PercentComplete ($Count*100 / $Users.Count)
            $Node = [UserNode]::new(
                "User",
                $User.Id,
                $User.DisplayName,
                $User.createdDateTime,
                $User.AccountEnabled,
                $User.LastPasswordChangeDateTime,
                $User.Mail
            )
            $Return += $Node
        }

        Write-Progress `
        -Id 0 `
        -Activity "Gathering Users" `
        -Status "Complete" `
        -Completed

        return $Return
    }
    catch {
        throw $_
    }
}

Function Get-GroupNodes() {
    try {
        $Groups = Get-MgGroup
        $Return = @()
        $Count = 0
        ForEach($Group in $Groups) {
            $Count += 1
            Write-Progress `
                -Id 0 `
                -Activity "Gathering Groups" `
                -Status $Group.DisplayName `
                -PercentComplete ($Count*100 / $Groups.Count)
            $Node = [GroupNode]::new(
                "Group",
                $Group.Id,
                $Group.DisplayName,
                $Group.createdDateTime,
                $Group.Mail,
                $Group.MailEnabled,
                $Group.OnPremisesDomainName,
                $Group.OnPremisesSyncEnabled,
                $Group.SecurityEnabled
            )
            $Return += $Node
        }

        Write-Progress `
        -Id 0 `
        -Activity "Gathering Groups" `
        -Status "Complete" `
        -Completed

        return $Return
    }
    catch {
        throw $_
    }
}

Function Get-RoleNodes() {
    try {
        $Roles = Get-MgDirectoryRole
        $Return = @()
        $Count = 0
        ForEach($Role in $Roles) {
            $Count += 1
            Write-Progress `
                -Id 0 `
                -Activity "Gathering Roles" `
                -Status $Role.DisplayName `
                -PercentComplete ($Count*100 / $Roles.Count)
            $Node = [RoleNode]::new(
                "Role",
                $Role.Id,
                $Role.DisplayName,
                $Role.Description,
                $Role.RoleTemplateId
            )
            $Return += $Node
        }

        Write-Progress `
        -Id 0 `
        -Activity "Gathering Roles" `
        -Status "Complete" `
        -Completed

        return $Return
    }
    catch {
        throw $_
    }
}

Function Get-NamedLocationNodes() {
    try {
        $NamedLocations = Get-MgIdentityConditionalAccessNamedLocation
        $Return = @()
        $Count = 0
        ForEach($NamedLocation in $NamedLocations) {
            $Count += 1
            Write-Progress `
                -Id 0 `
                -Activity "Gathering Named Locations" `
                -Status $NamedLocation.DisplayName `
                -PercentComplete ($Count*100 / $NamedLocations.Count)
            $Node = [NamedLocationNode]::new(
                "NamedLocation",
                $NamedLocation.Id,
                $NamedLocation.DisplayName,
                $NamedLocation.CreatedDateTime,
                $NamedLocation.ModifiedDateTime,
                ($NamedLocation.AdditionalProperties.countriesAndRegions | ConvertTo-Json -Compress),
                ($NamedLocation.AdditionalProperties.includeUnknownCountriesAndRegions),
                $NamedLocation.AdditionalProperties.countryLookupMethod,
                $NamedLocation.AdditionalProperties.isTrusted,
                ($NamedLocation.AdditionalProperties.ipRanges | ConvertTo-Json -Compress),
                $NamedLocation.AdditionalProperties.'@odata.type'
            )
            $Return += $Node
        }

        Write-Progress `
        -Id 0 `
        -Activity "Gathering Named Locations" `
        -Status "Complete" `
        -Completed

        return $Return
    }
    catch {
        throw $_
    }
}

Function Get-DeviceNodes() {
    try {
        $Devices = Get-MgDevice
        $Return = @()
        $Count = 0
        ForEach($Device in $Devices) {
            $Count += 1
            Write-Progress `
                -Id 0 `
                -Activity "Gathering Devices" `
                -Status $Device.DisplayName `
                -PercentComplete ($Count*100 / $Devices.Count)
            $Node = [DeviceNode]::new(
                "Device",
                $Device.Id,
                $Device.DisplayName,
                $Device.AccountEnabled,
                $Device.AdditionalProperties.createdDateTime,
                $Device.ApproximateLastSignInDateTime,
                $Device.DeviceId,
                $Device.DomainName,
                $Device.IsCompliant,
                $Device.IsManaged,
                $Device.IsRooted,
                $Device.OperatingSystem,
                $Device.ProfileType,
                $Device.TrustType
            )
            $Return += $Node
        }

        Write-Progress `
        -Id 0 `
        -Activity "Gathering Devices" `
        -Status "Complete" `
        -Completed

        return $Return
    }
    catch {
        throw $_
    }
}

Function Get-ConditionalAccessPolicyNodes() {
    try {
        $Policies = Get-MgIdentityConditionalAccessPolicy
        $Return = @()
        $Count = 0
        ForEach($Policy in $Policies) {
            $Count += 1
            Write-Progress `
                -Id 0 `
                -Activity "Gathering Policies" `
                -Status $Policy.DisplayName `
                -PercentComplete ($Count*100 / $Policies.Count)
            $Node = [ConditionalAccessPolicyNode]::new(
                "ConditionalAccessPolicy",
                $Policy.Id,
                $Policy.DisplayName,
                $Policy.CreatedDateTime,
                $Policy.ModifiedDateTime,
                $Policy.State,
                $Policy.Conditions.Applications.IncludeAuthenticationContextClassReferences,
                $Policy.Conditions.Applications.IncludeUserActions,
                $Policy.Conditions.Applications.ClientAppTypes,
                $Policy.Conditions.Platforms.ExcludePlatforms,
                $Policy.Conditions.Platforms.IncludePlatforms,
                $Policy.Conditions.SignInRiskLevels,
                $Policy.Conditions.UserRiskLevels,
                ($Policy.GrantControls.BuiltInControls | ConvertTo-Json -Compress),
                ($Policy.GrantControls.CustomAuthenticationFactors | ConvertTo-Json -Compress),
                $Policy.GrantControls.Operator,
                $Policy.GrantControls.TermsOfUse,
                $Policy.SessionControls.DisableResilienceDefaults
            )
            $Return += $Node
        }

        Write-Progress `
        -Id 0 `
        -Activity "Gathering Policies" `
        -Status "Complete" `
        -Completed

        return @($Return, $Policies)
    }
    catch {
        throw $_
    }
}

Function Get-ActionNodes() {
    try {
        $GlobalAdminRole = Get-MgRoleManagementDirectoryRoleDefinition |
         Where-Object {$_.DisplayName -eq "Global Administrator"}
        $Actions = $GlobalAdminRole.RolePermissions.AllowedResourceActions
        $Return = @()
        $Count = 0
        ForEach($Action in $Actions) {
            $Count += 1
            Write-Progress `
                -Id 0 `
                -Activity "Gathering Actions" `
                -Status $Action `
                -PercentComplete ($Count*100 / $Actions.Count)
            $Node = [BasicNode]::new(
                "Action",
                "",
                $Action
            )
            $Return += $Node
        }

        Write-Progress `
        -Id 0 `
        -Activity "Gathering Actions" `
        -Status "Complete" `
        -Completed

        return $Return
    }
    catch {
        throw $_
    }
}