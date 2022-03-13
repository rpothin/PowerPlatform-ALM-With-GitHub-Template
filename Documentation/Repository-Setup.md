<p align="center">
    <h1 align="center">
        How to setup a repository from this template?
    </h1>
    <p align="center">
        First steps to initialize a repository for Power Platform / Dynamics 365 development.
    </p>
</p>

## Prerequisites

- [ ] A GitHub account - *if you don't have one it is really easy and fun to create one: [GitHub signup](https://github.com/signup)*
- [ ] 2 Dataverse environments already created on your tenant: **Validation** and **Production**
- [ ] An **app registration** registered in Azure Active Directory with (*at least*):
  - the following permission (delegated type) : `Dynamics CRM.user_impersonation`
  - the following account type selected: **multitenant**
  - a client secret generated and stored somewhere safe
- [ ] Run the [**New-PowerAppManagementApp**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/new-powerappmanagementapp) PowerShell command of the [**Microsoft.PowerApps.Administration.PowerShell**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell) PowerShell module specifying the **Application (client) ID** of the app registration you registered previously in Azure AD:

```shell
> Add-PowerAppsAccount
> New-PowerAppManagementApp -ApplicationId 00000000-0000-0000-0000-000000000000
```

## Step by step guide

### 1 - Create repository from template

1. Click on the **Use this template** button on the top of the main page of [this repository](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template)
2. In the page that will open, enter the information for the creation of your new repository based on this template

> *Note: Let the **Include all branches** option unchecked if you don't want to get potential branches with work in progress.*

3. Click on the **Create repository from template** button to finalize the creation of the repository

