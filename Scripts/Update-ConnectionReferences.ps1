Function Update-ConnectionReferences {
    <#
        .SYNOPSIS
            Add a link to a valid connection for connection references not already configured in a specific solution in a targeted Dataverse environment.

        .DESCRIPTION
            Get the mapping between connection references and connections from a configuration file.
            Link connections references of the specified solution to corresponding connections in the targeted Dataverse environment using impersonation of the provided user.

        .PARAMETER TenantId
            ID of the tenant where the targeted Dataverse environment is.

        .PARAMETER ClientId
            Client ID of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER ClientSecret
            Client Secret of the Azure AD application registration associated to the application user with the System Administrator security role in the targeted Dataverse environment.

        .PARAMETER DataverseEnvironmentUrl
            URL of the targeted Dataverse environment.

        .PARAMETER SolutionName
            Name of the considered solution in the targeted Dataverse environment.

        .PARAMETER SolutionComponentsOwnerEmail
            Email of the user who will be set as owner of the components of the solution.

        .PARAMETER ConfigurationFilePath
            Path to the configuration file with the mapping between connection references and connections.

        .INPUTS
            None. You cannot pipe objects to Update-ConnectionReferences.

        .OUTPUTS
            Object. Update-ConnectionReferences returns the result of the operation of enabling Cloud Flows in the targeted Dataverse environment.

        .EXAMPLE
            PS> Update-ConnectionReferences -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/" -SolutionName "Demo" -SolutionComponentsOwnerEmail "demo.user@demo.com" -ConfigurationFilePath ".\ConnectionsMapping.json"

        .LINK
            README.md: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/README.md

        .NOTES
            * This function does not work for now whith PowerShell 7 / Core
            * You need to have the following PowerShell modules installed to be able to use this function: Microsoft.Xrm.Data.PowerShell
            * Do not forget to register the considered Azure AD application registration using the "New-PowerAppManagementApp" (Microsoft.PowerApps.Administration.PowerShell)
            * The considered user for the "SolutionComponentsOwnerEmail" parameter need to be the one who created the considered connections
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

        # Name of the considered solution in the targeted Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SolutionName,

        # Email of the user who will be set as owner of the components of the solution
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SolutionComponentsOwnerEmail,
        
        # Path to the configuration file with the mapping between connection references and connections
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
                $configuration = Get-Content $ConfigurationFilePath -ErrorVariable getConfigurationError -ErrorAction Stop | ConvertFrom-Json
            }
            catch {
                Write-Verbose "Error in the extraction of the configuration from the considered file ($ConfigurationFilePath): $getConfigurationError"
            }
        }

        # Set variables
        Write-Verbose "Set variables."
        $dataverseBaseConnectionString = "AuthType=ClientSecret;ClientId=$ClientId;ClientSecret=$ClientSecret;Url="
        
        # Set generic connection (with service principal)
        Write-Verbose "Set generic connection (with service principal)."
        $connection = Get-CrmConnection -ConnectionString "$dataverseBaseConnectionString$DataverseEnvironmentUrl"
        
        # Set impersonation connection
        Write-Verbose "Set impersonation connection."
        $impersonationConnection = Get-CrmConnection -ConnectionString "$dataverseBaseConnectionString$DataverseEnvironmentUrl"
        $systemUser = Get-CrmRecords -conn $connection -EntityLogicalName systemuser -FilterAttribute "domainname" -FilterOperator "eq" -FilterValue $SolutionComponentsOwnerEmail
        $systemUserId = $systemUser.CrmRecords[0].systemuserid
        $impersonationConnection.OrganizationWebProxyClient.CallerId = $systemUserId

        # List connection references in the considered solution
        $fetchConnectionReferences = @"
<fetch>
    <entity name='connectionreference' >
    <attribute name="connectionreferenceid" />
    <attribute name="connectionid" />
    <filter><condition attribute='connectionid' operator='not-null' /></filter>
    <link-entity name='solutioncomponent' from='objectid' to='connectionreferenceid' >
        <link-entity name='solution' from='solutionid' to='solutionid' >
        <filter>
            <condition attribute='uniquename' operator='eq' value='$SolutionName' />
        </filter>
        </link-entity>
    </link-entity>
    </entity>
</fetch>
"@;
        $connectionReferences = (Get-CrmRecordsByFetch -conn $connection -Fetch $fetchConnectionReferences -Verbose).CrmRecords
        
        # For each connection reference in the considered solution
        foreach ($connectionReference in $connectionReferences) {
            # Get the correponding connection for the current connection reference from the configuration file
            $connectionReferenceMapping = $configuration | ?{ $_.connectionReferenceId -eq $connectionReference.connectionid }
            $connectionId = $connectionReferenceMapping.connectionId

            # Link the connection to the connection reference based on the mapping in the configuration file
            Set-CrmRecord -conn $impersonationConnection -EntityLogicalName connectionreference -Id $connectionReference.connectionid -Fields @{"connectionid" = $connectionId }
        }
    }

    End{}
}