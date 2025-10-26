#!/bin/bash

# Список нод
NODES=(
  192.168.122.201
  192.168.122.202
  192.168.122.203
  192.168.122.204
  192.168.122.205
)

# Локальная папка, которую нужно скопировать
LOCAL_DIR="./airgap/k3s"

# Папка на нодах
REMOTE_DIR="/root/airgap"

# Цикл по всем нодам
for host in "${NODES[@]}"; do
  echo "Копируем на $host..."
  # Создаём директорию на удалённой ноде
  ssh root@"$host" "mkdir -p $REMOTE_DIR"
  # Копируем папку
  scp -r "$LOCAL_DIR" root@"$host":"$REMOTE_DIR/"
  if [ $? -eq 0 ]; then
    echo "✅ Успешно скопировано на $host"
  else
    echo "❌ Ошибка при копировании на $host"
  fi
done
