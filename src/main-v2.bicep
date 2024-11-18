targetScope = 'resourceGroup'

var clusterName = 'AKSCLUSTER'

resource managedCluster 'Microsoft.ContainerService/managedClusters@2023-05-01' existing = {
  name: clusterName
}

resource localLA 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: 'WORKLOAD-LA'
}

resource globalLA 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: 'SOC-LA'
}


module worklaodDCR 'modules/dcr.bicep' = {
  name: 'workloadDCR'
  params: {
    dcrName: 'workloadDCR'
    workspaceResourceId: localLA.id
    location: localLA.location
  }
  dependsOn: [
    managedCluster
  ]
}

module globalDCR 'modules/dcr.bicep' = {
  name: 'globalDCR'
  params: {
    dcrName: 'globalDCR'
    workspaceResourceId: globalLA.id
    location: globalLA.location
  }
  dependsOn: [
    managedCluster
  ]
}

resource workloadDCRassoc 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'workload-dcr-assoiation'
  scope: managedCluster
  properties: {
    dataCollectionRuleId: worklaodDCR.outputs.dcrResourceId
    description: 'Associate AKS Containerinsight DCR with AKS'
  }
}

resource globalDCRassoc 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'global-dcr-assoiation'
  scope: managedCluster
  properties: {
    dataCollectionRuleId: globalDCR.outputs.dcrResourceId
    description: 'Associate AKS Containerinsight DCR with AKS'
  }
}

output sku string = managedCluster.sku.name
output localLASku string = localLA.properties.sku.name
output globalLASku string = globalLA.properties.sku.name
