<p align="center">
    <h1 align="center">
        How to configure a custom deployment settings file?
    </h1>
</p>

Currently, some configurations, like canvas apps sharing, need to be managed in a custom way because it is not covered in the ["out of the box" deployment settings file](https://docs.microsoft.com/en-us/power-platform/alm/conn-ref-env-variables-build-tools).

Using this repository, you will need to configure custom deployment settings files following the principles below:

- one custom deployment settings file per solution and per environment that need to be stored under `Configurations/<SolutionName>/` (*ex: Configurations/PowerPlatformALMWithGitHub/*)
- the custom deployment settings files need to respect the format below:

```json
{
    "canvasApps": {
        "sharing": [
            {
                "canvasAppName": "app1",
                "groupName": "sg-app-viewers",
                "roleName": "CanView"
            },
            {
                "canvasAppName": "app2",
                "groupName": "sg-app-makers",
                "roleName": "CanEdit"
            }
        ],
        "instrumentationKey": "00000000-0000-0000-0000-000000000000"
    }
}
```

> *Notes:*
> - *You can find the name of a canvas app in the objects of a solution in the [Power Apps maker portal](https://make.powerapps.com/) in the **Name** column*
> - *You can find the name of the Azure AD group you want to consider in the [**Groups** section of **Azure AD**](https://portal.azure.com/#blade/Microsoft_AAD_IAM/GroupsManagementMenuBlade/AllGroups)*
> - *Valid options for the role of a group on a canvas app are: **CanView**, **CanViewWithShare**, **CanEdit** (source [set-adminpowerapproleassignment](https://docs.microsoft.com/en-us/powershell/module/microsoft.powerapps.administration.powershell/set-adminpowerapproleassignment))*
> - *You can find the instrumentation key of the considered Azure Application Insights in the header of the Overview page of the resource in the Azure portal*

- the base of the name of custom deployment settings files is defined in the property `customDeploymentSettingsFileNameBase` in the global configuration file ([Configurations/configurations.json](../Configurations/configurations.json))
- the name of the custom deployment settings files must respect the following format: `<customDeploymentSettingsFileNameBase>_<environmentName>` (*ex: `CustomDeploymentSettings_validation`*)

<h3 align="center">
  <a href="../README.md#-documentation">🏡 README - Documentation</a>
</h3>