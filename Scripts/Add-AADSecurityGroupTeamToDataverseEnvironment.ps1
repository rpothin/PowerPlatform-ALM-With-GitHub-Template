# Copyright (c) 2020 Raphael Pothin.
# Licensed under the MIT License.

Function Add-AADSecurityGroupTeamToDataverseEnvironment {
    <#
        .SYNOPSIS
            Add an Azure AD Security Group Team to a Dataverse environment

        .DESCRIPTION
            Add an Azure AD Security Group Team to a Dataverse environment and assign the provided security role.

        .PARAMETER TenantId
            ID of the tenant where the targeted Dataverse environment is.

        .PARAMETER ClientId
            Client ID of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER ClientSecret
            Client Secret of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER DataverseEnvironmentUrl
            URL of the targeted Dataverse environment.

        .PARAMETER AzureADSecurityGroupName
            Name of the Azure AD Security Group to add as a team to the considered Dataverse environment.

        .PARAMETER SecurityRoleName
            Specifies the name of the security role you want to assign to the Azure AD Security Group team you will add to the considered Dataverse environment.

        .INPUTS
            None. You cannot pipe objects to Add-AADSecurityGroupTeamToDataverseEnvironment.

        .OUTPUTS
            None.

        .EXAMPLE
            PS> Add-AADSecurityGroupTeamToDataverseEnvironment -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/" -AzureADSecurityGroupName "SG-POWERPLATFORM-DEVELOPERS-DEMO"

        .LINK
            README.md: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/README.md

        .NOTES
            * This function does not work for now whith PowerShell 7 / Core
            * You need to have the following PowerShell modules installed to be able to use this function: Azure CLI, Microsoft.PowerApps.Administration.PowerShell, Microsoft.Xrm.Data.PowerShell
            * Do not forget to register the considered Azure AD application registration using the "New-PowerAppManagementApp" (Microsoft.PowerApps.Administration.PowerShell)
    #>

    [CmdletBinding()]
    Param (
        # ID of the tenant where the targeted Dataverse environment is
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$TenantId,

        # Client ID of the Azure AD application registration
        # associated to the application user with the System Administrator security role
        # in the targeted Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ClientId,

        # Client Secret of the Azure AD application registration
        # associated to the application user with the System Administrator security role
        # in the targeted Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ClientSecret,

        # URL of the targeted Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$DataverseEnvironmentUrl,

        # Name of the Azure AD Security Group to add to the Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$AzureADSecurityGroupName,
        
        # Name of the security role to assign to the new user
        [Parameter()]
        [String]$SecurityRoleName="System Administrator"
    )

    Begin{}

    Process{
        
    }

    End{}
}