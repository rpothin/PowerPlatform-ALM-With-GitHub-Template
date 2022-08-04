<p align="center">
    <h1 align="center">
        What are the principles of the ALM strategy proposed in this repository?
    </h1>
</p>

## Overview of the ALM strategy

```mermaid
sequenceDiagram
    autonumber

    actor Developer
    
    participant GitHub
    participant PowerPlatformDev
    participant PowerPlatformBuild
    participant PowerPlatformValidation
    participant PowerPlatformProduction
    
    Developer->>GitHub: Create issue
    Developer->>GitHub: Assign issue and add 'in progress' label to it
    par GitHub to PowerPlatformDev
        GitHub->>GitHub: Create development branch
    and GitHub to PowerPlatformDev
        GitHub->>PowerPlatformDev: Create development environment
    end
    GitHub->>PowerPlatformDev: Give access to development environment to developers
    loop For each solution
        GitHub->>PowerPlatformDev: Import solution
    end
    Developer->>PowerPlatformDev: Update solution
    Developer->>GitHub: Trigger solution export
    GitHub->>PowerPlatformDev: Export solution to development branch
    Developer->>GitHub: Create pull request
    GitHub->>PowerPlatformBuild: Create just-in-time Build environment
    Note left of GitHub: Solution packed from development branch
    GitHub->>PowerPlatformBuild: Build managed solution (import unmanaged and export managed)
    par GitHub to PowerPlatformBuild
        Note over GitHub, PowerPlatformBuild: Execute solution checker on managed solution
    and GitHub to PowerPlatformBuild
        GitHub->>PowerPlatformBuild: Delete just-in-time Build environment
    end
    Developer->>GitHub: Review and then approve pull request
    Note over Developer, GitHub: Changes pushed to 'main' branch
    GitHub->>PowerPlatformBuild: Create just-in-time Build environment
    Note left of GitHub: Solution packed from 'main' branch
    GitHub->>PowerPlatformBuild: Build managed solution (import unmanaged and export managed)
    GitHub->>PowerPlatformValidation: Import solution, activate cloud flows and share canvas apps
```

## Solution versioning

> **Note:** Proposition based on the fact that a concatenation of the date (*yyyymmdd*) and the workflow run id for the patch part of the version we quickly reach some limitations on Power Platform solution versioning.

| Phase                                                                                     | Format             | Notes                                                                                                                                                        |
| ----------------------------------------------------------------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Development workspace initialization](../.github/workflows/workspace-initialization.yml) | 1.yyyymmdd.xxx     | with <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number**                                                                             |
| [Import solution to validation](../.github/workflows/import-solution-to-validation.yml)   | 1.yyyymmdd.xxx     | with <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number**                                                                             |
| [Create and deploy release](../.github/workflows/create-deploy-release.yml)               | major.yyyymmdd.xxx | with <br/> - `major` a major version provided as input when running the workflow <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number** |