# Azure API Management with Bicep

This repository tries to illustrate *one way* of working with
Azure API Management by leveraging Bicep as the Infrastructure-as-Code approach.

This example originates from [azure-api-management-logic-app](https://github.com/JanneMattila/329-azure-api-management-logic-app)
demo, which illustrated the use of feature folders in your ARM template deployment with API Management.

## Pre-reqs

1. Get [apimtemplate.exe](https://github.com/Azure/azure-api-management-devops-resource-kit/tree/master/src/APIM_ARMTemplate)
2. Get [bicep](https://github.com/Azure/bicep)

## Development loop

Currently you need to login **both** with az cli and Azure PowerShell:

```powershell
az login
az account set --subscription <subscription_id>

Login-AzAccount
Select-AzSubscription -SubscriptionName <subscription>
```

To `extract` API Management you cant use following configuration file `extractorparams.json`:

```json
{
  "sourceApimName": "contosoapim4-local",
  "destinationApimName": "contosoapim4-local2",
  "resourceGroup": "rg-apim4-local",
  "fileFolder": ".\\extractor"
}
```

Execute `extract`:

```cmd
apimtemplate.exe extract --extractorConfig extractorparams.json
```

Decompile all extracted ARM templates to Bicep:

```cmd
.\bicep-decompile.ps1 -Folder extractor
```

Now you can use decompiled content in your `deploy` resources.

----

**Note**: In this demo we rely heavily on using additional files
e.g. `openapi` for defining the APIs:

```bicep
resource apiResourceName 'Microsoft.ApiManagement/service/apis@2020-12-01' = {
  name: apiResourceName_var
  properties: {
    // ...
    value: loadTextContent('./products.yaml')
    format: 'openapi'
  }
}
```

Above is extremely handy feature and enables you to include files as you need.

----

For compiling your Bicep artifacts to ARM templates and then deploying them,
use following commands:

```powershell
cd deploy
bicep build azuredeploy.bicep
.\deploy.ps1
```
