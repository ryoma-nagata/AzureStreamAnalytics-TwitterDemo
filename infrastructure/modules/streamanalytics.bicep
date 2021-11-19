param paramName string
param evhName string
param pbiGroupId string

var asaName = 'asa-${paramName}'
var location = resourceGroup().location

resource streamanalytics 'Microsoft.StreamAnalytics/streamingjobs@2020-03-01'={
  name:asaName
  identity:{
    type: 'SystemAssigned'
  }
  location:location
  properties:{
    sku:{
      name:'Standard'
    }
    inputs:[
      {
        name:'evh'
        properties:{
          type:'Stream'
          compression:{
            type:'GZip'
          }
          serialization:{
            type:'Json'
            properties:{
              encoding:'UTF8'
            }
          }

          datasource:{
            type:'Microsoft.EventHub/EventHub'
            properties:{
              authenticationMode:'Msi'
              consumerGroupName:'asa'
              serviceBusNamespace:evhName
              eventHubName:'tweethub'
            }
          }

        }
      }
    ]
    transformation:{
      name:'Transformation'
      properties:{
        streamingUnits:1
        query:'SELECT System.Timestamp as Time, text\r\nFROM\r\n    [evh]'
      }
    }
    outputs:[
      {
        name:'pbi'
        properties:{
          datasource:{
            type: 'PowerBI'
            properties:{
              authenticationMode:'Msi'
              groupId:pbiGroupId
              dataset:'Dashboard'
              table:'Twitter'

            }
          }
        }
      }
      {
        name:'pbi-raw'
        properties:{
          datasource:{
            type: 'PowerBI'
            properties:{
              authenticationMode:'Msi'
              groupId:pbiGroupId
              dataset:'Stream'
              table:'Twitter'

            }
          }
        }
      }
    ]
  }
}

output asaName string = asaName
