param apimName string
param apimPublisherEmail string = 'admin@contoso.com'
param apimPublisherName string = 'Contoso'
param apimPricingTier string = 'Consumption'
param apimCapacity int = 0

param location string = resourceGroup().location

resource apimNameResource 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: apimName
  location: location
  sku: {
    name: apimPricingTier
    capacity: apimCapacity
  }
  properties: {
    publisherEmail: apimPublisherEmail
    publisherName: apimPublisherName
  }
}

resource apimGlobalpolicy 'Microsoft.ApiManagement/service/policies@2019-01-01' = {
  name: '${apimNameResource.name}/policy'
  properties: {
    value: loadTextContent('./policies/global.xml')
    format: 'rawxml'
  }
}

module apiUsersTemplate './api/users/api.bicep' = {
  name: 'apiUsersTemplate'
  params: {
    apimName: apimName
  }
  dependsOn: [
    apimNameResource
  ]
}

module apiProductsTemplate './api/products/api.bicep' = {
  name: 'apiProductsTemplate'
  params: {
    apimName: apimName
  }
  dependsOn: [
    apimNameResource
  ]
}

output apimGateway string = apimNameResource.properties.gatewayUrl
