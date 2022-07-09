# Copyright (c) 2020-2022 Raphael Pothin.
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

        .PARAMETER MaximumTries
            Maximum tries allowed for the activation of the cloud flows.
            Parameter to cover the presence of multiple levels of child flows.

        .INPUTS
            None. You cannot pipe objects to Enable-CloudFlows.

        .OUTPUTS
            None.

        .EXAMPLE
            PS> Enable-CloudFlows -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/" -SolutionName "Demo" -SolutionComponentsOwnerEmail "demo.user@demo.com" -MaximumTries "3"

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
        [String]$SolutionComponentsOwnerEmail,

        # Maximum tries allowed for the activation of the cloud flows
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$MaximumTries
    )

    Begin{}

    Process{
        # Set variables
        [int]$maximumTriesForCloudFlowsActivation = $MaximumTries

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

        # Until all cloud flows are activated or the maximum tries limit is reached
        $cloudFlowsActivationTryIndex = 0
        do {
            # Set variables
            $cloudFlowsActivationContinue = $true
            $cloudFlowActivationFailed = $false

            # Increment cloud flows activation try index
            $cloudFlowsActivationTryIndex++
            Write-Verbose "Cloud flows activation try $cloudFlowsActivationTryIndex"

            # Get the cloud (modern) flows in "Draft" state in the considered solution
            $draftCloudFlows = (Get-CrmRecordsByFetch -conn $connection -Fetch $fetchDraftCloudFlows -Verbose).CrmRecords

            # For each cloud (modern) flow in "Draft" state in the considered solution
            Write-Verbose "For each cloud flow in the considered solution..."
            foreach ($draftCloudFlow in $draftCloudFlows) {
                $cloudFlowId = $draftCloudFlow.workflowid

                # Turn on the cloud flow using the impersonation connection (automatically set the provided user as owner)
                Write-Verbose "Try to turn on the following cloud flow: $cloudFlowId"
                try {
                    Set-CrmRecordState -conn $impersonationConnection -EntityLogicalName workflow -Id $cloudFlowId -StateCode Activated -StatusCode Activated -ErrorVariable cloudFlowStateUpdateError -ErrorAction Stop
                    Write-Verbose "Following cloud flow successfully activated: $cloudFlowId"
                }
                catch {
                    Write-Verbose "Error in the activation of the following cloud flow: $cloudFlowId - $cloudFlowStateUpdateError"
                    $cloudFlowActivationFailed = $true
                }
            }

            # Stop the do-while loop if at least one condition below is true
            #   - No cloud flow activation failed
            #   - Maximum tries limit reached
            #   - No cloud flows in the "Draft" state found in the considered solution
            if (!$cloudFlowActivationFailed -or ($cloudFlowsActivationTryIndex -eq $maximumTriesForCloudFlowsActivation) -or ($draftCloudFlows.Count -eq 0)) {
                $cloudFlowsActivationContinue = $false
            }

            # Throw error if maximum tries limit reached and at least one cloud flow activation failed
            if ($cloudFlowActivationFailed -and ($cloudFlowsActivationTryIndex -eq $maximumTriesForCloudFlowsActivation)) {
                throw "Activation of all the cloud flows in the $SolutionName solution was not completed successfully in the maximum tries configured ($maximumTriesForCloudFlowsActivation)."
            }

        } while ($cloudFlowsActivationContinue)
    }

    End{}
}