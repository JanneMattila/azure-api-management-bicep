param ApimServiceName string

resource ApimServiceName_productsLogicAppBackend 'Microsoft.ApiManagement/service/backends@2019-01-01' = {
  properties: {
    description: 'products-handler'
    resourceId: '<redacted>/resourceGroups/rg-apim4-local/providers/Microsoft.Logic/workflows/products-handler'
    url: '<redacted>'
    protocol: 'http'
  }
  name: '${ApimServiceName}/productsLogicAppBackend'
}

resource ApimServiceName_usersLogicAppBackend 'Microsoft.ApiManagement/service/backends@2019-01-01' = {
  properties: {
    description: 'users-handler'
    resourceId: '<redacted>/resourceGroups/rg-apim4-local/providers/Microsoft.Logic/workflows/users-handler'
    url: '<redacted>'
    protocol: 'http'
  }
  name: '${ApimServiceName}/usersLogicAppBackend'
}