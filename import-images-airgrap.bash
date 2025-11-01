#!/bin/bash
set -euo pipefail

NODES=(
  192.168.122.201
  192.168.122.202
  192.168.122.203
  192.168.122.204
  192.168.122.205
)

LOCAL_IMAGES_DIR="./airgap/images"
REMOTE_DIR="/root/airgap/images"

for host in "${NODES[@]}"; do
  echo "============================"
  echo "Копируем образы на $host..."
  ssh root@"$host" "mkdir -p $REMOTE_DIR"
  
  scp -r "$LOCAL_IMAGES_DIR"/* root@"$host":"$REMOTE_DIR/"
  
  echo "Импортируем образы на $host..."
  ssh root@"$host" 'for ns_dir in '"$REMOTE_DIR"'/*; do
      [ -d "$ns_dir" ] || continue
      echo "=== Namespace $(basename "$ns_dir") ==="
      for f in "$ns_dir"/*.tar; do
          [ -f "$f" ] || continue
          echo "Импорт $f"
          ctr -n k8s.io images import "$f"
      done
  done'

  echo "✅ Образы на $host готовы"
done

echo "Все образы скопированы и импортированы на всех нодах."
