param location string {
  metadata: {
    description: 'Location for all resources.'
  }
}

var logicAppName_var = 'users-handler'

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
            schema: {
              properties: {
                address: {
                  properties: {
                    city: {
                      type: 'string'
                    }
                    country: {
                      type: 'string'
                    }
                    postalCode: {
                      type: 'string'
                    }
                    street: {
                      type: 'string'
                    }
                  }
                  type: 'object'
                }
                id: {
                  type: 'integer'
                }
                name: {
                  type: 'string'
                }
              }
              type: 'object'
            }
          }
        }
      }
      actions: {
        Condition: {
          actions: {
            Response: {
              runAfter: {}
              type: 'Response'
              kind: 'Http'
              inputs: {
                body: {
                  summary: 'User validated succesfully'
                }
                headers: {
                  'X-UserValidation': '1'
                }
                statusCode: 200
              }
            }
          }
          runAfter: {}
          else: {
            actions: {
              Response_2: {
                runAfter: {}
                type: 'Response'
                kind: 'Http'
                inputs: {
                  body: {
                    summary: 'Validation failed'
                  }
                  headers: {
                    'X-UserValidation': '0'
                  }
                  statusCode: 200
                }
              }
            }
          }
          expression: {
            and: [
              {
                equals: [
                  '@triggerBody()?[\'address\']?[\'postalCode\']'
                  '12345'
                ]
              }
            ]
          }
          type: 'If'
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