<p align="center">
    <h1 align="center">
        What can be found in this repository?
    </h1>
</p>

## 🚀 Automation

### Actions

- [**get-configurations**](../.github/actions/get-configurations/action.yml): action to extract configuration from a JSON file respecting the format described [here](./Repository-Setup.md#5---update-global-configurations) 

### Workflows

- [**workspace-initialization.yml](../.github/workflows/workspace-initialization.yml):
   - Trigger: issue assigned or label added (*we only consider the `in progress` label - or the one you decided to use*)
   - Summary of actions:
      - create a branch
      - create a Dataverse Dev environment
      - add a team to the new Dataverse Dev environment to automatically give access to the development team
      - import the solution to the new Dataverse Dev environment if there is one in the repository
      - add comments to the issue to give visibility on the progress of the initialization of the workspace

### PowerShell scripts

## 🧾 Configurations

- [**Configurations/configurations.json**](../Configurations/configurations.json): global configurations file used to simplify the management of information required in the GitHub workflows ([details](./Repository-Setup.md#5---update-global-configurations))

## 🖼 Issue / Pull request templates

- [**BUG.yml**](../.github/ISSUE_TEMPLATE/BUG.yml): issue template to allow people to report bugs
- [**config.yml**](../.github/ISSUE_TEMPLATE/config.yml): issues configuration to also present redirections to discussions for ideas and q&a when creating an issue in addition to the bug option
- [**pull_request_template.md**](../.github/pull_request_template.md): pull request template to have a minimum of consistency in the pull requests created in this repository

<h3 align="center">
  <a href="../README.md#-documentation">🏡 README - Documentation</a>
</h3>