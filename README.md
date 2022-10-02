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
3. Run `az upgrade` command in Powershell to make sure everything is updated appropriately.
4. Get a PAT from Azure DevOps that has the ability to read/write/manage work items in the project you wish to manage.
5. Enable running scripts if necessary. See Troubleshooting section for more details.

## Troubleshooting

### Running scripts is disabled on this system.

If you get an error similar to the one shown below, stating that you cannot run the scripts due to the ability to run scripts being disabled on the system; you can easily fix this.
```dotnetcli
az : File C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin\az.ps1 cannot be loaded because running scripts is
disabled on this system. For more information, see about_Execution_Policies at
https:/go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ az extension add --upgrade -n azure-devops
+ ~~
    + CategoryInfo          : SecurityError: (:) [], PSSecurityException
    + FullyQualifiedErrorId : UnauthorizedAccess
```
First, check what your system policies are set to currently using the `Get-ExecutionPolicy -List` command in Powershell. You should get a readout similar to the following:

```dotnetcli
        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser       Undefined
 LocalMachine       Undefined
 ```

We want to enable scripts to run, so we are going to use `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser` to accomplish that.

After running the command, you can confirm the changes by running `Get-ExecutionPolicy -List` again. You should see the `CurrentUser` value update to `Unrestricted`.

It is recommended that you set it back to `Undefined` when you are done running scripts. This helps make it more difficult for malicious scripts to run without your knowledge.

## Additional Resources

- [Azure DevOps Fields](https://learn.microsoft.com/en-us/rest/api/azure/devops/wit/fields/list?view=azure-devops-rest-6.0&tabs=HTTP&viewFallbackFrom=azure-devops-rest-7.0)