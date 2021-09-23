# Changelog

All notable changes to this repository will be documented in this file.

> The format is based on [Keep a Changelog](https://keepachangelog.com/en/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [⚒ To do / Unreleased]

### 🔨 Fixed

- ...

### 🚀 Added

- ...

### 🤖 Changed

- Power Platform environment configuration details moved to a centralized configuration file and information extracted in workflows when needed using a dedicated action (*to configure*)
- Add multiple users (*the members of the development team for example*) configured in a file as System Administrators to the Dataverse Dev environment created in the **workspace-initialization-when-issue-assigned** GitHub workflow (*to configure*)
- Update connection references through out of the box [import-solution](https://github.com/microsoft/powerplatform-actions/blob/main/import-solution/action.yml) action (*to configure*)

### ❌ Deleted

- Update-ConnectionReferences.ps1 (*replaced by the out of the box [import-solution](https://github.com/microsoft/powerplatform-actions/blob/main/import-solution/action.yml) action - to configure*)

## [0.2.0] - 2021-09-??

> Improve the GitHub workflows proposed in this repository template 🥳

> *Note: This version has been built entirely using [GitHub Codespaces](https://github.com/features/codespaces)* 🤩

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

### 🤖 Changed

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

- Issue template for bugs (replaced by issue form)
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

[⚒ To do / Unreleased]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/releases/tag/v0.1.0