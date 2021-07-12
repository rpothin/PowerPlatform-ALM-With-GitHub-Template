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

## [2.0] - 2021-07-??

> Improve the GitHub workflows by mainly replacing PowerShell scripts by existing [Power Platform actions](https://github.com/microsoft/powerplatform-actions) 🤩

### 🚀 Added

- This Changelog 😋
- Issue form for bugs
- Template chooser for issues
- Copyright and MIT license at the top of each YAML file built in the repository
- Management of the version of the solution (*export --> `1.0.0` / import to dev or validation --> `1.0.<YYYYMMDD>.<GitHub workflow run id>` / release --> `<base version (ex: 1.2)>.<YYYYMMDD>.<GitHub workflow run id>`*)
- Canvas app (*%.msapp files*) unpack on solution export and pack for import using a static built version of the [microsoft/PowerApps-Language-Tooling](https://github.com/microsoft/PowerApps-Language-Tooling) solution stored in the repository
- JSON files formatting on solution export to make them more readable (*ex: cloud flows*) and change back the format for import
- More comments added to the issue in the GitHub workflow for the initialization of a workspace for Power Platform development
- Check in the GitHub workflow for the initialization of a workspace for Power Platform development to manage the situation you do not yet have a solution in the repository

### 🤖 Changed

- README.md: updates to reflect all the updates in this version
- Creation of Power Platform environments with the **create-environment** action available
- Numbers as prefix for the name of the GitHub workflows to make it easier to follow the flow of work
- **powerapps** replaced by **dataverse** everywhere because it seems more inclusive when we talk about solutions
- Run set to **ubuntu-latest** for every job where it was possible to use it
- Label about the creation of the dev environment in the GitHub workflow for the initialization of a workspace for Power Platform development added to the issue as soon as it is created
- GitHub workflow for the deployment of a Power Platform solution to a Validation environment after a build with a JIT environment on a push to the main branch - YAML file renamed(*import-solution-to-qa.yml --> import-solution-to-validation.yml*)
- GitHub workflow for the cleaning of the development workspace (branch and Power Platform environment) when the associated issue is closed or deleted - YAML file renamed(*delete-powerapps-dev-environment-when-issue-closed.yml --> clean-dev-workspace-when-issue-closed-or-deleted.yml*)
- GitHub workflow for the creation of a GitHub release for a Power Platform solution and the deployment to the production environment - YAML file renamed(*create-github-release.yml --> create-deploy-release.yml*)

### ❌ Deleted

- Issue template for bugs (replaced by issue form)
- Sample of Power Platform solution to make the repository cleaner

## [1.0] - 2020-12-22

> Initialize a repository template to make Power Platform ALM with GitHub a little bit easier 😊

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
- GitHub workflow for the creation of a GitHub release for a Power Platform solution (*build with a JIT environment*)

[⚒ Unreleased]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v2.0...HEAD
[2.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/compare/v1.0...HEAD
[1.0]: https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/releases/tag/v1.0