class BasicNode {
    [string]$Type
    [string]$Id
    [string]$DisplayName

    BasicNode(){}
    
    BasicNode( 
        [string]$Type,
        [string]$Id,
        [string]$DisplayName
    ) {
        $this.Type = $Type
        $this.Id = $Id
        $this.DisplayName = $DisplayName
    }
}

class UserNode : BasicNode {
    [string]$AccountCreated
    [bool]$AccountEnabled
    [string]$LastPasswordChange
    [string]$Mail

    UserNode(){}
    UserNode(
        [string]$Type,
        [string]$Id,
        [string]$DisplayName,
        [string]$AccountCreated,
        [bool]$AccountEnabled,
        [string]$LastPasswordChange,
        [string]$Mail
         ) : base($Type, $Id, $DisplayName) {
        
        $this.AccountCreated = $AccountCreated
        $this.AccountEnabled = $AccountEnabled
        $this.LastPasswordChange = $LastPasswordChange
        $This.Mail = $Mail
    }
}

class GroupNode : BasicNode {
    [string]$GroupCreated
    [string]$Mail
    [bool]$MailEnabled
    [string]$OnPremisesDomainName
    [bool]$OnPremisesSyncEnabled
    [bool]$SecurityEnabled

    GroupNode(){}
    GroupNode(
        [string]$Type,
        [string]$Id,
        [string]$DisplayName,
        [string]$GroupCreated,
        [string]$Mail,
        [bool]$MailEnabled,
        [string]$OnPremisesDomainName,
        [bool]$OnPremisesSyncEnabled,
        [bool]$SecurityEnabled
         ) : base($Type, $Id, $DisplayName) {
        $this.GroupCreated = $GroupCreated
        $this.Mail = $Mail
        $this.MailEnabled = $MailEnabled
        $this.OnPremisesDomainName = $OnPremisesDomainName
        $this.OnPremisesSyncEnabled = $OnPremisesSyncEnabled
        $this.SecurityEnabled = $SecurityEnabled
    }
}

class RoleNode : BasicNode {
    [string]$Description
    [string]$RoleTemplateId

    RoleNode(){}
    RoleNode(
        [string]$Type,
        [string]$Id,
        [string]$DisplayName,
        [string]$Description,
        [string]$RoleTemplateId
         ) : base($Type, $Id, $DisplayName) {
        $this.Description = $Description
        $this.RoleTemplateId = $RoleTemplateId
    }
}

class ServicePrincipalNode : BasicNode {
    [bool]$AccountEnabled
    [string]$Description
    [string]$AppId
    [string]$ServicePrincipalType
    [string]$SigninAudience
    [bool]$HasPasswordCredentials
    [bool]$HasKeyCredentials

    ServicePrincipalNode(){}
    ServicePrincipalNode(
        [string]$Type,
        [string]$Id,
        [string]$DisplayName,
        [bool]$AccountEnabled,
        [string]$Description,
        [string]$AppId,
        [string]$ServicePrincipalType,
        [string]$SigninAudience,
        [bool]$HasPasswordCredentials,
        [bool]$HasKeyCredentials
    ) : base($Type, $Id, $DisplayName) {
        $this.AccountEnabled = $AccountEnabled
        $this.Description = $Description
        $this.AppId = $AppId
        $this.ServicePrincipalType = $ServicePrincipalType
        $this.SigninAudience = $SigninAudience
        $this.HasPasswordCredentials = $HasPasswordCredentials
        $this.HasKeyCredentials = $HasKeyCredentials
    }
}

class NamedLocationNode : BasicNode {
    [string]$CreatedDateTime
    [string]$ModifiedDateTime
    [string]$CountriesAndRegions
    [bool]$IncludeUnknownCountriesAndRegions
    [string]$CountryLookupMethod
    [bool]$IsTrusted
    [string]$ipRanges
    [string]$OdataType

    NamedLocationNode(){}
    NamedLocationNode(
        [string]$Type,
        [string]$Id,
        [string]$DisplayName,
        [string]$CreatedDateTime,
        [string]$ModifiedDateTime,
        [string]$CountriesAndRegions,
        [bool]$IncludeUnknownCountriesAndRegions,
        [string]$CountryLookupMethod,
        [bool]$IsTrusted,
        [string]$IpRanges,
        [string]$OdataType
         ) : base($Type, $Id, $DisplayName) {
        $this.CreatedDateTime = $CreatedDateTime
        $this.ModifiedDateTime = $ModifiedDateTime
        $this.CountriesAndRegions = $CountriesAndRegions
        $this.IncludeUnknownCountriesAndRegions = $IncludeUnknownCountriesAndRegions
        $this.CountryLookupMethod = $CountryLookupMethod
        $this.IsTrusted = $IsTrusted
        $this.ipRanges = $IpRanges
        $this.OdataType = $OdataType
    }
}

