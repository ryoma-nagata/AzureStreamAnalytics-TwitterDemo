@description('リソース名の一部に利用されます。必要に応じて変更してください。既定値:twitter')
param project string
@description('リソース名の一部に利用されます。必要に応じて変更してください。既定値:demo')
param env string
@description('ランダム性を保つ文字列を入力してください。小文字英数のみ。例：test01')
@minLength(4)
@maxLength(8)
param deployment_id string

@description('4. 変数情報の設定に従ってPower BI WorkspaceのIDを入力してください。マイワークスペースを利用する場合は空白のままでOK')
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
