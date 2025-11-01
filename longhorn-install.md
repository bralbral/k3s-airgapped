1. Install requirements

```
sudo apt install -y open-iscsi nfs-common
sudo systemctl enable --now iscsid
```

1. Install chart

```

kubectl create namespace longhorn-system

./airgap/helm/helm install longhorn ./airgap/charts/longhorn \
  -n longhorn-system



```

3. Check

```

kubectl get pods -n longhorn-system


```

4. Open ports ( for `longhorn-single-node.yaml`)

```
kubectl -n longhorn-system port-forward svc/longhorn-frontend 8080:80
```
