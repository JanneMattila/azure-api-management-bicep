param ApimServiceName string

resource ApimServiceName_products 'Microsoft.ApiManagement/service/apis@2019-01-01' = {
  properties: {
    authenticationSettings: {
      subscriptionKeyRequired: false
    }
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    apiRevision: '1'
    isCurrent: true
    subscriptionRequired: false
    displayName: 'Products'
    path: 'products'
    protocols: [
      'https'
    ]
  }
  name: '${ApimServiceName}/products'
  dependsOn: []
}

resource ApimServiceName_products_5ff435fd1d80c410f8d54ece 'Microsoft.ApiManagement/service/apis/schemas@2019-01-01' = {
  properties: {
    contentType: 'application/vnd.oai.openapi.components+json'
    document: {
      components: {
        schemas: {
          product: {
            type: 'object'
            properties: {
              id: {
                type: 'integer'
              }
              name: {
                type: 'string'
              }
              date1: {
                type: 'string'
                format: 'date'
                example: '25.6.2020 0.00.00'
              }
              date2: {
                type: 'string'
                format: 'date-time'
                example: '25.7.2020 12.34.56'
              }
            }
            description: 'Product'
          }
        }
      }
    }
  }
  name: '${ApimServiceName_products.name}/5ff435fd1d80c410f8d54ece'
}

resource ApimServiceName_products_get 'Microsoft.ApiManagement/service/apis/operations@2019-01-01' = {
  properties: {
    templateParameters: []
    request: {
      queryParameters: []
      headers: []
      representations: []
    }
    responses: [
      {
        statusCode: 200
        description: 'OK response'
        headers: []
        representations: [
          {
            contentType: 'application/json'
            schemaId: '5ff435fd1d80c410f8d54ece'
            typeName: 'product'
          }
        ]
      }
    ]
    displayName: '/ - GET'
    method: 'GET'
    urlTemplate: '/'
  }
  name: '${ApimServiceName_products.name}/get'
  dependsOn: [
    ApimServiceName_products_5ff435fd1d80c410f8d54ece
  ]
}

resource ApimServiceName_products_get_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2019-01-01' = {
  properties: {
    value: '<policies>\r\n\t<inbound>\r\n\t\t<base />\r\n\t\t<set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />\r\n\t\t<set-method>POST</set-method>\r\n\t\t<rewrite-uri template="/manual/paths/invoke?api-version=2019-05-01&amp;sp=/triggers/manual/run&amp;sv=1.0&amp;sig={{products-logic-app-sig}}" />\r\n\t\t<set-backend-service backend-id="productsLogicAppBackend" />\r\n\t</inbound>\r\n\t<backend>\r\n\t\t<base />\r\n\t</backend>\r\n\t<outbound>\r\n\t\t<set-header name="X-Products-Policy-Example" exists-action="override">\r\n\t\t\t<value>v1</value>\r\n\t\t</set-header>\r\n\t\t<base />\r\n\t</outbound>\r\n\t<on-error>\r\n\t\t<base />\r\n\t</on-error>\r\n</policies>'
    format: 'rawxml'
  }
  name: '${ApimServiceName_products_get.name}/policy'
}

resource ApimServiceName_users 'Microsoft.ApiManagement/service/apis@2019-01-01' = {
  properties: {
    description: 'Users API - User validation service'
    authenticationSettings: {
      subscriptionKeyRequired: false
    }
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    apiRevision: '1'
    isCurrent: true
    subscriptionRequired: false
    displayName: 'Users'
    path: 'users'
    protocols: [
      'https'
    ]
  }
  name: '${ApimServiceName}/users'
  dependsOn: []
}

resource ApimServiceName_users_get 'Microsoft.ApiManagement/service/apis/operations@2019-01-01' = {
  properties: {
    templateParameters: []
    description: 'Validates user'
    request: {
      queryParameters: []
      headers: []
      representations: []
    }
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
    displayName: 'Validate user'
    method: 'POST'
    urlTemplate: '/'
  }
  name: '${ApimServiceName_users.name}/get'
}

resource ApimServiceName_users_get_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2019-01-01' = {
  properties: {
    value: '<policies>\r\n\t<inbound>\r\n\t\t<base />\r\n\t\t<set-header name="Ocp-Apim-Subscription-Key" exists-action="delete" />\r\n\t\t<set-method>POST</set-method>\r\n\t\t<rewrite-uri template="/manual/paths/invoke?api-version=2019-05-01&amp;sp=/triggers/manual/run&amp;sv=1.0&amp;sig={{users-logic-app-sig}}" />\r\n\t\t<set-backend-service backend-id="usersLogicAppBackend" />\r\n\t</inbound>\r\n\t<backend>\r\n\t\t<base />\r\n\t</backend>\r\n\t<outbound>\r\n\t\t<set-header name="X-UserValidation-Policy-Example" exists-action="override">\r\n\t\t\t<value>v1</value>\r\n\t\t</set-header>\r\n\t\t<base />\r\n\t</outbound>\r\n\t<on-error>\r\n\t\t<base />\r\n\t</on-error>\r\n</policies>'
    format: 'rawxml'
  }
  name: '${ApimServiceName_users_get.name}/policy'
}