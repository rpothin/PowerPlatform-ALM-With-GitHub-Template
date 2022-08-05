<p align="center">
    <h1 align="center">
        How to setup a repository from this template?
    </h1>
    <p align="center">
        First steps to initialize a GitHub repository for Power Platform / Dynamics 365 development.
    </p>
</p>

## Prerequisites

- [ ] A GitHub account - *if you don't have one it is really easy and fun to create it: [GitHub signup](https://github.com/signup)*
- [ ] 2 Dataverse environments already created in your tenant: **Validation** and **Production**
- [ ] An **app registration** registered in Azure Active Directory with a client secret generated and stored somewhere safe
- [ ] Run the [**New-PowerAppManagementApp**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/new-powerappmanagementapp) PowerShell command of the [**Microsoft.PowerApps.Administration.PowerShell**](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell) PowerShell module specifying the **Application (client) ID** of the app registration mentioned in the previous point:

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

> *Note: We suggest to add a [protection rule](https://docs.github.com/en/actions/deployment/environments#environment-protection-rules) (at least one reviewer for solution deployments) for the **validation** and **production** environments.*

![Create_Environment_With_Reviewer](https://user-images.githubusercontent.com/23240245/136494086-bccc84a5-1a82-4bfb-8359-d9211e0ea234.gif)

> *Note: The GIF above is not up to date. We will update it in a future version.*

### 3 - Add secrets to repository

#### Action secrets

1. In the new repository, go to the **Settings** tab
2. Open the **Secrets > Actions** section
3. Create the secrets below using the **New repository secret** button:

| **Secret Name**                     | **Description**                                                                                   | **Example**                          |
| ----------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------ |
| **APPLICATION_ID**                  | **Application (client) ID** of the considered app registration                                    | 00000000-0000-0000-0000-000000000000 |
| **CLIENT_SECRET**                   | **Secret** of the considered app registration                                                     | *********************                |
| **TENANT_ID**                       | **Directory (tenant) ID** of the considered app registration                                      | 00000000-0000-0000-0000-000000000000 |
| **SOLUTION_COMPONENTS_OWNER_EMAIL** | Email of the user account considered for the ownership of solution components (*ex: cloud flows*) | appcomponentsowner@email.com         |

![Create_Secret](https://user-images.githubusercontent.com/23240245/136882520-ba598d65-7760-4504-b2df-9dfae930570d.gif)

> *Note: The GIF above is not up to date. We will update it in a future version.*

#### Environment secrets

> *Note: The actions below need to be done for the **validation** and **production** environments.*

1. In the new repository, go to the **Settings** tab
2. Open the **Environments** section
3. Click on the name of the environment where you want to add the secrets
4. Go to the botton of the environment page, and click on the **Add secret** button to register the secrets below:

| **Secret Name**                        | **Description**                                      | **Example**                          |
| -------------------------------------- | ---------------------------------------------------- | ------------------------------------ |
| **DATAVERSE_ENVIRONMENT_URL**          | URL of the considered Dataverse environment          | https://validation.crm3.dynamics.com |
| **DATAVERSE_ENVIRONMENT_DISPLAY_NAME** | Display name of the considered Dataverse environment | Validation                           |

### 4 - Add labels to repository

1. In the new repository, go to the **Issues** tab
2. Click on **Labels**
3. Create the labels below using the **New label** button:

| **Label Name**      | **Description**                                | Usage                                                                                           |
| ------------------- | ---------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **in progress**     | Work in progress                               | Involved in the trigger of the workspace initialization (*branch and dev environment creation*) |
| **dev env created** | Development environment created for this issue | Indicate that a Dataverse Dev environment has been created for the considered issue             |

> *Note: You can change the name of the labels, but in that case you will need to make some replacements in the GitHub workflows.*

![Create_Label](https://user-images.githubusercontent.com/23240245/137238762-f0cd25a7-dc2d-4647-b33b-de6d41ab86a5.gif)

### 5 - Update global configurations

The global configurations file is used to simplify the management of information required in the GitHub workflows proposed in this repository.

This file follows the format below:

```json
{
    "environment": {
        "region": "canada",
        "urlRegionCode": "crm3",
        "languageCode": "1033",
        "currencyName": "CAD",
        "developmentEnvironment": {
            "displayNameBase": "xxx - ",
            "domainNameBase": "xxx-",
            "skuName": "Sandbox",
            "developersAzureAdGroupName": "sg-xxx",
            "descriptionBase": "Environment for development on the following issue: "
        },
        "buildEnvironment": {
            "displayNameBase": "xxx - ",
            "domainNameBase": "xxx-",
            "skuName": "Sandbox",
            "azureAdGroupName": "sg-xxx",
            "descriptionBase": "Development for the following build of solution: "
        }
    },
    "developmentBranchNameBase": "work/",
    "pacCliVersion": "1.16.6",
    "powerAppsMakerPortalBaseUrl": "https://make.powerapps.com/environments/",
    "deploymentSettingsFileNameBase": "DeploymentSettings",
    "customDeploymentSettingsFileNameBase": "CustomDeploymentSettings",
    "maximumTriesForCloudFlowsActivation": 3,
    "solutionChecker": {
        "outputDirectory": "solutionCheckerResults/",
        "geography": "Canada",
        "maximumNumberHighSeverityPoints": 0,
        "maximumNumberMediumSeverityPoints": 5
    }
}
```

You will find below details regarding each configuration:

| **Configuration Name**                                                    | **Description**                                                                                                                                                                                                                    | **Example**                                            |
| ------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| environment </br> region                                                  | Region considered for the Dataverse environments                                                                                                                                                                                   | canada                                                 |
| environment </br> urlRegionCode                                           | Code of the region considered for the URL of the Dataverse environments                                                                                                                                                            | crm3                                                   |
| environment </br> languageCode                                            | Code of the default language for the Dataverse environments                                                                                                                                                                        | 1033                                                   |
| environment </br> currencyName                                            | Name of the default currency for the Dataverse environments                                                                                                                                                                        | CAD                                                    |
| environment </br> developmentEnvironment </br> displayNameBase            | Left part of the display name of the Dataverse Dev environment that will be created during workspace initialization phase                                                                                                          | "BAFC - Demo Application - Dev - "                     |
| environment </br> developmentEnvironment </br> domainNameBase             | Left part of the URL of the Dataverse Dev environment that will be created during workspace initialization phase                                                                                                                   | "bafc-demo-app-dev-"                                   |
| environment </br> developmentEnvironment </br> skuName                    | SKU name the Dataverse Dev environment that will be created during workspace initialization phase                                                                                                                                  | Sandbox                                                |
| environment </br> developmentEnvironment </br> developersAzureAdGroupName | Name of the Azure AD security group with the developers to add as a Azure AD security group team to the Dataverse Dev environment that will be created during workspace initialization phase and used to restrict the access to it | "sg-demoapplication-developers"                        |
| environment </br> developmentEnvironment </br> descriptionBase            | Base of the description of the Dataverse Dev environment that will be created during workspace initialization phase                                                                                                                | "Environment for development on the following issue: " |
| environment </br> buildEnvironment </br> displayNameBase                  | Left part of the display name of the Dataverse Build environments that will be created in different GitHub workflows                                                                                                               | "BAFC - Demo Application - Build - "                   |
| environment </br> buildEnvironment </br> domainNameBase                   | Left part of the URL of the Dataverse Build environments that will be created in different GitHub workflows                                                                                                                        | "bafc-demo-app-build-"                                 |
| environment </br> buildEnvironment </br> skuName                          | SKU name the Dataverse Build environments that will be created in different GitHub workflows                                                                                                                                       | Sandbox                                                |
| environment </br> buildEnvironment </br> azureAdGroupName                 | Name of the Azure AD security group to use to restrict the access to the Dataverse Build environments that will be created in different GitHub workflows                                                                           | "sg-demoapplication-developers"                        |
| environment </br> buildEnvironment </br> descriptionBase                  | Base of the description of the Dataverse Build environments that will be created in different GitHub workflows                                                                                                                     | "Environment for the following solution build: "       |
| developmentBranchNameBase                                                 | Left part of the name of the branch that will be created during workspace initialization phase                                                                                                                                     | "work/"                                                |
| pacCliVersion                                                             | Version of the Power Platform CLI you plan to use in the repository                                                                                                                                                                | "1.10.4"                                               |
| powerAppsMakerPortalBaseUrl                                               | Left part of the Power Apps maker portal URL focusing the solutions page of the Dataverse Dev environment that will be created during workspace initialization phase                                                               | "https://make.powerapps.com/environments/"             |
| deploymentSettingsFileNameBase                                            | Left part of the name of the deployment settings file that will be used for the configuration of solutions                                                                                                                         | "DeploymentSettings"                                   |
| customDeploymentSettingsFileNameBase                                      | Left part of the name of the custom deployment settings file (*for points not covered by the out of the box deployment settings file*) that will be used for the configuration of solutions                                        | "CustomDeploymentSettings"                             |
| maximumTriesForCloudFlowsActivation                                       | Maximum tries allowed for the activation of the cloud flows post solution deployment                                                                                                                                               | "3"                                                    |
| solutionChecker </br> outputDirectory                                     | Absolute path considered to store the sarif file generated by the solution checker                                                                                                                                                 | "solutionCheckerResults/"                              |
| solutionChecker </br> geography                                           | "Region" considered for the execution of the solution checker </br> *- used to temporarily stores the data that you upload in Azure along with the reports that are generated*                                                     | Canada                                                 |
| solutionChecker </br> maximumNumberHighSeverityPoints                     | Maximum number of high severity points identified during the execution of the solution checker allowed to continue                                                                                                                 | 0                                                      |
| solutionChecker </br> maximumNumberMediumSeverityPoints                   | Maximum number of medium severity points identified during the execution of the solution checker allowed to continue                                                                                                               | 5                                                      |

> *Notes:*
>
> - *You can find the code for the URL for a Dataverse environment for a considered region in the [Datacenter regions](https://docs.microsoft.com/en-us/power-platform/admin/new-datacenter-regions) documentation page.*
> - *You can use the commands below from the [Microsoft.PowerApps.Administration.PowerShell](https://www.powershellgallery.com/packages/Microsoft.PowerApps.Administration.PowerShell) PowerShell module to find the information for the configurations of Dataverse environments:*
>   - *The [Get-AdminPowerAppEnvironmentLocations](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappenvironmentlocations) command (**LocationName** column value in results) can be used to get all the supported locations for Dataverse environments*
>   - *The [Get-AdminPowerAppCdsDatabaseCurrencies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappcdsdatabasecurrencies) command (**CurrencyName** column value in results) can be used to get all the supported currencies for a specific location for Dataverse environments*
>   - *The [Get-AdminPowerAppCdsDatabaseLanguages](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappcdsdatabaselanguages) command (**LanguageName** column value in results) can be used to get all the supported languages for a specific location for Dataverse environments*
> - *Valid options for **environment.xxx.skuName** configurations are: Trial, **Sandbox, Production, SubscriptionBasedTrial** (source [microsoft/powerplatform-actions/create-environment](https://github.com/microsoft/powerplatform-actions/blob/30b7cbe414cf675d173d8af70e06c1ed7eef10f3/create-environment/action.yml#L36))*
> - *Valid options for **solutionChecker.geography** configuration can be found in the [Invoke-PowerAppsChecker](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.checker.powershell/invoke-powerappschecker?view=pa-ps-latest#parameters) Micrsoft documentation page*

You should now be ready to start your Power Platform / Dynamics 365 developments using your new GitHub repository 🎉

### 6 - Update code for your own needs (optional)

1. In the new repository, go to the **Code** tab
2. Open the [**github.dev**](https://github.dev/rpothin/PowerPlatform-ALM-With-GitHub-Template) (*exemple of the rpothin/PowerPlatform-ALM-With-GitHub-Template repository*) interface by pressing "."
3. In the **VS Code for the web** experience you will be able to make some updates, if necessary, in the GitHub workflows:
   - environment variables:
      - **solution_name** (*default value: PowerPlatformALMWithGitHub*)
   - issue labels:
      - **in progress**
      - **dev env created**

![Update_GitHub_Workflows](https://user-images.githubusercontent.com/23240245/137244781-6de497ea-a4ba-4143-a19a-0f561dfc50ba.gif)

<h3 align="center">
  <a href="../README.md#-documentation">🏡 README - Documentation</a>
</h3>
