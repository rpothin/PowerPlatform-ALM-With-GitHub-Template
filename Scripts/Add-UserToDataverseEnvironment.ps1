Function Add-UserToDataverseEnvironment {
    <#
        .SYNOPSIS
            Add a user to a Dataverse environment

        .DESCRIPTION
            Add a user to a Dataverse environment and assign the provided security role.

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

        .PARAMETER UserObjectId
            Object ID (in Azure AD) of the user to add to the considered Dataverse environment.

        .PARAMETER UserInternalEmail
            Internal email of the user to add to the considered Dataverse environment.

        .PARAMETER SecurityRoleName
            Specifies the name of the security role you want to assign to the user you will add to the considered Dataverse environment.
        
        .INPUTS
            None. You cannot pipe objects to Add-UserToDataverseEnvironment.

        .OUTPUTS
            Object. Add-UserToDataverseEnvironment returns the details of of the operation of adding the user to the targeted Dataverse environment.

        .EXAMPLE
            PS> Add-UserToDataverseEnvironment -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "clientSecretSample" -DataverseEnvironmentUrl "https://demo.crm3.dynamics.com/" -DataverseEnvironmentDisplayName "Demo" -UserObjectId "00000000-0000-0000-0000-000000000000" -UserObjectId "user.demo@demo.com"

        .LINK
            README.md: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/README.md

        .NOTES
            * This function does not work for now whith PowerShell 7 / Core
            * You need to have the following PowerShell modules installed to be able to use this function: Microsoft.PowerApps.Administration.PowerShell, Microsoft.Xrm.Data.PowerShell
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

        # Display name of the targeted Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$DataverseEnvironmentDisplayName,

        # Object ID of the user to add to the Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$UserObjectId,

        # Internal email of the user to add to the Dataverse environment
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$UserInternalEmail,

        # Name of the security role to assign to the new user
        [Parameter()]
        [String]$SecurityRoleName="System Administrator"
    )

    Begin{}

    Process{
        # Set variables
        Write-Verbose "Set variables."
        $dataverseEnvironmentNameForSearch = $DataverseEnvironmentDisplayName.Replace(" ", "*")

        # Connect to Power Apps with service principal
        Write-Verbose "Connect to Power Apps with service principal."
        Add-PowerAppsAccount -TenantID $TenantId -ApplicationId $ClientId -ClientSecret $ClientSecret
        
        # Set generic connection (with service principal)
        Write-Verbose "Set generic connection (with service principal)."
        $connection = Connect-CrmOnline -ServerUrl $DataverseEnvironmentUrl -OAuthClientId $ClientId -ClientSecret $ClientSecret
        
        # Get the business unit ID of the of the account we are connected with
        Write-Verbose "Get the business unit ID of the of the account we are connected with."
        $businessUnitId = (Invoke-CrmWhoAmI).BusinessUnitId

        # Set Fetch query variable for the search of an existing user
        $fetchUsers = @"
<fetch version="1.0" output-format="xml-platform" mapping="logical" distinct="false" no-lock="true">
    <entity name="systemuser">
        <attribute name="systemuserid" />
        <filter type="and">
            <condition attribute="internalemailaddress" operator="eq" value="{0}" />
        </filter>
    </entity>
</fetch>
"@
        $fetchUsers = $fetchUsers -F $UserInternalEmail

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
        
        # Search considered environment based on Display name
        Write-Verbose "Search Dataverse environments with the following display name: $DataverseEnvironmentDisplayName"
        $dataverseEnvironments = Get-AdminPowerAppEnvironment *$dataverseEnvironmentNameForSearch*

        # Number of environments found
        $dataverseEnvironmentsMeasure = $dataverseEnvironments | Measure
        $dataverseEnvironmentsCount = $dataverseEnvironmentsMeasure.count

        # If only 1 Dataverse environment found we continue, else there is an error
        if($dataverseEnvironmentsCount -eq 1) {
            Write-Verbose "Only one Dataverse environment found."
            Write-Verbose "Set variable for the 'name' of the considered Dataverse environment."
            $dataverseEnvironmentName = $dataverseEnvironments[0].EnvironmentName

            Write-Verbose "Add the considered to the Dataverse environment we found."
            $addUserToEnvironment = Add-AdminPowerAppsSyncUser -EnvironmentName "$dataverseEnvironmentName" -PrincipalObjectId $UserObjectId

            Write-Verbose "List users with the considered internal email."
            $users = Get-CrmRecordsByFetch -Fetch $fetchUsers

            # If only 1 user found we continue, else there is an error
            if ($users.Count -eq 1) {
                Write-Verbose "Get the ID of the new user in the considered Dataverse environment."
                $userId = $users.CrmRecords[0].systemuserid

                Write-Verbose "Search security roles with the following information: SecurityRoleName is $SecurityRoleName and BusinessUnitId is $businessUnitId"
                $securityRoles = Get-CrmRecordsByFetch -Fetch $fetchSecurityRoles

                # If only 1 security role found we continue, else there is an error
                if ($securityRoles.Count -eq 1) {
                    Write-Verbose "Set variable for the 'id' of the security role we found."
                    $securityRoleId = $securityRoles.CrmRecords[0].roleid.Guid

                    Write-Verbose "Assign security role to the user."
                    Add-CrmSecurityRoleToUser -UserId $userId -SecurityRoleId $securityRoleId
                }
                else {
                    Write-Verbose "No or multiple security role(s) found - Error."
                    Throw "No or multiple security role(s) found in the considered Dataverse environment."
                }
            }
            else {
                Write-Verbose "No or multiple user(s) found - Error."
                Throw "No or multiple user(s) found for the following display name in the considered Dataverse environment."
            }
        }
        else {
            Write-Verbose "No or multiple Dataverse environment(s) found - Error."
            Throw "No or multiple Dataverse environment(s) found for the following display name: $DataverseEnvironmentDisplayName"
        }
    }

    End{}
}