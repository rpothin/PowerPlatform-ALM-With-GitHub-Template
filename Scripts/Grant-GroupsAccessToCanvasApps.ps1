# Copyright (c) 2020-2022 Raphael Pothin.
# Licensed under the MIT License.

Function Grant-GroupsAccessToCanvasApps {
    <#
        .SYNOPSIS
            Grant access to canvas apps to Azure AD groups based on a mapping in a configuration file.

        .DESCRIPTION
            Grant a permission to canvas apps to Azure AD groups based on a mapping in a configuration file.

        .PARAMETER TenantId
            ID of the tenant where the targeted Dataverse environment is.

        .PARAMETER ClientId
            Client ID of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER ClientSecret
            Client Secret of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER DataverseEnvironmentUrl
            URL of the targeted Dataverse environment.

        .PARAMETER DataverseEnvironmentDisplayName
            Display name of the targeted Dataverse environment.

        .PARAMETER ConfigurationFilePath
            Path to the configuration file with the mapping between canvas apps and Azure AD groups.

        .INPUTS
            None. You cannot pipe objects to Grant-GroupsAccessToCanvasApps.

        .OUTPUTS
            None.

        .EXAMPLE
            PS> Grant-GroupsAccessToCanvasApps -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/" -DataverseEnvironmentDisplayName "Demo" -ConfigurationFilePath ".\CanvasAppsGroupsAccessMapping.json"

        .LINK
            README.md: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/README.md

        .NOTES
            * This function does not work for now whith PowerShell 7 / Core
            * You need to have the following PowerShell modules installed to be able to use this function: Microsoft.Xrm.Data.PowerShell
            * Do not forget to register the considered Azure AD application registration using the "New-PowerAppManagementApp" (Microsoft.PowerApps.Administration.PowerShell)
    #>

    [CmdletBinding()]
    [OutputType([psobject])]
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

        # Display name of the targeted Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$DataverseEnvironmentDisplayName,

        # Path to the configuration file with the mapping between canvas apps and Azure AD groups
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ConfigurationFilePath
    )

    Begin{}

    Process{
        # Set variables
        Write-Verbose "Set variables."
        $dataverseEnvironmentNameForSearch = $DataverseEnvironmentDisplayName.Replace(" ", "*")

        # Test the path provided to the file with the configuration
        Write-Verbose "Test the path provided to the file with the configuration: $ConfigurationFilePath"
        if(Test-Path $ConfigurationFilePath) {
            $configurationFilePathValidated = $true
        }
        else {
            Write-Verbose "Error in the path provided for the configuration: $ConfigurationFilePath"
            $configurationFilePathValidated = $false
        }

        # Continue only if the path provided for the file with the configuration is correct
        if ($configurationFilePathValidated) {
            # Extract configuration from the file
            Write-Verbose "Get content from file with the configuration in following location: $ConfigurationFilePath"
            try {
                Write-Verbose "Try to call the Get-Content command."
                Write-Debug "Before the call to the Get-Content command..."
                $configurations = Get-Content $ConfigurationFilePath -ErrorVariable getConfigurationError -ErrorAction Stop | ConvertFrom-Json

                $canvasAppsSharingConfigurations = $configurations.canvasApps.sharing
            }
            catch {
                Write-Verbose "Error in the extraction of the configuration from the considered file ($ConfigurationFilePath): $getConfigurationError"
            }
        }

        # Set generic connection (with service principal)
        Write-Verbose "Set generic connection (with service principal)."
        $connection = Connect-CrmOnline -ServerUrl $DataverseEnvironmentUrl -OAuthClientId $ClientId -ClientSecret $ClientSecret

        # Connect to Azure CLI with service principal
        Write-Verbose "Connect to Azure CLI with service principal."
        az login --service-principal -u $ClientId -p $ClientSecret --tenant $TenantId --allow-no-subscriptions

        # Connect to Power Apps with service principal
        Write-Verbose "Connect to Power Apps with service principal."
        Add-PowerAppsAccount -TenantID $TenantId -ApplicationId $ClientId -ClientSecret $ClientSecret

        # Search considered environment based on Display name
        Write-Verbose "Search Dataverse environments with the following display name: $DataverseEnvironmentDisplayName"
        $dataverseEnvironments = Get-AdminPowerAppEnvironment *$dataverseEnvironmentNameForSearch*

        # Number of environments found
        $dataverseEnvironmentsMeasure = $dataverseEnvironments | Measure-Object
        $dataverseEnvironmentsCount = $dataverseEnvironmentsMeasure.count

        # If only 1 Dataverse environment found we continue, else there is an error
        if($dataverseEnvironmentsCount -eq 1) {
            Write-Verbose "Only one Dataverse environment found."
            Write-Verbose "Set variable for the 'name' of the considered Dataverse environment."
            $dataverseEnvironmentName = $dataverseEnvironments[0].EnvironmentName

            # For each canvas app - Azure AD group mapping...
            Write-Verbose "For each canvas app - Azure AD group mapping..."
            foreach ($canvasAppsSharingConfiguration in $canvasAppsSharingConfigurations) {
                # List canvas app based on the provided name
                Write-Verbose "List canvas app based on the provided name: "
                $canvasApps = Get-CrmRecords -conn $connection -EntityLogicalName canvasapp -FilterAttribute "name" -FilterOperator "eq" -FilterValue $canvasAppsSharingConfiguration.canvasAppName -Fields name
                $canvasAppId = $canvasApps.CrmRecords[0].canvasappid

                # Get the details of the considered group
                Write-Verbose "Get group details from the provided name."
                $group = az ad group show --group $canvasAppsSharingConfiguration.groupName | ConvertFrom-Json

                # If group found, we continue
                Write-Verbose "If group found, we continue."
                if ($null -ne $group) {
                    # Get the Object ID of the considered group
                    Write-Verbose "Get group Object ID from the provided name."
                    $groupObjectId = $group.id

                    # Get group Object ID
                    Set-AdminPowerAppRoleAssignment -PrincipalType Group -PrincipalObjectId $groupObjectId -RoleName $canvasAppsSharingConfiguration.roleName -AppName $canvasAppId -EnvironmentName $dataverseEnvironmentName
                }
            }
        }
    }

    End{}
}