param apimName string
param apimPublisherEmail string = 'admin@contoso.com'
param apimPublisherName string = 'Contoso'
param apimPricingTier string = 'Consumption'

param location string = resourceGroup().location

// Storage account container base url for deployment templates
param templateUrl string

// Storage account access token for accessing templates
param templateToken string {
  secure: true
}

resource apimNameResource 'Microsoft.ApiManagement/service@2019-01-01' = {
  name: apimName
  location: location
  sku: {
    name: apimPricingTier
  }
  properties: {
    publisherEmail: apimPublisherEmail
    publisherName: apimPublisherName
  }
}

resource apimGlobalpolicy 'Microsoft.ApiManagement/service/policies@2019-01-01' = {
  name: '${apimNameResource.name}/policy'
  properties: {
    value: '${templateUrl}policies/global.xml${templateToken}'
    format: 'rawxml-link'
  }
}

module apiUsersTemplate './api/users/api.bicep' = {
  name: 'apiUsersTemplate'
  params: {
    apimName: apimName
    templateUrl: templateUrl
    templateToken: templateToken
    location: location
  }
  dependsOn: [
    apimNameResource
  ]
}

module apiProductsTemplate './api/products/api.bicep' = {
  name: 'apiProductsTemplate'
  params: {
    apimName: apimName
    templateUrl: templateUrl
    templateToken: templateToken
    location: location
  }
  dependsOn: [
    apimNameResource
  ]
}

output apimGateway string = apimNameResource.properties.gatewayUrl