param apimName string

var apiName = 'products'
var apiPath = 'products'
var logicAppKeyName = 'products-logic-app-sig'
var logicAppBackendName = 'productsLogicAppBackend'
var logicAppTemplateName = 'productsLogicAppBackendTemplate'

resource apim 'Microsoft.ApiManagement/service@2020-12-01' existing = {
  name: apimName
}

module logicAppTemplate './logicapp.json' = {
  name: logicAppTemplateName
  params: {
    location: apim.location
  }
}

resource logicAppKey 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  name: '${apimName}/${logicAppKeyName}'
  properties: {
    secret: true
    displayName: logicAppKeyName
    value: logicAppTemplate.outputs.sig
  }
}

resource apiResource 'Microsoft.ApiManagement/service/apis@2020-12-01' = {
  name: '${apimName}/${apiName}'
  properties: {
    displayName: 'Products'
    description: 'Products API - Product validation service'
    path: apiPath
    subscriptionRequired: false
    protocols: [
      'https'
    ]
    value: loadTextContent('./products.yaml')
    format: 'openapi'
    apiType: 'http'
  }
  dependsOn: [
    logicAppTemplate
  ]
}

resource logicAppBackend 'Microsoft.ApiManagement/service/backends@2020-12-01' = {
  name: '${apimName}/${logicAppBackendName}'
  properties: {
    description: logicAppTemplate.outputs.name
    resourceId: '${environment().resourceManager}${logicAppTemplate.outputs.logicApp}'
    url: logicAppTemplate.outputs.endpoint
    protocol: 'http'
  }
}

resource apiGetResourcePolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2020-12-01' = {
  name: '${apimName}/${apiName}/get/policy'
  properties: {
    value: loadTextContent('./api-get.xml')
    format: 'rawxml'
  }
  dependsOn: [
    apim
    logicAppKey
    logicAppBackend
  ]
}
