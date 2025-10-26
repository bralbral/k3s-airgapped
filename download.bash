#!/usr/bin/env bash
set -euo pipefail

# === Config ===
K3S_VERSION="v1.34.1+k3s1"
HELM_VERSION="v3.16.2"
KUBECTL_VERSION="v1.34.0"
GRAFANA_CHART_VERSION="10.1.2"  # Используем доступную версию
PROMETHEUS_CHART_VERSION="25.17.0"
LONGHORN_CHART_VERSION="1.10.0" # пример
LOG_FILE="download.log"

# === Setup ===
mkdir -p airgap/{k3s,helm,kubectl,charts,storageclass,values}
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Starting offline bundle download ==="
echo "All files will be stored in ./airgap/"
date
echo

# === wget defaults ===
WGET_OPTS="--no-verbose --show-progress --continue --no-check-certificate --timeout=30 --tries=30 --waitretry=5"

# === 1. K3s binaries ===
echo "[1/6] Downloading K3s ${K3S_VERSION}..."
cd airgap/k3s

wget $WGET_OPTS "https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION//+/%2B}/k3s"
chmod +x k3s

wget $WGET_OPTS "https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION//+/%2B}/k3s-airgap-images-amd64.tar"
wget $WGET_OPTS "https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION//+/%2B}/k3s-images.txt"
wget $WGET_OPTS -O install.sh https://get.k3s.io
chmod +x install.sh
cd ../..

# === 2. Helm ===
echo "[2/6] Downloading Helm ${HELM_VERSION}..."
cd airgap/helm
wget $WGET_OPTS "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"
tar -xzf helm-${HELM_VERSION}-linux-amd64.tar.gz linux-amd64/helm --strip-components=1
rm -rf linux-amd64 helm-${HELM_VERSION}-linux-amd64.tar.gz
chmod +x helm
cd ../..

# === 3. kubectl ===
echo "[3/6] Downloading kubectl ${KUBECTL_VERSION}..."
cd airgap/kubectl
wget $WGET_OPTS "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
cd ../..

# === 4. Helm charts ===
echo "[4/6] Downloading Helm charts (Grafana, Prometheus, Longhorn)..."
cd airgap/charts

# Добавляем локальный Helm
export PATH=$PATH:$(pwd)/../helm

helm repo add grafana https://grafana.github.io/helm-charts >/dev/null 2>&1 || true
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true
helm repo add longhorn https://charts.longhorn.io >/dev/null 2>&1 || true

# Скачиваем чарты оффлайн
helm pull grafana/grafana --version ${GRAFANA_CHART_VERSION} --untar --untardir .
helm pull prometheus-community/prometheus --version ${PROMETHEUS_CHART_VERSION} --untar --untardir .
helm pull longhorn/longhorn --version ${LONGHORN_CHART_VERSION} --untar --untardir .

cd ../..

# === 5. StorageClass для single-node Longhorn ===
echo "[5/6] Creating StorageClass for single-node Longhorn..."
cat > airgap/storageclass/longhorn-single.yaml <<EOF
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: longhorn-single
provisioner: driver.longhorn.io
parameters:
  numberOfReplicas: "1"
reclaimPolicy: Delete
allowVolumeExpansion: true
volumeBindingMode: Immediate
EOF

# === 6. Values.yaml для чарта Grafana и Prometheus (single-node) ===
echo "[6/6] Creating single-node values.yaml for Grafana and Prometheus..."
cat > airgap/values/grafana-values-longhorn-single-node.yaml <<EOF
persistence:
  enabled: true
  storageClassName: longhorn-single
EOF

cat > airgap/values/prometheus-values-longhorn-single-node.yaml <<EOF
server:
  persistentVolume:
    enabled: true
    storageClass: longhorn-single
alertmanager:
  persistentVolume:
    enabled: true
    storageClass: longhorn-single
EOF

echo "[✓] All done. Airgap bundle ready in ./airgap/"
find airgap -type f | sort
echo "=== Completed at $(date) ==="
