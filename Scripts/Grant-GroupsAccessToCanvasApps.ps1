Function Grant-GroupsAccessToCanvasApps{
    <#
        .SYNOPSIS
            Grant access to canvas apps to Azure AD groups based on a mapping in a configuration file.

        .DESCRIPTION
            Grant a permission to canvas apps to Azure AD groups based on a mapping in a configuration file.

        .PARAMETER ClientId
            Client ID of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER ClientSecret
            Client Secret of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER DataverseEnvironmentUrl
            URL of the targeted Dataverse environment.

        .PARAMETER ConfigurationFilePath
            Path to the configuration file with the mapping between canvas apps and Azure AD groups.

        .INPUTS
            None. You cannot pipe objects to Grant-GroupsAccessToCanvasApps.

        .OUTPUTS
            Object. Grant-GroupsAccessToCanvasApps returns the result of the operation of giving access to canvas apps to Azure AD groups in the targeted Dataverse environment.

        .EXAMPLE
            PS> Grant-GroupsAccessToCanvasApps -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/"  -ConfigurationFilePath ".\CanvasAppsGroupsAccessMapping.json"

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
        
        # Path to the configuration file with the mapping between canvas apps and Azure AD groups
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ConfigurationFilePath
    )

    Begin{}

    Process{
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
            }
            catch {
                Write-Verbose "Error in the extraction of the configuration from the considered file ($ConfigurationFilePath): $getConfigurationError"
            }
        }
        
        # Set generic connection (with service principal)
        Write-Verbose "Set generic connection (with service principal)."
        $connection = Connect-CrmOnline -ServerUrl $DataverseEnvironmentUrl -OAuthClientId $ClientId -ClientSecret $ClientSecret
        
        
    }

    End{}
}