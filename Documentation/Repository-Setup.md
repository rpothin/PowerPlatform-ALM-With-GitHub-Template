<p align="center">
    <h1 align="center">
        How to setup your repository from this template?
    </h1>
    <p align="center">
        First steps to initialize your repository for Power Platform / Dynamics 365 development.
    </p>
</p>

## Prerequisites

- [ ] A GitHub account - *if you don't have one it is really easy and fun to create one: [GitHub signup](https://github.com/signup)*
- [ ] Access to the information (*tenant id, client id and secret*) of a service principal capable of creating Power Platform environments on the tenant you want to use and execute the solution checker - *API permissions required on the service principal (at least): Dynamics CRM.user_impersonation and Microsoft Graph.User.Read*
- [ ] 2 Power Platform environments already created on your tenant: Validation and Production
- [ ] An **app registration** registered in Azure Active Directory with (*at least*):
  - the following permission (delegated type) : `Dynamics CRM.user_impersonation`
  - a client secret generated and stored somewhere safe
  - the following account type selected: **multitenant**
- [ ] Run the [**New-PowerAppManagementApp**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/new-powerappmanagementapp) PowerShell command of the [**Microsoft.PowerApps.Administration.PowerShell**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell) PowerShell module specifying the **Application (client) ID** of the app registration you registered previously in Azure AD:

```shell
> Add-PowerAppsAccount
> New-PowerAppManagementApp -ApplicationId 00000000-0000-0000-0000-000000000000
```

## Step by step guide

1. Click on the **Use this template** button on the top of the main page of [this repository](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template)
2. In the page that will open, enter the information for the creation of your new repository based on this template

> *Note: Let the **Include all branches** option unchecked.*

3. Click on the **Create repository from template** button

![Create_Repository_From_Template](https://user-images.githubusercontent.com/23240245/136492683-f9206b6f-2608-493c-a7ac-8bc2aea065b8.gif)

4. In the new repository, go to the **Settings** tab
5. Open the **Environments** section
6. Create the following environments:
   - development
   - build
   - validation
   - production

> *Note: We suggest to add a [protection rule](https://docs.github.com/en/actions/deployment/environments#environment-protection-rules) (at least one reviewer for solution deployments) on the **validation** and **production** environments.*

![Create_Environment_With_Reviewer](https://user-images.githubusercontent.com/23240245/136494086-bccc84a5-1a82-4bfb-8359-d9211e0ea234.gif)

7. Open the **Secrets** section
8. Add the following repository secrets to the new repository:

| **Secret Name**                           | **Description**                                                                            | **Example**                          |
|-------------------------------------------|--------------------------------------------------------------------------------------------|--------------------------------------|
| **APPLICATION_ID**                        | **Application (client) ID** of the app registration with *Dynamics CRM.user_impersonation* | 00000000-0000-0000-0000-000000000000 |
| **CLIENT_SECRET**                         | **Secret** of the app registration with *Dynamics CRM.user_impersonation*                  | *********************                |
| **TENANT_ID**                             | **Directory (tenant) ID** of the app registration with *Dynamics CRM.user_impersonation*   | 00000000-0000-0000-0000-000000000000 |
| **DATAVERSE_VALIDATION_ENVIRONMENT_URL**  | URL of the Dataverse Validation environment                                                | https://validation.crm3.dynamics.com |
| **DATAVERSE_VALIDATION_ENVIRONMENT_NAME** | Display name of the Dataverse Validation environment                                       | Validation                           |
| **DATAVERSE_PRODUCTION_ENVIRONMENT_URL**  | URL of the Dataverse Production environment                                                | https://production.crm3.dynamics.com |
| **DATAVERSE_PRODUCTION_ENVIRONMENT_NAME** | Display name of the Dataverse Production environment                                       | Production                           |
| **SOLUTION_COMPONENTS_OWNER_EMAIL**       | Email of the user considered for the ownership of solution components (*ex: cloud flows*)  | appcomponentsowner@email.com         |

![Create_Secret](https://user-images.githubusercontent.com/23240245/136882520-ba598d65-7760-4504-b2df-9dfae930570d.gif)

9. In the new repository, go to the **Issues** tab
10.  Click on **Labels**
11.  Create the following labels using the **New label** button:
   - **in progress**: Trigger the workspace initialization (*branch and environment*)
   - **dev env created**: Indicate that a Power Platform Dev environment has been created for this issue

> *Note: you can change the name of the labels, but you will need to make some replacements in the GitHub workflows.*

![Create_Label](https://user-images.githubusercontent.com/23240245/137238762-f0cd25a7-dc2d-4647-b33b-de6d41ab86a5.gif)

12.  In the new repository, go to the **Code** tab
13.  Open the [**github.dev**](https://github.dev/rpothin/PowerPlatform-ALM-With-GitHub-Template) interface
14.  Open and make some updates, if necessary, in the GitHub workflows:
   - environment variables:
      - **dataverse_environment_sku** and **solution_name** in multiple workflows
      - **solution_checker_geography** in "solution-quality-check-on-pr.yml"
   - issue labels considered in the workflows

![Update_GitHub_Workflows](https://user-images.githubusercontent.com/23240245/137244781-6de497ea-a4ba-4143-a19a-0f561dfc50ba.gif)

15. Update the [configurations.json](Configurations/configurations.json) file

> *Note: You can find all the available values in the [Datacenter regions](https://docs.microsoft.com/en-us/power-platform/admin/new-datacenter-regions) documentation page.*

> *Note: You can use the commands below from the [Microsoft.PowerApps.Administration.PowerShell](https://www.powershellgallery.com/packages/Microsoft.PowerApps.Administration.PowerShell) PowerShell module to find the information for the GitHub secrets for the creation of the Power Platform environments:*
> - *The [Get-AdminPowerAppEnvironmentLocations](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappenvironmentlocations) command can be used to get all the supported locations for your Power Platform environment*
> - *The [Get-AdminPowerAppCdsDatabaseCurrencies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappcdsdatabasecurrencies) command can be used to get all the supported currencies for a specific location for your Power Platform environment*
> - *The [Get-AdminPowerAppCdsDatabaseLanguages](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappcdsdatabaselanguages) command can be used to get all the supported languages for a specific location for your Power Platform environment*

You should now be ready to start your Power Platform developments from your new GitHub repository 🎉