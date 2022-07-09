# Copyright (c) 2020-2022 Raphael Pothin.
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
        # Set variables
        Write-Verbose "Set variables."
        $aadSecurityGroupTeamType = New-CrmOptionSetValue -Value 2

        # Connect to Azure CLI with service principal
        Write-Verbose "Connect to Azure CLI with service principal."
        az login --service-principal -u $ClientId -p $ClientSecret --tenant $TenantId --allow-no-subscriptions

        # Search the considered Azure AD security group based on the provided name
        Write-Verbose "Search the considered Azure AD security group based on the provided name: $AzureADSecurityGroupName"
        $azureAdGroups = az ad group list --filter "displayname eq '$AzureADSecurityGroupName'" | ConvertFrom-Json

        # Number of groups found
        $azureAdGroupsMeasure = $azureAdGroups | Measure-Object
        $azureAdGroupsCount = $azureAdGroupsMeasure.Count

        # Case only one Azure AD security group found for the provided name
        if ($azureAdGroupsCount -eq 1) {
            Write-Verbose "Only one Azure AD security group found for the provided name - We continue."
            Write-Verbose "Get the object id of the group found."
            $azureAdSecurityGroupId = $azureAdGroups[0].id

            # Connect to Microsoft.Xrm.Data.PowerShell with service principal
            Write-Verbose "Connect to Microsoft.Xrm.Data.PowerShell with service principal."
            $connection = Connect-CrmOnline -ServerUrl $DataverseEnvironmentUrl -OAuthClientId $ClientId -ClientSecret $ClientSecret

            # Get the business unit ID of the of the account we are connected with
            Write-Verbose "Get the business unit ID of the of the account we are connected with."
            $businessUnitId = (Invoke-CrmWhoAmI).BusinessUnitId

            # Set Fetch query variable for the search the security role details for the business unit of the account used to logged in
            $fetchSecurityRoles = @"
<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false" no-lock="true">
    <entity name="role">
        <attribute name="roleid" />
        <filter type="and">
            <condition attribute="name" operator="eq" value="{0}" />
            <condition attribute="businessunitid" operator="eq" value="{1}" />
        </filter>
    </entity>
</fetch>
"@
            $fetchSecurityRoles = $fetchSecurityRoles -F $SecurityRoleName, $businessUnitId

            # Search the considered Azure AD security group in the teams of the Dataverse environment base on the provided name
            Write-Verbose "Search the considered Azure AD security group in the teams of the Dataverse environment based on the provided name: $AzureADSecurityGroupName"
            $dataverseTeams = Get-CrmRecords -conn $connection -EntityLogicalName team -FilterAttribute "name" -FilterOperator "eq" -FilterValue $AzureADSecurityGroupName -Fields teamid

            # Number of teams found in the Dataverse environment
            $dataverseTeamsCount = $dataverseTeams.Count

            # Configuration of the Azure AD security group team in Dataverse
            $azureAdSecurityGroupDataverseTeamConfiguration = @{ "name"=$AzureADSecurityGroupName;"teamtype"=$aadSecurityGroupTeamType;"azureactivedirectoryobjectid"=[guid]$azureAdSecurityGroupId }

            # Case no team found for the provided name
            if ($dataverseTeamsCount -eq 0) {
                Write-Verbose "No Azure AD security group found for the provided name - Create it."
                $azureAdSecurityGroupDataverseTeamId = New-CrmRecord -conn $connection -EntityLogicalName team -Fields $azureAdSecurityGroupDataverseTeamConfiguration
            }
            # Case only one team found for the provided name
            elseif ($dataverseTeamsCount -eq 1) {
                Write-Verbose "One Azure AD security group found for the provided name - Update it."
                $azureAdSecurityGroupDataverseTeamId = $dataverseTeams.CrmRecords[0].teamid

                Set-CrmRecord -conn $connection -EntityLogicalName team -Id $azureAdSecurityGroupDataverseTeamId -Fields $azureAdSecurityGroupDataverseTeamConfiguration
            }
            # Case more than one team found for the provided name
            else {
                Throw "Multiple teams found for the following Azure AD security group: $AzureADSecurityGroupName"
            }

            # Search security roles with the provided name and for the business unit of the logged in user (should be root)
            Write-Verbose "Search security roles with the following information: SecurityRoleName is $SecurityRoleName and BusinessUnitId is $businessUnitId"
            $securityRoles = Get-CrmRecordsByFetch -Fetch $fetchSecurityRoles

            # Number of teams found in the Dataverse environment
            $securityRolesCount = $securityRoles.Count

            # Case only one security role found
            if ($securityRolesCount -eq 1) {
                Write-Verbose "One security role found."
                $securityRoleId = $securityRoles.CrmRecords[0].roleid.Guid

                Write-Verbose "Assign security role to the Azure AD security group team."
                Add-CrmSecurityRoleToTeam -TeamId $azureAdSecurityGroupDataverseTeamId -SecurityRoleId $securityRoleId
            }
            # Case no security role found
            elseif ($securityRolesCount -eq 0) {
                Throw "No security role found in the considered Dataverse environment."
            }
            else {
                Throw "More than one security role found in the considered Dataverse environment."
            }
        }
        # Case no Azure AD security group found for the provided name
        elseif ($azureAdGroupsCount -eq 0) {
            Throw "No Azure AD security group found with the following name: $AzureADSecurityGroupName"
        }
        # Case more than one Azure AD security group found for the provided name
        else {
            Throw "More than one Azure AD security group found with the following name: $AzureADSecurityGroupName"
        }
    }

    End{}
}