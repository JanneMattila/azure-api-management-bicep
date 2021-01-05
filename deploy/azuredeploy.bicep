param apimName string {
  metadata: {
    description: 'API Management name.'
  }
}
param publisherEmail string {
  minLength: 1
  metadata: {
    description: 'The email address of the owner of the service'
  }
  default: 'admin@contoso.com'
}
param publisherName string {
  minLength: 1
  metadata: {
    description: 'The name of the owner of the service'
  }
  default: 'Contoso'
}
param location string {
  metadata: {
    description: 'Location for all resources.'
  }
  default: resourceGroup().location
}
param sharedTemplatesUrl string {
  metadata: {
    description: 'Storage account container base url for deployment templates'
  }
}
param sharedTemplatesToken string {
  metadata: {
    description: 'Storage account access token for accessing templates'
  }
  secure: true
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

resource apimName_resource 'Microsoft.ApiManagement/service@2019-01-01' = {
  name: apimName
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

resource apimName_policy 'Microsoft.ApiManagement/service/policies@2019-01-01' = {
  name: '${apimName_resource.name}/policy'
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
    apimName_resource
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
    apimName_resource
  ]
}

output apimGateway string = apimName_resource.properties.gatewayUrl