```
root@node1:~/airgap/images# kubectl get svc -n monitoring
NAME                                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
grafana                               ClusterIP   10.43.140.23    <none>        80/TCP     64m
prometheus-alertmanager               ClusterIP   10.43.12.42     <none>        9093/TCP   55m
prometheus-alertmanager-headless      ClusterIP   None            <none>        9093/TCP   55m
prometheus-kube-state-metrics         ClusterIP   10.43.65.178    <none>        8080/TCP   55m
prometheus-prometheus-node-exporter   ClusterIP   10.43.115.158   <none>        9100/TCP   55m
prometheus-prometheus-pushgateway     ClusterIP   10.43.43.128    <none>        9091/TCP   55m
prometheus-server                     ClusterIP   10.43.249.184   <none>        80/TCP     55m
```
monitoring/prometheus-server:80 (для фриленс)
