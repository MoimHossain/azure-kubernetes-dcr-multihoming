
param dcrName string 
param workspaceResourceId string
param endpointId string
param k8sNamespaces array
param transformKql string = ''
param location string = resourceGroup().location

resource containerLogV2HighScaleDCR 'Microsoft.Insights/dataCollectionRules@2023-03-11' = {
  name: dcrName
  location: location  
  kind: 'Linux'
  properties: {
    dataSources: {
      extensions: [
        {
          name: 'ContainerLogV2Extension'
          streams: [
            'Microsoft-ContainerLogV2-HighScale'
          ]
          extensionSettings: {
            dataCollectionSettings: {
              namespaces: k8sNamespaces
            }
          }
          extensionName: 'ContainerLogV2Extension'
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: 'ciworkspace'
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-ContainerLogV2-HighScale'
        ]
        destinations: [
          'ciworkspace'
        ]
        transformKql: (empty(transformKql) ? null : transformKql)
      }
    ]
    dataCollectionEndpointId: endpointId
  }
}


output dcrResourceId string = containerLogV2HighScaleDCR.id
