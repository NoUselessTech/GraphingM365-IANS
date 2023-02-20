## -- Imports
Using Module .\Classes\Nodes.psm1
Using Module .\Classes\Edges.psm1
Import-Module .\Functions\NodeFunctions.psm1
Import-Module .\Functions\EdgeFunctions.psm1
Import-Module .\Functions\CypherOutput.psm1

## -- Variables
$ServicePrincipalNodes = @()
$UserNodes = @()
$GroupNodes = @()
$RoleNodes = @()
$DeviceNodes = @()
$ActionNodes = @()
$NamedLocationNodes = @()
$ConditionalAccessPolicyNodes = @()
$RawConditionalAccessPolicies = @()

## -- Functions

## -- Logic
Clear-Host # Clears the terminal so all previous info removed
Write-Host " Starting CA to Cyper.`r`n " -ForegroundColor White

Write-Host " Checking prerequisites." -ForegroundColor White

try {
    ## [l] -- Precheck
    Write-Host " Checking for Microsoft Graph Powershell." -ForegroundColor Yellow
    try {
        If (!(Get-Module -Name Microsoft.Graph -ListAvailable)) {
            Install-Module -Name Microsoft.Graph
        }
    } catch {
        throw " Could not install Microsoft Graph.`r`n Try again from an administrative prompt.`r`n $_"
    }
    
    Write-Host "`r`n Connecting to Microsoft Graph." -Foreground White
    ## [l] -- Connect to Microsoft Graph
    try { 
        Connect-MgGraph -Scopes "Directory.Read.All,User.Read.All,Policy.Read.All,Group.Read.All" | Out-Null
        Select-MgProfile -Name Beta 
        Write-Host " Connected to Microsoft Graph." -ForegroundColor Yellow
    } catch {
        throw " Could not connect to Microsoft Graph. `r`n $_"

    }

    Write-Host "`r`n Gathering Nodes." -ForegroundColor White

    ## [l] -- Start enumerating service principals
    try {
        Write-Host " Enumerating Service Principals." -ForegroundColor Yellow
        $ServicePrincipalNodes = Get-ServicePrincipalNodes
        $ServicePrincipalNodes | Export-Csv -NoTypeInformation "./Output/ServicePrincipalNodes.csv"
        $ServicePrincipalNodes | ConvertTo-Json | Out-File "./Output/ServicePrincipalNodes.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Unable to gather Microsoft Service Principals.`r`n $_"
    }

    ## [l] -- Start enumerating user accounts
    try {
        Write-Host " Enumerating Users." -ForegroundColor Yellow
        $UserNodes = Get-UserNodes
        $UserNodes | Export-Csv -NoTypeInformation "./Output/UserNodes.csv"
        $UserNodes | ConvertTo-Json | Out-File "./Output/UserNodes.json"

    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Unable to gather end users.`r`n $_"
    }

    ## [l] -- Start enumerating groups
    try {
        Write-Host " Enumerating Groups." -ForegroundColor Yellow
        $GroupNodes = Get-GroupNodes
        $GroupNodes | Export-Csv -NoTypeInformation "./Output/GroupNodes.csv"
        $GroupNodes | ConvertTo-Json | Out-File "./Output/GroupNodes.json"

    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Unable to gather groups.`r`n $_"
    }

    
    ## [l] -- Start enumerating roles
    try {
        Write-Host " Enumerating Roles." -ForegroundColor Yellow
        $RoleNodes = Get-RoleNodes
        $RoleNodes | Export-Csv -NoTypeInformation "./Output/RoleNodes.csv"
        $RoleNodes | ConvertTo-Json | Out-File "./Output/RoleNodes.json"

    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Unable to gather roles.`r`n $_"
    }

    ## [l] -- Start enumerating named locations
    try {
        Write-Host " Enumerating Named Locations." -ForegroundColor Yellow
        $NamedLocationNodes = Get-NamedLocationNodes
        $NamedLocationNodes | Export-Csv -NoTypeInformation "./Output/NamedLocationNodes.csv"
        $NamedLocationNodes | ConvertTo-Json | Out-File "./Output/NamedLocationNodes.json"

    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Unable to gather Named Locations.`r`n $_"
    }

    ## [l] -- Start enumerating devices
    try {
        Write-Host " Enumerating Devices." -ForegroundColor Yellow
        $DeviceNodes = Get-DeviceNodes
        $DeviceNodes | Export-Csv -NoTypeInformation "./Output/DeviceNodes.csv"
        $DeviceNodes | ConvertTo-Json | Out-File "./Output/DeviceNodes.json"

    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Unable to gather devices.`r`n $_"
    }

    ## [l] -- Start enumerating ca policies
    try {
        Write-Host " Enumerating Conditional Access Policies." -ForegroundColor Yellow
        $CAPolicyInfo = Get-ConditionalAccessPolicyNodes
        # This is the final piece of node collection. All needed nodes should now exist.
        $ConditionalAccessPolicyNodes = $CAPolicyInfo[0]
        $RawConditionalAccessPolicies = $CAPolicyInfo[1]
        $ConditionalAccessPolicyNodes | Export-Csv -NoTypeInformation "./Output/ConditionalAccessPolicyNodes.csv"
        $ConditionalAccessPolicyNodes | ConvertTo-Json | Out-File "./Output/ConditionalAccessPolicyNodes.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Unable to gather devices.`r`n $_"
    }

    
    ## Logic -- Enumerate Microsoft Actoins
    try {
        Write-Host " Enumerating Microsoft Actions." -ForegroundColor Yellow
        $ActionNodes = Get-ActionNodes
        $ActionNodes | Export-Csv -NoTypeInformation "./Output/ActionNodes.csv"
        $ActionNodes | ConvertTo-Json | Out-File "./Output/ActionNodes.json"
    } catch {
        throw " Unable to gather action nodes.`r`n $_"
    }

    Write-Host "`r`n Building Connections." -ForegroundColor White
    
    ## [l] -- Connecting CA Policies and Users
    try {
        Write-Host " Connecting Users to Policies." -ForegroundColor Yellow
        $UserCaEdges = Get-UserToCaEdges -CaPolicies $RawConditionalAccessPolicies -Users $UserNodes
        $UserCaEdges | Export-Csv -NoTypeInformation "./Output/UserCaEdges.csv"
        $UserCaEdges | ConvertTo-Json | Out-File "./Output/UserCaEdges.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Could not map users to policies.`r`n $_da"
    }

    ## [l] -- Connecting CA Policies and Groups
    try {
        Write-Host " Connecting Groups to Policies." -ForegroundColor Yellow
        $GroupCaEdges = Get-GroupToCaEdges -CaPolicies $RawConditionalAccessPolicies -Groups $GroupNodes
        $GroupCaEdges | Export-Csv -NoTypeInformation "./Output/GroupCaEdges.csv"
        $GroupCaEdges | ConvertTo-Json | Out-File "./Output/GroupCaEdges.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Could not map groups to policies.`r`n $_"
    }

    ## [l] -- Connecting CA Policies and Roles
    try {
        Write-Host " Connecting Roles to Policies." -ForegroundColor Yellow
        $RoleToCaEdges = Get-RoleToCaEdges -CaPolicies $RawConditionalAccessPolicies -Roles $RoleNodes
        $RoleToCaEdges | Export-Csv -NoTypeInformation "./Output/RoleToCaEdges.csv"
        $RoleToCaEdges | ConvertTo-Json | Out-File "./Output/RoleToCaEdges.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Could not map roles to policies.`r`n $_"
    }

    ## [l] -- Connecting CA Policies and Service Principals
    try {
        Write-Host " Connecting Applications to Policies." -ForegroundColor Yellow
        $SpCaEdges = Get-ApplicationToCaEdges -CaPolicies $RawConditionalAccessPolicies -Apps $ServicePrincipalNodes
        $SpCaEdges | Export-Csv -NoTypeInformation "./Output/ApplicationCaEdges.csv"
        $SpCaEdges | ConvertTo-Json | Out-File "./Output/ApplicationCaEdges.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Could not map applications to policies.`r`n $_"
    }

    ## [l] -- Mapping Roles
    try {
        Write-Host " Mapping roles." -ForegroundColor Yellow
        $RoleToAllEdges = Get-RoleToAllEdges -Roles $RoleNodes
        $RoleToAllEdges | Export-Csv -NoTypeInformation "./Output/RoleToAllEdges.csv"
        $RoleToAllEdges | ConvertTo-Json | Out-File "./Output/RoleToAllEdges.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Could not map roles.`r`n $_"
    }
    #>

    ## [l] -- Mapping Groups
    try {
        Write-Host " Mapping groups." -ForegroundColor Yellow
        $GroupToAllEdges = Get-GroupToAllEdges -Groups $GroupNodes
        $GroupToAllEdges | Export-Csv -NoTypeInformation "./Output/GroupToAllEdges.csv"
        $GroupToAllEdges | ConvertTo-Json | Out-File "./Output/GroupToAllEdges.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Could not map groups.`r`n $_"
    }

    ## [l] -- Mapping Groups
    try {
        Write-Host " Mapping Actions." -ForegroundColor Yellow
        $ActionToEdges = Get-RoleToActionEdge
        $ActionToEdges | Export-Csv -NoTypeInformation "./Output/ActionToEdges.csv"
        $ActionToEdges | ConvertTo-Json | Out-File "./Output/ActionToEdges.json"
    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Could not map groups.`r`n $_"
    }

    <#
    ## [l] -- Connecting CA Policies and Devices
    try {
        Write-Host " Connecting Devices to Policies." -ForegroundColor Yellow
        $DeviceCaEdges = Get-DeviceToCaEdges -CaPolicies $RawConditionalAccessPolicies -Devices $DeviceNodes
        $DeviceCaEdges | Export-Csv -NoTypeInformation "./Output/DeviceCaEdges.csv"
        $DeviceCaEdges | ConvertTo-Json | Out-File "./Output/DeviceCaEdges.json"

    } catch {
        Write-Host $_ -ForegroundColor Red
        throw " Could not map devices to policies."
    }
    #>

    ## [l] -- NodesToCyper
    Export-Node -Nodes $UserNodes
    Export-Node -Nodes $GroupNodes -Method "Append"
    Export-Node -Nodes $RoleNodes -Method "Append"
    Export-Node -Nodes $ServicePrincipalNodes -Method "Append"
    Export-Node -Nodes $ConditionalAccessPolicyNodes -Method "Append"
    #Export-Node -Nodes $ActionNodes -Method "Append"

    ## [l] -- EdgesToCyper
    Export-Edge -Edges $UserCaEdges -Method "Append"
    Export-Edge -Edges $RoleToCaEdges -Method "Append"
    Export-Edge -Edges $GroupCaEdges -Method "Append"
    Export-Edge -Edges $SpCaEdges -Method "Append"
    Export-Edge -Edges $GroupToAllEdges -Method "Append"
    Export-Edge -Edges $RoleToAllEdges -Method "Append"
    #Export-EdgeByDisplayName -Edges $ActionToEdges -Method "Append"

    ## Append-Cleanup -Method "Append"

} catch {
    Write-Host $_ -ForegroundColor Red
}

# [l] -- Close the application
Disconnect-MgGraph | Out-Null
Remove-Module -Name Nodes
Remove-Module -Name Edges
Remove-Module -Name NodeFunctions
Remove-Module -Name EdgeFunctions
Remove-Module -Name CypherOutput
Write-Host "`r`n Quitting CA to Cypher." -ForegroundColor Green