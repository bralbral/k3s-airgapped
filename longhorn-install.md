1. Install requirements

```
sudo apt install -y open-iscsi nfs-common
sudo systemctl enable --now iscsid
```

2. Install chart (single node)

```


kubectl apply -f airgap/storageclass/longhorn-single.yaml

kubectl create namespace longhorn-system

./airgap/helm/helm install longhorn ./airgap/charts/longhorn \
  -n longhorn-system \
  -f ./airgap/values/longhorn-single-node.yaml



```

3. Check

```

kubectl get pods -n longhorn-system


```

4. Open ports ( for `longhorn-single-node.yaml`)

```
kubectl -n longhorn-system port-forward svc/longhorn-frontend 8080:80
```
