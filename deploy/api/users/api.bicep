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

var apiName = 'users'
var apiPath = 'users'
var logicAppKeyName = 'users-logic-app-sig'
var logicAppBackendName = 'usersLogicAppBackend'
var logicAppTemplate_var = 'usersLogicAppBackendTemplate'
var apiResourceName_var = '${apimName}/${apiName}'
var apiResourceId = resourceId('Microsoft.ApiManagement/service/apis', apimName, apiName)
var apiGetResourceName_var = '${apiResourceName_var}/get'
var apiGetResourceId = resourceId('Microsoft.ApiManagement/service/apis/operations', apimName, apiName, 'get')

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
    displayName: 'Users'
    description: 'Users API - User validation service'
    path: apiPath
    subscriptionRequired: false
    protocols: [
      'https'
    ]
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

resource apiGetResourceName 'Microsoft.ApiManagement/service/apis/operations@2018-01-01' = {
  name: apiGetResourceName_var
  properties: {
    displayName: 'Validate user'
    method: 'POST'
    urlTemplate: '/'
    templateParameters: []
    description: 'Validates user'
    responses: [
      {
        statusCode: 200
        description: 'OK'
        headers: []
        representations: [
          {
            contentType: 'application/json'
            sample: '{\r\n    "summary": "User validated succesfully"\r\n}'
          }
        ]
      }
    ]
  }
  dependsOn: [
    apiResourceId
  ]
}

resource apiGetResourceName_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2019-01-01' = {
  name: '${apiGetResourceName.name}/policy'
  properties: {
    value: '${templateUrl}api/users/api-post.xml${templateToken}'
    format: 'rawxml-link'
  }
  dependsOn: [
    apiGetResourceId
    apimName_logicAppKeyName
    apimName_logicAppBackendName
  ]
}