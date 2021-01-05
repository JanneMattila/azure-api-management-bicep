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

**Note**: In this demo we rely heavily on using external files
e.g. `openapi-link` in below example:

```json
{
  "name": "[variables('apiResourceName')]",
  "type": "Microsoft.ApiManagement/service/apis",
  "apiVersion": "2019-01-01",
  "properties": {
    // external file->
    "value": "[concat(parameters('templateUrl'), 'api/products/products.yaml', parameters('templateToken'))]",
    "format": "openapi-link",
    "apiType": "http"
  }
}
```

Above is not _yet_ supported in directly in Bicep using `includeFile()` (or similar command)
for including these directly from local filesystem, but it's tracked in here:
[Bicep Issue #471](https://github.com/Azure/bicep/issues/471).

----

For compiling your Bicep artifacts to ARM templates and then deploying them,
use following commands:

```powershell
cd deploy
bicep compile azuredeploy.bicep
.\deploy.ps1
```
