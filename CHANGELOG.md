# Changelog

All notable changes to this repository will be documented in this file.

> The format is based on [Keep a Changelog](https://keepachangelog.com/en/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [⚒ Unreleased]

### 🔨 Fixed

- ...

### 🚀 Added

- ...

### 🤖 Changed

- ...

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
- Publish of the considered solution before the export in the `export-and-unpack-solution.yml` workflow
- Connection using a service principal in actions from [microsoft/powerplatform-actions](https://github.com/microsoft/powerplatform-actions) repository




- Management of the version of the solution (*export --> `1.0.0` / import to dev or validation --> `1.0.<YYYYMMDD>.<GitHub workflow run id>` / release --> `<base version as workflow input (ex: 1.2)>.<YYYYMMDD>.<GitHub workflow run id>`*)
- GitHub workflow for the initialization of a workspace for Power Platform development triggers only if issue is assigned and has a specific label (*by default "in progress"*)
- Canvas app (*%.msapp files*) unpack on solution export and pack for import using a static built version of the [microsoft/PowerApps-Language-Tooling](https://github.com/microsoft/PowerApps-Language-Tooling) tool stored in the repository
- JSON files formatting on solution export to make them more readable (*ex: cloud flows*) and change back the format for import
- More comments added to the issue in the GitHub workflow for the initialization of a workspace for Power Platform development
- Check in the GitHub workflow for the initialization of a workspace for Power Platform development to manage the situation you do not yet have a solution in the repository

### 🤖 Changed

- Pull request template moved in ".github" folder
- References to "Power Apps" in variables / comments replaces by "Dataverse" - *I personnaly found this notion more appropriate*





- README.md: updates to reflect all the updates in this version
- Creation of Power Platform environments with the **create-environment** action available
- Numbers as prefix for the name of the GitHub workflows to make it easier to follow the flow of work
- **powerapps** replaced by **dataverse** everywhere because it seems more inclusive when we talk about solutions
- Run set to **ubuntu-latest** for every job where it was possible to use it
- Label about the creation of the dev environment (*by default "dev env created"*) in the GitHub workflow for the initialization of a workspace for Power Platform development added to the issue as soon as it is created
- GitHub workflow for the deployment of a Power Platform solution to a Validation environment after a build with a JIT environment on a push to the main branch - YAML file renamed(*import-solution-to-qa.yml --> import-solution-to-validation.yml*)
- GitHub workflow to delete development environment after work replaced by a new one for the cleaning of the development workspace (*branch and Power Platform environment*) when the associated issue is closed or deleted - `YAML file renamed: delete-powerapps-dev-environment-when-issue-closed.yml --> clean-dev-workspace-when-issue-closed-or-deleted.yml`
- GitHub workflow for the creation of a GitHub release replaced by another one that will also deploy the solution in the Github release to a production environment - `YAML file renamed: create-github-release.yml --> create-deploy-release.yml`

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