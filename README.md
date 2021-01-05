# Azure API Management with Bicep

`extractorparams.json`:

```json
{
  "sourceApimName": "contosoapim4-local",
  "destinationApimName": "contosoapim4-local2",
  "resourceGroup": "rg-apim4-local",
  "fileFolder": ".\\extractor"
}
```

```cmd
apimtemplate.exe extract --extractorConfig extractorparams.json
```
