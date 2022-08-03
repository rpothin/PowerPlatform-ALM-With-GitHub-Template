<p align="center">
    <h1 align="center">
        What can be found in this repository?
    </h1>
</p>

## 🚀 Automation

### Actions

- [**get-configurations**](../.github/actions/get-configurations/action.yml): action to extract configuration from a JSON file respecting the format described [here](./Repository-Setup.md#5---update-global-configurations)
- [**run-import-solutions**](../.github/actions/run-import-solutions/action.yml): action to create runs of the [**import-solution-to-dev**](../.github/workflows/import-solution-to-dev.yml) for a list of solutions passed as an input
- [**set-canvasapps-instrumentation-key**](../.github/actions/set-canvasapps-instrumentation-key/action.yml): action to set an Azure Application Insights Instrumentation Key we get from the considered custom deployment settings file (*format described [here](./Custom-Deployment-Settings-File-Management.md)*) in the source code of the canvas apps of the considered solution before packing for deployment

### Workflows

- [**workspace-initialization.yml**](../.github/workflows/workspace-initialization.yml):
   - Trigger: issue assigned or labeled (*we only consider the `in progress` label - or the one you decided to use*)
   - Summary of actions:
      - get global configurations (*using the **get-configurations** action*) and set job outputs
      - create a branch for the work on the considered issue
      - create a Dataverse Dev environment (*using the **create-dataverse-environment** reusable workflow*)
      - add developers as System Administrators to the new Dataverse Dev environment (*using the **Add-AADSecurityGroupTeamToDataverseEnvironment** PowerShell script*)
      - import solutions to the new Dataverse Dev environment, if there is at least one in the repository (*using the **run-import-solutions** action*)
      - add comments to the issue to give visibility on the progress of the initialization of the workspace
- [**import-solution-to-dev**](../.github/workflows/import-solution-to-dev.yml):
   - Trigger: manual with inputs (*runs created from [**run-import-solutions**](../.github/actions/run-import-solutions/action.yml) action called from the [**workspace-initialization.yml**](../.github/workflows/workspace-initialization.yml) workflow*)
   - Summary of actions:
      - set solution version in the **Solution.xml** file (*version passed in an input*)
      - pack solution as unmanaged
      - import unmanaged solution to the considered Dataverse Dev environment (*environment url passed in an input*)
      - add a comment to the considered issue if the solution import is successful (*issue number passed in an input*)
- [**export-and-unpack-solution**](../.github/workflows/export-and-unpack-solution.yml):
   - Trigger: manual with inputs
   - Summary of actions:
      - get global configurations (*using the **get-configurations** action*) and set job outputs
      - publish customizations on the considered Dataverse Dev environment
      - export and unpack the considered solution (*+ second unpack for a workaround regarding an issue on the unpack of the canvas apps - [#226](https://github.com/rpothin/PowerPlatform-ALM-With-GitHub-Template/issues/226)*)
      - put a default value for the version of the solution in the **Solution.xml** file
      - update the deployment settings file template
      - push the changes to the considered branch (*based on input value*)
- [**solution-quality-check-on-pr**](../.github/workflows/solution-quality-check-on-pr.yml):
   - Trigger: pull request targeting the `main` branch and with changes on specific folders
   - Summary of actions:
      - get global configurations (*using the **get-configurations** action*) and set job outputs (*for example, identify the updated solution*)
      - create a just-in-time Dataverse Build environment (*using the **create-dataverse-environment** reusable workflow*)
      - build a managed version of the solution using the just-in-time Build environment (*using the **build-managed-solution** reusable workflow*)
      - execute the solution checker on the considered solution and generate an error in the workflow run if thresholds are not met
      - delete the just-in-time Dataverse Build environment
- [**import-solution-to-validation**](../.github/workflows/import-solution-to-validation.yml):
   - Trigger: push to the `main` branch with changes on specific folders
   - Summary of actions:
      - get global configurations (*using the **get-configurations** action*) and set job outputs (*for example, identify the updated solution*)
      - create a just-in-time Dataverse Build environment (*using the **create-dataverse-environment** reusable workflow*)
      - build a managed version of the solution using the just-in-time Build environment (*using the **build-managed-solution** reusable workflow*)
      - import the managed version of the considered solution to the Dataverse Validation environment (*using the **import-solution** reusable workflow*)
      - delete the just-in-time Dataverse Build environment
- [**create-deploy-release**](../.github/workflows/create-deploy-release.yml):
   - Trigger: manual with inputs
   - Summary of actions:
      - get global configurations (*using the **get-configurations** action*) and set job outputs
      - create a branch for the considered release
      - create a just-in-time Dataverse Build environment (*using the **create-dataverse-environment** reusable workflow*)
      - build a managed version of the solution using the just-in-time Build environment (*using the **build-managed-solution** reusable workflow*)
      - delete the just-in-time Dataverse Build environment
      - delete the release branch if deployment of the considered solution to the just-in-time Dataverse Build environment fails
      - create a GitHub release as draft with the unmanaged and managed versions of the considered solution and the README file
      - import the managed version of the considered solution to the Dataverse Production environment (*using the **import-solution** reusable workflow*)
      - publish the GitHub release initialized earlier
- [**clean-dev-workspace-when-issue-closed-or-deleted**](../.github/workflows/clean-dev-workspace-when-issue-closed-or-deleted.yml):
   - Trigger: issue closed or deleted
   - Summary of actions:
      - get global configurations (*using the **get-configurations** action*) and set job outputs
      - delete branch created for the development regarding the considered issue if it still exists
      - delete the Dataverse Dev environment created for the considered issue
      - add a comment to the issue to give a status on the workspace created for the development is the issue was closed

#### Reusable workflows

- [**create-dataverse-environment**](../.github/workflows/create-dataverse-environment.yml):
   - Triggers: called by another workflow
   - Summary of actions:
      - set some variables for dynamic display and domain name (*based on a condition on the value of an input*)
      - create the Dataverse environment (*2 methods considered - out-of-the-box [create-environment](https://github.com/microsoft/powerplatform-actions/blob/main/create-environment/action.yml) GitHub action or the [New-DataverseEnvironment.ps1](../Scripts/New-DataverseEnvironment.ps1) PowerShell script - and the choice is made based on the value of an input*)
      - set job outputs
      - update considered issue - add `dev env created` label and add a comment - if we are in this scenario (*based on a condition on the value of an input*)
- [**build-managed-solution**](../.github/workflows/build-managed-solution.yml):
   - Triggers: called by another workflow
   - Summary of actions:
      - set some variables like the path to packed solution (*zip*) and the solution version
      - update the olution version in **Solution.xml** file
      - push changes to the considered branch if we are in a release scenario (*based on a condition on the value of an input*)
      - set the instrumentation key in the unpack canvas apps in the considered solution (*using the **set-canvasapps-instrumentation-key** action*)
      - pack the solution from the considered branch in the repository
      - store the unmanaged solution in the GitHub artifact store if we are in a release scenario (*based on a condition on the value of an input*)
      - import solution as unmanaged to just-in-time Build environment and export it as managed
      - store the managed version of the considered solution in GitHub artifact store
- [**import-solution**](../.github/workflows/import-solution.yml):
   - Triggers: called by another workflow
   - Summary of actions:
      - get packed solution to import from GitHub artifact store
      - import solution to considered environment
      - execute post solution import steps (*turn on cloud flows and share canvas apps*)

### PowerShell scripts

- [**Add-AADSecurityGroupTeamToDataverseEnvironment**](../Scripts/Add-AADSecurityGroupTeamToDataverseEnvironment.ps1): Add an Azure AD Security Group Team to a Dataverse environment
- [**Add-UserToDataverseEnvironment**](../Scripts/Add-UserToDataverseEnvironment.ps1): Add a user to a Dataverse environment (*not used anymore - replaced by **Add-AADSecurityGroupTeamToDataverseEnvironment***)
- [**Enable-CloudFlows**](../Scripts/Enable-CloudFlows.ps1): Turn on the Cloud Flows in a specific solution in a targeted Dataverse environment
- [**Grant-GroupsAccessToCanvasApps**](../Scripts/Grant-GroupsAccessToCanvasApps.ps1): Grant access to canvas apps to Azure AD groups based on a mapping in a configuration file
- [**New-DataverseEnvironment**](../Scripts/New-DataverseEnvironment.ps1): Creation of a Dataverse environment using the [New-AdminPowerAppEnvironment](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/new-adminpowerappenvironment?view=pa-ps-latest) PowerShell command to be able to set an Azure AD Security group to secure the access to an environment but also a description

### Other workflows / automations

- [**PSScriptAnalyzer**](../.github/workflows/powershell-analysis.yml):
   - Triggers:
      - push to the `main` branch with changes on specific folders
      - pull request tarteging the `main` branch and with changes on specific folders
   - Summary of actions:
      - run PSScriptAnalyzer on the PowerShell code in the repository
      - upload the generated sarif file for analysis
- [**dependabot**](../.github/dependabot.yml): Dependabot configuration for security or version updates on GitHub Actions (*run daily on all the repository*)

## 🧾 Configurations

- [**Configurations/configurations.json**](../Configurations/configurations.json): global configurations file used to simplify the management of information required in the GitHub workflows ([details](./Repository-Setup.md#5---update-global-configurations))

## 🖼 Issue / Pull request templates

- [**BUG.yml**](../.github/ISSUE_TEMPLATE/BUG.yml): issue template to allow people to report bugs
- [**config.yml**](../.github/ISSUE_TEMPLATE/config.yml): issues configuration to also present redirections to discussions for ideas and q&a when creating an issue in addition to the bug option
- [**pull_request_template.md**](../.github/pull_request_template.md): pull request template to have a minimum of consistency in the pull requests created in this repository

<h3 align="center">
  <a href="../README.md#-documentation">🏡 README - Documentation</a>
</h3>