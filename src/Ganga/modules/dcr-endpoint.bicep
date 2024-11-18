

param dcrEndpointName string 
param location string = resourceGroup().location
param useAzureMonitorPrivateLinkScope bool = false

resource ingestionDCE 'Microsoft.Insights/dataCollectionEndpoints@2023-03-11' = {
  name: dcrEndpointName
  location: location  
  kind: 'Linux'
  properties: {
    networkAcls: {
      publicNetworkAccess: (useAzureMonitorPrivateLinkScope ? 'Disabled' : 'Enabled')
    }
  }
}


output endpointId string = ingestionDCE.id
