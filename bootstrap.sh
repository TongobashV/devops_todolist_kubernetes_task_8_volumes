#!/bin/bash
set -e # Зупинити скрипт при помилці

echo "Starting deployment..."

# Заходимо в папку з маніфестами, щоб не було помилок зі шляхами
cd "$(dirname "$0")/.infrastructure"

# 1. Основа
kubectl apply -f namespace.yml

# 2. Конфігурація (Deployments чекають на них)
kubectl apply -f configMap.yml
kubectl apply -f secret.yml

# 3. Сховище (PV має бути першим!)
kubectl apply -f pv.yml
kubectl apply -f pvc.yml

# 4. Додаток (Коли конфіги та диски готові)
kubectl apply -f deployment.yml

# 5. Мережа та Масштабування
kubectl apply -f clusterIp.yml
kubectl apply -f nodeport.yml
kubectl apply -f hpa.yml

echo "Todo-app deployed successfully!"
kubectl get pods -n todoapp