![Create_Repository_From_Template](https://user-images.githubusercontent.com/23240245/136492683-f9206b6f-2608-493c-a7ac-8bc2aea065b8.gif)

### 2 - Add environments to repository

1. In the new repository, go to the **Settings** tab
2. Open the **Environments** section
3. Create the following environments:
   - **development**
   - **build**
   - **validation**
   - **production**

> *Note: We suggest to add a [protection rule](https://docs.github.com/en/actions/deployment/environments#environment-protection-rules) (at least one reviewer for solution deployments) on the **validation** and **production** environments.*

![Create_Environment_With_Reviewer](https://user-images.githubusercontent.com/23240245/136494086-bccc84a5-1a82-4bfb-8359-d9211e0ea234.gif)

> *Note: The GIF above is not up to date. We will update it in a future version.*

### 3 - Add secrets to repository

1. In the new repository, go to the **Settings** tab
2. Open the **Secrets > Actions** section
3. Create the secrets below using the **New repository secret** button:

| **Secret Name**                           | **Description**                                                                            | **Example**                          |
| ----------------------------------------- | ------------------------------------------------------------------------------------------ | ------------------------------------ |
| **APPLICATION_ID**                        | **Application (client) ID** of the app registration with *Dynamics CRM.user_impersonation* | 00000000-0000-0000-0000-000000000000 |
| **CLIENT_SECRET**                         | **Secret** of the app registration with *Dynamics CRM.user_impersonation*                  | *********************                |
| **TENANT_ID**                             | **Directory (tenant) ID** of the app registration with *Dynamics CRM.user_impersonation*   | 00000000-0000-0000-0000-000000000000 |
| **DATAVERSE_VALIDATION_ENVIRONMENT_URL**  | URL of the Dataverse Validation environment                                                | https://validation.crm3.dynamics.com |
| **DATAVERSE_VALIDATION_ENVIRONMENT_NAME** | Display name of the Dataverse Validation environment                                       | Validation                           |
| **DATAVERSE_PRODUCTION_ENVIRONMENT_URL**  | URL of the Dataverse Production environment                                                | https://production.crm3.dynamics.com |
| **DATAVERSE_PRODUCTION_ENVIRONMENT_NAME** | Display name of the Dataverse Production environment                                       | Production                           |
| **SOLUTION_COMPONENTS_OWNER_EMAIL**       | Email of the user considered for the ownership of solution components (*ex: cloud flows*)  | appcomponentsowner@email.com         |

![Create_Secret](https://user-images.githubusercontent.com/23240245/136882520-ba598d65-7760-4504-b2df-9dfae930570d.gif)

> *Note: The GIF above is not up to date. We will update it in a future version.*

### 4 - Add labels to repository

1. In the new repository, go to the **Issues** tab
2. Click on **Labels**
3. Create the labels below using the **New label** button:

| **Label Name**      | **Description**                                | Usage                                                                               |
| ------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------- |
| **in progress**     | Work in progress                               | Involved in the trigger of the workspace initialization (*branch and environment*)  |
| **dev env created** | Development environment created for this issue | Indicate that a Dataverse Dev environment has been created for the considered issue |

> *Note: You can change the name of the labels, but you will need to make some replacements in the GitHub workflows.*

![Create_Label](https://user-images.githubusercontent.com/23240245/137238762-f0cd25a7-dc2d-4647-b33b-de6d41ab86a5.gif)

### 5 - Update global configurations

The global configurations file is used to simplify the management of information required in the GitHub workflows proposed in this repository.

This file follows the format below:

```json
{
    "environment": {
        "region": "canada",
        "urlRegionCode": "crm3",
        "languageDisplayName": "English",
        "currencyName": "CAD",
        "developmentEnvironment": {
            "displayNameBase": "xxx - ",
            "domainNameBase": "xxx-",
            "skuName": "Sandbox",
            "developersAzureAdGroupName": "sg-xxx"
        },
        "buildEnvironment": {
            "displayNameBase": "xxx - ",
            "domainNameBase": "xxx-",
            "skuName": "Sandbox"
        }
    },
    "developmentBranchNameBase": "work/",
    "pacCliVersion": "1.10.4",
    "powerAppsMakerPortalBaseUrl": "https://make.powerapps.com/environments/",
    "deploymentSettingsFileNameBase": "DeploymentSettings",
    "customDeploymentSettingsFileNameBase": "CustomDeploymentSettings"
}
```

You will find below details regarding each configuration:

| **Configuration Name**                             | **Description**                                                                                                           | **Example**               |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ------------------------- |
| environment.region                                 | Region considered for the Dataverse environments                                                                          | canada                    |
| environment.urlRegionCode                          | Code of the region considered for the URL of the Dataverse environments                                                   | crm3                      |
| environment.languageDisplayName                    | Display name of the default language for the Dataverse environments                                                       | English                   |
| environment.currencyName                           | Name of the default currency for the Dataverse environments                                                               | CAD                       |
| environment.developmentEnvironment.displayNameBase | Left part of the display name of the Dataverse Dev environment that will be created during workspace initialization phase | "BAFC - Raphael - Dev - " |
| environment.developmentEnvironment.domainNameBase  | Left part of the URL of the Dataverse Dev environment that will be created during workspace initialization phase          | "bafc-rpo-gh-dev-"        |
| environment.developmentEnvironment.skuName         | SKU name the Dataverse Dev environment that will be created during workspace initialization phase                         | Sandbox                   |
| ...                                                |                                                                                                                           |                           |

> *Note: You can find the code for the URL of a Datavers environment of the considered region in the [Datacenter regions](https://docs.microsoft.com/en-us/power-platform/admin/new-datacenter-regions) documentation page.*

> *Note: You can use the commands below from the [Microsoft.PowerApps.Administration.PowerShell](https://www.powershellgallery.com/packages/Microsoft.PowerApps.Administration.PowerShell) PowerShell module to find the information for the configurations of Dataverse environments:*
> - *The [Get-AdminPowerAppEnvironmentLocations](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappenvironmentlocations) command (**LocationName** column value in results) can be used to get all the supported locations for Dataverse environments*
> - *The [Get-AdminPowerAppCdsDatabaseCurrencies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappcdsdatabasecurrencies) command can be used to get all the supported currencies for a specific location for Dataverse environments*
> - *The [Get-AdminPowerAppCdsDatabaseLanguages](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappcdsdatabaselanguages) command can be used to get all the supported languages for a specific location for Dataverse environments*

> *Note: Valid options for **skuName** configurations are: Trial, Sandbox, Production, SubscriptionBasedTrial (source [microsoft/powerplatform-actions/create-environment](https://github.com/microsoft/powerplatform-actions/blob/30b7cbe414cf675d173d8af70e06c1ed7eef10f3/create-environment/action.yml#L36))*

You should now be ready to start your Power Platform / Dynamics 365 developments using your new GitHub repository 🎉

### 6 - Update code for your own needs (optional)

1. In the new repository, go to the **Code** tab
2. Open the [**github.dev**](https://github.dev/rpothin/PowerPlatform-ALM-With-GitHub-Template) interface
3. Open and make some updates, if necessary, in the GitHub workflows:
   - environment variables:
      - **dataverse_environment_sku** (*in "global" configurations file now*) and **solution_name** in multiple workflows
      - **solution_checker_geography** in "solution-quality-check-on-pr.yml" ==> *will soon be replaced by properties in the "global" configurations file*
   - issue labels considered in the workflows

![Update_GitHub_Workflows](https://user-images.githubusercontent.com/23240245/137244781-6de497ea-a4ba-4143-a19a-0f561dfc50ba.gif)