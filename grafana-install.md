1. install

```

kubectl create namespace monitoring

./airgap/helm/helm install grafana ./airgap/charts/grafana \
  -n monitoring \
  -f ./airgap/values/grafana-values-longhorn-single-node.yaml


```



Output:


```
NAME: grafana
LAST DEPLOYED: Sun Oct 26 09:45:15 2025
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:

   kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

   grafana.monitoring.svc.cluster.local

   Get the Grafana URL to visit by running these commands in the same shell:
     export NODE_PORT=$(kubectl get --namespace monitoring -o jsonpath="{.spec.ports[0].nodePort}" services grafana)
     export NODE_IP=$(kubectl get nodes --namespace monitoring -o jsonpath="{.items[0].status.addresses[0].address}")
     echo http://$NODE_IP:$NODE_PORT

3. Login with the password from step 1 and the username: admin

```



2. upgrade 

```

helm upgrade grafana ./airgap/charts/grafana \
  -n monitoring \
  -f ./airgap/charts/values/grafana-values-longhorn.yaml

```
