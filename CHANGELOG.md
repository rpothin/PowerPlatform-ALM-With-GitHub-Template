# Changelog

All notable changes to this repository will be documented in this file.

> The format is based on [Keep a Changelog](https://keepachangelog.com/en/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [⚒ Unreleased]

### 🔨 Fixed

- ...

### 🚀 Added

- ...

### 🤖 Changed

- Power Platform environment configuration details moved to a centralized configuration file and information extracted in workflows when needed using a dedicated action (*to configure*)

### ❌ Deleted

- ...

## [0.2.0] - 2021-09-??

> Improve the GitHub workflows proposed in this repository template 🥳

> *Note: This version has been built entirely using [GitHub Codespaces](https://github.com/features/codespaces)* 🤩

### 🚀 Added

- This Changelog 😋
- Issue form for bugs
- Template chooser for issues
- Copyright and MIT license at the top of each GitHub workflow and each PowerShell script

### 🤖 Changed

- Pull request template moved in ".github" folder
- References to "Power Apps" in variables / comments replaces by "Dataverse" - *I personnaly found this notion more appropriate*
- GitHub hosted runner type update to **ubuntu-latest** for every job where it was possible to use it
- Make some variables reusable in workflows to set them only once (*ex: `echo "NOW=$(date +'%Y%m%d')" >> $Env:GITHUB_ENV`*)
- Update of the version of the actions from [microsoft/powerplatform-actions](https://github.com/microsoft/powerplatform-actions) repository `v0.1.8 --> main`
- Connection using a service principal in actions from [microsoft/powerplatform-actions](https://github.com/microsoft/powerplatform-actions) repository
- Creation of Power Platform environments using the [create-environment](https://github.com/microsoft/powerplatform-actions/blob/main/create-environment/action.yml) action
- Power Platform environment configuration details (*location, sku, currency name and language code*) moved from variables to secret to centralize the information
- Deletion of Power Platform environments using the [delete-environme](https://github.com/microsoft/powerplatform-actions/blob/main/delete-environment/action.yml) action
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
   - Connection to use [Microsoft.PowerApps.Checker.PowerShell](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.checker.powershell) PowerShell module using a service principal
- **workspace-initialization-when-issue-assigned.yml**
   - ...

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

[⚒ Unreleased]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/releases/tag/v0.1.0