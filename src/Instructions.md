

# Apply config map

```bash
kubectl apply -f configmap.yaml
```

# Enable Container Insights

```bash

az aks addon enable --addon monitoring --workspace-resource-id '/subscriptions/xxx/resourcegroups/aks-logs/providers/microsoft.operationalinsights/workspaces/local-laws'  --name ABCAKS --resource-group AKS-LOGS --enable-high-log-scale-mode
```

# Deploy Bicep

```bash
az deployment group create --resource-group AKS-LOGS --template-file .\main.bicep      
```