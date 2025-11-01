1. install

```

kubectl create namespace monitoring

./airgap/helm/helm install grafana ./airgap/charts/grafana -n monitoring -f ./airgap/values/grafana-values.yaml



```

Если ошибка типа: `Error: INSTALLATION FAILED: cannot re-use a name that is still in use`

то:

```
./airgap/helm/helm uninstall grafana -n monitoring

```






Output:


```
ubuntu@ubuntu-MS-7C52:~/Projects/k3s-airgapped$ ./airgap/helm/helm install grafana ./airgap/charts/grafana -n monitoring -f ./airgap/values/grafana-values.yaml
NAME: grafana
LAST DEPLOYED: Sat Nov  1 16:54:55 2025
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:

   kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo


2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:

   grafana.monitoring.svc.cluster.local

   If you bind grafana to 80, please update values in values.yaml and reinstall:
   ```
   securityContext:
     runAsUser: 0
     runAsGroup: 0
     fsGroup: 0

   command:
   - "setcap"
   - "'cap_net_bind_service=+ep'"
   - "/usr/sbin/grafana-server &&"
   - "sh"
   - "/run.sh"
   ```
   Details refer to https://grafana.com/docs/installation/configuration/#http-port.
   Or grafana would always crash.

   From outside the cluster, the server URL(s) are:
     http://grafana.local

3. Login with the password from step 1 and the username: admin
```


2. Проверить:

```
kubectl -n monitoring get pods -o wide
```

```

kubectl -n monitoring get pvc

```

Вывод:

```

root@node1:~/airgap/k3s# kubectl -n monitoring get pods -o wide
NAME                       READY   STATUS    RESTARTS   AGE     IP           NODE    NOMINATED NODE   READINESS GATES
grafana-69f4547dc9-hn9t2   1/1     Running   0          2m15s   10.42.1.19   node2   <none>           <none>
root@node1:~/airgap/k3s# 
kubectl -n monitoring get pvc
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
grafana   Bound    pvc-0b8100a5-57e1-45e9-a125-e7bc0bf88a08   10Gi       RWO            longhorn       <unset>                 3m19s
root@node1:~/airgap/k3s# 

```



3. upgrade 

```

helm upgrade grafana ./airgap/charts/grafana \
  -n monitoring \
  -f ./airgap/values/grafana-values.yaml

```
