targetScope = 'resourceGroup'
@description('Specifies the location of the AKS cluster.')
param location string = resourceGroup().location

var clusterName = 'mydcluster'

resource managedCluster 'Microsoft.ContainerService/managedClusters@2023-05-01' existing = {
  name: clusterName
}

resource localLA 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: 'local-la-workspace'
}

resource globalLA 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: 'global-la-workspace'
}

// 2022-06-01 & 23-03-11 will not work
// 2021-04-01 should work and continue to work
resource monitorDCR 'Microsoft.Insights/dataCollectionRules@2021-04-01' = {
  name: 'azmon-dcr'
  location: location
  kind: 'Linux'
  dependsOn: [
    managedCluster
    localLA
    globalLA
  ]
  properties: {
    dataSources: {
      syslog: [
        {
          name: 'sysLogsDataSource'
          streams: [
            'Microsoft-Syslog'
          ]
          facilityNames: [
            'auth'
            'authpriv'
            'cron'
            'daemon'
            'mark'
            'kern'
            'local0'
            'local1'
            'local2'
            'local3'
            'local4'
            'local5'
            'local6'
            'local7'
            'lpr'
            'mail'
            'news'
            'syslog'
            'user'
            'uucp'
          ]
          logLevels: [
            'Debug'
            'Info'
            'Notice'
            'Warning'
            'Error'
            'Critical'
            'Alert'
            'Emergency'
          ]
        }        
      ]
      extensions: [
        {
          streams: [
            'Microsoft-ContainerLogV2'
            'Microsoft-KubeEvents'
            'Microsoft-KubePodInventory'
            'Microsoft-KubeNodeInventory'
            'Microsoft-KubePVInventory'
            'Microsoft-KubeServices'
            'Microsoft-KubeMonAgentEvents'
            'Microsoft-InsightsMetrics'
            'Microsoft-ContainerInventory'
            'Microsoft-ContainerNodeInventory'
            'Microsoft-Perf'
          ]          
          extensionName: 'ContainerInsights'
          extensionSettings: {
            dataCollectionSettings: {
              enableContainerLogV2: true
              interval: '1m'
              namespaceFilteringMode: 'Off'
            }
          }
          name: 'ContainerInsightsExtension'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'localworkspace'
          workspaceResourceId: localLA.id
        }
        {
          name: 'globalworkspace'
          workspaceResourceId: globalLA.id
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-ContainerLogV2'
          'Microsoft-KubeEvents'
          'Microsoft-KubePodInventory'
          'Microsoft-KubeNodeInventory'
          'Microsoft-KubePVInventory'
          'Microsoft-KubeServices'
          'Microsoft-KubeMonAgentEvents'
          'Microsoft-InsightsMetrics'
          'Microsoft-ContainerInventory'
          'Microsoft-ContainerNodeInventory'
          'Microsoft-Perf'
          'Microsoft-Syslog'
        ]
        destinations: [
          'localworkspace'
        ]        
      }
      {
        streams: [          
          'Microsoft-ContainerLogV2'
          'Microsoft-KubeEvents'
          'Microsoft-KubePodInventory'
          'Microsoft-KubeNodeInventory'
          'Microsoft-KubePVInventory'
          'Microsoft-KubeServices'
          'Microsoft-KubeMonAgentEvents'
          'Microsoft-InsightsMetrics'
          'Microsoft-ContainerInventory'
          'Microsoft-ContainerNodeInventory'
          'Microsoft-Perf'
          'Microsoft-Syslog'
        ]
        destinations: [
          'globalworkspace'
        ]        
      }
    ]    
  }
}


resource mscidatacollruleassoc 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'dcr-assoiation'
  scope: managedCluster
  properties: {
    dataCollectionRuleId: monitorDCR.id
    description: 'Associate AKS Containerinsight DCR with AKS'
  }
}

output sku string = managedCluster.sku.name
output localLASku string = localLA.properties.sku.name
output globalLASku string = globalLA.properties.sku.name
