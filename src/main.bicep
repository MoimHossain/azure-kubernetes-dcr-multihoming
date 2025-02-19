targetScope = 'resourceGroup'

var clusterName = 'aks-multi-home'
var localLAName = 'LOCAL-LAWS'
var globalLAName = 'GLOBAL-LAWS' 

// var k8sNamespaces = [
//   'default'  
//   'kube-system' 
// ]

var k8sNamespaces = [ '_ALL_K8S_NAMESPACES_' ]

resource managedCluster 'Microsoft.ContainerService/managedClusters@2023-05-01' existing = {
  name: clusterName
}

resource localLA 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: localLAName
}

resource globalLA 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: globalLAName
}

module localContainerLogsDCREndpoint 'modules/dcr-endpoint.bicep' = {
  name: 'localCILogsDCREndpoint'
  params: {
    dcrEndpointName: 'localCILogsDCREndpoint'
    location: localLA.location
  }
}

module localContainerLogsDCR 'modules/containerLogv2HSDcr.bicep' = {
  name: 'localCILogsDCR'
  params: {
    dcrName: 'localCILogsDCR'  
    endpointId: localContainerLogsDCREndpoint.outputs.endpointId
    k8sNamespaces: k8sNamespaces
    workspaceResourceId: localLA.id
  }
}

resource localLAContainerLogDCRA 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'localLA-contLogs-dcr-assoiation'
  scope: managedCluster
  properties: {
    dataCollectionRuleId: localContainerLogsDCR.outputs.dcrResourceId
    description: 'Associate AKS Containerinsight DCR with AKS'
  }
}



module globalContainerLogsDCREndpoint 'modules/dcr-endpoint.bicep' = {
  name: 'globalCILogsDCREndpoint'
  params: {
    dcrEndpointName: 'globalCILogsDCREndpoint'
    location: globalLA.location
  }
}

module globalContainerLogsDCR 'modules/containerLogv2HSDcr.bicep' = {
  name: 'globalCILogsDCR'
  params: {
    dcrName: 'globalCILogsDCR'  
    endpointId: globalContainerLogsDCREndpoint.outputs.endpointId
    k8sNamespaces: k8sNamespaces
    workspaceResourceId: globalLA.id
  }
}

resource globalLAContainerLogDCRA 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'globalLA-contLogs-dcr-assoiation'
  scope: managedCluster
  properties: {
    dataCollectionRuleId: globalContainerLogsDCR.outputs.dcrResourceId
    description: 'Associate AKS Containerinsight DCR with AKS'
  }
}




module localSyslogDCR 'modules/syslog-dcr.bicep' = {
  name: 'localLASyslogDCR'
  params: {
    dcrName: 'localLASyslogDCR'
    workspaceResourceId: localLA.id
    location: localLA.location
  }
  dependsOn: [
    managedCluster
  ]
}

resource localLASyslogDCRA 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'localLA-syslog-dcr-assoiation'
  scope: managedCluster
  properties: {
    dataCollectionRuleId: localSyslogDCR.outputs.dcrResourceId
    description: 'Associate AKS Containerinsight DCR with AKS'
  }
}


module globalSyslogDCR 'modules/syslog-dcr.bicep' = {
  name: 'globalSyslogDCR'
  params: {
    dcrName: 'globalSyslogDCR'
    workspaceResourceId: globalLA.id
    location: globalLA.location
  }
  dependsOn: [
    managedCluster
  ]
}

resource globalLASyslogDCRA 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'globalLA-syslog-dcr-assoiation'
  scope: managedCluster
  properties: {
    dataCollectionRuleId: globalSyslogDCR.outputs.dcrResourceId
    description: 'Associate AKS Containerinsight DCR with AKS'
  }
}
