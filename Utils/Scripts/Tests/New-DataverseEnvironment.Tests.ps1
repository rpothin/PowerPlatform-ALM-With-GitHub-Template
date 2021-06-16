BeforeAll {
    # Import Microsoft.PowerApps.Administration.PowerShell module
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
    Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Scope CurrentUser -Force

    # Import New-DataverseEnvironment function
    Import-Module ..\New-DataverseEnvironment.ps1 -Force
}

# New-DataverseEnvironment tests without integrations with other modules
Describe "New-DataverseEnvironment Unit Tests" -Tag "UnitTests" {
    Context "Parameters configuration verification" {
        It "Given the Mandatory attribute of the DisplayName parameter, it should be equal to true" {
            (Get-Command New-DataverseEnvironment).Parameters['DisplayName'].Attributes.Mandatory | Should -Be $true
        }

        It "Given the Mandatory attribute of the DomainName parameter, it should be equal to true" {
            (Get-Command New-DataverseEnvironment).Parameters['DomainName'].Attributes.Mandatory | Should -Be $true
        }

        It "Given the Mandatory attribute of the ConfigurationFilePath parameter, it should be equal to true" {
            (Get-Command New-DataverseEnvironment).Parameters['ConfigurationFilePath'].Attributes.Mandatory | Should -Be $true
        }

        It "Given the Mandatory attribute of the Description parameter, it should be equal to false" {
            (Get-Command New-DataverseEnvironment).Parameters['Description'].Attributes.Mandatory | Should -Be $false
        }

        It "Given the Mandatory attribute of the Sku parameter, it should be equal to false" {
            (Get-Command New-DataverseEnvironment).Parameters['Sku'].Attributes.Mandatory | Should -Be $false
        }

        It "Given the ValidValues attribute of the Sku parameter, it should be equal to false" {
            (Get-Command New-DataverseEnvironment).Parameters['Sku'].Attributes.ValidValues | Should -Be @('Production', 'Sandbox', 'Trial')
        }

        It "Given the Mandatory attribute of the SecurityGroupId parameter, it should be equal to false" {
            (Get-Command New-DataverseEnvironment).Parameters['SecurityGroupId'].Attributes.Mandatory | Should -Be $false
        }
    }

    Context "Dataverse environment configuration extraction from file verification" {
        BeforeEach{
            # Simulate the extraction of the content of the Dataverse environment configuration file
            $dataverseConfigurationMock = @('location=france', 'currencyName=EUR', 'languageCode=1033', 'templates=D365_Sales')
            Mock Get-Content { $dataverseConfigurationMock } -ParameterFilter { $Path -eq ".\DataverseEnvironmentConfiguration.txt" }

            # Simulate the behavior of the execution of the Get-AdminPowerAppEnvironment and New-AdminPowerAppEnvironment commands
            $dataverseEnvironmentFoundMock = [PSCustomObject]@{
                DisplayName = "Existing Mock Environment"
            }
            $dataverseEnvironmentCreatedMock = [PSCustomObject]@{
                DisplayName = "New Mock Environment"
            }

            Mock Get-AdminPowerAppEnvironment { $dataverseEnvironmentFoundMock } -ParameterFilter { $DisplayName -eq "Existing Mock Environment" }
            Mock Get-AdminPowerAppEnvironment { $null } -ParameterFilter { $DisplayName -eq "Non Existing Mock Environment" }

            Mock New-AdminPowerAppEnvironment { $dataverseEnvironmentCreatedMock }

            # Definition of the exepcted results of the tests of the this context
            $expectedResultExistingDataverseEnvironmentFound = [PSCustomObject]@{
                DisplayName = "Existing Mock Environment"
                Type = "Existing"
            }
            $expectedResultNewDataverseEnvironmentCreated = [PSCustomObject]@{
                DisplayName = "New Mock Environment"
                Type = "Created"
            }
            $expectedResultErrorDataverseEnvironmentConfigurationExtraction = [PSCustomObject]@{
                Error = "Error in the extraction of the Dataverse configuration from the considered file: System.Management.Automation.ActionPreferenceStopException: The running command stopped because the preference variable"
            }
        }

        It "Given a correct path to Dataverse configuration file and the display name of an existing environment, it should return the information of the environment found" {
            (New-DataverseEnvironment -DisplayName "Existing Mock Environment"-DomainName "existing-mock-environment" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt" | ConvertTo-Json) | Should -Be ($expectedResultExistingDataverseEnvironmentFound | ConvertTo-Json)
        }

        It "Given a wrong path to Dataverse configuration file and the display name of an existing environment, it should return the information of the environment found" {
            (New-DataverseEnvironment -DisplayName "Existing Mock Environment" -DomainName "existing-mock-environment" -ConfigurationFilePath ".\wrongpath.ko" | ConvertTo-Json) | Should -Be ($expectedResultExistingDataverseEnvironmentFound | ConvertTo-Json)
        }

        It "Given a correct path to Dataverse configuration file and the display name of a non existing environment, it should return the information of the new environment created" {
            (New-DataverseEnvironment -DisplayName "Non Existing Mock Environment" -DomainName "non-existing-mock-environment" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt" | ConvertTo-Json) | Should -Be ($expectedResultNewDataverseEnvironmentCreated | ConvertTo-Json)
        }

        It "Given a wrong path to Dataverse configuration file and the display name of a non existing environment, it should return an error regarding the extraction of the Dataverse environment configuration" {
            (New-DataverseEnvironment -DisplayName "Non Existing Mock Environment" -DomainName "non-existing-mock-environment" -ConfigurationFilePath ".\wrongpath.ko").Error.Substring(0, 200) | Should -Be $expectedResultErrorDataverseEnvironmentConfigurationExtraction.Error
        }

        It "Given a wrong path to Dataverse configuration file and the display name of a non existing environment, it should not call the New-AdminPowerAppEnvironment command" {
            New-DataverseEnvironment -DisplayName "Non Existing Mock Environment" -DomainName "non-existing-mock-environment" -ConfigurationFilePath ".\wrongpath.ko"

            Assert-MockCalled New-AdminPowerAppEnvironment -Times 0
        }
    }

    Context "Behavior verification regarding Dataverse environment search results" {
        BeforeEach{
            # Simulate the extraction of the content of the Dataverse environment configuration file
            $dataverseConfigurationMock = @('location=france', 'currencyName=EUR', 'languageCode=1033', 'templates=D365_Sales')
            Mock Get-Content { $dataverseConfigurationMock } -ParameterFilter { $Path -eq ".\DataverseEnvironmentConfiguration.txt" }

            # Simulate the behavior of the execution of the Get-AdminPowerAppEnvironment and New-AdminPowerAppEnvironment commands
            $dataverseEnvironmentFoundMock = [PSCustomObject]@{
                DisplayName = "Existing Mock Environment"
            }
            $dataverseEnvironmentCreatedMock = [PSCustomObject]@{
                DisplayName = "New Mock Environment"
            }
            $dataverseMultipleEnvironmentsFoundMock = @($dataverseEnvironmentFoundMock, $dataverseEnvironmentFoundMock)

            Mock Get-AdminPowerAppEnvironment { $dataverseEnvironmentFoundMock } -ParameterFilter { $DisplayName -eq "Existing Mock Environment" }
            Mock Get-AdminPowerAppEnvironment { $null } -ParameterFilter { $DisplayName -eq "Non Existing Mock Environment" }
            Mock Get-AdminPowerAppEnvironment { $dataverseMultipleEnvironmentsFoundMock } -ParameterFilter { $DisplayName -eq "Multiple Existing Mock Environment" }

            Mock New-AdminPowerAppEnvironment { $dataverseEnvironmentCreatedMock }

            # Definition of the exepcted results of the tests of the this context
            $expectedResultExistingDataverseEnvironmentFound = [PSCustomObject]@{
                DisplayName = "Existing Mock Environment"
                Type = "Existing"
            }
            $expectedResultNewDataverseEnvironmentCreated = [PSCustomObject]@{
                DisplayName = "New Mock Environment"
                Type = "Created"
            }
            $expectedResultErrorMultipleDataverseEnvironmentsFound = [PSCustomObject]@{
                Error = "Multiple Dataverse environment corresponding to the following display name: Multiple Existing Mock Environment"
            }
        }

        It "Given the display name of an existing environment, it should return the information of the environment found" {
            (New-DataverseEnvironment -DisplayName "Existing Mock Environment" -DomainName "existing-mock-environment" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt" | ConvertTo-Json) | Should -Be ($expectedResultExistingDataverseEnvironmentFound | ConvertTo-Json)
        }

        It "Given the display name of an existing environment, it should not call the New-AdminPowerAppEnvironment command" {
            New-DataverseEnvironment -DisplayName "Existing Mock Environment" -DomainName "existing-mock-environment" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt"

            Assert-MockCalled New-AdminPowerAppEnvironment -Times 0
        }

        It "Given the display name of a non existing environment, it should return the information of the new environment created" {
            (New-DataverseEnvironment -DisplayName "Non Existing Mock Environment" -DomainName "non-existing-mock-environment" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt" | ConvertTo-Json) | Should -Be ($expectedResultNewDataverseEnvironmentCreated | ConvertTo-Json)
        }

        It "Given the display name of a non existing environment, it should call the New-AdminPowerAppEnvironment command once" {
            New-DataverseEnvironment -DisplayName "Non Existing Mock Environment" -DomainName "non-existing-mock-environment" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt"

            Assert-MockCalled New-AdminPowerAppEnvironment -Times 1
        }

        It "Given the display name corresponding to multiple environments, it should return an error" {
            (New-DataverseEnvironment -DisplayName "Multiple Existing Mock Environment" -DomainName "multiple-existing-mock-environment" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt").Error | Should -Be $expectedResultErrorMultipleDataverseEnvironmentsFound.Error
        }

        It "Given the display name corresponding to multiple environments, it should not call the New-AdminPowerAppEnvironment command" {
            New-DataverseEnvironment -DisplayName "Multiple Existing Mock Environment" -DomainName "multiple-existing-mock-environment" -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt"

            Assert-MockCalled New-AdminPowerAppEnvironment -Times 0
        }
    }
}

# New-DataverseEnvironment tests with integrations with other modules
#   Prerequisites: To execute the following tests you need to be authenticated using the Add-PowerAppsAccount command
Describe "New-DataverseEnvironment Integration Tests" -Tag "IntegrationTests" {
    Context "Integration tests with the commands of the Microsoft.PowerApps.Administration.PowerShell module" {
        BeforeEach{
            # Simulate the extraction of the content of the Dataverse environment configuration file
            $dataverseConfigurationMockOK = @('location=france', 'currencyName=EUR', 'languageCode=1033', 'templates=D365_Sales')
            $dataverseConfigurationMockKO = @('location=montreal', 'currencyName=EUR', 'languageCode=1033', 'templates=D365_Sales')
            Mock Get-Content { $dataverseConfigurationMockOK } -ParameterFilter { $Path -eq ".\DataverseEnvironmentConfiguration.txt" }
            Mock Get-Content { $dataverseConfigurationMockKO } -ParameterFilter { $Path -eq ".\DataverseEnvironmentConfigurationError.txt" }
            
            # Initialise a variable for the display name of the environment considered in the tests of this context
            $dataverseEnvironmentDisplayName = "Test auto $(Get-Date -format 'yyyyMMdd')"

            # Definition of the exepcted results of the tests of the this context
            $newDataverseEnvironmentExpectedDisplayName = "Test auto $(Get-Date -format 'yyyyMMdd') (test-auto-$(Get-Date -format 'yyyyMMdd'))"

            $values = Get-Content ".\DataverseEnvironmentConfiguration.txt" | Out-String | ConvertFrom-StringData
            $location = $values.location
            $currencyName = $values.currencyName
            $languageCode = $values.languageCode
            $templates = $values.templates

            $defaultDataverseEnvironmentType = "Sandbox"

            $expectedResultErrorDataverseEnvironmentCreation = [PSCustomObject]@{
                Error = "Error in the creation of the Dataverse environment: UnsupportedGeoForProxying | The geo 'montreal' is not a valid geo for proxying requests."
            }
        }

        It "Given a correct path to a Dataverse configuration file with an error and the display name of a non existing environment, it should return an error on the creation of the new environment" {
            (New-DataverseEnvironment -DisplayName $dataverseEnvironmentDisplayName -ConfigurationFilePath ".\DataverseEnvironmentConfigurationError.txt").Error | Should -Be $expectedResultErrorDataverseEnvironmentCreation.Error
        }

        It "Given a correct path to a Dataverse configuration file without errors and the display name of a non existing environment, it should return the information of the new environment created" {
            $newDataverseEnvironment = New-DataverseEnvironment -DisplayName $dataverseEnvironmentDisplayName -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt"
            
            $newDataverseEnvironment.DisplayName | Should -Be $newDataverseEnvironmentExpectedDisplayName
            $newDataverseEnvironment.Location | Should -Be $location
            $newDataverseEnvironment.EnvironmentType | Should -Be $defaultDataverseEnvironmentType
            $newDataverseEnvironment.Type | Should -Be "Created"
        }

        It "Given a correct path to a Dataverse configuration file without errors and the display name of an existing environment, it should return the information of the environment found" {
            $existingDataverseEnvironment = New-DataverseEnvironment -DisplayName $dataverseEnvironmentDisplayName -ConfigurationFilePath ".\DataverseEnvironmentConfiguration.txt"
            
            $existingDataverseEnvironment.DisplayName | Should -Be $newDataverseEnvironmentExpectedDisplayName
            $existingDataverseEnvironment.Location | Should -Be $location
            $existingDataverseEnvironment.EnvironmentType | Should -Be $defaultDataverseEnvironmentType
            $existingDataverseEnvironment.Type | Should -Be "Existing"

            # Delete the Dataverse environment created in the previous test
            Remove-AdminPowerAppEnvironment -EnvironmentName $newDataverseEnvironment.EnvironmentName
        }
    }
}