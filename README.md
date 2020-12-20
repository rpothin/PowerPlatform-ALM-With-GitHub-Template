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

- **Workspace initialization** when an issue is assigned in GitHub:
  - create a new branch dedicated to the issue
  - create a new Power Platform dev environment dedicated to the issue
  - import the existing solution in the main branch of the repository to the new dev environment
  - add a comment to the issue with workspace details
- **On-demand solution export and unpack** from a Power Platform dev environment using the issue number
- **Solution checker** execution on solution version in dev branch on the creation of a pull request targeting the main branch
- **Import solution to a Power Platform QA environment** when a new commit is maid on the main branch with changes in the "Solutions/" folder
- **Delete a Power Platform dev environment** when the associated issue is closed or canceled
- **Create a GitHub release** containing a packed managed version of the solution

> *Note: Some of these features used a Just In Time (JIT) Power Platform Build environment to build a managed version of a solution based on an export and unpack of an unmanaged solution.*

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

- A service principal regesterd in Azure Active Directory on your tenant with the following API Permissions (at least) that will be user to execute the **Power Apps Solution Checker**: Dynamics CRM.user_impersonation and Microsoft Graph.User.Read

- A Power Platform QA environment already created on your tenant

### Step by step configuration procedure

To do

## 📅 Roadmap

- Replace the creation and deletion of Power Platform environments using PowerShell by the [Power Platform Actions](https://github.com/microsoft/powerplatform-actions) when they will be available

- Add the **publish-solution** and **update-solution-version** actions when it will be available in the [Power Platform Actions](https://github.com/microsoft/powerplatform-actions)

- Improve the documentation about the usage of this solution

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

I would like to thank the open-source projects below that helped me finding some ideas on how to organize this project.

- [budibase](https://github.com/Budibase/budibase/)
- [all-contributors](https://github.com/all-contributors/all-contributors)