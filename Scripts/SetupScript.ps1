## Setup script for the 2nd Lab of the M365 Graphing Class

## -- Variables
$TotalSteps = 0
$CompletedSteps = 0
$TenantDomain = $Null
$Global:TenantUsers = @()
$Global:TenantGroups = @()

## -- Functions

## Logic
Clear-Host
try {
    Write-Host " M365 Sandbox Setup Utility.`r`n" -ForegroundColor White

    ## Logic -- Check for previous run
    if ( Test-Path .\setup_complete) {
        throw " Setup already run."
    }

    ## Logic -- Installing Microsoft Graph module 
    try {
        Write-Host " Installing Microsoft Graph Module." -ForegroundColor White
        $TotalSteps++
        if ( (Get-Module -Name "Microsoft.Graph" -ListAvailable).Count -eq 0) {
            Install-Module -Name Microsoft.Graph
        } else {
            Write-Host " Microsoft Graph powershell module installed." -ForegroundColor Yellow
        }
        $CompletedSteps++
    }catch {
        throw " Module installation was not successful.`r`n $_"
    }

    ## Logic -- Connect To Microsoft Graph
    Write-Host "`r`n Connecting To Microsoft Graph." -ForegroundColor White
    try {
        $TotalSteps++
        $Scopes = @(
            "Directory.ReadWrite.All",
            "Policy.ReadWrite.ConditionalAccess",
            "Application.ReadWrite.All"
        )
        Connect-MgGraph -Scopes ($Scopes -Join ",") | Out-Null
        Select-MgProfile -Name Beta
        Write-Host " Connected." -ForegroundColor Yellow
        $CompletedSteps++

    } catch {
        throw "Unable to connect to Microsoft Graph. `r`n $_"
    }

    
    ## Logic -- <Logic>
    Write-Host " Getting tenant information." -ForegroundColor Yellow
    try {
        $TotalSteps++
        $TenantDomain = (Get-MgOrganization).VerifiedDomains.Name
        $CompletedSteps++
    } catch {
        throw " Could not get Tenant Domain.`r`n $_"
    }

    ## Logic -- Starting to configure
    Write-Host "`r`n Setting up the tenant." -ForegroundColor White

    ## Logic -- Create Users
    Write-Host " Creating users." -ForegroundColor Yellow
    try {
        $TotalSteps++
        $PasswordSeed = "1234567890!@#$%^&*()QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm" -Split ''
        $Users = @(
            "Einstein",
            "Archimedes",
            "Euclid",
            "Plato",
            "Aristotle",
            "Socrates",
            "Hippocrates",
            "Galileo",
            "Leonardo",
            "Curie"
        )

        ForEach($User in $Users) {
            $UserParams = @{
                AccountEnabled = $true
                DisplayName = $User
                MailNickname = $User
                UserPrincipalName = "$User@$TenantDomain"
                PasswordProfile = @{
                    ForceChangePasswordNextSignIn = $true
                    Password =  (-join($PasswordSeed | Get-Random -Count 14 -ErrorAction SilentlyContinue))
                }
            }

            $Global:TenantUsers += New-MgUser -BodyParameter $UserParams
        }

        $CompletedSteps++
    } catch {
        throw $_
    }

    ## Logic -- Create Groups
    Write-Host " Creating groups." -ForegroundColor Yellow
    try {
        $TotalSteps++
        $Groups = @(
            "Executives",
            "Admins",
            "Legal"
        )

        ForEach($Group in $Groups) {
            $GroupParams = @{
                SecurityEnabled = $True
                MailNickname = $Group
                MailEnabled = $False
                DisplayName = $Group
                IsAssignableToRole = $True
            }
            $GroupInfo = New-MgGroup -BodyParameter $GroupParams
            $Global:TenantGroups += $GroupInfo

            $BodyParams = $Null
            Switch ($Group) {
                "Executives" {
                    $BodyParams = @{
                        "Members@odata.bind" = @(
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[0].Id)"
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[1].Id)"
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[2].Id)"
                        )
                    }
                }
                "Admins" {
                    $BodyParams = @{
                        "Members@odata.bind" = @(
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[4].Id)"
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[5].Id)"
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[6].Id)"
                        )
                    }
                }
                "Legal"{
                    $BodyParams = @{
                        "Members@odata.bind" = @(
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[7].Id)"
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[8].Id)"
                            "https://graph.microsoft.com/v1.0/directoryObjects/$($Global:TenantUsers[9].Id)"
                        )
                    }
                }
            }

            Update-MgGroup -GroupId $GroupInfo.Id -BodyParameter $BodyParams
        }

        $CompletedSteps++
    } catch {
        throw " Could not create groups. `r`n $_"
    }

    # Logic -- Add 


    ## Logic -- Assign Roles
    Write-Host " Assigning Roles." -ForegroundColor Yellow
    try {
        $TotalSteps++

        ## Global Admin
        $AdminGroup = $Global:TenantGroups | Where-Object { $_.DisplayName -eq "Admins"}
        $AdminUser = $Global:TenantUsers | Where-Object { $_.DisplayName -eq "Curie"}
        New-MgRoleManagementDirectoryRoleAssignment `
            -RoleDefinitionId "62e90394-69f5-4237-9190-012177145e10" `
            -PrincipalId $AdminGroup.Id `
            -DirectoryScopeId "/"
        New-MgRoleManagementDirectoryRoleAssignment `
            -RoleDefinitionId "62e90394-69f5-4237-9190-012177145e10" `
            -PrincipalId $AdminUser.Id `
            -DirectoryScopeId "/"
                
        ## Global Reader
        $ReaderGroup = $Global:TenantGroups | Where-Object {$_.DisplayName -eq "Executives"}
        New-MgRoleManagementDirectoryRoleAssignment `
            -RoleDefinitionId "f2ef992c-3afb-46b9-b7cf-a126ee74c451" `
            -PrincipalId $ReaderGroup.Id `
            -DirectoryScopeId "/"

        ## Application Administrator
        $ReaderGroup = $Global:TenantGroups | Where-Object {$_.DisplayName -eq "Legal"}
        New-MgRoleManagementDirectoryRoleAssignment `
            -RoleDefinitionId "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3" `
            -PrincipalId $ReaderGroup.Id `
            -DirectoryScopeId "/"

        $CompletedSteps++
    } catch {
        throw " Could not assign roles.`r`n $_"
    }

    ## Logic -- Create CA Policies
    Write-Host " Creating Policies." -ForegroundColor Yellow
    try {
        $TotalSteps++

        $Curie = $Global:TenantUsers | Where-Object {$_.DisplayName -eq "Curie"}

        Update-MgPolicyIdentitySecurityDefaultEnforcementPolicy -IsEnabled:$False
        Start-Sleep -Seconds 10
        
        # Policy configus
        $PolicyConfigs = @(
            @{
                DisplayName = "ExamplePolicyOne"
                State = "disabled"
                Conditions = @{
                    Applications = @{
                        IncludeApplications =   @("All")
                    }
                    Users = @{
                        IncludeUsers = @("All")
                    }
                }
                GrantControls = @{
                    Operator = "OR"
                    BuiltInControls= @(
                        "mfa"
                    )
                }
            },
            @{
                DisplayName = "ExamplePolicyTwo"
                State = "enabled"
                Conditions = @{
                    Applications = @{
                        IncludeApplications =   @("All")
                    }
                    Users = @{
                        IncludeUsers = @("All")
                        ExcludeUsers = @($Curie.Id)
                    }
                }
                GrantControls = @{
                    Operator = "OR"
                    BuiltInControls= @(
                        "mfa"
                    )
                }
            }
        )

        ForEach($Config in $PolicyConfigs) {
            New-MgIdentityConditionalAccessPolicy -BodyParameter $Config
        }


        $CompletedSteps++
    } catch {
        throw " Could not assign CA Policies.`r`n $_"
    }

} catch {
    Write-Host " Could not complete the run." -ForegroundColor Red
    Write-Host $_ -ForegroundColor Red
}

## Logic -- Write Completion file to avoid duplication
if ($TotalSteps -eq $CompletedSteps) {
    "Done" | Out-File setup_complete
}
    
## Logic -- Done
Write-Host "`r`n Done.`r`n" -ForegroundColor Green
Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null