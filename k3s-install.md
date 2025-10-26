1. Copy folder `airgap` to vm
2. 

Execute

```
cd /root/airgap/k3s
sudo cp k3s /usr/local/bin/
sudo chmod +x /usr/local/bin/k3s
sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

sudo INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh --write-kubeconfig-mode 644

```

3. Check status

```
sudo systemctl status k3s
sudo kubectl get nodes
```

4. Obtain node-token

```
sudo cat /var/lib/rancher/k3s/server/node-token

```


5. Add workers

```

cd /root/airgap/k3s
sudo cp k3s /usr/local/bin/
sudo chmod +x /usr/local/bin/k3s
sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

sudo K3S_URL="https://<MASTER_IP>:6443" \
     K3S_TOKEN="<NODE_TOKEN>" \
     INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh

```

6. Add masters ( do not pass `server` flag )

```
cd /root/airgap/k3s
sudo cp k3s /usr/local/bin/
sudo chmod +x /usr/local/bin/k3s
sudo mkdir -p /var/lib/rancher/k3s/agent/images/
sudo cp k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

sudo K3S_URL="https://<MASTER_IP>:6443" \
     K3S_TOKEN="<MASTER_TOKEN>" \
     INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh server
```

7. Obtain .kubeconfig for `kubectl`, `freelens`, `etc`.

```
sudo cat /etc/rancher/k3s/k3s.yaml

```
Dont forget replace `127.0.0.1` with your external IP.



8. Copy config  (Optional)

```

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

```

