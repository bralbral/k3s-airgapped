#!/usr/bin/env bash
set -euo pipefail


# uncomment
# NAMESPACE="monitoring"
NAMESPACE="longhorn-system"
OUTPUT_DIR="./airgap/images/$NAMESPACE"

mkdir -p "$OUTPUT_DIR"

# 1️⃣ Получаем все образы подов в namespace
IMAGES=$(kubectl -n "$NAMESPACE" get pods -o jsonpath='{.items[*].spec.containers[*].image}')

# 2️⃣ Делаем уникальные
UNIQUE_IMAGES=$(echo "$IMAGES" | tr ' ' '\n' | sort -u)

# 3️⃣ Пуллим и сохраняем в tar
for img in $UNIQUE_IMAGES; do
    echo "Pulling $img ..."
    docker pull "$img"

    # Формируем имя файла безопасное для файловой системы
    FILE_NAME=$(echo "$img" | tr '/:' '_').tar
    echo "Saving $img -> $OUTPUT_DIR/$FILE_NAME ..."
    docker save "$img" -o "$OUTPUT_DIR/$FILE_NAME"
done

echo "✅ All images pulled and saved in $OUTPUT_DIR"
