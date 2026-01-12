# INSTRUCTION.md

Цей документ містить інструкції для повної перевірки (валідації) розгорнутого додатка **todoapp**.

---

## 1. Валідація: Чи запущено додаток (App is running)

Перевірте статус об'єктів у неймспейсі та переконайтеся, що поди готові приймати трафік.

```bash
# 1. Перевірка статусів усіх ресурсів (має бути Running)
kubectl get all -n todoapp

# 2. Отримання назви активного пода для подальших перевірок
export POD_NAME=$(kubectl get pods -n todoapp -l app=todoapp -o jsonpath='{.items[0].metadata.name}')
# Перегляд списку файлів у директорії конфігів (кожен ключ - окремий файл)
kubectl exec -it $POD_NAME -n todoapp -- ls -F /app/configs

# Перевірка вмісту конкретного файлу
kubectl exec -it $POD_NAME -n todoapp -- cat /app/configs/PYTHONUNBUFFERED

# Перевірка наявності файлу секрету всередині контейнера
kubectl exec -it $POD_NAME -n todoapp -- ls -l /app/secrets

# Читання вмісту секрету (має бути відкритий текст, а не base64)
kubectl exec -it $POD_NAME -n todoapp -- cat /app/secrets/SECRET_KEY

# Перевірка монтування тому в системі контейнера
kubectl exec -it $POD_NAME -n todoapp -- df -h | grep /app/data

# 3. Перевірка логів (має бути повідомлення про запуск сервера)
kubectl logs $POD_NAME -n todoapp

# 4. Перевірка доступності через API (очікувана відповідь HTTP 200)
export NODE_PORT=$(kubectl get svc todoapp-nodeport -n todoapp -o jsonpath='{.spec.ports[0].nodePort}')
curl -I http://localhost:$NODE_PORT/api/health