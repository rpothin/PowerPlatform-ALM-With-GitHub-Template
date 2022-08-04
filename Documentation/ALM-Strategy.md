<p align="center">
    <h1 align="center">
        What are the principles of the ALM strategy proposed in this repository?
    </h1>
</p>

## Overview of the ALM strategy

```mermaid
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail!
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!
```

## Solution versioning

> **Note:** Proposition based on the fact that a concatenation of the date (*yyyymmdd*) and the workflow run id for the patch part of the version we quickly reach some limitations on Power Platform solution versioning.

| Phase                                                                                     | Format             | Notes                                                                                                                                                        |
| ----------------------------------------------------------------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Development workspace initialization](../.github/workflows/workspace-initialization.yml) | 1.yyyymmdd.xxx     | with <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number**                                                                             |
| [Import solution to validation](../.github/workflows/import-solution-to-validation.yml)   | 1.yyyymmdd.xxx     | with <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number**                                                                             |
| [Create and deploy release](../.github/workflows/create-deploy-release.yml)               | major.yyyymmdd.xxx | with <br/> - `major` a major version provided as input when running the workflow <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number** |