class DeviceNode : BasicNode {
    [string]$AccountEnabled
    [string]$CreatedDateTime
    [string]$ApproximateLastSignInDateTime
    [string]$DeviceId
    [string]$DomainName
    [bool]$IsCompliant
    [bool]$IsManaged
    [bool]$IsRooted
    [string]$OperatingSystem
    [string]$ProfileType
    [string]$TrustType

    DeviceNode(){}
    DeviceNode(
        [string]$Type,
        [string]$Id,
        [string]$DisplayName,
        [string]$AccountEnabled,
        [string]$CreatedDateTime,
        [string]$ApproximateLastSignInDateTime,
        [string]$DeviceId,
        [string]$DomainName,
        [bool]$IsCompliant,
        [bool]$IsManaged,
        [bool]$IsRooted,
        [string]$OperatingSystem,
        [string]$ProfileType,
        [string]$TrustType
         ) : base($Type, $Id, $DisplayName) {
        $this.AccountEnabled = $AccountEnabled
        $this.CreatedDateTime = $CreatedDateTime
        $this.ApproximateLastSignInDateTime = $ApproximateLastSignInDateTime
        $this.DeviceId = $DeviceId
        $this.DomainName = $DomainName
        $this.IsCompliant = $IsCompliant
        $this.IsManaged = $IsManaged
        $this.IsRooted = $IsRooted
        $this.OperatingSystem = $OperatingSystem
        $this.ProfileType = $ProfileType
        $this.TrustType = $TrustType
    }
}

class ConditionalAccessPolicyNode : BasicNode {
    [string]$CreatedDateTime
    [string]$ModifiedDateTime
    [string]$State
    [string]$ConditionApplicationsIncludeAuthenticationContextClassReference
    [string]$ConditionApplicationsIncludeUserActions
    [string]$ConditionApplicationsClientAppTypes
    [string]$ConditionExcludePlatforms
    [string]$ConditionIncludePlatforms
    [string]$ConditionSignInRiskLevels
    [string]$ConditionUserRiskLevels
    [string]$GrantBuiltInControls
    [string]$GrantCustomAuthenticationFactors
    [string]$GrantOperator
    [string]$GrantTermsOfUse
    [bool]$SessionDisableResilienceDefaults

    ConditionalAccessPolicyNode(){}
    ConditionalAccessPolicyNode(
        [string]$Type,
        [string]$Id,
        [string]$DisplayName,
        [string]$CreatedDateTime,
        [string]$ModifiedDateTime,
        [string]$State,
        [string]$ConditionApplicationsIncludeAuthenticationContextClassReference,
        [string]$ConditionApplicationsIncludeUserActions,
        [string]$ConditionApplicationsClientAppTypes,
        [string]$ConditionExcludePlatforms,
        [string]$ConditionIncludePlatforms,
        [string]$ConditionSignInRiskLevels,
        [string]$ConditionUserRiskLevels,
        [string]$GrantBuiltInControls,
        [string]$GrantCustomAuthenticationFactors,
        [string]$GrantOperator,
        [string]$GrantTermsOfUse,
        [bool]$SessionDisableResilienceDefaults
         ) : base($Type, $Id, $DisplayName) {
        $this.CreatedDateTime = $CreatedDateTime
        $this.ModifiedDateTime = $ModifiedDateTime
        $this.State = $State
        $this.ConditionApplicationsIncludeAuthenticationContextClassReference = $ConditionApplicationsIncludeAuthenticationContextClassReference
        $this.ConditionApplicationsIncludeUserActions = $ConditionApplicationsIncludeUserActions
        $this.ConditionApplicationsClientAppTypes = $ConditionApplicationsClientAppTypes
        $this.ConditionExcludePlatforms = $ConditionExcludePlatforms
        $this.ConditionIncludePlatforms = $ConditionIncludePlatforms
        $this.ConditionSignInRiskLevels = $ConditionSignInRiskLevels
        $this.ConditionUserRiskLevels = $ConditionUserRiskLevels   
        $this.GrantBuiltInControls = $GrantBuiltInControls
        $this.GrantCustomAuthenticationFactors = $GrantCustomAuthenticationFactors
        $this.GrantOperator = $GrantOperator
        $this.GrantTermsOfUse = $GrantTermsOfUse
        $this.SessionDisableResilienceDefaults = $SessionDisableResilienceDefaults
    }
}