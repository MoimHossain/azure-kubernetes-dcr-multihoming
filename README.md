

```
az deployment group create --resource-group ASK-LOG-EXPERIMENTS --template-file .\main.bicep                                             
```

```
az aks addon enable --addon monitoring --workspace-resource-id '/subscriptions/xxx/resourcegroups/LA-test/providers/microsoft.operationalinsights/workspaces/LOCAL-LA'  --name abc --resource-group LA-test
```


```
kubectl run busybox --image=busybox --restart=Never -- /bin/sh -c "while true; do echo MOIM Hello World; sleep 10; done"
```