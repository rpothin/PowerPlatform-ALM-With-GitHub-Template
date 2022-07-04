# Copyright (c) 2020 Raphael Pothin.
# Licensed under the MIT License.

Function New-DataverseEnvironment {
    <#
        .SYNOPSIS
            Create a new Dataverse environment if it does not exist.

        .DESCRIPTION
            Search a Dataverse environment with the name provided.
            If no environment found, create a new one.

        .PARAMETER TenantId
            ID of the tenant where the targeted Dataverse environment is.

        .PARAMETER ClientId
            Client ID of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER ClientSecret
            Client Secret of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER DisplayName
            Specifies the display name of the Dataverse environment to create.

        .PARAMETER DomainName
            Specifies the domain name of the Dataverse environment to create.

        .PARAMETER Sku
            Specifies the Sku (Production, Sandbox or Trial) of the Dataverse environment to create.

        .PARAMETER SecurityGroupId
            Specifies the security group ID that will be use to restrict the access to the Dataverse environment to create.

        .PARAMETER Description
            Specifies the description of the Dataverse environment to create.

        .PARAMETER ConfigurationFilePath
            Specifies the path to the configuration file to use for the creation of the Dataverse environment with the following information: location (canada), currency name (CAD), language code (1033) and Dynamics 365 templates (D365_Sales) 

        .INPUTS
            None. You cannot pipe objects to New-DataverseEnvironment.

        .OUTPUTS
            Object. New-DataverseEnvironment returns the details of the Dataverse environment found or created.

        .EXAMPLE
            PS> New-DataverseEnvironment -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DisplayName "Demonstration" -DomainName "demonstration" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt"
            EnvironmentName                            : 00000000-0000-0000-0000-000000000000
            DisplayName                                : Example (example)
            Description                                :
            IsDefault                                  : False
            Location                                   : canada
            CreatedTime                                : 2021-03-15T02:08:57.4513455Z
            CreatedBy                                  : @{id=00000000-0000-0000-0000-000000000000;
                                                        displayName=ServicePrincipal; type=NotSpecified;
                                                        tenantId=00000000-0000-0000-0000-000000000000}
            LastModifiedTime                           : 2021-03-15T02:08:57.4513455Z
            LastModifiedBy                             :
            CreationType                               : User
            EnvironmentType                            : Sandbox
            CommonDataServiceDatabaseProvisioningState : Succeeded
            CommonDataServiceDatabaseType              : Common Data Service for Apps
            Internal                                   : @{id=/providers/Microsoft.BusinessAppPlatform/scopes/admin/env
                                                        ironments/00000000-0000-0000-0000-000000000000;
                                                        type=Microsoft.BusinessAppPlatform/scopes/environments;
                                                        location=canada; name=00000000-0000-0000-0000-000000000000;
                                                        properties=}
            InternalCds                                :
            Type                                       : Created

        .EXAMPLE
            PS> New-DataverseEnvironment -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DisplayName "Demonstration" -DomainName "demonstration" -Sku "Sandbox" -SecurityGroupId "00000000-0000-0000-0000-000000000000" -Description "Demonstration" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt"
            EnvironmentName                            : 00000000-0000-0000-0000-000000000000
            DisplayName                                : Example (example)
            Description                                :
            IsDefault                                  : False
            Location                                   : canada
            CreatedTime                                : 2021-03-15T02:08:57.4513455Z
            CreatedBy                                  : @{id=00000000-0000-0000-0000-000000000000;
                                                        displayName=ServicePrincipal; type=NotSpecified;
                                                        tenantId=00000000-0000-0000-0000-000000000000}
            LastModifiedTime                           : 2021-03-15T02:08:57.4513455Z
            LastModifiedBy                             :
            CreationType                               : User
            EnvironmentType                            : Sandbox
            CommonDataServiceDatabaseProvisioningState : Succeeded
            CommonDataServiceDatabaseType              : Common Data Service for Apps
            Internal                                   : @{id=/providers/Microsoft.BusinessAppPlatform/scopes/admin/env
                                                        ironments/00000000-0000-0000-0000-000000000000;
                                                        type=Microsoft.BusinessAppPlatform/scopes/environments;
                                                        location=canada; name=00000000-0000-0000-0000-000000000000;
                                                        properties=}
            InternalCds                                :
            Type                                       : Existing

        .LINK
            README.md: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/README.md

        .NOTES
            * This function does not work for now whith PowerShell 7 / Core
            * Do not forget to register the considered app registration using the "New-PowerAppManagementApp" (Microsoft.PowerApps.Administration.PowerShell) command on your tenant
            * You can get the list of all supported locations by using the "Get-AdminPowerAppEnvironmentLocations" (Microsoft.PowerApps.Administration.PowerShell) command
            * You can get the list of all supported languages for a location by using the "Get-AdminPowerAppCdsDatabaseLanguages" (Microsoft.PowerApps.Administration.PowerShell) command
            * You can get the list of all supported applications for a location by using the "Get-AdminPowerAppCdsDatabaseTemplates" (Microsoft.PowerApps.Administration.PowerShell) command
            * You can get the list of all supported currencies for a location by using the "Get-AdminPowerAppCdsDatabaseCurrencies" (Microsoft.PowerApps.Administration.PowerShell) command
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

        # Display name of the Dataverse environment to create
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$DisplayName,
        
        # Display name of the Dataverse environment to create
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$DomainName,
        
        # Sku (Production, Sandbox or Trial) of the Dataverse environment to create
        [Parameter()]
        [ValidateSet("Production", "Sandbox", "Trial")]
        [String]$Sku = "Sandbox",
        
        # Security group ID that will be use to restrict the access to the Dataverse environment to create
        [Parameter()]
        [String]$SecurityGroupId,
        
        # Description of the Dataverse environment to create
        [Parameter()]
        [String]$Description,
        
        # Path to the configuration file to use for the creation of the Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ConfigurationFilePath
    )

    Begin{}

    Process{
        #region VariablesInitialization
        Write-Verbose "Variables initialization."
        
        # Variable from DisplayName parameter with some "cleaning"
        $DisplayName = $DisplayName.Trim()
        $DisplayName = $DisplayName -replace '\s+', ' '

        # Variable dedicated to the search of the Dataverse environment
        $displayNameForSearch = $DisplayName.Replace(" ", "*")

        # Set Description to empty string if not provided
        $Description = if($Description -eq $null) { '' } else { $Description }

        # Set SecurityGroupId to empty string if not provided
        $SecurityGroupId = if($SecurityGroupId -eq $null) { '' } else { $SecurityGroupId }
        
        #endregion VariablesInitialization

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

                $dataverseEnvironmentConfigurations = $configurations.environment
            }
            catch {
                Write-Verbose "Error in the extraction of the configuration from the considered file ($ConfigurationFilePath): $getConfigurationError"
            }
        }

        # Connect to Power Apps with service principal
        Write-Verbose "Connect to Power Apps with service principal."
        Add-PowerAppsAccount -TenantID $TenantId -ApplicationId $ClientId -ClientSecret $ClientSecret

        # Search for an existing Dataverse environment with the display name provided
        Write-Verbose "Search Dataverse environments with the following display name: $DisplayName"
        Write-Debug "Before the call to the Get-AdminPowerAppEnvironment command..."
        $dataverseEnvironments = Get-AdminPowerAppEnvironment *$displayNameForSearch*

        # Number of environments found
        $dataverseEnvironmentsMeasure = $dataverseEnvironments | Measure
        $dataverseEnvironmentsCount = $dataverseEnvironmentsMeasure.count

        # Case only one Dataverse environment found for the provided display name
        if($dataverseEnvironmentsCount -eq 1) {
            Write-Verbose "Only one Dataverse environment found - Do nothing"
            $dataverseEnvironment = $dataverseEnvironments[0]
            $dataverseEnvironment | Add-Member -MemberType NoteProperty -Name "Type" -Value "Existing"
        }

        # Case no Dataverse environment found for the provided display name
        if($dataverseEnvironmentsCount -eq 0 -and $dataverseConfigurationExtracted) {
            Write-Verbose "No Dataverse environment found - Create a new one"
            # Initialise parameters to call the New-AdminPowerAppEnvironment command
            Write-Verbose "Initialize parameters to call the New-AdminPowerAppEnvironment command."
            $NewAdminPowerAppEnvironmentParams = @{
                DisplayName = $DisplayName
                LocationName = $dataverseEnvironmentConfigurations.region
                Description = $Description
                DomainName = $DomainName
                EnvironmentSku = $Sku
                SecurityGroupId = $SecurityGroupId
                LanguageName = $dataverseEnvironmentConfigurations.languageCode # Missing for now in global configuration file
                CurrencyName = $dataverseEnvironmentConfigurations.currencyName
                # Templates = $templates - Not used for now
            }

            # Call to New-AdminPowerAppEnvironment command
            try {
                Write-Verbose "Try to call the New-AdminPowerAppEnvironment command."
                Write-Debug "Before the call to the New-AdminPowerAppEnvironment command..."
                $dataverseEnvironment = New-AdminPowerAppEnvironment @NewAdminPowerAppEnvironmentParams -ProvisionDatabase -WaitUntilFinished 1 -ErrorVariable dataverseEnvironmentCreationError -ErrorAction Stop
                $dataverseEnvironment | Add-Member -MemberType NoteProperty -Name "Type" -Value "Created"
            }
            catch {
                Write-Verbose "Error in the creation of the Dataverse environment: $dataverseEnvironmentCreationError"
                $dataverseEnvironment = [PSCustomObject]@{
                    Error = "Error in the creation of the Dataverse environment: $dataverseEnvironmentCreationError"
                }
            }

            if (-not ($dataverseEnvironment.error -eq $null)) {
                $errorCode = $dataverseEnvironment.error.code
                $errorMessage = $dataverseEnvironment.error.message
                Write-Verbose "Error in the creation of the Dataverse environment: $errorCode | $errorMessage"
                $dataverseEnvironment = [PSCustomObject]@{
                    Error = "Error in the creation of the Dataverse environment: $errorCode | $errorMessage"
                }
            }
        }

        # Case multiple Dataverse environments found for the provided display name
        if($dataverseEnvironmentsCount -gt 1) {
            Write-Verbose "Multiple Dataverse environment corresponding to the following display name: $DisplayName"
            $dataverseEnvironment = [PSCustomObject]@{
                Error = "Multiple Dataverse environment corresponding to the following display name: $DisplayName"
            }
        }

        # Return the considered Dataverse environment (found or created)
        Write-Verbose "Return the Dataverse environment found or created."
        Write-Debug "Before sending the output..."
        $dataverseEnvironment
    }

    End{}
}