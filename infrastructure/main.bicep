param project string
param env string
param deployment_id string

param pbiGroupId string =''

var uniqueName = '${project}${env}${deployment_id}'

module eventhubs 'modules/eventhubs.bicep'={
  name:'eventhubs_deployment'
  params:{
    paramName: uniqueName
  }
}

module streamanalytics 'modules/streamanalytics.bicep'={
  name:'streamanalytics_deployment'
  params:{
    pbiGroupId:pbiGroupId
    paramName:uniqueName
    evhName:eventhubs.outputs.evhName
  }
  dependsOn:[
    eventhubs
  ]
}

module roleAssingment 'modules/roleAssingment.bicep'={
  name:'rbac_ops'
  params:{
    asaName:streamanalytics.outputs.asaName
    evhName:eventhubs.outputs.evhName
  }
  dependsOn:[
    eventhubs
    streamanalytics
  ]
}
