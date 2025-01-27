

# Apply config map

```bash
kubectl apply -f config-map.yaml
```

# Enable Container Insights

```bash

az aks addon enable --addon monitoring --workspace-resource-id '/subscriptions/XXXXX-XXXX-XXXX/resourcegroups/aks-multihome/providers/microsoft.operationalinsights/workspaces/workload-laws'  --name aks-multi-home-demo --resource-group AKS-MULTIHOME --enable-high-log-scale-mode
```

# Deploy Bicep

```bash
az deployment group create --resource-group AKS-MULTIHOME --template-file main.bicep
```