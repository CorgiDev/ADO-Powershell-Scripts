# ADO_Powershell_Fun
Powershell scripts for doing stuff in ADO.

## Azure_DevOps-WIT.ps1

- **Purpose:** This script for creating some tasks in Azure DevOps.

### Pre-requisites

You must do the following before you can successfully run this script:
1. Install Azure CLI from:
    1. https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
2. Install the Azure DevOps Powershell Extension using the following command in Powershell:
    1. `az extension add --upgrade -n azure-devops`
3. Get a PAT from Azure DevOps that has the ability to read/write/manage work items in the project you wish to manage.
