param apimName string {
  metadata: {
    description: 'API Management name.'
  }
}
param templateUrl string {
  metadata: {
    description: 'Storage account container base url for deployment templates'
  }
}
param templateToken string {
  metadata: {
    description: 'Storage account access token for accessing templates'
  }
  secure: true
}
param location string {
  metadata: {
    description: 'Location for all resources.'
  }
}

var apiName = 'products'
var apiPath = 'products'
var logicAppKeyName = 'products-logic-app-sig'
var logicAppBackendName = 'productsLogicAppBackend'
var logicAppTemplate_var = 'productsLogicAppBackendTemplate'
var apiResourceName_var = '${apimName}/${apiName}'
var apiGetResourceId = resourceId('Microsoft.ApiManagement/service/apis/operations', apimName, apiName, 'get')
var apiGetResourcePolicyName_var = '${apimName}/${apiName}/get/policy'

module logicAppTemplate './logicapp.bicep' = {
  name: logicAppTemplate_var
  params: {
    location: location
  }
}

resource apimName_logicAppKeyName 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  name: '${apimName}/${logicAppKeyName}'
  properties: {
    secret: true
    displayName: logicAppKeyName
    value: logicAppTemplate.outputs.sig
  }
}

resource apiResourceName 'Microsoft.ApiManagement/service/apis@2019-01-01' = {
  name: apiResourceName_var
  properties: {
    displayName: 'Products'
    description: 'Products API - Product validation service'
    path: apiPath
    subscriptionRequired: false
    protocols: [
      'https'
    ]
    value: '${templateUrl}api/products/products.yaml${templateToken}'
    format: 'openapi-link'
    apiType: 'http'
  }
  dependsOn: [
    logicAppTemplate
  ]
}

resource apimName_logicAppBackendName 'Microsoft.ApiManagement/service/backends@2019-01-01' = {
  name: '${apimName}/${logicAppBackendName}'
  properties: {
    description: logicAppTemplate.outputs.name
    resourceId: 'https://management.azure.com${logicAppTemplate.outputs.logicApp}'
    url: logicAppTemplate.outputs.endpoint
    protocol: 'http'
  }
}

resource apiGetResourcePolicyName 'Microsoft.ApiManagement/service/apis/operations/policies@2019-01-01' = {
  name: apiGetResourcePolicyName_var
  properties: {
    value: '${templateUrl}api/products/api-get.xml${templateToken}'
    format: 'rawxml-link'
  }
  dependsOn: [
    resourceId('Microsoft.ApiManagement/service/apis', apimName, apiName)
    apimName_logicAppKeyName
    apimName_logicAppBackendName
  ]
}