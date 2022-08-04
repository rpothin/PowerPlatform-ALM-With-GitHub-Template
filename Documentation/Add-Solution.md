<p align="center">
    <h1 align="center">
        How to add a new solution to this repository?
    </h1>
</p>

## Step by step guide

1. Create an issue for the initialization of the new solution
2. Assign the issue and add the **in progress** label to it
3. In the Dataverse Dev environment associated to your issue, create your new solution
4. In your development branch (*work/xxx*), add your solution in the inputs configuration of the workflows below:

   - [export-and-unpack-solution](../.github/workflows/export-and-unpack-solution.yml)
   - [import-solution-to-dev](../.github/workflows/import-solution-to-dev.yml)
   - [create-deploy-release](../.github/workflows/create-deploy-release.yml)

5. Run the **export-and-unpack-solution** by selecting your development branch, entering your issue number and selecting your new solution
6. In your developmment branch (*work/xxx*), in the **Configurations/<NewSolutionName>** folder, duplicate the **DeploymentSettingsTemplate.json** file to have one file per environment you will want to deploy to like below (*by default, validation and production*):

   - DeploymentSettings_validation.json
   - DeploymentSettings_production.json

7. Create a pull request to validate that your standards are respected
8. When the pull request is approved and the changes pushed to the **main** branch, you will have your new solution in your repository