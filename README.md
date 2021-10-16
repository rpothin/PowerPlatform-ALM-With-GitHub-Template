<p align="center">
    <h1 align="center">
        Power Platform ALM With GitHub - Template
    </h1>
    <h3 align="center">
        Simplify the setup of a GitHub repository for Power Platform development!
    </h3>
    <p align="center">
        This project is an open-source repository template whose main purpose is to help you start your ALM journey for Power Platform solutions using GitHub.
    </p>
</p>

<p align="center">
    <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/LICENSE" alt="Repository License">
        <img src="https://img.shields.io/github/license/rpothin/PowerPlatform-ALM-With-GitHub-Template?color=yellow&label=License" /></a>
    <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/issues" alt="Open Issues">
        <img src="https://img.shields.io/github/issues-raw/rpothin/PowerPlatform-ALM-With-GitHub-Template?label=Open%20Issues" /></a>
    <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/pulls" alt="Open Pull Requests">
        <img src="https://img.shields.io/github/issues-pr-raw/rpothin/PowerPlatform-ALM-With-GitHub-Template?label=Open%20Pull%20Requests" /></a>
</p>

<p align="center">
    <a href="#watchers" alt="Watchers">
        <img src="https://img.shields.io/github/watchers/rpothin/PowerPlatform-ALM-With-GitHub-Template?style=social" /></a>
    <a href="#forks" alt="Forks">
        <img src="https://img.shields.io/github/forks/rpothin/PowerPlatform-ALM-With-GitHub-Template?style=social" /></a>
    <a href="#stars" alt="Stars">
        <img src="https://img.shields.io/github/stars/rpothin/PowerPlatform-ALM-With-GitHub-Template?style=social" /></a>
</p>

<h3 align="center">
  <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/discussions?discussions_q=category%3AIdeas">Feature request</a>
  <span> · </span>
  <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/issues/new/choose">Report a bug</a>
  <span> · </span>
  <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/discussions/categories/q-a">Support</a>
</h3>

## 🚀 Features

- **Workspace initialization** when an issue is assigned and a specific label added to it:
  - create a new branch dedicated to the issue
  - create a new Power Platform Dev environment dedicated to the issue and add the developer as System Administrator
  - import the existing solution in the repository to the new Dev environment (*if it exists*)
  - add comments to the issue with workspace details (*branch an Dev environment*)
  - add a specific label to the issue to indicate a Power Platform Dev environment has been created for this issue
