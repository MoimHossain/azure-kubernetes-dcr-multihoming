param managedClusters_spoke_aks_name string = 'spoke-aks'
param workspaces_spoke_log_analytics_workspace_externalid string = '/subscriptions/7f2413b7-93b1-4560-a932-220c34c9db29/resourceGroups/AKS_LOGS_CHECK/providers/Microsoft.OperationalInsights/workspaces/spoke-log-analytics-workspace'
param publicIPAddresses_b194de9a_d98e_4b45_9590_94c1b7f2c563_externalid string = '/subscriptions/7f2413b7-93b1-4560-a932-220c34c9db29/resourceGroups/MC_AKS_LOGS_CHECK_spoke-aks_westeurope/providers/Microsoft.Network/publicIPAddresses/b194de9a-d98e-4b45-9590-94c1b7f2c563'
param userAssignedIdentities_spoke_aks_agentpool_externalid string = '/subscriptions/7f2413b7-93b1-4560-a932-220c34c9db29/resourceGroups/MC_AKS_LOGS_CHECK_spoke-aks_westeurope/providers/Microsoft.ManagedIdentity/userAssignedIdentities/spoke-aks-agentpool'

resource managedClusters_spoke_aks_name_resource 'Microsoft.ContainerService/managedClusters@2024-05-01' = {
  name: managedClusters_spoke_aks_name
  location: 'westeurope'
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.29.7'
    dnsPrefix: '${managedClusters_spoke_aks_name}-dns'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_D4ds_v5'
        osDiskSizeGB: 128
        osDiskType: 'Ephemeral'
        kubeletDiskType: 'OS'
        maxPods: 110
        type: 'VirtualMachineScaleSets'
        maxCount: 5
        minCount: 2
        enableAutoScaling: true
        powerState: {
          code: 'Running'
        }
        orchestratorVersion: '1.29.7'
        enableNodePublicIP: false
        mode: 'System'
        osType: 'Linux'
        osSKU: 'Ubuntu'
        upgradeSettings: {
          maxSurge: '10%'
        }
        enableFIPS: false
      }
    ]
    windowsProfile: {
      adminUsername: 'azureuser'
      enableCSIProxy: true
    }
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    addonProfiles: {
      azureKeyvaultSecretsProvider: {
        enabled: false
      }
      azurepolicy: {
        enabled: false
      }
      omsAgent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: workspaces_spoke_log_analytics_workspace_externalid
          useAADAuth: 'true'
        }
      }
    }
    nodeResourceGroup: 'MC_AKS_LOGS_CHECK_${managedClusters_spoke_aks_name}_westeurope'
    enableRBAC: true
    supportPlan: 'KubernetesOfficial'
    networkProfile: {
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
      networkPolicy: 'none'
      networkDataplane: 'azure'
      loadBalancerSku: 'Standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
        effectiveOutboundIPs: [
          {
            id: publicIPAddresses_b194de9a_d98e_4b45_9590_94c1b7f2c563_externalid
          }
        ]
        backendPoolType: 'nodeIPConfiguration'
      }
      podCidr: '10.244.0.0/16'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      outboundType: 'loadBalancer'
      podCidrs: [
        '10.244.0.0/16'
      ]
      serviceCidrs: [
        '10.0.0.0/16'
      ]
      ipFamilies: [
        'IPv4'
      ]
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: userAssignedIdentities_spoke_aks_agentpool_externalid
        clientId: '6df0808e-6ca7-4db3-bfb8-3452667cbf70'
        objectId: 'a5327a67-0e40-414c-9430-893f31cebf45'
      }
    }
    autoScalerProfile: {
      'balance-similar-node-groups': 'false'
      'daemonset-eviction-for-empty-nodes': false
      'daemonset-eviction-for-occupied-nodes': true
      expander: 'random'
      'ignore-daemonsets-utilization': false
      'max-empty-bulk-delete': '10'
      'max-graceful-termination-sec': '600'
      'max-node-provision-time': '15m'
      'max-total-unready-percentage': '45'
      'new-pod-scale-up-delay': '0s'
      'ok-total-unready-count': '3'
      'scale-down-delay-after-add': '10m'
      'scale-down-delay-after-delete': '10s'
      'scale-down-delay-after-failure': '3m'
      'scale-down-unneeded-time': '10m'
      'scale-down-unready-time': '20m'
      'scale-down-utilization-threshold': '0.5'
      'scan-interval': '10s'
      'skip-nodes-with-local-storage': 'false'
      'skip-nodes-with-system-pods': 'true'
    }
    autoUpgradeProfile: {
      upgradeChannel: 'patch'
      nodeOSUpgradeChannel: 'NodeImage'
    }
    disableLocalAccounts: false
    securityProfile: {}
    storageProfile: {
      diskCSIDriver: {
        enabled: true
      }
      fileCSIDriver: {
        enabled: true
      }
      snapshotController: {
        enabled: true
      }
    }
    oidcIssuerProfile: {
      enabled: false
    }
    workloadAutoScalerProfile: {}
    azureMonitorProfile: {
      metrics: {
        enabled: true
        kubeStateMetrics: {}
      }
    }
    metricsProfile: {
      costAnalysis: {
        enabled: false
      }
    }
  }
}

resource managedClusters_spoke_aks_name_agentpool 'Microsoft.ContainerService/managedClusters/agentPools@2024-05-01' = {
  parent: managedClusters_spoke_aks_name_resource
  name: 'agentpool'
  properties: {
    count: 2
    vmSize: 'Standard_D4ds_v5'
    osDiskSizeGB: 128
    osDiskType: 'Ephemeral'
    kubeletDiskType: 'OS'
    maxPods: 110
    type: 'VirtualMachineScaleSets'
    maxCount: 5
    minCount: 2
    enableAutoScaling: true
    powerState: {
      code: 'Running'
    }
    orchestratorVersion: '1.29.7'
    enableNodePublicIP: false
    mode: 'System'
    osType: 'Linux'
    osSKU: 'Ubuntu'
    upgradeSettings: {
      maxSurge: '10%'
    }
    enableFIPS: false
  }
}

resource managedClusters_spoke_aks_name_aksManagedAutoUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-05-01' = {
  parent: managedClusters_spoke_aks_name_resource
  name: 'aksManagedAutoUpgradeSchedule'
  properties: {
    maintenanceWindow: {
      schedule: {
        weekly: {
          intervalWeeks: 1
          dayOfWeek: 'Sunday'
        }
      }
      durationHours: 4
      utcOffset: '+00:00'
      startDate: '2024-09-05'
      startTime: '00:00'
    }
  }
}

resource managedClusters_spoke_aks_name_aksManagedNodeOSUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-05-01' = {
  parent: managedClusters_spoke_aks_name_resource
  name: 'aksManagedNodeOSUpgradeSchedule'
  properties: {
    maintenanceWindow: {
      schedule: {
        weekly: {
          intervalWeeks: 1
          dayOfWeek: 'Sunday'
        }
      }
      durationHours: 4
      utcOffset: '+00:00'
      startDate: '2024-09-05'
      startTime: '00:00'
    }
  }
}
