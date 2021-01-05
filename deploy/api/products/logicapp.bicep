param location string {
  metadata: {
    description: 'Location for all resources.'
  }
}

var logicAppName_var = 'products-handler'

resource logicAppName 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName_var
  location: location
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {
        manual: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {}
          }
        }
      }
      actions: {
        Response: {
          runAfter: {}
          type: 'Response'
          kind: 'Http'
          inputs: {
            body: [
              {
                id: 1
                name: 'Product 1'
              }
              {
                id: 2
                name: 'Product 2'
              }
            ]
            headers: {
              'Content-type': 'application/json'
            }
            statusCode: 200
          }
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}

output name string = logicAppName_var
output logicApp string = logicAppName.id
output sig string = listCallbackURL('${logicAppName.id}/triggers/manual', '2019-05-01').queries.sig
output endpoint string = '${logicAppName.properties.accessEndpoint}/triggers'
output fullLogicAppObject object = reference(logicAppName.id, '2019-05-01', 'Full')
output fullListCallbackURLObject object = listCallbackURL('${logicAppName.id}/triggers/manual', '2019-05-01')