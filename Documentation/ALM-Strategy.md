<p align="center">
    <h1 align="center">
        What are the principles of the ALM strategy proposed in this repository?
    </h1>
</p>

## Solution versioning

| Phase                                                                                     | Format             | Notes                                                                                                                                                        |
| ----------------------------------------------------------------------------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [Development workspace initialization](../.github/workflows/workspace-initialization.yml) | 1.yyyymmdd.xxx     | with <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number**                                                                             |
| [Import solution to validation](../.github/workflows/import-solution-to-validation.yml)   | 1.yyyymmdd.xxx     | with <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number**                                                                             |
| [Create and deploy release](../.github/workflows/create-deploy-release.yml)               | major.yyyymmdd.xxx | with <br/> - `major` a major version provided as input when running the workflow <br/> - `yyyymmdd` the current date <br/> - `xxx` the **github.run_number** |