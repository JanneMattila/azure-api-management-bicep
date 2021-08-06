param apimName string

var apiName = 'users'
var apiPath = 'users'
var logicAppKeyName = 'users-logic-app-sig'
var logicAppBackendName = 'usersLogicAppBackend'
var logicAppTemplateName = 'usersLogicAppBackendTemplate'

resource apim 'Microsoft.ApiManagement/service@2020-12-01' existing = {
  name: apimName
}

resource apiGet 'Microsoft.ApiManagement/service/apis/operations@2020-12-01' existing = {
  name: '${apimName}/${apiName}/get'
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

resource logicAppBackend 'Microsoft.ApiManagement/service/backends@2020-12-01' = {
  name: '${apimName}/${logicAppBackendName}'
  properties: {
    description: logicAppTemplate.outputs.name
    resourceId: '${environment().resourceManager}${logicAppTemplate.outputs.logicApp}'
    url: logicAppTemplate.outputs.endpoint
    protocol: 'http'
  }
}

resource apiGetResource 'Microsoft.ApiManagement/service/apis/operations@2020-12-01' = {
  name: '${apimName}/${apiName}/get'
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
    apiResource
  ]
}

resource apiGetResourcePolicy 'Microsoft.ApiManagement/service/apis/operations/policies@2020-12-01' = {
  name: '${apiGetResource.name}/policy'
  properties: {
    value: loadTextContent('./api-post.xml')
    format: 'rawxml'
  }
  dependsOn: [
    apiGet
    logicAppKey
    logicAppBackend
  ]
}
