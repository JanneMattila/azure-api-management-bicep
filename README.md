# Azure API Management with Bicep

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
