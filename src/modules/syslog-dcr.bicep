
param dcrName string 
param workspaceResourceId string
param location string = resourceGroup().location


resource syslogDCR 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: dcrName
  location: location
  kind: 'Linux'
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
        // {
        //   streams: [
        //     'Microsoft-ContainerInsights-Group-Default'
        //   ]          
        //   extensionName: 'ContainerInsights'
        //   extensionSettings: {
        //     dataCollectionSettings: {
        //       enableContainerLogV2: true
        //       interval: '1m'
        //       namespaceFilteringMode: 'Off'
        //     }
        //   }
        //   name: 'ContainerInsightsExtension'
        // }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'laworkspace'
          workspaceResourceId: workspaceResourceId
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          // 'Microsoft-ContainerInsights-Group-Default'
          'Microsoft-Syslog'
        ]
        destinations: [
          'laworkspace'
        ]        
      }
    ]    
  }
}

output dcrResourceId string = syslogDCR.id
