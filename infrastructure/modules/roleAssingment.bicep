param asaName string
param evhName string 


//https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
var AzureEventHubsDataReceiver = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/a638d3c7-ab3a-418d-83e6-5f17a39d4fde'



resource streamanalytics 'Microsoft.StreamAnalytics/streamingjobs@2020-03-01'existing={
  name:asaName
}

resource eventhubs 'Microsoft.EventHub/namespaces@2021-01-01-preview' existing={
  name:evhName
}

resource roleAssignments_purviewtostorage 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope:eventhubs
  name: guid('asa-evhdatareceiver',asaName)
  properties: {
    roleDefinitionId: AzureEventHubsDataReceiver
    principalId: streamanalytics.identity.principalId
    principalType: 'ServicePrincipal'
  }
}