- **On-demand solution export and unpack** from a Power Platform Dev environment using the issue number and the name of the considered solution
- **Solution validation** on the "work in progress" version of a solution on the creation of a pull request targeting the main branch
- **Import solution to a Power Platform Validation environment** when a new commit is made on the main branch with changes in the **Solutions/** folder
- **Clean a development workspace** when the associated issue is closed or deleted
- **Create a GitHub release** and **deploy the managed solution in it to a Power Platform Production environment**

> *Note: Some of these features used a Just In Time (JIT) Power Platform Build environment to build a managed version of a solution based on an exported and unpacked unmanaged solution.*

## ✈️ How to use this repository template?

### Prerequisites

- A GitHub account - *if you don't have one it is really easy and fun to create one: [GitHub signup](https://github.com/signup)*
- Access to the information (*tenant id, client id and secret*) of a service principal capable of creating Power Platform environments on the tenant you want to use and execute the solution checker - *API permissions required on the service principal (at least): Dynamics CRM.user_impersonation and Microsoft Graph.User.Read*
- 2 Power Platform environments already created on your tenant: Validation and Production

### Step by step configuration procedure

1. Click on the **Use this template** button on the top of the main page of [this repository](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template)
2. In the page that will open, enter the information for the creation of the new repository based on this template

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
   - **APPLICATION_ID**: Application (client) ID of the service principal with Dynamics CRM.user_impersonation and Microsoft Graph.User.Read API permissions
   - **CLIENT_SECRET**: Client secret of the service principal with Dynamics CRM.user_impersonation and Microsoft Graph.User.Read API permissions
   - **TENANT_ID**: Directory (tenant) ID of the service principal with Dynamics CRM.user_impersonation and Microsoft Graph.User.Read API permissions
   - **DATAVERSE_VALIDATION_ENVIRONMENT_URL**: URL of the Power Platform Validation environment
   - **DATAVERSE_VALIDATION_ENVIRONMENT_NAME**: Display name of the Power Platform Validation environment
   - **DATAVERSE_PRODUCTION_ENVIRONMENT_URL**: URL of the Power Platform Production environment
   - **DATAVERSE_PRODUCTION_ENVIRONMENT_NAME**: Display name of the Power Platform Production environment
   - **BRANCH_NAME_BASE**: Base used with the number of the issue to build the name of the development branches (*for example `dev/issue_`*)
   - **DATAVERSE_ENVIRONMENT_DISPLAY_NAME_BASE**: Base used with the number of the issue to build the display name of the Power Platform environments (*for example `BAFC - Raphael - Dev - Issue `*)
   - **DATAVERSE_ENVIRONMENT_DOMAIN_NAME_BASE**: Base used with the number of the issue to build the domain name of the Power Platform environments (*for example `bafc-rpo-gh-dev-issue-`*)
   - **DATAVERSE_ENVIRONMENT_URL_BASE**: Base of the URL used for the creation of the Power Platform environments (*for example `.crm3.dynamics.com`*) - you can find all the available values in the [Datacenter regions](https://docs.microsoft.com/en-us/power-platform/admin/new-datacenter-regions) documentation page
   - **DATAVERSE_ENVIRONMENT_REGION**: Name of the location used for the creation of the Power Platform environments (*development and build*)
   - **DATAVERSE_ENVIRONMENT_CURRENCY_NAME**: Name of the currency used for the creation of the Power Platform environments (*development and build*)
   - **DATAVERSE_ENVIRONMENT_LANGUAGE_NAME**: Name of the language used for the creation of the Power Platform environments (*development and build*)
   - **DEVELOPER_INTERNAL_EMAIL**: Email used by the developer to connect to the Power Platform environments (*currently the GitHub workflow support only one developer*)
   - SOLUTION_COMPONENTS_OWNER_EMAIL: Email of the user considered for the ownership of solution components (*ex: cloud flows*)
   - PAC_CLI_VERSION: Version of the [Power Platform CLI](https://docs.microsoft.com/en-us/powerapps/developer/data-platform/powerapps-cli) used in the GitHub workflows to unpack and pack the canvas apps (*for example `1.8.6`*)

> *Note: You can use the commands below from the [Microsoft.PowerApps.Administration.PowerShell](https://www.powershellgallery.com/packages/Microsoft.PowerApps.Administration.PowerShell) PowerShell module to find the information for the GitHub secrets for the creation of the Power Platform environments:*
> - *The [Get-AdminPowerAppEnvironmentLocations](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappenvironmentlocations) command can be used to get all the supported locations for your Power Platform environment*
> - *The [Get-AdminPowerAppCdsDatabaseCurrencies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappcdsdatabasecurrencies) command can be used to get all the supported currencies for a specific location for your Power Platform environment*
> - *The [Get-AdminPowerAppCdsDatabaseLanguages](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/get-adminpowerappcdsdatabaselanguages) command can be used to get all the supported languages for a specific location for your Power Platform environment*

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

You should now be ready to start your Power Platform developments from your new GitHub repository 🎉

## 📅 Roadmap

Keep an eye 👀 on the [⚒ To do / Unreleased](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/CHANGELOG.md#-to-do--unreleased) section of the **CHANGELOG** to know what's coming next.

## ❗ Code of Conduct

I, Raphael Pothin, as creator of this project, am dedicated to providing a welcoming, diverse, and harrassment-free experience for everyone. I expect everyone visiting or participating to this project to abide by the following [**Code of Conduct**](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/CODE_OF_CONDUCT.md). Please read it.

## 👐 Contributing to this project

From opening a bug report to creating a pull request: every contribution is appreciated and welcomed.
For more information, see [CONTRIBUTING.md](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/CONTRIBUTING.md)

### Not Sure Where to Start?

If you want to participate to this project, but you are not sure how you can do it, do not hesitate to contact [@rpothin](https://github.com/rpothin):
- By email at raphael.pothin@gmail.com
- On [Twitter](https://twitter.com/RaphaelPothin)

### Contributors

Thanks to the following people who have contributed to this project:
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://medium.com/rapha%C3%ABl-pothin"><img src="https://avatars0.githubusercontent.com/u/23240245?v=4" width="100px;" alt=""/><br /><sub><b>Raphael Pothin</b></sub></a><br /><a href="#ideas-rpothin" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/commits?author=rpothin" title="Code">💻</a> <a href="#content-rpothin" title="Content">🖋</a> <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/commits?author=rpothin" title="Documentation">📖</a> <a href="#maintenance-rpothin" title="Maintenance">🚧</a> <a href="#projectManagement-rpothin" title="Project Management">📆</a> <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/commits?author=rpothin" title="Tests">⚠️</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->

> *This project follows the [all-contributors](https://allcontributors.org/docs/en/specification) specification. Everyone who would like to contribute to it is welcome!*

## 📝 License

This project is licensed under the [MIT](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/LICENSE) license.

## 💡 Inspiration

I would like to thank the open-source projects below that helped me find some ideas on how to organize this project.

- [budibase](https://github.com/Budibase/budibase/)
- [all-contributors](https://github.com/all-contributors/all-contributors)
- CoE Starter Kit...
