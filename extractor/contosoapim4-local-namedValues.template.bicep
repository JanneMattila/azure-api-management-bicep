param ApimServiceName string

resource ApimServiceName_products_logic_app_sig 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  properties: {
    secret: true
    displayName: 'products-logic-app-sig'
    value: '<redacted>'
  }
  name: '${ApimServiceName}/products-logic-app-sig'
}

resource ApimServiceName_users_logic_app_sig 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  properties: {
    secret: true
    displayName: 'users-logic-app-sig'
    value: '<redacted>'
  }
  name: '${ApimServiceName}/users-logic-app-sig'
}