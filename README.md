<p align="center">
    <h1 align="center">
        Power Platform ALM With GitHub - Template
    </h1>
    <h3 align="center">
        Easily start a new GitHub repository to build Power Platform solutions
    </h3>
    <p align="center">
        This project is an open-source template whose main purpose is to help you start your ALM journey for Power Platform solutions using GitHub.
    </p>
</p>

<p align="center">
    <a href="#repolicense" alt="Repository License">
        <img src="https://img.shields.io/github/license/rpothin/PowerPlatform-ALM-With-GitHub-Template?color=yellow&label=License" /></a>
    <a href="#openissues" alt="Open Issues">
        <img src="https://img.shields.io/github/issues-raw/rpothin/PowerPlatform-ALM-With-GitHub-Template?label=Open%20Issues" /></a>
    <a href="#openpr" alt="Open Pull Requests">
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
  <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/issues">Report a bug</a>
  <span> · </span>
  Support: <a href="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/discussions">Discussions</a>
</h3>

## 🚀 Features

- **Workspace initialization** when a specific label is added to an issue in GitHub:
  - create a new branch dedicated to the issue
  - create a new Power Platform dev environment dedicated to the issue
  - import the existing solution in the main branch of the repository to the new dev environment
  - add a comment to the issue with workspace details
  - add a specific label to the issue to indicate a Power Platform dev environment has been created for this issue
