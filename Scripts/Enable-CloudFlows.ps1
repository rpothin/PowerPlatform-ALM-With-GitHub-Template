Function Enable-CloudFlows {
    <#
        .SYNOPSIS
            Enable the Cloud Flows in a targeted Dataverse environment.

        .DESCRIPTION
            Link connections references to existing connections in the targeted Dataverse environment using impersonation with the user who created the connection.
            Turn on the Cloud Flows using the identity of the connection for the first connection reference found.

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

        .PARAMETER ConnectionReferencesConfigurationFilePath
            Path to the configuration file to use for the configuration of the connection references.

        .INPUTS
            None. You cannot pipe objects to Enable-CloudFlows.

        .OUTPUTS
            Object. Enable-CloudFlows returns the result of the operation of enabling Cloud Flows in the targeted Dataverse environment.

        .EXAMPLE
            PS> Enable-CloudFlows -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/" -ConnectionReferencesConfigurationFilePath ".\ConnectionReferencesConfiguration.json"
            Result                            : OK

        .EXAMPLE
            PS> Enable-CloudFlows -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/" -ConnectionReferencesConfigurationFilePath ".\ConnectionReferencesConfiguration.json"
            Result                            : KO

        .LINK
            README.md: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/README.md
            microsoft/coe-alm-accelerator-templates/Pipelines/Templates/update-connection-references.yml: https://github.com/microsoft/coe-alm-accelerator-templates/blob/main/Pipelines/Templates/update-connection-references.yml

        .NOTES
            * This function does not work for now whith PowerShell 7
            * You need to have the following PowerShell modules installed to be able to use this function:Microsoft.PowerApps.Administration.PowerShell, Microsoft.Xrm.Data.PowerShell
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

        # Name of the considered solution in the targeted Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SolutionName,
        
        # Path to the configuration file to use for the configuration of the connection references
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ConnectionReferencesConfigurationFilePath
    )

    Begin{}

    Process{
        $dataverseBaseConnectionString = "AuthType=ClientSecret;ClientId=$ClientId;ClientSecret=$ClientSecret;Url="

        Add-PowerAppsAccount -TenantID $TenantId -ApplicationId $ClientId -ClientSecret $ClientSecret
        $conn = Get-CrmConnection -ConnectionString "$dataverseBaseConnectionString$DataverseEnvironmentUrl"
        $impersonationConn = Get-CrmConnection -ConnectionString "$dataverseBaseConnectionString$DataverseEnvironmentUrl"
        
        # Get the EnvironmentName (which is a GUID) of the environment based on the orgid in Dataverse
        $environmentName = (Get-CrmRecords -conn $conn -EntityLogicalName organization).CrmRecords[0].organizationid
            
        $config = ConvertFrom-Json '${{parameters.connectionReferences}}' # Update with the configuration file with path provided as parameter
        $connRefOwnerCollection = New-Object -TypeName System.Collections.Specialized.NameValueCollection
        foreach ($c in $config) {
            # Get the connection reference to update
            $connRefs = Get-CrmRecords -conn $conn -EntityLogicalName connectionreference -FilterAttribute "connectionreferencelogicalname" -FilterOperator "eq" -FilterValue $c[0]
            $connRef = $connRefs.CrmRecords[0]
            # Connection References can only be updated by an identity that has permissions to the connection it references
            # As of authoring this script, Service Principals (SPN) cannot update connection references
            # The temporary workaround is to impersonate the user that created the connection
            
            # Get connection
            $connections = Get-AdminPowerAppConnection -EnvironmentName $environmentName -Filter $c[1]
            # Get Dataverse systemuserid for the system user that maps to the aad user guid that created the connection 
            $systemusers = Get-CrmRecords -conn $conn -EntityLogicalName systemuser -FilterAttribute "azureactivedirectoryobjectid" -FilterOperator "eq" -FilterValue $connections[0].CreatedBy.id
            # Impersonate the Dataverse systemuser that created the connection when updating the connection reference
            $impersonationCallerId = $systemusers.CrmRecords[0].systemuserid
            $impersonationConn.OrganizationWebProxyClient.CallerId = $impersonationCallerId 
            $connRefOwnerCollection.Add($c[0],$impersonationCallerId)
            Set-CrmRecord -conn $impersonationConn -EntityLogicalName connectionreference -Id $connRef.connectionreferenceid -Fields @{"connectionid" = $c[1] }
        }

        $solutions = Get-CrmRecords -conn $conn -EntityLogicalName solution -FilterAttribute "uniquename" -FilterOperator "eq" -FilterValue "$SolutionName"
        $solutionId = $solutions.CrmRecords[0].solutionid
        $result = Get-CrmRecords -conn $conn -EntityLogicalName solutioncomponent -FilterAttribute "solutionid" -FilterOperator "eq" -FilterValue $solutionId -Fields objectid,componenttype
        $solutionComponents = $result.CrmRecords
        foreach ($c in $solutionComponents){
            if ($c.componenttype -eq "Workflow"){
                # Flows can only be turned on if the user turning them on has permissions to connections being referenced by the connection reference
                # As of authoring this script, the Service Principal (SPN) we use to connect to the Dataverse API cannot turn on the Flow
                # The temporary workaround is use a brute force approach for now.  We use the identity of the connection for the first connection
                # reference we find to turn on the Flow.  This may have side effects or unintended consequences we haven't fully tested.
                # Need a better long term solution.  Will replace when we find one.
                $wf = Get-CrmRecord -conn $conn -EntityLogicalName workflow -Id $c.objectid -Fields clientdata,category
                if ($wf.category -eq "Modern Flow"){
                    $impersonationCallerId = ""
                    foreach ($key in $connRefOwnerCollection.AllKeys){
                        if($wf.clientdata.Contains($key)){
                        $impersonationCallerId = $connRefOwnerCollection[$key]
                        break
                        }
                    }
                    if ($impersonationCallerId -ne "") {
                        $impersonationConn.OrganizationWebProxyClient.CallerId = $impersonationCallerId 
                        Set-CrmRecordState -conn $impersonationConn -EntityLogicalName workflow -Id $c.objectid -StateCode Activated -StatusCode Activated
                    }
                }            
            }
        }
    }

    End{}
}