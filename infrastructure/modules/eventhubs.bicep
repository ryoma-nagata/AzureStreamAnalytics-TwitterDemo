param paramName string

var evhName = 'evh-${paramName}'
var location = resourceGroup().location

resource eventhubs 'Microsoft.EventHub/namespaces@2021-01-01-preview'={
  name: evhName
  location:location
  resource hub 'eventhubs' = {
    name: 'tweethub'
    resource consumergroup 'consumergroups'={
      name:'asa'
    }
  }
}


output evhName string = evhName