- **On-demand solution export and unpack** from a Power Platform dev environment using the issue number and the name of the considered solution
- **Solution checker** execution on solution version in a dev branch on the creation of a pull request targeting the main branch
- **Import solution to a Power Platform QA environment** when a new commit is made on the main branch with changes in the **Solutions/** folder
- **Delete a Power Platform dev environment** when the associated issue is closed or canceled
- **Create a GitHub release** containing a packed managed version of the solution

> *Note: Some of these features used a Just In Time (JIT) Power Platform Build environment to build a managed version of a solution based on an exported and unpacked unmanaged solution.*

<p align="center">
    <h3 align="center">
        🤖 GitHub Actions last run status
    </h3>
</p>
<p align="center">
    <a href="#workspace-initialization-when-issue-assigned" alt="Workspace initialization">
        <img src="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/workflows/workspace-initialization-when-issue-assigned/badge.svg" /></a>
    <a href="#export-and-unpack-solution" alt="Export & Unpack solution">
        <img src="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/workflows/export-and-unpack-solution/badge.svg" /></a>
    <a href="#solution-quality-check-on-pr" alt="Quality checks">
        <img src="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/workflows/solution-quality-check-on-pr/badge.svg" /></a>
    <a href="#import-solution-to-qa" alt="Import to QA">
        <img src="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/workflows/import-solution-to-qa/badge.svg" /></a>
    <a href="#delete-powerapps-dev-environment-when-issue-closed" alt="Delete dev environment">
        <img src="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/workflows/delete-powerapps-dev-environment-when-issue-closed/badge.svg" /></a>
    <a href="#create-github-release" alt="Create release">
        <img src="https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/workflows/create-github-release/badge.svg" /></a>
</p>

## ✈️ How to use this repository template?

### Prerequisites

- A user account capable of creating Power Platform environments on on your tenant

> *Note: If you want to try this solution on a trial tenant, you will need at least 3 different users (1 per Power Platform environment used in this solution)*

- A service principal regesterd in Azure Active Directory on your tenant with the following API Permissions (at least) that will be used to execute the **Power Apps Solution Checker**: Dynamics CRM.user_impersonation and Microsoft Graph.User.Read

- A Power Platform QA environment already created on your tenant

### Step by step configuration procedure

1. Click on the **Use this template** button on the top of the main page of [this repository](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template)
2. In the page that will open, enter the information for the creation of the new repository based on this template

> *Note: Let the **Include all branches** option unchecked.*

3. Click on the **Create repository from template** button
4. In the new repository, go to the **Settings** tab
5. Open the **Environments** section
6. Create the following environments:
   - dev_environment
   - build_environment
   - qa_environment

> *Note: We suggest to add a protection rule (at least one reviewer for solution deployments) on the **qa_environment**.*

7. Open the **Secrets** section
8. Add the following repository secrets to the new repository:
   - APPLICATION_ID: Application (client) ID of the service principal with Dynamics CRM.user_impersonation and Microsoft Graph.User.Read API permissions
   - CLIENT_SECRET: Client secret of the service principal with Dynamics CRM.user_impersonation and Microsoft Graph.User.Read API permissions
   - TENANT_ID: Directory (tenant) ID of the service principal with Dynamics CRM.user_impersonation and Microsoft Graph.User.Read API permissions
   - DEV_USER_LOGIN: User login for the management of the Dev environments that will be created
   - DEV_USER_PASSWORD: User password for the management of the Dev environments that will be created
   - BUILD_USER_LOGIN: User login for the management of the Build environments that will be created
   - BUILD_USER_PASSWORD: User password for the management of the Build environments that will be created
   - POWERAPPS_QA_ENVIRONMENT_URL: URL of the existing QA environment
   - QA_USER_LOGIN: User login for the management of the existing QA environment
   - QA_USER_PASSWORD: User password for the management of the existing QA environment
9. In the new repository, go to the **Issues** tab
10.  Click on **Labels**
11.  Create the following labels using the **New label** button:
    - **work in progress**: Trigger the workspace initialization (branch and environment)
    - **dev env created**: Power Platform Dev environment created for this issue

> *Note: you can change the name of the labels, but you will need to make some replacements in the GitHub actions.*

12.  In the new repository, go to the **Code** tab
13.  Open the **.github/workflows** folder
14.  Open and update each YAML file in this folder:
    - environment variables
    - job conditions (if you decided to go for different label names)
    - default value for the **solution_name** input variable in the **export-and-unpack-solution** GitHub Actions

> *Notes:*
> - *you can delete the **Solutions** folder if you want. It contains a simple solution to test the GitHub Actions.*
> - *if you do not have a solution in your repository (in the **Solutions** folder) and you create a new issue, the **import-solution-to-dev-environment** job in the **workspace-initialization-when-issue-assigned** GitHub Actions will fail, but you will still be able to start building your solution.*

You should now be ready to start using this solution 🎉

## 📅 Roadmap

- Replace the creation and deletion of Power Platform environments using PowerShell by the [Power Platform Actions](https://github.com/microsoft/powerplatform-actions) project when they will be available

- Add the **publish-solution** and **update-solution-version** actions when they will be available in the [Power Platform Actions](https://github.com/microsoft/powerplatform-actions) repository

- Improve the way we manage the configuration of the Power Platform environments we create

- Improve the documentation about the usage of this solution (branching strategy...)

- Take in account more complex scenarios:
  - multiple solutions
  - solution upgrade
  - ...

## ❗ Code of Conduct

I, Raphael Pothin, as creator of this project, am dedicated to providing a welcoming, diverse, and harrassment-free experience for everyone. I expect everyone visiting or participating to this project to abide by the following [**Code of Conduct**](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/CODE_OF_CONDUCT.md). Please read it.

## 👐 Contributing to this project

From opening a bug report to creating a pull request: every contribution is appreciated and welcomed.
For more information, see [CONTRIBUTING.md](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/CONTRIBUTING.md)

### Not Sure Where to Start?

If you want to participate to this project, but you are not sure how you can do it, do not hesitate to contact [@rpothin](https://github.com/rpothin):
- By email at raphael.pothin@gmail.com
- On [Twitter](https://twitter.com/RaphaelPothin)  

### How the repository is organized

At a high level, here are the main parts of this repository:

- [.github/workflows](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/tree/main/.github/workflows) - contains all the GitHub Actions workflows available in this repository and that can be use to manage the ALM process of Power Platform solutions directly from GitHub.
- [Solutions/PowerPlatformALMWithGitHub](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/tree/main/Solutions/PowerPlatformALMWithGitHub) - contains a simple Power Platform solution used for the tests of the GitHub Actions.

## Contributors

Thanks to the following people who have contributed to this project ([emoji key](https://allcontributors.org/docs/en/emoji-key)):
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

This project follows the [all-contributors](https://allcontributors.org/docs/en/specification) specification. Everyone who would like to contribute to it is welcome!

## 📝 License

This project is licensed under the [MIT](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/blob/main/LICENSE) license.

## 💡 Inspiration

I would like to thank the open-source projects below that helped me find some ideas on how to organize this project.

- [budibase](https://github.com/Budibase/budibase/)
- [all-contributors](https://github.com/all-contributors/all-contributors)