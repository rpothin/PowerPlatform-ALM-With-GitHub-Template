# Copyright (c) 2020 Raphael Pothin.
# Licensed under the MIT License.

Function Enable-CloudFlows {
    <#
        .SYNOPSIS
            Turn on the Cloud Flows in a specific solution in a targeted Dataverse environment.

        .DESCRIPTION
            Turn on the Cloud Flows in a specific solution in a targeted Dataverse environment using an impersonation of the provided user

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

        .INPUTS
            None. You cannot pipe objects to Enable-CloudFlows.

        .OUTPUTS
            None.

        .EXAMPLE
            PS> Enable-CloudFlows -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/" -SolutionName "Demo" -SolutionComponentsOwnerEmail "demo.user@demo.com"

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

        # Name of the considered solution in the targeted Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SolutionName,

        # Email of the user who will be set as owner of the components of the solution
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SolutionComponentsOwnerEmail
    )

    Begin{}

    Process{
        # Set generic connection (with service principal)
        Write-Verbose "Set generic connection (with service principal)."
        $connection = Connect-CrmOnline -ServerUrl $DataverseEnvironmentUrl -OAuthClientId $ClientId -ClientSecret $ClientSecret

        # Set impersonation connection
        Write-Verbose "Set impersonation connection."
        $impersonationConnection = Connect-CrmOnline -ServerUrl $DataverseEnvironmentUrl -OAuthClientId $ClientId -ClientSecret $ClientSecret
        $systemUser = Get-CrmRecords -conn $connection -EntityLogicalName systemuser -FilterAttribute "domainname" -FilterOperator "eq" -FilterValue $SolutionComponentsOwnerEmail
        $systemUserId = $systemUser.CrmRecords[0].systemuserid
        $impersonationConnection.OrganizationWebProxyClient.CallerId = $systemUserId

        # List cloud (modern) flows in "Draft" state in the considered solution
        #       * category = 5 ==> Modern Flow
        #       * statecode = 0 ==> Draft
        Write-Verbose "List cloud (modern) flows in 'Draft' state in the considered solution."
        $fetchDraftCloudFlows = @"
<fetch>
    <entity name='workflow'>
    <attribute name='category' />
    <attribute name='name' />
    <attribute name='statecode' />
    <filter>
        <condition attribute='category' operator='eq' value='5' />
        <condition attribute='statecode' operator='eq' value='0' />
    </filter>
    <link-entity name='solutioncomponent' from='objectid' to='workflowid'>
        <link-entity name='solution' from='solutionid' to='solutionid'>
        <filter>
            <condition attribute='uniquename' operator='eq' value='$SolutionName' />
        </filter>
        </link-entity>
    </link-entity>
    </entity>
</fetch>
"@;
        $draftCloudFlows = (Get-CrmRecordsByFetch -conn $connection -Fetch $fetchDraftCloudFlows -Verbose).CrmRecords

        # For each cloud flow in the considered solution
        Write-Verbose "For each cloud flow in the considered solution..."
        foreach ($draftCloudFlow in $draftCloudFlows) {
            $cloudFlowId = $draftCloudFlow.workflowid

            # Turn on the cloud flow using the impersonation connection (automatically set the provided user as owner)
            Write-Verbose "Turn on the following cloud flow: $cloudFlowId"
            Set-CrmRecordState -conn $impersonationConnection -EntityLogicalName workflow -Id $cloudFlowId -StateCode Activated -StatusCode Activated
        }
    }

    End{}
}