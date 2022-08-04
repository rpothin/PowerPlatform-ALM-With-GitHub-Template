# Changelog

All notable changes to this repository will be documented in this file.

> The format is based on [Keep a Changelog](https://keepachangelog.com/en/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [⚒ Work in progress]

<!-- ### 🔨 Fixed

- ...

### 🚀 Added

- ...

### 🤖 Changed

- ...

### ❌ Deleted

- ... -->

## [0.4.0] - 2022-08-04

> Improvements on code resuability, resiliency and flexibility 🔥

### 🔨 Fixed

- Update of the solution versioning strategy proposed in this template (*details [here](./Documentation/ALM-Strategy.md#solution-versioning)*) because with a concatenation of the date (*yyyymmdd*) and the workflow run id for the patch part of the version we quickly reach some limitations on Power Platform solution versioning
- Checkout the `main` branch in the [**clean-dev-workspace-when-issue-closed-or-deleted**](./.github/workflows/clean-dev-workspace-when-issue-closed-or-deleted.yml) before trying to delete the development branch if it exists
- Management of the activation of cloud flows with child flows: introduction of a notion of retry in the [**Enable-CloudFlows**](./Scripts/Enable-CloudFlows.ps1) PowerShell script to cover a kind of multi-layered architecture (*cloud flows calling cloud flows calling cloud flows...*) based on a configuration at the repository level
- Removal of custom steps for cloud flows custom JSON formatting because the out-of-the-box Power Platform GitHub actions handle this part natively now
- Replacement of custom steps for the unpack and pack of canvas apps using PAC CLI with the new inputs in the out-of-the-box Power Platform GitHub actions - ⚠ *To correctly handle this process we currently have workarounds in place ([#226](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/issues/226)) that will be removed as soon as possible*
- Correction of issues due to an update on Azure CLI commands output schema (*`objectId` --> `id`*) in some PowerShell scripts
- Specification of the correct source branch for the build of the managed solution in the [**solution-quality-check-on-pr**](./.github/workflows/solution-quality-check-on-pr.yml) workflow
- Update of the version of some GitHub actions used in our workflows:
  - [**checkout**](https://github.com/actions/checkout) from 2 to 3.0.2
  - **github/codeql-action/upload-sarif** from 1 to 2 (*in [**powershell-analysis**](./.github/workflows/powershell-analysis.yml)*)
  - **actions/download-artifact** from 2 to 3
  - **actions/upload-artifact** from 2 to 3
  - **peter-evans/create-or-update-comment** from 1 to 2
  - **peterjgrainger/action-create-branch** from 2.0.1 to 2.2.0
- Ignore the [Documentation](./Documentation/) folder in the trigger configuration of the following workflows: [import-solution-to-validation](./.github/workflows/import-solution-to-validation.yml), [powershell-analysis](./.github/workflows/powershell-analysis.yml) and [solution-quality-check-on-pr](./.github/workflows/solution-quality-check-on-pr.yml)

### 🚀 Added

- [Reusable workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows) below for actions sequences previously duplicated in different workflows:
  - [**create-dataverse-environment**](../.github/workflows/create-dataverse-environment.yml): for the creation of just-in-time (*development and build*) environments
  - [**build-managed-solution**](../.github/workflows/build-managed-solution.yml): for the build of a managed solution using a just-in-time build environment (*pack and import as unmanaged and export as managed*)
  - [**import-solution**](../.github/workflows/import-solution.yml) for the import of a solution, the activation of cloud flows and the sharing of canvas apps
- [**New-DataverseEnvironment**](./Scripts/New-DataverseEnvironment.ps1) PowerShell script for the creation of Dataverse environments with configuration of an Azure AD Security Group to secure the access to the environment and a description
- Composite action [**run-import-solutions**](./.github/actions/run-import-solutions/action.yml) to execute the [import-solution-to-dev](./.github/workflows/import-solution-to-dev.yml) workflow on a list of solutions using the [GitHub CLI](https://cli.github.com/manual/gh_run)
- Manually triggered workflow [**import-solution-to-dev**](./.github/workflows/import-solution-to-dev.yml) for the import of an unmanaged solution to a development environment (*pack solution as unmanaged then import it*)
- Composite action [**set-canvasapps-instrumentation-key**](./.github/actions/set-canvasapps-instrumentation-key/action.yml) to be able to set an Azure Application Insights instrumentation key using a value stored in the considered [custom deployment settings](./Documentation/Custom-Deployment-Settings-File-Management.md) file in canvas apps by updating the `AppInsightsKey.json` file in the canvas apps source code before the solution pack step
- [**Dependabot**](./.github/dependabot.yml) configuration to automate GitHub actions version update (*monitoring and pull requests creation*)
- [**Add-Solution**](./Documentation/Add-Solution.md) documentation page about adding a new solution to the repository
- [**ALM-Strategy**](./Documentation/ALM-Strategy.md) documentation page about the ALM strategy proposed in this repository

### 🤖 Changed

- Integration of the reusable workflows added to the repository in the existing workflows
- To be able to manage multiple solutions,
  - Steps added to get the solutions in the repository and call the [run-import-solutions](./.github/actions/run-import-solutions/action.yml) composite action in the [**workspace-initialization**](./.github/workflows/workspace-initialization.yml) workflow
  - Step added in the [**solution-quality-check-on-pr**](./.github/workflows/solution-quality-check-on-pr.yml) and [**import-solution-to-validation**](./.github/workflows/import-solution-to-validation.yml) workflows to idenfity the changed solution - ⚠ *For now, only one solution can be updated in each development cycle*
  - Input added in the [**create-deploy-release**](./.github/workflows/create-deploy-release.yml) workflow to trigger a release for a unique identified solution
- Configuration of a description for the just-in-time Dataverse Development environment in `pre-job` of the [**workspace-initialization**](./.github/workflows/workspace-initialization.yml) workflow
- Get the updated solution and configuration of a description for the just-in-time Dataverse Build environment in `pre-job` of the following workflows: [**import-solution-to-validation**](./.github/workflows/import-solution-to-validation.yml) and [**solution-quality-check-on-pr**](./.github/workflows/solution-quality-check-on-pr.yml)
- Get global configurations and configuration of a description for the just-in-time Dataverse Build environment in `pre-job` of the [**create-deploy-release**](./.github/workflows/create-deploy-release.yml) workflow
- Update of global configurations in [**Configurations/configurations.json**](./Configurations/configurations.json) and [**get-configurations**](./.github/actions/get-configurations/action.yml):
  - `environment.languageCode` (*configuration updated - previously 'environment.languageDisplayName'*)
  - `environment.developmentEnvironment.descriptionBase` (*added*)
  - `environment.buildEnvironment.azureAdGroupName` (*added*)
  - `environment.buildEnvironment.descriptionBase` (*added*)
  - `pacCliVersion` (*default value updated*)
  - `powerAppsMakerPortalBaseUrl` (*default value updated*)
  - `maximumTriesForCloudFlowsActivation` (*added*)
- Reorganization of the [**solution-quality-check-on-pr**](./.github/workflows/solution-quality-check-on-pr.yml) to be able to take advantage of some of the new reusable workflows ([**create-dataverse-environment**](../.github/workflows/create-dataverse-environment.yml) and [**build-managed-solution**](../.github/workflows/build-managed-solution.yml))
- Configuration of [concurrency](https://docs.github.com/en/actions/using-jobs/using-concurrency) in all the workflows to take advantage of the out-of-the-box GitHub capability
- Update the years range considered in the Copyright in the header of the different code files in the repository
- [**Custom-Deployment-Settings-File-Management**](./Documentation/Custom-Deployment-Settings-File-Management.md) documentation page updated regarding a change of format to be able to manage Azure Application Insights instrumentation key update in canvas apps during solution pack phase
- [**Grant-GroupsAccessToCanvasApps**](./Scripts/Grant-GroupsAccessToCanvasApps.ps1) updated regarding the path to consider to find the required information in the [custom deployment settings](./Documentation/Custom-Deployment-Settings-File-Management.md) file for the sharing of canvas apps
- [**Repository-Content**](./Documentation/Repository-Content.md) documentation page updated regarding all the changes in this version
- [**Repository-Setup**](./Documentation/Repository-Setup.md) documentation page updated:
  - 2 environment secrets in place of action secrets
  - Updates in the [**Configurations/configurations.json**](./Configurations/configurations.json) global configuration file

## [0.3.0] - 2022-03-25

> "Industrialize" our development flow for this repository template 🤖

### 🔨 Fixed

- Manage **pac/** folder in **.gitignore** file to ignore it during commits and remove the line that was handling this task from the **export-and-unpack-solution** workflow
- Run **microsoft/powerplatform-actions/import-solution** action asynchronously with a maximum wait time of 10 minutes in all workflows where this action is used
- Correction of PowerShell scripts to remediate code scanning alerts
- **workspace-initialization-when-issue-assigned** workflow renamed **workspace-initialization** (*simplification*)
- Add filter on paths to the trigger of the **solution-quality-check-on-pr** workflow

### 🚀 Added

- Composite action **get-configurations** localized to the repository to extract configurations used in workflows from a JSON file
- Global configuration file (JSON) that contains information used in the workflows like the details of the Dataverse environments we create - *multiple configurations where moved to this file during the work on the 0.3.0 version ([details](./Documentation/Repository-Setup.md#5---update-global-configurations))*
- PowerShell script **Add-AADSecurityGroupTeamToDataverseEnvironment.ps1** for the creation of a security group team associated to an Azure AD security group in a Dataverse environment and the assignation of a security role
- URL to the **Solutions** page of the Power Apps maker portal in the context of the new Dataverse Dev environment in the **workspace-initialization** workflow
- **Documentation** folder with one markdown file per topic and with each file referenced in the **README.md** file
   - **Repository-Setup.md**: a guide for the initialization of a repsitory from this repository template
   - **Custom-Deployment-Settings-File-Management.md**: a guide to manage custom deployment settings file for canvas apps sharing the Azure AD security groups
   - **Repository-Content.md**: a list of the elements in this repository

### 🤖 Changed

- Generation of a deployment settings file from the exported solution added to the **export-and-unpack-solution** workflow
- Include the deployment settings file associated to the considered environment in the **microsoft/powerplatform-actions/import-solution** action in the following workflows: **create-deploy-release** and **import-solution-to-validation**
- Calls to **Update-ConnectionReferences.ps1** PowerShell script removed from the following workflows: **create-deploy-release** and **import-solution-to-validation**
- All workflows to used the composite action **get-configurations** localized to the repository to get the configurations they need
- **Configuration** folder renamed **Configurations**
- References to GitHub secrets replaced by configurations in the configuration file (JSON) removed from the **README.md** file
- Creation of a user in the Dataverse environment replaced by the creation of a security group team in the **workspace-initialization** workflow
- Update paths considered in the trigger of the **import-solution-to-validation** and **solution-quality-check-on-pr** workflows
- Use the **environment-url** output of the **microsoft/powerplatform-actions/create-environment** action in the following workflows: **create-deploy-release**, **import-solution-to-validation** and **solution-quality-check-on-pr**
- Reorganization of the **README.md** file:
   - **🚀 Features** section removed
   - **📢 What is the PowerPlatform-ALM-With-GitHub-Template project?** and **🚀 Goals** sections added
   - **✈️ How to use this repository template?** section removed (*replaced by a dedicated documentation page*)
   - **📖 Documentation** section added
   - Small updates in the existing sections
- Small updates in the **CODE_OF_CONDUCT.md** file
- Disabled blank issue in the configuration file for the issue in this repository
- In the **create-deploy-release** workflow:
   - Example of the expected format for the **solution_base_version** input added to the description
   - Update of the release version format to be compliant with the semantic versioning

### ❌ Deleted

- **Update-ConnectionReferences.ps1** PowerShell script deleted because replaced by deployment settings files management in the workflows
- **ConnectionsMapping-%.json** files removed because replaced by deployment settings files management in the workflows
- **Configuration/PowerPlatformALMWithGitHub** folder deleted - *it was forgotten during the cleaning of the elements related the demo solution in version 0.2.0*

## [0.2.0] - 2021-10-19

> Improve the GitHub workflows proposed in this repository template 🤩

### 🚀 Added

- This Changelog 😋
- Issue form for bugs
- Template chooser for issues
- Configuration files examples:
   - **CanvasAppsGroupsAccessMapping.json**: for granting access to canvas apps to Azure AD groups
   - **ConnectionsMapping-....json**: for the mapping between a connection reference in the solution and the id of a connection in the targeted environment (*one by environment where you want to apply this configuration*)
- PowerShell scripts:
   - **Add-UserToDataverseEnvironment.ps1**: to add and configure a user in a Dataverse environment
   - **Enable-CloudFlows.ps1**: to turn on cloud flows in the solution
   - **Grant-GroupsAccessToCanvasApps.ps1**: to grant access to canvas apps to Azure AD groups
   - **Update-ConnectionReferences.ps1**: to update connection references adding a connection to it
- GitHub workflow for PowerShell code analysis

### 🤖 Changed

- Update the README.md and added some gifs to explain how to configure the GitHub repository template
- Update of the CODE_OF_CONDUCT.md based on the latest version of the [Contributor Covenant](https://www.contributor-covenant.org)
- Update of the CONBTRIBUTING.md guide
- Pull request template moved in ".github" folder
- Copyright and MIT license added at the top of each GitHub workflow and each PowerShell script
- References to "Power Apps" in variables / comments replaces by "Dataverse" - *I personnaly find this notion more appropriate*
- GitHub hosted runner type update to **ubuntu-latest** for every job where it was an option
- Make some variables reusable in workflows by setting them only once (*ex: `echo "NOW=$(date +'%Y%m%d')" >> $Env:GITHUB_ENV`*)
- Update of the version of the actions from [microsoft/powerplatform-actions](https://github.com/microsoft/powerplatform-actions) repository `v0.1.8 --> main`
- Connection using a service principal in actions from [microsoft/powerplatform-actions](https://github.com/microsoft/powerplatform-actions) repository
- Power Platform environment configuration details (*location, sku, currency name and language code*) moved from variables to GitHub secret to centralize the information
- Creation of Power Platform environments using the [create-environment](https://github.com/microsoft/powerplatform-actions/blob/main/create-environment/action.yml) action
- Deletion of Power Platform environments using the [delete-environment](https://github.com/microsoft/powerplatform-actions/blob/main/delete-environment/action.yml) action
- **export-and-unpack-solution.yml**
   - Publish of the solution before the export
   - Set solution version (*Other\Solution.xml*) to a default value (*1.0.0*)
   - Unpack of canvas apps using [Microsoft.PowerApps.CLI](https://docs.microsoft.com/en-us/powerapps/developer/data-platform/powerapps-cli#canvas)
   - Format JSON files (*cloud flows*) so they are easier to read in source control
   - Delete exported solution in packed format
   - Commit and push to development branch not using the [branch-solution](https://github.com/microsoft/powerplatform-actions/blob/main/branch-solution/action.yml) action for a better flexibility
- **build-managed-solution** job in the following workflows: workspace-initialization-when-issue-assigned.yml, solution-quality-check-on-pr.yml, import-solution-to-validation.yml and create-deploy-release.yml
   - Flatten JSON files (*cloud flows*) before solution packing
   - Pack canvas apps using [Microsoft.PowerApps.CLI](https://docs.microsoft.com/en-us/powerapps/developer/data-platform/powerapps-cli#canvas) before solution packing
   - Set solution version (*Other\Solution.xml*)
- **import-solution-to-...** job in the following workflows: import-solution-to-validation.yml and create-deploy-release.yml
   - Configure connection references with existing connections based on a mapping in a configuration file
   - Enable cloud flows in the imported solution
   - Grant access to canvas apps to Azure AD groups based on a mapping in a configuration file
- **solution-quality-check-on-pr.yml**
   - Flatten JSON files (*cloud flows*) and pack canvas apps using [Microsoft.PowerApps.CLI](https://docs.microsoft.com/en-us/powerapps/developer/data-platform/powerapps-cli#canvas) before solution packing
   - Connection to the [Microsoft.PowerApps.Checker.PowerShell](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.checker.powershell) PowerShell module using a service principal
- **workspace-initialization-when-issue-assigned.yml**
   - New trigger for specific label addedd to an issue (*by default the considered label is 'in progress'*)
   - New "pre-job" to avoid duplicate run of the GitHub workflow (*in the case where you assign an issue and add the considered label at the same time*)
   - New comments to the issue when the branch is created, when the Dataverse Dev environment is created and when the solution is imported
   - Add a label to the issue when the Dataverse Dev environment is created (*by default the labe is 'dev env created'*)
   - New job to add a user (*user email configured as a GitHub secret*) as System Administrator to the Dataverse Dev environment using a PowerShell script
   - New step in the **import-solution-to-dev-environment** job to check if a solution exists in the repositoy
   - Flatten JSON files (*cloud flows*) and pack canvas apps using [Microsoft.PowerApps.CLI](https://docs.microsoft.com/en-us/powerapps/developer/data-platform/powerapps-cli#canvas) before solution packing
   - Set solution version (*Other\Solution.xml*)
- **clean-dev-workspace-when-issue-closed-or-deleted.yml** (*renamed - 'delete-powerapps-dev-environment-when-issue-closed.yml'*)
   - Delete branch for development if it exists
   - Add a condition for the **delete-dataverse-dev-environment** job: issue not deleted and with the 'dev env created' label
   - Remove 'dev env created' label on the issue if closed
   - Add a comment to the issue when the Dataverse Dev environment is deleted
- **create-deploy-release.yml** (*renamed - 'create-github-release.yml'*)
   - Create a release branch, then a GitHub release (*through a just-in-time Dataverse Build environment*) and finally deploy the managed solution to a production environment
   - The GitHub release is created as a draft and publish only after a successfull deployment to a production environment
   - If an error occurs during the pack of the solution as managed (*through a just-in-time Dataverse Build environment*), the release branch will be deleted
- **import-solution-to-validation.yml** (*renamed - 'import-solution-to-qa.yml'*)

### ❌ Deleted

- Issue template for bugs (*replaced by issue form*)
- Solution used for the tests to make the repository a bit cleaner

## [0.1.0] - 2020-12-22

> Initialize this repository template to make Power Platform ALM with GitHub a little bit easier 😊

### 🚀 Added

- Core files of the repository: README.md, LICENSE, CONTRIBUTING.md and CODE_OF_CONDUCT.md
- [AllContributors](https://allcontributors.org/) GitHub app
- Issue and pull request templates
- Sample of Power Platform solution used for the tests
- GitHub workflow for the initialization of a workspace for Power Platform development (*branch, environment and solution import*)
- GitHub workflow for the export and unpack of a Power Platform solution in the context of Power Platform development
- GitHub workflow for the execution of the solution checker on a Power Platform solution and the build (*unmanaged to managed*) of the solution with a Just-In-Time (JIT) environment in the context of a pull request
- GitHub workflow for the deletion of the development Power Platform environment when the associated issue is closed or deleted
- GitHub workflow for the deployment of a Power Platform solution to a QA environment after a build with a JIT environment on a push to the main branch
- GitHub workflow for the creation of a GitHub release for a Power Platform managed solution (*build with a JIT environment*)

[⚒ Work in progress]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/releases/tag/v0.1.0
