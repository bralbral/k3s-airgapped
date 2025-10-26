1. Copy folder `airgap` to vm
2. 

Execute (single)

```
cd /root/airgap/k3s
cp k3s /usr/local/bin/
chmod +x /usr/local/bin/k3s
mkdir -p /var/lib/rancher/k3s/agent/images/
cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh --write-kubeconfig-mode 644


```

Execute (cluster)

```

cd /root/airgap/k3s
cp k3s /usr/local/bin/
chmod +x /usr/local/bin/k3s
mkdir -p /var/lib/rancher/k3s/agent/images/
cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

# Инициализация первого сервера с встроенным etcd
INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh server --cluster-init --write-kubeconfig-mode 644


```



3. Check status

```
systemctl status k3s
kubectl get nodes
```

4. Obtain node-token

```
cat /var/lib/rancher/k3s/server/node-token

```


5. Add workers

```

cd /root/airgap/k3s
cp k3s /usr/local/bin/
chmod +x /usr/local/bin/k3s
mkdir -p /var/lib/rancher/k3s/agent/images/
cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

K3S_URL="https://<MASTER_IP>:6443" \
     K3S_TOKEN="<NODE_TOKEN>" \
     INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh

```

6. Add masters ( do not pass `server` flag )

```
cd /root/airgap/k3s
cp k3s /usr/local/bin/
chmod +x /usr/local/bin/k3s
mkdir -p /var/lib/rancher/k3s/agent/images/
cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

K3S_URL="https://<MASTER_IP>:6443" \
     K3S_TOKEN="<MASTER_TOKEN>" \
     INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh server
```

7. Obtain .kubeconfig for `kubectl`, `freelens`, `etc`.

```
cat /etc/rancher/k3s/k3s.yaml

```
Dont forget replace `127.0.0.1` with your external IP.



8. Copy config  (Optional)

```

mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
chown $(id -u):$(id -g) ~/.kube/config

```

